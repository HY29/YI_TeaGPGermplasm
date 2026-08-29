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
VCF_filtered=$HOME/TeaGermplasm/vcf/filtered/
OutputDir=$HOME/TeaGermplasm/GeneticStat/GenoR2/

# maxmiss0.7
vcftools \
--gzvcf $VCFDir/list_TP139.Chr${SLURM_ARRAY_TASK_ID}.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
--geno-r2 \
--out $OutputDir/list_TP139.Chr${SLURM_ARRAY_TASK_ID}.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp_genor2

vcftools \
--gzvcf $VCFDir/list_TP139.Chr${SLURM_ARRAY_TASK_ID}.fromfiltered_maxmiss0.7_maf0.05_minDP2_imp.vcf.gz \
--geno-r2 \
--out $OutputDir/list_TP139.Chr${SLURM_ARRAY_TASK_ID}.fromfiltered_maxmiss0.7_maf0.05_minDP2_imp_genor2

vcftools \
--gzvcf $VCFDir/list_TP139.Chr${SLURM_ARRAY_TASK_ID}.fromfiltered_maxmiss0.7_maf0.05_minDP3_imp.vcf.gz \
--geno-r2 \
--out $OutputDir/list_TP139.Chr${SLURM_ARRAY_TASK_ID}.fromfiltered_maxmiss0.7_maf0.05_minDP3_imp_genor2

# maxmiss0.8
vcftools \
--gzvcf $VCFDir/list_TP139.Chr${SLURM_ARRAY_TASK_ID}.fromfiltered_maxmiss0.8_maf0.05_minDP1_imp.vcf.gz \
--geno-r2 \
--out $OutputDir/list_TP139.Chr${SLURM_ARRAY_TASK_ID}.fromfiltered_maxmiss0.8_maf0.05_minDP1_imp_genor2

vcftools \
--gzvcf $VCFDir/list_TP139.Chr${SLURM_ARRAY_TASK_ID}.fromfiltered_maxmiss0.8_maf0.05_minDP2_imp.vcf.gz \
--geno-r2 \
--out $OutputDir/list_TP139.Chr${SLURM_ARRAY_TASK_ID}.fromfiltered_maxmiss0.8_maf0.05_minDP2_imp_genor2

vcftools \
--gzvcf $VCFDir/list_TP139.Chr${SLURM_ARRAY_TASK_ID}.fromfiltered_maxmiss0.8_maf0.05_minDP3_imp.vcf.gz \
--geno-r2 \
--out $OutputDir/list_TP139.Chr${SLURM_ARRAY_TASK_ID}.fromfiltered_maxmiss0.8_maf0.05_minDP3_imp_genor2

# maxmiss0.9
vcftools \
--gzvcf $VCFDir/list_TP139.Chr${SLURM_ARRAY_TASK_ID}.fromfiltered_maxmiss0.9_maf0.05_minDP1_imp.vcf.gz \
--geno-r2 \
--out $OutputDir/list_TP139.Chr${SLURM_ARRAY_TASK_ID}.fromfiltered_maxmiss0.9_maf0.05_minDP1_imp_genor2

vcftools \
--gzvcf $VCFDir/list_TP139.Chr${SLURM_ARRAY_TASK_ID}.fromfiltered_maxmiss0.9_maf0.05_minDP2_imp.vcf.gz \
--geno-r2 \
--out $OutputDir/list_TP139.Chr${SLURM_ARRAY_TASK_ID}.fromfiltered_maxmiss0.9_maf0.05_minDP2_imp_genor2

vcftools \
--gzvcf $VCFDir/list_TP139.Chr${SLURM_ARRAY_TASK_ID}.fromfiltered_maxmiss0.9_maf0.05_minDP3_imp.vcf.gz \
--geno-r2 \
--out $OutputDir/list_TP139.Chr${SLURM_ARRAY_TASK_ID}.fromfiltered_maxmiss0.9_maf0.05_minDP3_imp_genor2

# maxmiss1.0
vcftools \
--gzvcf $VCFDir/list_TP139.Chr${SLURM_ARRAY_TASK_ID}.fromfiltered_maxmiss1.0_maf0.05_minDP1_imp.vcf.gz \
--geno-r2 \
--out $OutputDir/list_TP139.Chr${SLURM_ARRAY_TASK_ID}.fromfiltered_maxmiss1.0_maf0.05_minDP1_imp_genor2

vcftools \
--gzvcf $VCFDir/list_TP139.Chr${SLURM_ARRAY_TASK_ID}.fromfiltered_maxmiss1.0_maf0.05_minDP2_imp.vcf.gz \
--geno-r2 \
--out $OutputDir/list_TP139.Chr${SLURM_ARRAY_TASK_ID}.fromfiltered_maxmiss1.0_maf0.05_minDP2_imp_genor2

vcftools \
--gzvcf $VCFDir/list_TP139.Chr${SLURM_ARRAY_TASK_ID}.fromfiltered_maxmiss1.0_maf0.05_minDP3_imp.vcf.gz \
--geno-r2 \
--out $OutputDir/list_TP139.Chr${SLURM_ARRAY_TASK_ID}.fromfiltered_maxmiss1.0_maf0.05_minDP3_imp_genor2

