!/bin/bash -eux
#1: ref(wgs assembly)
#2: qry(sample)
#3: lane

R=$1
Q=$2

P=12

samtools merge -@ $P $Q.bam ${Q}_*.bam
samtools flagstat $Q.bam > $Q.flagstat
