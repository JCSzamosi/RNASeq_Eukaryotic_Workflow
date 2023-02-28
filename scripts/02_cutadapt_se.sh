#!/bin/bash -i

## Assuming the project directory is set up in the normal way, this should not
## require any editing to run. This version runs on single-end reads.

echo source ~/miniconda3/bin/activate cutadaptenv
source ~/miniconda3/bin/activate cutadaptenv

indir=data/
outdir=results/02_cutadapt/

in1=R1.fastq.gz

out1=R1_trimmed.fastq.gz

adapt="file:/home/jcszamosi/Disk2/CommonData/LibFiles/cutadapt_adapters.fna"

echo mkdir -p $outdir
mkdir -p $outdir

for R1 in $indir/*$in1
do
	bnm=`basename $R1 $in1`
	
	echo cutadapt -a $adapt -A $adapt \
	-o $outdir/$bnm$out1 \
	-j 8 \
	$R1 \
	-q 28 -m 50

	cutadapt -a $adapt -A $adapt \
	-o $outdir/$bnm$out1 \
	-j 8 \
	$R1 \
	-q 28 -m 50
done

echo conda deactivate
conda deactivate
