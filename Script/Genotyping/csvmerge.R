
setwd("/TeaGermplasm/geno/")

# load package
library(tidyverse)
file_list <- list.files("/TeaGermplasm/geno/",pattern = ".csv")
file_list

bind_data <- NULL

for (i in 1:length(file_list)) {
  csv_data<-read.csv(file_list[i])
  bind_data<-rbind(bind_data, csv_data)
  
}
dim(bind_data)

write.csv(bind_data,"/TeaGermplasm/geno/geno_list_germplasm_maxmiss0.7_maf0.05_minDP1_imp.csv", row.names = FALSE)

