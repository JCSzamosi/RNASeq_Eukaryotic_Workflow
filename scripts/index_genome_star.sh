#!/bin/bash

# Index the reference genome

## Run this once per genome, STAR version, and read length. You need to update
## the --sjdbOverhang parameter to be read length -1.

out=Desired/Path/To/Genome/Index/STARNN_MM 
#(NN is the version of STAR you're using, MM is the read length-1)
ref=Path/To/Genome/file.fna
gtf=Path/To/Annotation/file.gtf

echo STAR --runThreadN 10 \
	--runMode genomeGenerate \
	--genomeDir $out \
	--sjdbGTFfile $gtf \
	--sjdbOverhang 49 \
	--limitGenomeGenerateRAM 24000000000 \
	--genomeSAsparseD 2 \
	--genomeFastaFiles $ref 

STAR --runThreadN 10 \
	--runMode genomeGenerate \
	--sjdbGTFfile $gtf \
	--sjdbOverhang 49 \
	--genomeDir $out \
	--limitGenomeGenerateRAM 24000000000 \
	--genomeSAsparseD 2 \
	--genomeFastaFiles $ref 
