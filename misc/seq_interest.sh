#!/bin/bash

samtools faidx Zika_sequences.fasta "gi|982894594|gb|KU527068.1|"  > KU527068.1.fasta

msbar -sequence KU527068.1.fasta -count 12 -point 4 -block 0 -codon 0 -outseq /dev/stdout  > NewSequence.fastq

rm KU527068.1.fasta
