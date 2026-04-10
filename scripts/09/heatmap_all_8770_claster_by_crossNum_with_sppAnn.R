#!/usr/local/bin/Rscript

data <- read.csv(file = 'all_8770_pattern_crossNum_sppAnn.tsv', sep="\t", header = TRUE)


data$Genome_ID


data[1,2:ncol(data)]


data$Species = replace(data$Species, data$Species=="Acinetobacter baumannii", "A. baumannii")
data$Species = replace(data$Species, data$Species=="Enterococcus faecium", "E. faecium")
data$Species = replace(data$Species, data$Species=="Klebsiella pneumoniae", "K. pneumoniae")
data$Species = replace(data$Species, data$Species=="Pseudomonas aeruginosa", "P. aeruginosa")
data$Species = replace(data$Species, data$Species=="Staphylococcus aureus", "S. aureus")


data$Species

#data$AB
#data$EF
#data$KP
#data$PA
#data$SA

#quit()

ncol(data)

nrow(data)

#data


# 設定篩選條件
#data <- data[ which((data$Cross_num=="1" & data$Species=="K. pneumoniae") | (data$Cross_num=="5" & data$Species=="A. baumannii")), ] 
data <- data[ which(data$Cross_num > 1), ] 


data
ncol(data)
nrow(data)


#quit()

dataset <- as.data.frame(data[,3:(ncol(data)-8)])

#quit()

rownames(dataset) <- data$Genome_ID

length(dataset[1,])
length(dataset[,1])

#dataset[1:8,1:5]

#移除以數字開頭的名稱 會自動在前方加"X"的情況
colnames(dataset) <- substr(colnames(dataset),2,nchar(colnames(dataset)))
colnames(dataset)


#quit()


M2 <- as.matrix(dataset[1:length(dataset[,1]),1:length(dataset[1,])])

M2

#quit()

#sapply(dataset, as.numeric)
#class(dataset) <- "numeric"
#storage.mode(dataset) <- "numeric"



tM2 <- t(M2)

library("ComplexHeatmap")

freq <- colSums(M2) # 直接加總 column
#freq <- colSums(M2 == 1) # 計算數值為 1 的數量
#freq <- colSums(M2 == 0) # 計算數值為 0 的數量
freq

length(dataset[,1])

p_freq <- freq/length(dataset[,1])
p_freq

c(p_freq)



bar <- matrix(nc = 1, c(p_freq))
bar

#quit()

r_bar <- bar[nrow(bar):1, ] # reverse rows in matrix (anno_barplot 註解的順序是相反的)
r_bar


# distance in the ASCII table
dist_letters = function(x, y) {
    x = strtoi(charToRaw(paste(x, collapse = "")), base = 16)
    y = strtoi(charToRaw(paste(y, collapse = "")), base = 16)
#    sqrt(sum((x - y)^2))  # ASCII distance
    sum((x - y) != 0)      # non-zero conut
}



library("stringr")

class_id = factor(str_split_fixed(colnames(dataset), '[.]', 2) [,1]) # 抗生素類別的標籤
class_col = c("01"="#E3908C9B", "02"="#FFA5009B", "03"="#5CC0FF9B", "04"="#0175809B", "05"="#C99AE09B", "06"="#FF6C5C9B", 
      "07"="#415F949B", "08"="#61E7869B", "09"="#E0C6639B", "10"="#E044449B", "11"="#529CE09B", "12"="#E0721D9B", 
      "13"="#8435949B", "14"="#E07B689B", "15"="#274B949B", "16"="#8CE0669B", "17"="#944E2F9B", "18"="#F759CF9B", 
      "19"="#65E4E49B", "20"="#CB00009B", "21"="#1627DB9B", "22"="#9994DE9B", "23"="#8F79069B", "24"="#8080809B")  # 抗生素類別的顏色

class_id
class_col

#quit()


pdf(file="heatmap_all_8770_cluster_by_crossNum_with_sppAnn.pdf", width=28, height=28)


#ha = HeatmapAnnotation(freq. = anno_barplot(r_bar, gp = gpar(fill = c("#C4D79B", "#FEFF96", "#EB5953", "#E0E0E0")),
ha = HeatmapAnnotation(Freq. = anno_barplot(bar, gp = gpar(fill = c("#C54032")),
  axis_param=list(gp=gpar(fontsize = 16)),   # 改變軸上的刻度字型大小
  beside = TRUE, # beside = TRUE 時，要使用 reverse rows in matrix (bar -> r_bar) ，因為註解的順序會相反
  bar_width = 0.5,
  attach = TRUE,
#  add_numbers = TRUE, # It only works when x is a simple vector.
  height = unit(2, "cm")
  ),

  Class = class_id, # 設定抗生素類別的標籤
  col = list(Class = class_col), # 設定抗生素類別的顏色

  show_legend = FALSE,
  annotation_name_gp= gpar(fontsize = 20)  # 改變 "freq." 標籤的字型大小
)



ht_opt(
    legend_title_gp = gpar(fontsize = 20, fontface = "plain"), # 改變右邊 Annotation 的 legend 的字型大小
    legend_labels_gp = gpar(fontsize = 16, fontface = "plain"),  # 改變右邊 Annotation 的 legend 的字型大小
    legend_grid_height = unit(5, "mm"), legend_grid_width = unit(5, "mm"), legend_gap = unit(5, "mm"), # 改變 Annotation 的 legend 的圖示大小
#    heatmap_column_names_gp = gpar(fontsize = 16),
    heatmap_row_names_gp = gpar(fontsize = 20),
#    heatmap_column_title_gp = gpar(fontsize = 10),
    heatmap_row_title_gp = gpar(fontsize = 22, fontface = "plain")  # 控制左邊每個分類名稱的字型大小 例如："Acinetobacter baumannii", "Enterococcus faecium", "Klebsiella pneumoniae", "Pseudomonas aeruginosa", "Staphylococcus aureus"
)

annotation_row = data.frame(
  Cross_num = data$Cross_num
)

#annotation_row

ann_colors = list(
    Cross_num = c("#AFADDE", "#BEE3ED", "#FFF1BA", "#FFB3B3", "#F595B2")
)


data2 <- data.frame(data[,95], data[,96], data[,97], data[,98], data[,99], data[,100])

colnames(data2) <- c("Cross-species", "A. baumannii", "E. faecium", "K. pneumoniae", "P. aeruginosa", "S. aureus")

data2

#quit()

# How do I generate a mapping from numbers to colors in R?
# https://stackoverflow.com/questions/15006211/how-do-i-generate-a-mapping-from-numbers-to-colors-in-r

# colorRampPalette(c('blue', 'red'))(length(x))[rank(x)]

#The simplest thing I can think of is discretizing your variable x with cut and then using the resultant factor to index a color Palettes like heat.colors or cm.colors
#f <- function(x,n=10){
#    heat.colors(n)[cut(x,n)]
#}

#abc = seq(from=-9.9, to=-9, by=0.1)

#abc = c("Acinetobacter baumannii", "Enterococcus faecium", "Klebsiella pneumoniae", "Pseudomonas aeruginosa", "Staphylococcus aureus")

#abc = c("1", "2", "3", "4", "5")
abc = 2:5
#mypal = colorRampPalette( c( "#AFADDE", "#BEE3ED", "#FFF1BA", "#FFB3B3", "#F595B2" ) )( 5 )
mypal = colorRampPalette( c("#90E0EF", "#023E8A") )( 4 )
#CAF0F8, #ADE8F4, #90E0EF", "#48CAE4", "#0096C7", "#0077B6", "#023E8A
#1F45FC, "navy"

#names(mypal) = abc #非連續性的資料

library(circlize)
col_fun = colorRamp2(abc, mypal)  #連續性的資料


row_ha = rowAnnotation(
#    empty = anno_empty(border = FALSE),
#    foo = anno_block(gp = gpar(fill = c("#AFADDE", "#BEE3ED", "#FFF1BA", "#FFB3B3", "#F595B2")))

#    df = data$Binding_Energy,
#    col = colorRamp2(abc, mypal)

#    df = data$Binding_Energy,
#    col = list(type = c("-9.9" = "#AFADDE", "-9.8" = "#B5C5E4", "-9.7" = "#BCDCEB", "-9.6" = "#D3E7DC", "-9.5" = "#F0EDC5", "-9.4" = "#FFE3B8", "-9.3" = "#FFC7B5", "-9.2" = "#FDAFB2", "-9.1" = "#F9A2B2", "-9" = "#F595B2"))

    df = data2,

# Persistent random colors in sidebar annotations
# https://github.com/jokergoo/ComplexHeatmap/issues/674
#    col = list(Energy = col_fun),  #連續性的資料   Energy是 column 的名稱
#    col = list(Energy = mypal),  #非連續性的資料

#     col = list("Cross-species" = mypal),  #非連續性的顯示
    col = list("Cross-species" = col_fun,  #連續性的顯示  #  需和 colnames 的名字一致  #colnames(data2) <- c("Cross-species", "AB", "EF", "KP", "PA", "SA")
                "A. baumannii" = c("1" = "orange", "0" = "white"),
                "E. faecium" = c("1" = "orange", "0" = "white"),
                "K. pneumoniae" = c("1" = "orange", "0" = "white"),
                "P. aeruginosa" = c("1" = "orange", "0" = "white"),
                "S. aureus" = c("1" = "orange", "0" = "white")),
#    col = list(Cross_num = c("dark green", "white")),
    show_legend = c("Cross-species"=TRUE, "A. baumannii"=FALSE, "E. faecium"=FALSE, "K. pneumoniae"=FALSE, "P. aeruginosa"=FALSE, "S. aureus"=FALSE),  # 個別設定 figure legend 是否顯示
#    show_legend = c(TRUE, FALSE, FALSE, FALSE, FALSE, FALSE),

    annotation_name_side = "top",
    annotation_name_gp= gpar(fontsize = 18, fontface = c("plain", "italic", "italic", "italic", "italic", "italic"))  # annotation 標籤名稱的字型大小 (Species)

#    col = list(Energy = mypal) #非連續性的資料
#    width = unit(10,"mm")

#    col = list(Binding_Energy = mypal),

#    foo = data$Binding_Energy
#   foo = anno_block(gp = gpar(fill = mypal))
#     col = colorRamp2(abc, mypal)

#    foo = anno_block(gp = gpar(fill = colorRampPalette(c("#AFADDE", "#BEE3ED", "#FFF1BA", "#FFB3B3", "#F595B2"))(10)))
    
#   seq(from=-9.9, to=-9, by=0.1)

#abc <- seq(from=-9.9, to=-9, by=0.1)
#mypal <- colorRampPalette( c( "#AFADDE", "#BEE3ED", "#FFF1BA", "#FFB3B3", "#F595B2" ) )( 10 )
#names(mypal) <- abc


)

row_ha

ht = Heatmap(M2, 
#  row_km = 5,
  column_km = 5,
  row_split = annotation_row,
  left_annotation = row_ha,

  column_dend_height = unit(4, "cm"),  # 設定 tree 的寬度
  row_dend_width = unit(4, "cm"),  # 設定 tree 的寬度

  width = ncol(M2)*unit(6, "mm"),  # 控制 Heatmap 圖的大小
  #height = nrow(M2)*unit(0.06, "mm"),
  height = nrow(M2)*unit(2.4, "mm"),

#  rect_gp = gpar(col = "#FFFFFF", lwd = 0.01),
  heatmap_legend_param = list(
    title = "Resistance state", 
#    title_position = "leftcenter-rot",
    title_gp = gpar(fontsize = 20, fontface = "plain")  #fontface = c("plain", "bold", "italic", "bold.italic")
#    legend_gp = gpar(fontsize = 20)
  ),
#  use_raster = TRUE,
#  heatmap_column_param = list(
#    names_gp = gpar(fontsize = 16)
#  ),

  column_names_gp = grid::gpar(fontsize = 16),  # 在 Heatmap finction 內，必須這樣使用。 而 "heatmap_column_names_gp = gpar(fontsize = 16)," 只能在 Heatmap finction 外使用，因為 heatmap_column_names_gp 是全域變數
#  column_names_rot = 90, # only accept 00, 90, 180, 270
  show_row_names = FALSE,
  column_title = "The antibiogram patterns clustered by the number of cross-species",
  column_title_gp = gpar(fontsize = 32, fontface = "bold.italic"),
  show_heatmap_legend = FALSE,  # 下方已執行 draw(ht, heatmap_legend_list = lgd) ，所以可以把這個選項關掉

#  legend_title_gp = gpar(fontsize = 8, fontface = "bold"),
#  col = structure(c("#C4D79B", "#FEFF96", "#EB5953", "#E0E0E0"), names = c("S", "I", "R", "X")),

#  col = structure(c("#C54032", "#5074AF"), names = c("1", "0")),
  col = structure(c("#EB5953", "#C4D79B"), names = c("1", "0")),


#  clustering_distance_rows = dist_letters, 
#  clustering_distance_columns = dist_letters,
#    layer_fun = function(j, i, x, y, w, h, col) { # add text to each grid
#        grid.text(M2[i, j], x, y)
#    }
  cluster_columns = TRUE, # bottom_annotation 使用 anno_barplot 時，需要將cluster_columns關閉，不然 barplot 的順序會與標示的不一致
  bottom_annotation = ha

)

ht_opt(RESET = TRUE)


lgd = Legend(
  title = "Resistance state", 
  title_gp = gpar(fontsize = 20, fontface = "plain"), 
  labels = c("S", "R"), 
  grid_height = unit(5, "mm"), grid_width = unit(5, "mm"), gap = unit(5, "mm"),
  labels_gp = gpar(fontsize = 16, fontface = "plain"), 
  legend_gp = gpar(fill = c("#C4D79B", "#EB5953")),
#  legend_gp = gpar(fill = c("#C4D79B")),
)

draw(ht, heatmap_legend_list = lgd)
#draw(ht)

dev.off()


quit()


#annotation_row = data.frame(
#    VRE_type = factor(rep(c("VRE", "nonVRE"), c(575, 363)))
#)
#annotation_col = data.frame(
#    PeakRanking = 1:20
#)
#ann_colors = list(
#    VRE_type = c(VRE = "#D95F02", nonVRE = "#1B9E77"),
#    PeakRanking = c("dark green", "white")
#)



#annotation_col = data.frame(
#    Type = factor(rep(c("EC", "EU"), c(4, 4)))
#)
#annotation_col

#annotation_row = data.frame(
#    GeneRanking = 1:20
#)

annotation_row = data.frame(
  Energy = data$Binding_Energy
)
#annotation_row

ann_colors = list(
#    Type = c(EC = "#1B9E77", EU = "#D95F02"),
#    GeneRanking = c("dark green", "white")
#    Energy = c("#397A4C", "#BEDB92")
    Energy = c("#AFADDE", "#BEE3ED", "#FFF1BA", "#FFB3B3", "#F595B2")
#    Function = c(
#      "Hyalurononglucosaminidase (EC 3.2.1.35)" = "#E51932",
#      "Alpha-N-acetylglucosaminidase (EC 3.2.1.50)" = "#FF99BF",
#      "Beta-N-acetylhexosaminidase (EC 3.2.1.52)" = "#654CFF",
#      "Alpha-L-fucosidase (EC 3.2.1.51)" = "#CCBFFF",
#      "Sulfatase" = "#19B2FF",
 #     "Beta-galactosidase (EC 3.2.1.23)" = "#A5EDFF",
 #     "Alpha-galactosidase" = "#32FF00",
 #     "Glycosyl hydrolase family protein" = "#B2FF8C",
 #     "Exo-alpha-sialidase" = "#FFFF32",
 #     "Sialidase" = "#FF7F00"
 #     )
)

#colors<- structure(circlize::rand_color(2), names = c("a", "b"))

#mat_letters<- matrix(sample(letters[1:4], 100, replace = TRUE), 10, 10)
#mat_letters

#colors

#M2

#quit()

#pdf(file="heatmap_split_cluster_cols.pdf", width=4.5, height=51.5)
pdf(file="heatmap_split_cluster_col_-9_pass_freq.pdf", width=4.5, height=16.5)

#cluster_cols
#par(mfrow=c(1,1))
#par(mar = c(1, 1, 1, 1) + 0.3)

#pheatmap(tM2, name = "Matrix", annotation_row = annotation_row, annotation_col = annotation_col, annotation_colors = ann_colors, main = "Selected by P-value", clustering_method = "complete")
#pheatmap(M2, name = "CF A/P", row_split = annotation_row, row_title = NULL, annotation_row = annotation_row, annotation_colors = ann_colors, clustering_method = "complete", cellwidth = 20, cellheight = 16, fontsize_col = 10, fontsize_row = 10, angle_col = "90")
pheatmap(M2, name = "CF A/P", row_split = annotation_row, row_title = NULL, annotation_row = annotation_row, annotation_colors = ann_colors, cluster_cols = TRUE, clustering_method = "complete", cellwidth = 8, cellheight = 8, fontsize_col = 8, fontsize_row = 8, angle_col = "90")
#pheatmap(M2, col = colors, name = "gene present or absent", cellwidth = 20, cellheight = 16, fontsize_col = 10, fontsize_row = 10, angle_col = "90")

#heatmap(M2, col = colors)



dev.off()

quit()














top10 <- c()

top10 <- cbind(top10, M2[1:8,"ENSG00000133488"])
top10 <- cbind(top10, M2[1:8,"ENSG00000185669"])
top10 <- cbind(top10, M2[1:8,"ENSG00000206113"])
top10 <- cbind(top10, M2[1:8,"ENSG00000124875"])
top10 <- cbind(top10, M2[1:8,"ENSG00000148408"])
top10 <- cbind(top10, M2[1:8,"ENSG00000160808"])
top10 <- cbind(top10, M2[1:8,"ENSG00000113722"])
top10 <- cbind(top10, M2[1:8,"ENSG00000204065"])
top10 <- cbind(top10, M2[1:8,"ENSG00000160339"])
top10 <- cbind(top10, M2[1:8,"ENSG00000186912"])


top10 <- as.matrix(top10)

colnames(top10) <- c("SEC14L4","SNAI3","CFAP99","CXCL6","CACNA1B","MYL3","CDX1","TCEAL5","FCN2","P2RY4")

top10

t_top10 <- t(top10)

annotation_col = data.frame(
    Type = factor(rep(c("EC", "EU"), c(4, 4)))
)
annotation_row = data.frame(
    GeneRanking = 1:10
)
ann_colors = list(
    Type = c(EC = "#1B9E77", EU = "#D95F02"),
    GeneRanking = c("dark green", "white")
)


pheatmap(t_top10, name = "Matrix", annotation_row = annotation_row, annotation_col = annotation_col, annotation_colors = ann_colors, main = "Selected by P-value", clustering_method = "complete")
dev.off()


#quit()



# gbm variable importance with the Caret R Package

library("mlbench")
library("caret")

dataset$Type = factor(dataset$Type, levels = c(0, 1))
dataset$Type

# prepare training scheme
control <- trainControl(method="repeatedcv", number=10, repeats=3)
TG = expand.grid(k=1:3,size=seq(5,20,by=5))

control
TG

#quit()


# train the model
model <- train(Type~., data=dataset, method="lvq", preProcess="scale", trControl=control, tuneGrid=TG)
# estimate variable importance
importance <- varImp(model, scale=FALSE)
# summarize importance
print(importance)

pdf(file="imp.pdf", width=6.2, height=5.8)

# plot importance
plot(importance, top = 30)

dev.off()

rownames(importance[[1]])

importance[[1]][,1]

varImportance <- c()
varImportance <- c(varImportance, "NA")
varImportance <- c(varImportance, c(importance[[1]][,1]))

dataset <- rbind(dataset, varImportance)

rownames(dataset)[9] <- "varImportance"

dataset[1:9,1:5]

M6<-dataset[,order(as.double(dataset["varImportance",]),decreasing=TRUE)]

M7 <- as.matrix(M6[1:8,2:1973])

M7

sapply(M7, as.numeric)
class(M7) <- "numeric"
storage.mode(M7) <- "numeric"

tM7 <- t(M7)

library("ComplexHeatmap")

annotation_col = data.frame(
    Type = factor(rep(c("EC", "EU"), c(4, 4)))
)
annotation_row = data.frame(
    PeakRanking = 1:1972
)
ann_colors = list(
    Type = c(EC = "#1B9E77", EU = "#D95F02"),
    PeakRanking = c("dark green", "white")
)

pdf(file="heatmap5.pdf", width=6, height=24)
pheatmap(tM7, name = "Matrix", annotation_row = annotation_row, annotation_col = annotation_col, annotation_colors = ann_colors, main = "Selected by gbm variable importance", clustering_method = "complete")
dev.off()




quit()




# PCA


peak_num <- length(M3[1,])


#M8 <- top10[1:8,1:10] # by top10
#M8 <- M3[1:8,1:peak_num] # by P-value
M8 <- M7[1:8,1:peak_num] # by gbm variable importance
M8

# Data standardization
library("FactoMineR")

res.pca <- PCA(M8, graph = FALSE)
print(res.pca)

# Visualization and Interpretation
library("factoextra")

eig.val <- get_eigenvalue(res.pca)
eig.val


pdf(file="PCA.pdf", width=7, height=7)

fviz_eig(res.pca, addlabels = TRUE, ylim = c(0, 65))

var <- get_pca_var(res.pca)
# Coordinates
head(var$coord)
# Cos2: quality on the factore map
head(var$cos2)
# Contributions to the principal components
head(var$contrib)
# Coordinates of variables
head(var$coord, 4)

fviz_pca_var(res.pca, col.var = "black", repel = TRUE )


library("corrplot")

corrplot(var$cos2, is.corr=FALSE)

# Total cos2 of variables on Dim.1 and Dim.2
fviz_cos2(res.pca, choice = "var", axes = 1:2, addlabels = TRUE, ylim = c(0, 1))

# Color by cos2 values: quality on the factor map
fviz_pca_var(res.pca, col.var = "cos2",
    gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), 
    repel = TRUE # Avoid text overlapping
)

# Change the transparency by cos2 values
fviz_pca_var(res.pca, alpha.var = "cos2",
    gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), 
    repel = TRUE # Avoid text overlapping
)

corrplot(var$contrib, is.corr=FALSE)

# Contributions of variables to PC1
fviz_contrib(res.pca, choice = "var", axes = 1, top = 10)
# Contributions of variables to PC2
fviz_contrib(res.pca, choice = "var", axes = 2, top = 10)

fviz_contrib(res.pca, choice = "var", axes = 1:2, top = 10)

fviz_pca_var(res.pca, col.var = "contrib",
    gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
    repel = TRUE # Avoid text overlapping
)

# Change the transparency by contrib values
fviz_pca_var(res.pca, alpha.var = "contrib",
    gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
    repel = TRUE # Avoid text overlapping
)

ind <- get_pca_ind(res.pca)
ind

fviz_pca_ind(res.pca)

fviz_pca_ind(res.pca, col.ind = "cos2", 
    gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
    repel = TRUE # Avoid text overlapping (slow if many points)
)

fviz_pca_ind(res.pca, pointsize = "cos2", 
    pointshape = 21, fill = "#E7B800",
    repel = TRUE # Avoid text overlapping (slow if many points)
)


Groups <- factor(rep(c("EC", "EU"), c(4, 4)))
#Groups

# cbind.data.frame 以字串的方式加入
M8 <- cbind.data.frame(M8, Groups)
M8

fviz_pca_ind(res.pca,
#    geom.ind = c("point"), # show points only (nbut not "text")
#    label = "all",
    repel = TRUE, # Avoid text overlapping (slow if many points)
    col.ind = M8[,peak_num+1], # color by groups
#    palette = c("#00AFBB", "#FC4E07"),
    palette="joo",
    addEllipses = TRUE, # Concentration ellipses
    mean.point=TRUE,
    ggtheme = theme_minimal(),
#    ellipse.type="confidence",
#    ellipse.level=0.95,
    legend.title = "Groups",
    title = ""
)


fviz_pca_biplot(res.pca,
           fill.ind=M8[,peak_num+1],
           palette="joo",
           addEllipses = T,
#           ellipse.type="confidence",
#           ellipse.level=0.95,
           mean.point=F,
           col.var="contrib",
           gradient.cols = "RdYlBu",
           select.var = list(contrib = 10),
           ggtheme = theme_minimal(),
           repel = TRUE, # Avoid text overlapping (slow if many points)
           legend.title = list(fill = "Groups", color = "Contrib")
)


dev.off()





