Workflow for Eukaryotic RNASeq
==============================

0. Concatenate Lanes
--------------------

If sequencing happened on multiple lanes, you'll need to concatenate the files
into a single `.fastq.gz` file for each sample.

The script to do this is at [./scripts/00_cat.sh](./scripts/00_cat.sh).
