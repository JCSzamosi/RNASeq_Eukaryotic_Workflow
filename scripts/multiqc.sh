#!/bin/bash -i

outdir=results/multiqc/

multiqc --interactive -f \
	-o $outdir \
	$outdir
