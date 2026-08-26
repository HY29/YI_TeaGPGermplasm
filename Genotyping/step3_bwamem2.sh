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

#bwa-mem2:mapping
cd $FastpDir

for fpath in `ls *_1.pe.fastq.gz`
do

    fname=${fpath%_1.pe.fastq.gz}
    bamRG="@RG\tID:"${fname}"\tPL:ILLUMINA\tSM:"${fname}

    bwa-mem2 mem \
    -t 8 \
    -M \
    -T 30 \
    -R ${bamRG} \
    $GenomeDir/CSS_ChrLev_20200506_Genome_v2.fasta \
    $FastpDir/${fname}_1.pe.fastq.gz \
    $FastpDir/${fname}_2.pe.fastq.gz \
    |
    samtools sort \
    -m 8G \
    -@ 4 \
    -o $BamDir/${fname}.sort.bam \
    -
    
    #samtools:index
    samtools index $BamDir/${fname}.sort.bam

done


 