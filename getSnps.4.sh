#!/bin/bash -eux
#1: ref(wgs assembly)
#2: qry(sample)

R=$1
Q=$2

RDIR=

Q=$2

cat $Q.*.vcf        | perl -ane 'print if(/^#/ and $.==1 or !/^#/);'  > $Q.vcf
cat $Q.*.merged.bed | perl -ane 'print if(/^#/ and $.==1 or !/^#/);'  > $Q.merged.bed
