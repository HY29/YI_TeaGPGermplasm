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

#samtools view: bam split
cd $BamDir
for i in {1..15}
do
	mkdir $BamChrDir/Chr${i}

	for fpath in `ls *.sort.bam`
	do
		fname=${fpath%.sort.bam}

		samtools view -bh $BamDir/${fname}.sort.bam Chr${i} > $BamChrDir/Chr${i}/${fname}.Chr${i}.bam
	done

 done

    


 