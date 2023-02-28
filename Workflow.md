Workflow for Eukaryotic RNASeq
==============================

The project should be set up with the following directories

* ProjectName
	* data
	* orig_data
	* scripts
	* results
	* logs (optional)

I use the `ProjectName/logs` directory to store the output of logging screen to
capture std out.

Index Genome
------------

Before you start, you should have downloaded and indexed your reference genome.
This only needs to be done once per genome/mapper pair. So if you're using the
same genome (including same version) with the same mapping software as a
previous project, you don't need to do this again. Ideally, the
[index_genome_star.sh](./scripts/index_genome_star.sh) script will live in the
directory with the genome, although you may want a copy of it in your project
directory as well for reference/replicability. I'm using STAR to index the
genome because that's what I use for mapping, but if you use a different mapper
you'll need to follow its instructions.

0. Concatenate Lanes
--------------------

If sequencing happened on multiple lanes, you'll need to concatenate the files
into a single `.fastq.gz` file for each sample.

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
