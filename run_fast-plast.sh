#!/bin/bash

java -classpath trimmomatic-0.36.jar org.usadellab.trimmomatic.TrimmomaticPE -threads 4 -phred33 $1 $2 $3.trimmed_P1.fq $3.trimmed_U1.fq $3.trimmed_P2.fq $3.trimmed_U2.fq ILLUMINACLIP:Fast-Plast-master/bin/NEB-PE.fa:1:30:10 SLIDINGWINDOW:10:20 MINLEN:40

bowtie2 --very-sensitive-local --al map_hits.fq --al-conc map_pair_hits.fq -p 4 -x Fast-Plast/Verdant -1 $3.trimmed_P1.fq -2 $3.trimmed_P2.fq -U $3.trimmed_U1.fq,$3.trimmed_U2.fq -S $3.sam

python spades.py -o spades_iter1 -1 map_pair_hits.1.fq -2 map_pair_hits.2.fq -s map_hits.fq --only-assembler -k 55,87,121 -t 4

perl Fast-Plast/bin/filter_coverage_assembly.pl spades_iter1/contigs.fasta

Fast-Plast/afinit-afin-c25d552842f5/afin -c filtered_spades_contigs.fsa -r $3.trimmed* -l 50 -f .1 -d 100 -x 100 -p 20 -i 2 -o $3_afin

Fast-Plast/bin/plastome_finisher.sh $3 /home/mmckain/Andropogoneae_Plastomes/FINISHED/positional_genes.fsa


