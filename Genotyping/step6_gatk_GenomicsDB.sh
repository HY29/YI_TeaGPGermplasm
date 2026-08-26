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

#output sample list for gatk GenomicsDB
#Chr
for i in {1..15}
do
  cd $BamDir
  n=0
  for fpath in `ls *.sort.bam`
  do
    fname=${fpath%.sort.bam}
    cd $GVCFDir
    let n++
    echo -e "sample${n}\t${fname}.Chr${i}.g.vcf.gz"
  done > $GenomicsDBDir/SampleList_Chr${i}.txt
done

#gatk GenomicsDB
#Chr
for i in {1..15}
do
  cd $GVCFDir/Chr${i}

  gatk --java-options "-Xmx16G" \
  GenomicsDBImport \
  --genomicsdb-workspace-path $GenomicsDBDir/Chr${i}_DB \
  -R $GenomeDir/CSS_ChrLev_20200506_Genome_v2.fasta \
  --sample-name-map $GenomicsDBDir/SampleList_Chr${i}.txt \
  --intervals Chr${i}
  
done

