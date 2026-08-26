#!/bin/bash

#$ -S /bin/bash
#$ -l s_vmem=40G -l mem_req=40G
#$ -V
#$ -cwd
#$ -l d_rt=1000:00:00
#$ -l s_rt=1000:00:00

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
HeteroDir=$HOME/TeaGermplasm/GeneticStat/Heterozygosity/
LDDir=$HOME/TeaGermplasm/GeneticStat/LD/


vcf-concat \
$VCF_filtered/list_TP139.Chr1.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_TP139.Chr2.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_TP139.Chr3.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_TP139.Chr4.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_TP139.Chr5.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_TP139.Chr6.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_TP139.Chr7.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_TP139.Chr8.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_TP139.Chr9.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_TP139.Chr10.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_TP139.Chr11.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_TP139.Chr12.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_TP139.Chr13.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_TP139.Chr14.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_TP139.Chr15.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz | gzip -c > $VCF_filtered/concat.list_TP139.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz

vcf-concat \
$VCF_filtered/list_EP104.Chr1.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_EP104.Chr2.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_EP104.Chr3.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_EP104.Chr4.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_EP104.Chr5.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_EP104.Chr6.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_EP104.Chr7.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_EP104.Chr8.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_EP104.Chr9.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_EP104.Chr10.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_EP104.Chr11.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_EP104.Chr12.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_EP104.Chr13.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_EP104.Chr14.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_EP104.Chr15.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz | gzip -c > $VCF_filtered/concat.list_EP104.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz

vcf-concat \
$VCF_filtered/list_germplasm.Chr1.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_germplasm.Chr2.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_germplasm.Chr3.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_germplasm.Chr4.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_germplasm.Chr5.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_germplasm.Chr6.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_germplasm.Chr7.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_germplasm.Chr8.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_germplasm.Chr9.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_germplasm.Chr10.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_germplasm.Chr11.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_germplasm.Chr12.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_germplasm.Chr13.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_germplasm.Chr14.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
$VCF_filtered/list_germplasm.Chr15.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz | gzip -c > $VCF_filtered/concat.list_germplasm.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz


### Heterozygosity ###
# Training population #
vcftools \
--gzvcf $VCF_filtered/concat.list_TP139.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
--het \
--out $HeteroDir/heterozygosity_allwindow_list_TP139_maxmiss0.7_maf0.05_minDP1

# Empirical population #
vcftools \
--gzvcf $VCF_filtered/concat.list_EP104.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
--het \
--out $HeteroDir/heterozygosity_allwindow_list_EP104_maxmiss0.7_maf0.05_minDP1

# Germplasm population #
vcftools \
--gzvcf $VCF_filtered/concat.list_germplasm.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
--het \
--out $HeteroDir/heterozygosity_allwindow_list_germplasm_maxmiss0.7_maf0.05_minDP1



### LD ###
# Training population #
vcftools \
--gzvcf $VCF_filtered/concat.list_TP139.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
--geno-r2 \
--ld-window-bp 50000 \
--out $LDDir/LD_50kb_list_TP139_maxmiss0.7_maf0.05_minDP1

vcftools \
--gzvcf $VCF_filtered/concat.list_EP104.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
--geno-r2 \
--ld-window-bp 50000 \
--out $LDDir/LD_50kb_list_EP104_maxmiss0.7_maf0.05_minDP1

vcftools \
--gzvcf $VCF_filtered/concat.list_germplasm.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
--geno-r2 \
--ld-window-bp 50000 \
--out $LDDir/LD_50kb_list_germplasm_maxmiss0.7_maf0.05_minDP1
