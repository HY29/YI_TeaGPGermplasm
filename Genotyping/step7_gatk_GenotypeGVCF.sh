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
FastpDir=$HOME/Demo/fastp/
BamDir=$HOME/Demo/bam/
BamChrDir=$HOME/Demo/bam_chr/
GVCFDir=$HOME/Demo/gvcf/
GenomicsDBDir=$HOME/Demo/GenomicsDB/
VCFDir=$HOME/Demo/vcf/


#gatk: GenotypeGVCFs
#Chr
for i in {1..15}
do
  gatk --java-options "-Xmx16G" \
  GenotypeGVCFs \
  -R $GenomeDir/CSS_ChrLev_20200506_Genome_v2.fasta\
  -V gendb://$GenomicsDBDir/Chr${i}_DB \
  -O $VCFDir/merged.Chr${i}.vcf.gz
done




