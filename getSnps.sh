#!/bin/bash -eux
#1: ref
#2: qry
#3: bowtie2/bwa/nucmer

PATH=~/sw/packages/bowtie2-2.2.9/:~/sw/packages/samtools-1.3.1/:~/sw/packages/bcftools-1.3.1/:~/sw/packages/bedtools2/bin/:$PATH
P=8
test -f $1.fa

if [[ "$3" == "bowtie2" ||  "$3" == "bwa" ]] ; then
  test -f $2_1.fastq
  test -f $2_2.fastq
else
  test -f $2.fa
fi

if [[ "$3" == "bowtie2" ]] ; then
  bowtie2-build --threads $P $1.fa $1
  bowtie2 --threads $P -x $1 -1 $2_1.fastq -2 $2_2.fastq > $2.sam 
fi

if [[ "$3" == "bwa"	]] ; then
  bwa index -p $2 $2.fa 
  bwa mem $2 $2_1.fastq $2_2.fastq -t $P -v 1 > $2.sam
fi

if [[ "$3" == "bowtie2" ||  "$3" == "bwa" ]] ; then
  cat $2.sam | samtools view -b - | samtools sort --threads $P | tee $2.bam | bedtools bamtobed -i - > $2.bed 
  samtools mpileup -uf $1.fa $2.bam | bcftools call  --ploidy 1 -mv -Ov | tee $2.vcf  | grep -v INDEL > $2.noINDEL.vcf
else
#nucmer -t $P $1.fa $2.fa  
  delta-filter -1 $2.delta > $2.filter-1.delta
  show-snps -H $2.filter-1.delta  | snp2vcf.pl | tee $2.vcf | perl -ane 'next if($F[3] eq "." or $F[4] eq "."); print; ' > $2.noINDEL.vcf
fi  

cat $2.bed | bedtools merge | bed2bed.pl > $2.merged.bed
