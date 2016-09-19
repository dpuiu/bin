#!/bin/bash -eux
#1: sample 1
#2: sample 2

A=$1
B=$2

test -f $A/$A.vcf
test -f $B/$B.vcf

bedtools intersect -header -a $A/$A.vcf -b $B/$B.vcf > $A-$B.vcf
bedtools intersect -header -a $A/$A.merged.bed -b $B/$B.merged.bed > $A-$B.merged.bed
