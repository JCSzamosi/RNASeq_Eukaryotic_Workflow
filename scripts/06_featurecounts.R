#### Setup ####

library(Rsubread)
library(tidyverse)

##### Import data #####

# Set up file locations and sample names
setwd('~/Projects/Clients/Bowdish/WestonRNASeq2/')
dirs = list.dirs('results/04_map',recursive = FALSE)
dirs
samps = gsub('results/04_map/', '', dirs, fixed = TRUE)
samps = gsub('_.*', '', samps)
samps

# Define the gtf file
gtf = '/home/jcszamosi/Disk2/CommonData/ReferenceGenomes/Human/GRCh38_NCBI/genomic.gtf'

#### Feature Counts ####

##### Setup #####

# Define a function to count genes
call_fc = function(bamf, gtf, useMF = TRUE){
    fc = Rsubread::featureCounts(bamf, 
                       annot.ext = gtf, isGTFAnnotationFile = TRUE, # use the GTF file for features
                       GTF.featureType = 'gene', # this can also be exon, if that's what's wanted
                       GTF.attrType = 'gene_id', # this is necessary when using a GTF file
                       GTF.attrType.extra = c('transcript_id',
                                              'product'), # this matters more when counting exons
                       strandSpecific = 0, # 1: forward, 2: reverse, 0: unstranded
                       isPairedEnd = FALSE, 
                       primaryOnly = TRUE,
                       nthreads = 10,
                       verbose = TRUE,
                       useMetaFeatures = FALSE) # even when you count exons, this only reports genes if true. seems silly. you can use the gene id to glom later.
    return(fc)
}

# Set up the data structures in advance to save time
gene_counts = matrix(nrow = 67007, ncol = length(samps))
colnames(gene_counts) = samps

##### Run on the first sample ####

samp = samps[1]
dr = dirs[1]
bamf = paste(dr, 'Aligned.sortedByCoord.out.bam', sep = '/')
fc = call_fc(bamf, gtf)
stats = (fc$stat
         %>% data.frame()
         %>% column_to_rownames('Status'))
colnames(stats) = samp
gene_counts[,samp] = fc$counts

fc_lst = list()
fc_lst[[samp]] = fc

##### Run on the rest of the samples #####

for (i in 2:length(dirs)){
    samp = samps[i]
    dr = dirs[i]
    bamf = paste(dr, 'Aligned.sortedByCoord.out.bam', sep = '/')
    fc = call_fc(bamf, gtf, genome)
    gene_counts[,samp] = fc$counts
    stats[fc$stat$Status,samp] = fc$stat$Aligned.sortedByCoord.out.bam
    fc_lst[[samp]] = fc
}

stats_prop = apply(stats, 2, function(x) 100*x/sum(x))
print(round(stats_prop, 2))

rownames(gene_counts) = rownames(fc$counts)

#### Output ####

##### Write the counts table #####
gene_counts_nz = gene_counts[rowSums(gene_counts) > 0,]
dim(gene_counts_nz)
head(gene_counts_nz)

write.csv(gene_counts_nz, row.names = TRUE, 
          file = 'results/06_featurecounts/gene_counts.csv')

##### Write the stat summaries for multiqc #####
write.csv(stats, row.names = TRUE, 
			file = 'results/06_featurecounts/fc_stats.summary')

##### Save processed data #####
save(list = c('gene_counts', 'gene_counts_nz', 'stats', 'stats_prop', 'fc_lst'),
     file = 'results/06_featurecounts/feature_counts.RData')

