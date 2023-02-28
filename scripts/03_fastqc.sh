#! /bin/bash

## Run fastqc on trimmed data. If you have been following this workflow, nothing
## should need to be modified.

dat=results/02_cutadapt/
outdr=results/03_fastqc/

echo mkdir -p $outdr
mkdir -p $outdr
echo fastqc -o $outdr -t 10 $dat/*
fastqc -o $outdr -t 10 $dat/*
