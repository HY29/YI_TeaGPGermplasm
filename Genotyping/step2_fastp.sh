#!/bin/bash

#SBATCH -t 25-00:00:00
#SBATCH --mem-per-cpu 100g
#SBATCH -J fastp

#conda activate
export PATH=~/miniconda3/bin:$PATH
source ~/miniconda3/etc/profile.d/conda.sh
conda activate ngs

#mkdir
#mkdir $HOME/TeaGermplasm2021/{fastp, bam, bam_chr, gvcf, GenomicsDB, vcf}

#Directory design
GenomeDir=$HOME/reference/tea/ChrLev/
FastqDir=$HOME/TeaGermplasm/fastq/
FastpDir=$HOME/TeaGermplasm/fastp/
BamDir=$HOME/TeaGermplasm/bam/
BamChrDir=$HOME/TeaGermplasm/bam_chr/
GVCFDir=$HOME/TeaGermplasm/gvcf/
GenomicsDBDir=$HOME/TeaGermplasm/GenomicsDB/
VCFDir=$HOME/TeaGermplasm/vcf/
#fastp
cd $FastqDir

for fpath in `ls *_1.fastq.gz`
do

    fname=${fpath%_1.fastq.gz}

    #fastp
    fastp \
    --in1 $FastqDir/${fname}_1.fastq.gz \
    --in2 $FastqDir/${fname}_2.fastq.gz \
    --out1 $FastpDir/${fname}_1.pe.fastq.gz \
    --out2 $FastpDir/${fname}_2.pe.fastq.gz \
    --qualified_quality_phred 30 \
    --n_base_limit 5 \
    --detect_adapter_for_pe \
    --length_required 50 \
    --cut_front \
    --cut_front_window_size 1 \
    --cut_front_mean_quality 20 \
    --cut_tail \
    --cut_tail_window_size 1 \
    --cut_tail_mean_quality 20 \
    --html $FastpDir/${fname}.fastq.html \
    --json $FastpDir/${fname}.fastq.json \
    --thread 8 

done

#--qualified_quality_phred 15 \ #quality value (default:15)


#fastp \
#--in1 $FastqDir/${fname}_R1.fastq.gz \ #input Read_1
#--in2 $FastqDir/${fname}_R2.fastq.gz \ #input Read_2
#--out1 $TrimDir/${fname}_R1.pe.fastq.gz \ #output filterd.Read_1
#--out2 $TrimDir/${fname}_R2.pe.fastq.gz \ #output filterd.Read_2
#--n_base_limit 5 \ #one read's number of N base (default:5)
#--disable_adapter_trimming \ #adapter trimming (default)
#--length_required 15 \ #reads shorter than length_required will be discarded (default:15)
#--html $TrimDir/${fname}.fastq.html \
#--json $TrimDir/${fname}.fastq.json \
#--thread 8 #worker thread number (default:3)
 