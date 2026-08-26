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
AfterPLINK=$HOME/TeaGermplasm/plink/after
FSresult=$HOME/TeaGermplasm/FSresult/
FSDir=$HOME/proj/fastStructure/


##### vcf-merge -----
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


##### vcftools command -----
vcftools \
--gzvcf $VCF_filtered/concat.list_germplasm.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp.vcf.gz \
--plink --out $AfterPLINK/concat.list_germplasm.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp

##### plink command_make binary file (bed,bim,fam) -----
plink --file $AfterPLINK/concat.list_germplasm.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp \
--make-bed --out $AfterPLINK/concat.list_germplasm.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp

### fastStructure -----
python2 $FSDir/structure.py -K ${SGE_TASK_ID} \
--input=$AfterPLINK/concat.list_germplasm.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp \
--output=$FSresult/concat.list_germplasm.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp_faststructure \
--format=bed 