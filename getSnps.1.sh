#!/bin/bash -eux
#1: ref(wgs assembly)
#2: qry(sample)
#3: lane

R=$1
Q=$2
L=$3

P=12
p=2

RDIR=
QDIR=

test -f $RDIR/$R.fa
test -f $QDIR/$Q/${L}_R1_001.fq.gz
test -f $QDIR/$Q/${L}_R2_001.fq.gz

bowtie2 --threads $P -x $RDIR/bowtie2/$R -1 $QDIR/$Q/${L}_R1_001.fq.gz -2 $QDIR/$2/${L}_R2_001.fq.gz | samtools view -u - --threads $p | samtools sort --threads $P -m 5G > $L.bam

