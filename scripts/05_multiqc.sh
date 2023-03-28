#!/bin/bash -i

outdir=results/05_multiqc/

multiqc ./results/01_fastqc \
	-o $outdir \
	-n raw_multiqc

multiqc ./results/03_fastqc \
	-o $outdir \
	-n trimmed_multiqc

multiqc ./results/04_map \
	-o $outdir \
	-n mapping_multiqc
