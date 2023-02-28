#! /bin/bash

## Assuming the project files are set up in the normal way, this should not
## require any modification

dat=data/
outdr=results/01_fastqc/

echo mkdir -p $outdr
mkdir -p $outdr
echo fastqc -o $outdr -t 10 $dat/*
fastqc -o $outdr -t 10 $dat/*
