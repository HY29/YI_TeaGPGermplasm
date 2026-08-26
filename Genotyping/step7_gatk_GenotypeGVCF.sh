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




