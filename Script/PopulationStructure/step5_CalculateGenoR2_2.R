# Geno r2 ----------------------------------------------------
library(tidyverse)
library(cowplot)
library(nparcomp)

setwd("/Users/ishiguro/01_Lab_experiment/02_GenomeBreedingPJ/01_PopulationAnalysis/")

r2table = NULL
name = c("Chr1","Chr2","Chr3","Chr4","Chr5","Chr6","Chr7","Chr8","Chr9","Chr10","Chr11","Chr12","Chr13","Chr14","Chr15")
for (i in 1:15) {
  a = read.table(paste("data/GeneticStat/GenoR2/list_TP139.Chr",i,".fromfiltered_maxmiss0.7_maf0.05_minDP1_imp_genor2.geno.ld",sep = ""),header = T)
  b = a %>% 
    group_by(POS1) %>% 
    distinct(POS1,.keep_all = TRUE)
  r2 = mean(b$R.2)
  r2table = rbind(r2table,r2)
}
rownames(r2table) = name

mean = mean(r2table)
r2table = rbind(r2table,mean)


getwd()
today <- Sys.Date()
today <- gsub("-","",today)
print(today, quate=F)
write.csv(r2table,paste("",print(today,quate=F),"fromfiltered_maxmiss1.0_maf0.05_minDP3_imp_genor2.csv", sep=""))


