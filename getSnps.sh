#!/bin/bash -eux

N=1
K=7
P=4

test -f $1.fa
bowtie2-build $1.fa $1
 
bowtie2 -x $1 -1 $2_1.fastq -2 $2_2.fastq > $2.sam 
cat $2.sam | samtools view -b - | samtools sort > $2.bam 

test -f $2.bam
bedtools bamtobed -i $2.bam | tee $2.bed | bedtools merge | bed2bed.pl > $2.merged.bed
samtools mpileup -uf $1.fa $2.bam | bcftools call  --ploidy 1 -mv -Ov | tee $2.vcf | bcftools stats > $2.stats
