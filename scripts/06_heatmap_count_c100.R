#!/usr/local/bin/Rscript

data <- read.csv(file = 'results/tables/antibiotic_frequency.c100.tsv', sep="\t", header = TRUE)


data$Species

data[1,2:ncol(data)]

ncol(data)

nrow(data)


#quit()

dataset <- as.data.frame(data[,2:ncol(data)])
dataset
#quit()

rownames(dataset) <- data$Species

length(dataset[1,])
length(dataset[,1])

#移除以數字開頭的名稱 會自動在前方加"X"的情況
colnames(dataset) <- substr(colnames(dataset),2,nchar(colnames(dataset)))
colnames(dataset)

#quit()

# 移除都是 0 的 column
dataset <- dataset[,which(colSums(dataset)>0)]


#dataset[1:8,1:5]

M2 <- as.matrix(dataset[1:length(dataset[,1]),1:length(dataset[1,])])

M2

#quit()

#sapply(dataset, as.numeric)
#class(dataset) <- "numeric"
#storage.mode(dataset) <- "numeric"



tM2 <- t(M2)

# 斜體顯示
newnames <- lapply(
  rownames(dataset),
  function(x) bquote(italic(.(x))))

library("ComplexHeatmap")

#annotation_col = data.frame(
#    Type = factor(rep(c("EC", "EU"), c(4, 4)))
#)

library("stringr")

colnames(dataset)


annotation_col = data.frame(
  #以“.”為分隔符號，擷取抗生素前面的編號來做Class的分類
    Class = factor(str_split_fixed(colnames(dataset), '[.]', 2) [,1])
)

annotation_col

#quit()

#annotation_row = data.frame(
#    GeneRanking = 1:20
#)

ann_colors = list(
    Class = c("01"="#E3908C9B", "02"="#FFA5009B", "03"="#5CC0FF9B", "04"="#0175809B", "05"="#C99AE09B", "06"="#FF6C5C9B", 
      "07"="#415F949B", "08"="#61E7869B", "09"="#E0C6639B", "10"="#E044449B", "11"="#529CE09B", "12"="#E0721D9B", 
      "13"="#8435949B", "14"="#E07B689B", "15"="#274B949B", "16"="#8CE0669B", "17"="#944E2F9B", "18"="#F759CF9B", 
      "19"="#65E4E49B", "20"="#CB00009B", "21"="#1627DB9B", "22"="#9994DE9B", "23"="#8F79069B", "24"="#8080809B")  
#    Type = c(EC = "#1B9E77", EU = "#D95F02"),
#    GeneRanking = c("dark green", "white")
)

#names(ann_colors$Class) <- c("EXp1"="01", "Exp2"="02", "Exp3"="03", "Exp4"="04", "Exp5"="05", "Exp6"="06", 
#  "Exp7"="07", "Exp8"="08", "Exp9"="09", "Exp10"="10", "Exp11"="11", "Exp12"="12", 
#  "Exp13"="13", "Exp14"="14", "Exp15"="15", "Exp16"="16", "Exp17"="17", "Exp18"="18", 
#  "Exp19"="19", "Exp20"="20", "Exp21"="21", "Exp22"="22", "Exp23"="23", "Exp24"="24")


#pdf(file="heatmap.pdf", width=24, height=4)  #橫的顯示
pdf(file="results/figures/heatmap_count_c100.pdf", width=5, height=14)  #直的顯示

#par(mfrow=c(1,1))
#par(mar = c(1, 1, 1, 1) + 0.3)

#breaksList = seq(0, 32000, by = 1000)

#library("RColorBrewer")
#colors<-colorRampPalette(rev(brewer.pal(n=7,name="RdYlBu")))(255)
#colors = colorRampPalette(rev(brewer.pal(n = 7, name = "RdYlBu")))(length(breaksList))
#colors = rev(hcl.colors(50, "RdYlBu"))
colors = rev(hcl.colors(50, "BluYl"))

#pheatmap(tM2, name = "Matrix", annotation_row = annotation_row, annotation_col = annotation_col, annotation_colors = ann_colors, main = "Selected by P-value", clustering_method = "complete")
#pheatmap(M2, name = "AMR count\n", clustering_method = "complete", cellwidth = 16, cellheight = 16, fontsize_col = 10, fontsize_row = 10, angle_col = "45", color = colorRampPalette(c("white", "blue", "navy"))(20), breaks = breaksList)
#pheatmap(M2, name = "Antibiotic \ncount\n", clustering_method = "complete", cellwidth = 16, cellheight = 16, fontsize_col = 10, fontsize_row = 10, angle_col = "45", color = colorRampPalette(c("white", "#1F45FC", "navy"))(20), labels_row = as.expression(newnames))

#橫的顯示
#pheatmap(M2, name = "Antibiotic \ncount\n", annotation_col = annotation_col, annotation_colors = ann_colors, clustering_method = "complete", cellwidth = 16, cellheight = 16, fontsize_col = 10, fontsize_row = 10, angle_col = "45", color = colorRampPalette(c("white", "#1F45FC", "navy"))(20), labels_row = as.expression(newnames))

#直的顯示
pheatmap(tM2, cluster_rows = FALSE, cluster_cols = FALSE, name = "Antibiotic \ncount\n", annotation_row = annotation_col, annotation_colors = ann_colors, annotation_legend = FALSE, clustering_method = "complete", cellwidth = 18, cellheight = 10.5, fontsize_col = 10, fontsize_row = 10, angle_col = "90", color = colorRampPalette(c("white", "#1F45FC", "navy"))(20), labels_col = as.expression(newnames))


#pheatmap(M2, name = "CAZyme \ncount\n", clustering_method = "complete", cellwidth = 16, cellheight = 16, fontsize_col = 10, fontsize_row = 10, angle_col = "45", color = colors, breaks = breaksList)


dev.off()

