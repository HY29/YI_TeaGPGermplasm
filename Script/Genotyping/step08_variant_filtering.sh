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

### Select training population -----
vcftools \
--gzvcf $VCFDir/merged.Chr${SGE_TASK_ID}.vcf.gz \
--keep $ListDir/list_TP139.txt \
--recode --out $GPDir/list_TP139.Chr${SGE_TASK_ID}_fromfiltered
bgzip $GPDir/list_TP139.Chr${SGE_TASK_ID}_fromfiltered.recode.vcf

### Filtering variants in training population -----
vcftools \
--gzvcf $GPDir/list_TP139.Chr${SGE_TASK_ID}_fromfiltered.recode.vcf.gz \
--max-missing 0.7 \
--min-alleles 2 \
--max-alleles 2 \
--maf 0.05 \
--minDP 1 \
--recode --out $VCF_filtered/list_TP139.Chr${SGE_TASK_ID}.fromfiltered_maxmiss0.7_maf0.05_minDP1
bgzip $VCF_filtered/list_TP139.Chr${SGE_TASK_ID}.fromfiltered_maxmiss0.7_maf0.05_minDP1.recode.vcf

### Imputation in training population -----
zcat $VCF_filtered/list_TP139.Chr${SGE_TASK_ID}.fromfiltered_maxmiss0.7_maf0.05_minDP1.recode.vcf.gz | perl -pe "s/\s\.:/\t.\/.:/g" | bgzip -c > $VCF_filtered/list_TP139.Chr${SGE_TASK_ID}.fromfiltered_maxmiss0.7_maf0.05_minDP1.vcf.gz
java -Xmx32G -jar /home/yisgr/.conda/envs/ngs/share/beagle-5.2_21Apr21.304-0/beagle.jar gt=$VCF_filtered/list_TP139.Chr${SGE_TASK_ID}.fromfiltered_maxmiss0.7_maf0.05_minDP1.vcf.gz out=$VCF_filtered/list_TP139.Chr${SGE_TASK_ID}.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp
	



### Select empirical population -----
vcftools \
--gzvcf $VCFDir/merged.Chr${SGE_TASK_ID}.vcf.gz \
--keep $ListDir/list_EP104.txt \
--recode --out $GPDir/list_EP104.Chr${SGE_TASK_ID}_fromfiltered
bgzip $GPDir/list_EP104.Chr${SGE_TASK_ID}_fromfiltered.recode.vcf

# Filtering variants in empirical population -----
vcftools \
--gzvcf $GPDir/list_EP104.Chr${SGE_TASK_ID}_fromfiltered.recode.vcf.gz \
--max-missing 0.7 \
--min-alleles 2 \
--max-alleles 2 \
--maf 0.05 \
--minDP 1 \
--recode --out $VCF_filtered/list_EP104.Chr${SGE_TASK_ID}.fromfiltered_maxmiss0.7_maf0.05_minDP1
bgzip $VCF_filtered/list_EP104.Chr${SGE_TASK_ID}.fromfiltered_maxmiss0.7_maf0.05_minDP1.recode.vcf

### Imputation in empirical population -----
zcat $VCF_filtered/list_EP104.Chr${SGE_TASK_ID}.fromfiltered_maxmiss0.7_maf0.05_minDP1.recode.vcf.gz | perl -pe "s/\s\.:/\t.\/.:/g" | bgzip -c > $VCF_filtered/list_EP104.Chr${SGE_TASK_ID}.fromfiltered_maxmiss0.7_maf0.05_minDP1.vcf.gz
java -Xmx32G -jar /home/yisgr/.conda/envs/ngs/share/beagle-5.2_21Apr21.304-0/beagle.jar gt=$VCF_filtered/list_EP104.Chr${SGE_TASK_ID}.fromfiltered_maxmiss0.7_maf0.05_minDP1.vcf.gz out=$VCF_filtered/list_EP104.Chr${SGE_TASK_ID}.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp




### Select germplasm population -----
vcftools \
--gzvcf $VCFDir/merged.Chr${SGE_TASK_ID}.vcf.gz \
--keep $ListDir/list_germplasm.txt \
--recode --out $GPDir/list_germplasm.Chr${SGE_TASK_ID}_fromfiltered
bgzip $GPDir/list_germplasm.Chr${SGE_TASK_ID}_fromfiltered.recode.vcf

# Filtering variants in germplasm population -----
vcftools \
--gzvcf $GPDir/list_germplasm.Chr${SGE_TASK_ID}_fromfiltered.recode.vcf.gz \
--max-missing 0.7 \
--min-alleles 2 \
--max-alleles 2 \
--maf 0.05 \
--minDP 1 \
--recode --out $VCF_filtered/list_germplasm.Chr${SGE_TASK_ID}.fromfiltered_maxmiss0.7_maf0.05_minDP1
bgzip $VCF_filtered/list_germplasm.Chr${SGE_TASK_ID}.fromfiltered_maxmiss0.7_maf0.05_minDP1.recode.vcf

### Imputation in germplasm population -----
zcat $VCF_filtered/list_germplasm.Chr${SGE_TASK_ID}.fromfiltered_maxmiss0.7_maf0.05_minDP1.recode.vcf.gz | perl -pe "s/\s\.:/\t.\/.:/g" | bgzip -c > $VCF_filtered/list_germplasm.Chr${SGE_TASK_ID}.fromfiltered_maxmiss0.7_maf0.05_minDP1.vcf.gz
java -Xmx32G -jar /home/yisgr/.conda/envs/ngs/share/beagle-5.2_21Apr21.304-0/beagle.jar gt=$VCF_filtered/list_germplasm.Chr${SGE_TASK_ID}.fromfiltered_maxmiss0.7_maf0.05_minDP1.vcf.gz out=$VCF_filtered/list_germplasm.Chr${SGE_TASK_ID}.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp
