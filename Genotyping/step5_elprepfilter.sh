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


##elprepfilter
cd $BamDir

#Chr
for i in {1..15}
do
  mkdir $GVCFDir/Chr${i}

  for fpath in `ls *.sort.bam`
	do
	  fname=${fpath%.sort.bam}
    #elprepfilter
    elprep filter $BamChrDir/Chr${i}/${fname}.Chr${i}.bam $BamChrDir/Chr${i}/${fname}.Chr${i}.filtered.bam \
    --mark-duplicates --remove-duplicates \
    --sorting-order coordinate \
    --reference $GenomeDir/CSS_ChrLev_20200506_Genome_v2.elfasta \
    --haplotypecaller $GVCFDir/Chr${i}/${fname}.Chr${i}.g.vcf.gz \
    --nr-of-threads 8
  done

done
