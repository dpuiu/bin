#!/bin/bash -eux
#1: ref(wgs assembly)
#2: qry(sample)
#3: region

R=$1
Q=$2
L=$3

RDIR=

test -f split/$R.$L.bed
test -f $Q.bam
test -f $RDIR/$R.fa

samtools view -L split/$R.$L.bed $Q.bam -1 | tee $Q.$L.bam  | samtools mpileup -uf $RDIR/$R.fa - | bcftools call --ploidy 1 -mv -Ov | perl -ane 'print if(/^#/ and $.==1 or !/^#/);' > $Q.$L.vcf
bamToBed  -i $Q.$L.bam | bedtools merge | perl -ane '$F[3]="."; $F[4]=$F[2]-$F[1]; $F[5]="."; print join "\t",@F; print "\n";' > $Q.$L.merged.bed
