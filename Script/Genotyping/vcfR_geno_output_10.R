###vcf data construction for GP

#library
library(vcfR)
library(tidyverse)

#setwd
setwd("/TeaMix/")

#set file name
inputname = "list_TP139.Chr10.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp"
outputname = "list_TP139.Chr10.fromfiltered_maxmiss0.7_maf0.05_minDP1_imp"

#read compressed vcf file(*.vcf.gz)
vcf <- read.vcfR(paste("vcf/filtered/",inputname,".vcf.gz", sep=""))
vcf
sum(as.integer(is.indel(vcf)))
#extract genotype data from vcf
info <- extract.info(x=vcf, element="GT")
gt <- extract.gt(x=vcf, element = "GT", IDtoRowNames = FALSE)
#get marker information
chr <- getCHROM(vcf)
pos <- getPOS(vcf)

#create a matrix of gt score
gt.score <- matrix(NA, nrow(gt), ncol(gt))
gt.score[gt == "0|0"] <- -1
gt.score[gt == "0|1"] <- 0
gt.score[gt == "1|0"] <- 0
gt.score[gt == "1|1"] <- 1
table(is.na(gt.score))
dim(gt.score)
head(gt.score)
#write.csv(gt.score,"geno/DIT_geno.csv")
#name the rows and columns of matrix
rownames(gt.score) <- rownames(gt)
colnames(gt.score) <- colnames(gt)

#transpose the matrix
gt.score <- t(gt.score)

#format to dataframe
chr <- as.data.frame(chr)
pos <- as.data.frame(pos)

id <- matrix(NA, nrow(chr),1)
colnames(id) <- "id"
for (i in 1:nrow(chr)){
  print(i)
  id[i,1] <- paste("Marker_",chr[i,1],"_",pos[i,1],"", sep="")
}
ID <- as.data.frame(id)
gt.score <- as.data.frame(gt.score)
gt.score <- t(gt.score)
VariantTable <- cbind.data.frame(chr, pos, ID, gt.score)
head(VariantTable)

rownames(gt.score)

write.csv(VariantTable,paste("geno/",outputname,".csv", sep=""), row.names = FALSE)


