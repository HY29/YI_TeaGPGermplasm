#!/bin/bash

#$ -S /bin/bash
#$ -l s_vmem=80G -l mem_req=80G
#$ -V
#$ -cwd

#conda activate
export PATH=~/miniconda3/bin:$PATH
source ~/miniconda3/etc/profile.d/conda.sh
conda activate ngs

#Directory design
GenomeDir=$HOME/reference/tea/ChrLev/
FastqDir=$HOME/TeaGermplasm/fastq/
FastpDir=$HOME/TeaGermplasm/fastp/
BamDir=$HOME/TeaGermplasm/bam/
BamChrDir=$HOME/TeaGermplasm/bam_chr/
GVCFDir=$HOME/TeaGermplasm/gvcf/
GenomicsDBDir=$HOME/TeaGermplasm/GenomicsDB/
VCFDir=$HOME/TeaGermplasm/vcf/

#.dict
picard CreateSequenceDictionary \
REFERENCE=$GenomeDir/CSS_ChrLev_20200506_Genome_v2.fasta \
OUTPUT=$GenomeDir/CSS_ChrLev_20200506_Genome_v2.dict
#.fai
samtools faidx $GenomeDir/CSS_ChrLev_20200506_Genome_v2.fasta
#bwa-mem2:index
bwa-mem2 index $GenomeDir/CSS_ChrLev_20200506_Genome_v2.fasta
#elprep:index
elprep fasta-to-elfasta \
$GenomeDir/CSS_ChrLev_20200506_Genome_v2.fasta \
$GenomeDir/CSS_ChrLev_20200506_Genome_v2.elfasta
