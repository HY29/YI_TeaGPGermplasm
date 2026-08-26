#!/bin/bash

#$ -S /bin/bash
#$ -l s_vmem=40G -l mem_req=40G
#$ -V
#$ -cwd
#$ -l d_rt=1000:00:00
#$ -l s_rt=1000:00:00
#$ -t 1-15:1
#$ -tc 15

#conda activate
export PATH=~/miniconda3/bin:$PATH
source ~/miniconda3/etc/profile.d/conda.sh
conda activate renv

Rscript vcfR_geno_output_${SGE_TASK_ID}.R