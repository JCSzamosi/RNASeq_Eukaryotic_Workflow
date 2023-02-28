#! /bin/bash

# Run from top directory

## This script assumes that all fastq.gz files are stored in a flat 
## hierarchy in a directory called orig_data. If they are not, you can put
## symlinks there to mimic that structure, or you can make changes to the
## script to include the directories.

orig=orig_data
l1=L001_R1_001.fastq.gz
mkdir -p data

for file in $orig/*$l1
do
	bnm=`basename $file $l1`
	echo $bnm
	suf=R1.fastq.gz
	cat $orig/$bnm*R1* > data/$bnm$suf
	suf=R2.fastq.gz
	cat $orig/$bnm*R2* > data/$bnm$suf
done
