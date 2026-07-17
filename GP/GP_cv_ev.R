# Library & Setwd ---------------------------------------------------------
#load package
library(rrBLUP)
library(tidyverse)
library(glmnet)
library(dplyr)
library(BGLR)
library(cowplot)
set.seed(100)

getwd()
today <- Sys.Date()
today <- gsub("-","",today)
print(today, quate=F)

getwd()
setwd("/Users/ishiguro/01_Lab_experiment/01_NaturalVariation/")

# Import pheno ----------------------------------------------------
pheno_train <- read.csv("data/pheno/paper_training_FAACatechinAnthrax2.csv", row.names = 1,fileEncoding="CP932")
pheno_ex <- read.csv("/data/pheno/paper_empirical_FAACatechinAnthrax2.csv", row.names = 1,fileEncoding="CP932")

# Import geno -------------------------------------------------------------
geno_train <- read.csv("/data/geno/geno_list_gp_fromfiltered_maxmiss0.7_maf0.05_minDP1.csv")
geno_pred <- read.csv("/data/geno/geno_read50000over_maxmiss0.7_maf0.05_minDP1.csv")
geno_pred <- read.csv("/data/geno/geno_list_ex_fromfiltered_maxmiss0.7_maf0.05_minDP1_imp_v2.csv")

### 共通するマーカーを抽出
geno_joined <- inner_join(geno_train,geno_pred,by = "id",relationship = "many-to-many")
geno_joined <- geno_joined[, !(colnames(geno_joined) %in% c("chr.y","id.y","pos.y"))]
geno_joined <- rename(geno_joined, chr = chr.x, id = id, pos = pos.x)
name.marker = geno_joined$id
geno_joined <- geno_joined[,4:length(geno_joined)]
geno_joined <- t(geno_joined)
colnames(geno_joined) = name.marker
dim(geno_joined)

# training population
X.wp <- geno_joined[rownames(pheno_train),]
# validation population
X.wop <- geno_joined[!(rownames(geno_joined) %in% rownames(pheno_train)), ]
# Check
c(nrow(X.wp), nrow(X.wop))
dim(X.wp)
dim(X.wop)

# GP Empirical-Validation ------------------------------------------------------------------
# set n-fold cross varidation
n.fold = 10
# set number of repeat
rep = 10
#make directory for model
theme = print(paste("20182019NV139_FAACatechin"))
model = print(paste("GBLUP(RR)")) ##Caution!

dir.create(path = "Output/GPresult")
dir.create(path = paste("Output/GPresult/",theme,"",sep = ""))
dir.create(path = paste("Output/GPresult/",theme,"/",model,"",sep = ""))

### GBLUP
Predictedvalues <- matrix(NA, ncol=ncol(pheno_train), nrow=nrow(X.wop))
colnames(Predictedvalues) <- colnames(pheno_train)
rownames(Predictedvalues) <- rownames(X.wop)

for(i in 1:ncol(pheno_train)){
  
  trait <- colnames(pheno_train)[i]
  print(trait)
  if (model == "GBLUP(RR)" || model == "GBLUP(GAUSS)") {
    if (!requireNamespace("rrBLUP", quietly = TRUE)) {
      stop('R package "rrBLUP" is required. Please install it.')
    }
    res <- switch(model,
                  "GBLUP(RR)"    = rrBLUP::kinship.BLUP(y = pheno_train[,trait], 
                                                        G.train = X.wp, 
                                                        G.pred = X.wop, 
                                                        K.method = "RR"),
                  "GBLUP(GAUSS)" = rrBLUP::kinship.BLUP(y = pheno_train[,trait], 
                                                        G.train = X.wp, 
                                                        G.pred = X.wop, 
                                                        K.method = "GAUSS"),
                  stop('Only can use "GBLUP(RR)" and "GBLUP(GAUSS)"')
    )
    Predictedvalues[,trait] <- as.vector(res$g.pred) + c(res$beta)
    
  } else if (model == "Ridge" || model == "Lasso" || model == "ElasticNet") {
    if (!requireNamespace("glmnet", quietly = TRUE)) {
      stop('R package "glmnet" is required. Please install it.')
    }
    res <- switch(model,
                  "Ridge"      = glmnet::cv.glmnet(x = X.wp, 
                                                   y = pheno_train[,trait], 
                                                   alpha = 0),
                  "Lasso"      = glmnet::cv.glmnet(x = X.wp, 
                                                   y = pheno_train[,trait], 
                                                   alpha = 1),
                  "ElasticNet" = glmnet::cv.glmnet(x = X.wp, 
                                                   y = pheno_train[,trait], 
                                                   alpha = 0.5),
                  stop('Only can use "Ridge", "Lasso" and "ElasticNet"')
    )
    Predictedvalues[,trait] <- as.vector(stats::predict(res, newx = X.wop, s = "lambda.min"))
    
  } else if (model == "RandomForest") {
    if (!requireNamespace("randomForest", quietly = TRUE)) {
      stop('R package "randomForest" is required. Please install it.')
    }
    res <- randomForest::randomForest(x = X.wp, 
                                      y = pheno_train[,trait], 
                                      ntree = 1000)
    Predictedvalues[,trait] <- as.vector(stats::predict(res, newdata = X.wop))
  }
}
rownames(Predictedvalues) = rownames(X.wop)
write.csv(Predictedvalues,paste("Output/GPresult/",theme,"/",model,"/pheno_all_EmpiricalPop_predictvalue.csv", sep = ""))


# GP Cross-Validation --------------------------------------------------------------------
set.seed(100)
for (z in 1:length(pheno_train)){
  print(z)
  y = pheno_train[,z]
  dir.create(path=paste("Output/GPresult/",theme,"/",model,"/pheno_",z,"", sep=""))
  for (r in 1:rep){
    print(paste(z,r))     
    id <- sample(1:length(y) %% n.fold)
    id[id == 0] <- n.fold
    
    y.pred <- rep(NA, times=length(y))
    for(i in 1:n.fold) {
      print(paste(z,r,i))
      y.train <- y[id != i]
      x.train <- X.wp[id != i,]
      x.test <- X.wp[id == i,]
      

## rrBLUP ---------------------------------------------------------------------
      if (model == "GBLUP(RR)" || model == "GBLUP(GAUSS)") {
        if (!requireNamespace("rrBLUP", quietly = TRUE)) {
          stop('R package "rrBLUP" is required. Please install it.')
        }
        res <- switch(model,
                      "GBLUP(RR)"    = rrBLUP::kinship.BLUP(y = y.train,
                                                            G.train = x.train,
                                                            G.pred = x.test,
                                                            K.method = "RR"),
                      "GBLUP(GAUSS)" = rrBLUP::kinship.BLUP(y = y.train,
                                                            G.train = x.train,
                                                            G.pred = x.test,
                                                            K.method = "GAUSS"),
                      stop('Only can use "GBLUP(RR)" and "GBLUP(GAUSS)"')
        )
        y.pred[id == i] <- res$g.pred + rep(res$beta, length(res$g.pred))
## glmnet ------------------------------------------------------------------
      } else if (model == "Ridge" || model == "Lasso" || model == "ElasticNet") {
        if (!requireNamespace("glmnet", quietly = TRUE)) {
          stop('R package "glmnet" is required. Please install it.')
        }
        res <- switch(model,
                      "Ridge"        = glmnet::cv.glmnet(x = x.train, 
                                                         y = y.train, 
                                                         alpha = 0, 
                                                         standardize = F),
                      "Lasso"        = glmnet::cv.glmnet(x = x.train,
                                                         y = y.train,
                                                         alpha = 1,
                                                         standardize = F),
                      "ElasticNet"   = glmnet::cv.glmnet(x = x.train,
                                                         y = y.train,
                                                         alpha = 0.5,
                                                         standardize = F),
                      stop('Only can use "Ridge", "Lasso" and "ElasticNet"')
        )
        y.pred[id == i] <- stats::predict(res, newx = x.test, s = "lambda.min")
## randomForest ---------------------------------------------------------------
      } else if (model == "RandomForest") {
        if (!requireNamespace("randomForest", quietly = TRUE)) {
          stop('R package "randomForest" is required. Please install it.')
        }
        res <- switch(model,
                      "RandomForest" = randomForest::randomForest(x = x.train, 
                                                                  y = y.train, 
                                                                  ntree = 1000)
        )
        y.pred[id == i] <- stats::predict(res, newdata = x.test)
        
      }
      
      write.csv(y.pred, paste("Output/GPresult/",theme,"/",model,"/pheno_",z,"/pheno_",z,"_GP_10-fold_gwSNP_", r,".csv", sep=""))
      
    }}}


# GP Calculation of mean of R & RMSE value ----------------------------------------------------------------
for (z in 1:length(pheno_train)){
  print(z)
  y = pheno_train[,z]
  files <- list.files(paste("Output/GPresult/",theme,"/",model,"/pheno_",z,"", sep = ""))　　　
  
  mat<-matrix(NA,nrow=length(y),ncol=length(files)+1)
  
  for (r in 1:length(files)){
    print(paste(z,r))
    one<-read.csv(paste("Output/GPresult/",theme,"/",model,"/pheno_",z,"/pheno_",z,"_GP_10-fold_gwSNP_", r,".csv", sep=""),row.names=1)
    mat[,r]<-one[,1]
    names<-c(names,paste(r,sep=""))
  }
  
  #input actual pheno data to matrix of predicted data
  mat[,length(files)+1] <- y
  
  #R & RMSEvalue
  R.value<-c()
  RMSE.value<-c()
  
  for(m in 1:length(files)){
    print(paste(z,r,m))
    R<-cor(y,mat[,m])
    R.value<-c(R.value,R)
    print(R.value)
    
    RMSE<-sqrt((sum((y-mat[,m])^2))/length(y))
    RMSE.value<-c(RMSE.value,RMSE)
    print(RMSE.value)
  }
  write.csv(R.value, paste("Output/GPresult/",theme,"/",model,"/pheno_",z,"/pheno_",z,"_GP_10-fold_gwSNP_Rvalue.csv", sep=""))
  write.csv(RMSE.value, paste("Output/GPresult/",theme,"/",model,"/pheno_",z,"/pheno_",z,"_GP_10-fold_gwSNP_RMSEvalue.csv", sep=""))
  
}

# Mean & SD of R.value
matR<-matrix(NA,nrow=length(R.value),ncol=length(pheno_train))
matR_MeanSD<-matrix(NA,ncol=2,nrow=length(pheno_train))
colnames(matR_MeanSD)<-c("R2_Mean","R2_SD")
rownames(matR_MeanSD)<-colnames(pheno_train)
for (i in 1:length(pheno_train)){
  print(paste(i))
  one<-read.csv(paste("Output/GPresult/",theme,"/",model,"/pheno_",i,"/pheno_",i,"_GP_10-fold_gwSNP_Rvalue.csv", sep=""),row.names=1)
  matR[,i]<-one[,1]
  matR_MeanSD[i,1]<-mean(matR[,i])
  matR_MeanSD[i,2]<-sd(matR[,i])
  
}
write.csv(matR_MeanSD, paste("Output/GPresult/",theme,"/",model,"/Allpheno_GP_10-fold_gwSNP_MeanSD_Rvalue.csv", sep=""))

# Mean & SD of RMSE
matRMSE<-matrix(NA,nrow=length(R.value),ncol=length(pheno_train))
matRMSE_MeanSD<-matrix(NA,ncol=2,nrow=length(pheno_train))
colnames(matRMSE_MeanSD)<-c("RMSE_Mean","RMSE_SD")
rownames(matRMSE_MeanSD)<-colnames(pheno_train)
for (i in 1:length(pheno_train)){
  print(paste(i))
  one<-read.csv(paste("Output/GPresult/",theme,"/",model,"/pheno_",i,"/pheno_",i,"_GP_10-fold_gwSNP_RMSEvalue.csv", sep=""),row.names=1)
  matRMSE[,i]<-one[,1]
  matRMSE_MeanSD[i,1]<-mean(matRMSE[,i])
  matRMSE_MeanSD[i,2]<-sd(matRMSE[,i])
}
write.csv(matRMSE_MeanSD, paste("Output/GPresult/",theme,"/",model,"/Allpheno_GP_10-fold_gwSNP_MeanSD_RMSEvalue.csv", sep=""))


# Make bar plot of prediction accuracy -----------------------------------------------------------
matR_MeanSD = matR_MeanSD %>% 
  as.data.frame() %>% 
  tibble::rownames_to_column(var = "pheno")


matR_MeanSD$pheno=fct_inorder(matR_MeanSD$pheno)

# 最大値を取得．のちに使用
ylim = max(matR_MeanSD$R2_Mean + matR_MeanSD$R2_SD)*1.2


g = ggplot(matR_MeanSD, #使用するデータ
           # グラフのx,yの指定．x軸はpH，y軸はmean
           # fillで2つ目の要因を指定し塗り分ける (treatで塗り分ける)
           aes(x=pheno, y=R2_Mean,fill=pheno))+
  # geom_barで棒グラフ指定(x軸，y軸を指定するときはstat="identity")．
  # 2要因の場合はposition=position_dodge．widthで系列間の距離を設定
  geom_bar(stat="identity",position = position_dodge(width = 0.9))+
  # geom_errorbarでエラーバー追加．widthで幅設定．sizeで線の太さ設定
  # geom_barと同様にposition=position_dodge. ()の中はgeom_barのwidthの値を指定
  geom_errorbar(aes(ymax = R2_Mean + R2_SD, ymin = R2_Mean - R2_SD), width=0.2, size=0.5, position = position_dodge(0.9))+
  # y = 0に黒い線つける
  geom_segment(aes(x = -Inf,xend = Inf,y = 0, yend = 0),color = "black")+
  # y軸を0からにする(スペースをなくす)．軸の上限を設定 / 今回は負の値があるため-0.4-0.7に指定
  scale_y_continuous(expand = c(0,0),limits = c(-0.4,1.0))+
  # 論文っぽい見た目にする．(cowplotパッケージが別途必要)．フォントサイズと線の太さを設定
  #theme_cowplot(font_size = 10, line_size = 1.25,)+
  theme_cowplot(font_size = 25, line_size = 1.25,)+
  # 見た目を整える(タイトルの位置，縦横比など)
  theme(plot.title = element_text(hjust = 0, size = 28),aspect.ratio = 0.5)+
  #theme(plot.title = element_text(hjust = 0, size = 28))+
  # x軸の文字を90度傾ける    #hjustでx軸ラベルの位置調整
  theme(axis.text.x = element_text(angle = 90, hjust = 1,vjust = 0.5))+
  #凡例の位置変更
  theme(legend.position = c(0.05,1),legend.justification = c(0,1),legend.background = element_blank(),legend.title = element_blank())+
  # 色を指定．RGB or 色名で．
  scale_fill_grey(start = .2, end = .7, guide = "none")+
  #scale_fill_manual(values = c("#0168B7","#3889C7","#70ABD8","#F8C670","#F5AE39","#F39800"))+
  # タイトル，軸ラベルの内容を設定．上付き文字等も可能
  labs(title="", x="", y=expression(Prediction~accuracy~"("~r~")"))
g

getwd()
today <- Sys.Date()
today <- gsub("-","",today)
print(today, quate=F)
ggsave(paste("/Output/GPresult/",theme,"/",model,"/",print(today,quate=F),"_PredictionAccuracy.png",sep = ""),bg = "transparent" ,dpi = 200, width = 8, height = 8)


# Summarize predicted values ------------------------------------------------------------------
pheno.predict <- matrix(NA,nrow = nrow(pheno_train),ncol = length(pheno_train))
colnames(pheno.predict) <- colnames(pheno_train)
rownames(pheno.predict) <- rownames(pheno_train)

for (z in 1:(length(pheno_train) - 1)){
  print(z)
  y = pheno_train[,z]
  files <- list.files(paste("Output/GPresult/",theme,"/",model,"/pheno_",z,"", sep = ""))
  mat<-matrix(NA,nrow=length(y),ncol=length(files)-2)
  
  
  for (r in 1:10) {
    print(paste(z,r))
    csv_data <- read.csv(paste("Output/GPresult/",theme,"/",model,"/pheno_",z,"/pheno_",z,"_GP_10-fold_gwSNP_", r,".csv", sep=""),row.names=1)
    mat[,r]<-csv_data[,1]
    
  }
  print(z)
  pheno.predict[,z] <- rowMeans(mat[,1:10])
}
write.csv(pheno.predict,paste("Output/GPresult/",theme,"/",model,"/Allpheno_GP_10-fold_gwSNP_PredictValue.csv", sep=""))
