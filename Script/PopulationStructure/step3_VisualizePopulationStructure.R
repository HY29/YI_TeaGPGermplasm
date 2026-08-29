library(tidyverse)
library(ape)
library(ggtree)
library(patchwork)

setwd("/Users/ishiguro/01_Lab_experiment/02_GenomeBreedingPJ/01_PopulationAnalysis/")

# Data import -------------------------------------------------------------
geno <- read.csv("geno/geno_list_germplasm_maxmiss0.7_maf0.05_minDP1_imp.csv")
geno <- geno[,4:length(geno)]
x <- t(geno)

Q = read.table("fastSTRUCTURE/2497系統_102189variants/result/meanQ/faststructure.7.meanQ",header = FALSE)

fam = read.table("data/concat.list_read50000_maxmiss0.7_maf0.05_minDP1_imp.fam",
                 header = FALSE,
                 stringsAsFactors = FALSE)

Metadata = read.csv("Metadata_germplasm.csv",fileEncoding = "CP932")
Metadata2 = Metadata %>% 
  arrange(SampleID)

# Sample ID ---------------------------------------------------------------
sample_hca = rownames(x)
sample_fast = fam[,2]

identical(sample_hca, sample_fast)
setequal(sample_hca, sample_fast)

# HCA ---------------------------------------------------------------------
rd = dist(x)
rc = hclust(rd, method = "ward.D2")


## Get ggtree order for pophelper ---------------------------------------------------------------------
HCA_order = rownames(x)[rc$order]
alphabet_order = sort(rownames(x))
ggtree_order = data.frame(HCA_order,
                          alphabet_order)
ggtree_order = ggtree_order[order(ggtree_order$HCA_order),]
order2497 = ggtree_order$alphabet_order

## Make figure ---------------------------------------------------------------------
rc_tree = as.phylo(rc)
rc_tree$tip.label <- Metadata2$Variety

grp <- list(Japanese_var._sinensis = (Metadata2 %>% filter(Variety=="Japanese var. sinensis"))[,6],
            Exotic_var._sinensis = (Metadata2 %>% filter(Variety=="Exotic var. sinensis"))[,6],
            var._assamica = (Metadata2 %>% filter(Variety=="var. assamica"))[,6],
            Unknown = (Metadata2 %>% filter(Variety=="Unknown"))[,6])

grp
grp <- as.list(grp)
rc_tree <- groupOTU(rc_tree,grp,"Variety")
rc_tree

mycolors4 <- c("#0993A0","#FDBF3A","#5A595A","#E56C53")

r <- ggtree(rc_tree, 
            layout = 'rectangular',
            mapping = aes(color = Variety)) +
  theme(panel.background = element_rect(fill = "transparent",color = NA),
        panel.grid.minor = element_line(color = NA), 
        panel.grid.major = element_line(color = NA),
        plot.background = element_rect(fill = "transparent",color = NA),
        legend.position = "none",
        legend.background = element_rect(fill = NA, colour = NA))+ 
  scale_color_manual(values = mycolors4)
r
## Export ---------------------------------------------------------------------
getwd()
today <- Sys.Date()
today <- gsub("-","",today)
print(today, quate=F)
ggsave(paste("",print(today,quate=F),"_germplasm2497_HCA.pdf", sep=""), dpi = 200, width = 30, height = 30)


# fastSTRUCTURE -----------------------------------------------------------
sfiles <- list.files("/Users/ishiguro/01_Lab_experiment/02_GenomeBreedingPJ/01_PopulationAnalysis/fastSTRUCTURE/2497系統_102189variants/result/meanQ/", full.names=T)
slist <- readQ(files=sfiles)
head(slist[[10]])

Label2 = cbind(Metadata2,order2497)
rownames(slist[[1]]) <- Label2$order2497
if(length(unique(sapply(slist,nrow)))==1) slist2 <- lapply(slist,"rownames<-",Label2$order2497)
lapply(slist, rownames)[1:2]

labelset <- as.data.frame(Label2$order2497)
head(labelset)
rownames(labelset) <- Label2$order2497
labelset$`Label2$order2497`=as.character(labelset$`Label2$order2497`)

p1 <- plotQ(slist[18],returnplot=T,exportplot=F,basesize=2,
            grplab=labelset,
            #grplabsize=4,
            showgrplab=F,
            linesize = 0.8,
            pointsize=4,ordergrp = T,
            #subsetgrp="Exotic",
            showindlab=F,showdiv=FALSE,
            indlabwithgrplab=T)
grid.arrange(p1$plot[[1]])

## Export ---------------------------------------------------------------------
getwd()
today <- Sys.Date()
today <- gsub("-","",today)
print(today, quate=F)
ggsave(paste("",print(today,quate=F),"_germplasm2497_FS_K7.pdf", sep=""), dpi = 200, width = 30, height = 30)



# PCA ---------------------------------------------------------------------
dim(x)

res <- prcomp(x)
pc <- summary(res)
pc1=format(signif(pc$importance[2]*100, digits = 3), nsmall=1) 
pc2=format(signif(pc$importance[5]*100, digits = 3), nsmall=1)
pc3=format(signif(pc$importance[8]*100, digits = 3), nsmall=1)
pc4=format(signif(pc$importance[11]*100, digits = 3), nsmall=1)
pc5=format(signif(pc$importance[14]*100, digits = 3), nsmall=1)
pc6=format(signif(pc$importance[17]*100, digits = 3), nsmall=1)

pcs <- res$x[,1:6]

rm(res)

pca.data <- as.data.frame(pcs)
pca.data <- cbind(pca.data, Metadata2[,1:length(Metadata2)])


g = ggplot(pca.data, aes(y=PC2, x=PC1, fill=Variety))+
  geom_point(color="black",shape=21,size=4, alpha=0.9)+
  theme_cowplot(font_size = 50, line_size = 1.25)+
  theme(text=element_text(size=60),
        legend.position = 'none',
        axis.text=element_text(size=60,color="black"))+
  scale_fill_manual(values = c("#0993A0","#FDBF3A","#5A595A","#E56C53"))+
  ylab(bquote("PC2 ("~.(pc2) ~"%)"))+
  xlab(bquote("PC1 ("~.(pc1) ~"%)"))
g

## Export ---------------------------------------------------------------------
getwd()
today <- Sys.Date()
today <- gsub("-","",today)
print(today, quate=F)
ggsave(paste("",print(today,quate=F),"_germplasm2497_PCA.png", sep=""), bg = "transparent" ,dpi = 200, width =15, height = 15)






# Visualization for main figure ---------------------------------------------------------------------
## Data setting -------------------------------------------------------------
colnames(Q) = paste0("Sub-Pop",1:7)
#Q$Sample = rownames(Q)
Q$Sample = Metadata2$SampleID

Q.long = Q %>%
  pivot_longer(cols=starts_with("Sub-Pop"),
               names_to="Population",
               values_to="Probability")


## fastSTRUCTURE -----------------------------------------------------------
Q.long$Sample = factor(Q.long$Sample, levels=HCA.order)
mycolors7 <- c("#212AD9","#9A99FF","#DF2000","#06B405","#FFFB23","#FF9326","#A945FF")

### fastSTRUCTURE visualization ---------------------------------------------------------------
g.Q = ggplot(Q.long, aes(x=Sample, y=Probability, fill=Population))+
  geom_col(width=1)+
  scale_y_continuous(expand=c(0,0))+
  scale_x_discrete(expand=c(0,0))+
  theme_cowplot()+
  scale_fill_manual(values = mycolors7)+
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.x=element_blank(),
        legend.position = 'none')+
        #legend.position="bottom")+
  theme(plot.margin = margin(-5,0,0,0))+
  ylab("Ancestry\nprobability")
g.Q

g.Q = g.Q+
  annotate("text",
           x=Inf,
           y=0.5,
           label="italic(K) == 7",
           parse=TRUE,
           angle=90,
           hjust=0.5,
           vjust=1.4,
           size=6)+
  coord_cartesian(clip="off")+
  theme(plot.margin=margin(0,35,0,0))
g.Q


## (Variety annotation) ------------------------------------------------------
#Metadata2$Sample = factor(Metadata2$Sample, levels=HCA.order)

#g.variety = ggplot(Metadata2, aes(x=Sample, y=1, fill=Variety))+
#  geom_tile()+
#  scale_x_discrete(expand=c(0,0))+
#  theme_void()+
#  scale_fill_manual(values = c("#0993A0","#FDBF3A","#5A595A","#E56C53"))+
#  theme(legend.position="right")
#g.variety

## HCA ---------------------------------------------------------------------
### HCA order ---------------------------------------------------------------
HCA.order = rc$labels[rc$order]

### HCA visualization ---------------------------------------------------------------
rc_tree = as.phylo(rc)
rc_tree$tip.label <- Metadata2$Variety
grp <- list(Japanese_var._sinensis = (Metadata2 %>% filter(Variety=="Japanese var. sinensis"))[,6],
            Exotic_var._sinensis = (Metadata2 %>% filter(Variety=="Exotic var. sinensis"))[,6],
            var._assamica = (Metadata2 %>% filter(Variety=="var. assamica"))[,6],
            Unknown = (Metadata2 %>% filter(Variety=="Unknown"))[,6])
grp
grp <- as.list(grp)
rc_tree <- groupOTU(rc_tree,grp,"Variety")
rc_tree

mycolors4 <- c("#0993A0","#FDBF3A","#5A595A","#E56C53")

g.tree = ggtree(rc_tree,
                layout = "rectangular",
                mapping = aes(color = Variety))+
  layout_dendrogram()+
  theme(panel.background = element_rect(fill = "transparent",color = NA),
        panel.grid.minor = element_line(color = NA),
        panel.grid.major = element_line(color = NA),
        plot.background = element_rect(fill = "transparent",color = NA),
        legend.position = "none",
        legend.background = element_rect(fill = NA,colour = NA),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        axis.line = element_blank())+
  theme(plot.margin = margin(0,0,-5,0))+
  scale_color_manual(values = mycolors4)
g.tree

## Group label -------------------------------------------------------------
Group = cutree(rc,k=2)

group.df = data.frame(
  Sample = names(Group),
  Group = paste0("Group ",Group)
)

group.df = group.df[match(HCA.order,group.df$Sample),]
group.df$x = 1:nrow(group.df)

### Group 1 Group 2 ------------------------------------
group.change = which(group.df$Group[-1] != group.df$Group[-nrow(group.df)])
boundary.x = group.change + 0.5

group.left = group.df$Group[1]
group.right = group.df$Group[nrow(group.df)]

group.df$Group[group.df$Group == group.left] = "Group 1"
group.df$Group[group.df$Group == group.right] = "Group 2"

left.x = 0.5
right.x = nrow(group.df) + 0.5

group.range = data.frame(
  Group = c("Group 1","Group 2"),
  xmin = c(left.x,boundary.x),
  xmax = c(boundary.x,right.x)
)

group.range$xmid = (group.range$xmin + group.range$xmax) / 2

### Group label visualization ------------------------------------
g.group = ggplot()+
  geom_segment(data = group.range,
               aes(x = xmin, xend = xmax, y = 1, yend = 1),
               linewidth = 0.5)+
  geom_segment(aes(x = left.x, xend = left.x, y = 0.9, yend = 1.1),
               linewidth = 0.5)+
  geom_segment(aes(x = boundary.x, xend = boundary.x, y = 0.9, yend = 1.1),
               linewidth = 0.5)+
  geom_segment(aes(x = right.x, xend = right.x, y = 0.9, yend = 1.1),
               linewidth = 0.5)+
  geom_text(data = group.range,
            aes(x = xmid, y = 0.93, label = Group),
            size = 4,
            family = "Helvetica")+
  scale_x_continuous(limits = c(0.5,nrow(group.df)+0.5),
                     expand = c(0,0))+
  scale_y_continuous(limits = c(0.85,1.18),
                     expand = c(0,0))+
  theme_void()+
  theme(plot.margin = margin(-5,0,0,0))

g.group


## Merge ---------------------------------------------------------------------
g.all = g.tree /
  g.Q /
  g.group +
  plot_layout(heights=c(2,1,0.30))

g.all

## Export ---------------------------------------------------------------------
getwd()
today <- Sys.Date()
today <- gsub("-","",today)
print(today, quate=F)
ggsave(paste("",print(today,quate=F),"_germplasm2497_HCAfastStructure3.png", sep=""), bg = "transparent" ,dpi = 200, width =10, height = 5)
