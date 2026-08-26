#!/bin/bash

#$ -S /bin/bash
#$ -l s_vmem=80G -l mem_req=80G
#$ -V
#$ -cwd
#$ -l d_rt=1000:00:00
#$ -l s_rt=1000:00:00


#conda activate
export PATH=~/miniconda3/bin:$PATH
source ~/miniconda3/etc/profile.d/conda.sh
conda activate renv

Rscript csvmerge.R
#Rscript vcfR_geno_output.R
