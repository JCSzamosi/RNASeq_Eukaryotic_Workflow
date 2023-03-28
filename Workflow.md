Workflow for Eukaryotic RNASeq
==============================

The project should be set up with the following directories

* ProjectName
	* data
	* orig_data
	* scripts
	* results
	* logs

I use the `ProjectName/logs` directory to store the output of logging screen to
capture std out.

Index Genome
------------

Before you start, you need to download and index your reference genome.  This
only needs to be done once per genome/mapper pair. So if you're using the same
genome version with the same mapping software (and version) as a previous
project, you don't need to do this again. Ideally, the
[index_genome_star.sh](./scripts/index_genome_star.sh) script will live in the
directory with the genome, although you may want a copy of it in your project
directory as well for reference/replicability. I'm using STAR to index the
genome because that's what I use for mapping, but if you use a different mapper
you'll need to follow its instructions.

0. Concatenate Lanes
--------------------

If sequencing happened on multiple lanes, you'll need to concatenate the files
into a single `.fastq.gz` file for each sample/direction pair.

The script to do this is at [./scripts/00_cat.sh](./scripts/00_cat.sh).

1. FastQC
---------

Run [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) on
all samples to check their quality and read depth. This can be done on .gz
files. 

The script to do this is at [./scripts/01_fastqc.sh](./scripts/01_fastqc.sh)

2. Cutadapt
-----------

Run [cutadapt](https://cutadapt.readthedocs.io/en/stable/) to trim Illumina
adapters and low-quality ends off the reads. There is a script to do this on
[paired-end](./scripts/02_cutadapt_pe.sh) or
[single-end](./scripts/02_cutadapt_se.sh) reads.

3. FastQC Again
---------------

Run FastQC on the trimmed reads. There should be no Ns, no adapter sequences,
and you shouldn't have lost a huge amount of data. Sequence lengths will not be
uniform anymore, but you should still have sufficient sequences of sufficient
length to do your analysis.

4. Mapping
----------

I map to the genome using [STAR aligner](https://github.com/alexdobin/STAR),
which is a splice-aware read mapper. It aligns reads across splice junctions. If
you're only looking at gene expression, and don't care about splice junction
discovery, single-pass mapping is sufficient. The script to run STAR is at
[./scripts/04_map.sh](./scripts/04_map.sh). The manual is very accessible and is
a good place to go for explanations of various parameter value choices.

5. MultiQC
----------

I run multiQC individually on three sets of data:

* the original (concatenated), untrimmed reads
* the trimmed reads
* the mapped reads

You can also run everything together, but I find the output messy and prefer to
look at them individually. The script to do this is in
[./scripts/05_multiqc.sh](./scripts/05_multiqc.sh).

6. Read Counting & Analysis
---------------------------

A rough example script is in [./06_analysis.Rmd](./06_analysis.Rmd). I typically
keep this script in the top level directory for the project, and its html output
is generated there as well.

### 6.1 Read Counting

I use featureCount from the RSubreads package to count reads.
[./06_analysis.Rmd](./06_analysis.Rmd) contains a function to count reads mapped
to gene. For more detailed analysis it is also possible to use this function to
count reads mapped to exons (or any other feature in the featureType column of
the GTF file. Intermediate data structures are stored in
[./results/06_analysis/](./results/06_analysis/).

### 6.2 Differential Expression Analysis

The details of this analysis will vary substantially from project to project,
but I typically use DESeq2 to conduct differential expression analysis. It's a
good idea to remove unwanted variation if the project is at all complicated
(multiple processing batches, illumina runs, etc.). Typically you want to remove
any rows that are 0 everywhere, make sure your sample data are leveled the way
you want, make sure any continuous predictors are z-scored to remove numerical
estimation problems, and set up contrasts the way you want them.
