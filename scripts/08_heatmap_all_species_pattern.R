#!/usr/local/bin/Rscript

data <- read.csv(file = 'data/processed/all.c100.pattern.crossNum.tsv', sep="\t", header = TRUE)


data$Genome_ID


data[1,2:ncol(data)]


data$Species = replace(data$Species, data$Species=="Acinetobacter baumannii", "A. baumannii")
data$Species = replace(data$Species, data$Species=="Enterococcus faecium", "E. faecium")
data$Species = replace(data$Species, data$Species=="Klebsiella pneumoniae", "K. pneumoniae")
data$Species = replace(data$Species, data$Species=="Pseudomonas aeruginosa", "P. aeruginosa")
data$Species = replace(data$Species, data$Species=="Staphylococcus aureus", "S. aureus")


data$Species

#quit()

ncol(data)

nrow(data)

# 設定篩選條件
#data <- data[ which(data$Binding_Energy <= -9 & data$Ro5 == "Pass" & data$CF4 == "1" & data$CF9 == "1" & data$CF11 == "1"), ]
#data


#quit()

dataset <- as.data.frame(data[,3:(ncol(data)-2)])

#dataset

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

#data[(data$Species == "A. baumannii"),3:(ncol(data)-1)]

M2_AB <- as.matrix(data[which(data$Species == "A. baumannii"),3:(ncol(data)-2)]) # 加 which 才會印出這筆資料的所有欄位，如果沒有加 which 只會印出 "Species" 這個欄位
colnames(M2_AB) <- colnames(dataset)
M2_AB

freq_AB <- colSums(M2_AB) # 直接加總 column

length(M2_AB[,1])

p_freq_AB <- freq_AB /length(M2_AB[,1])
p_freq_AB

c(p_freq_AB)

bar_AB <- matrix(nc = 1, c(p_freq_AB))
bar_AB



M2_EF <- as.matrix(data[which(data$Species == "E. faecium"),3:(ncol(data)-2)]) # 加 which 才會印出這筆資料的所有欄位，如果沒有加 which 只會印出 "Species" 這個欄位
colnames(M2_EF) <- colnames(dataset)
M2_EF

freq_EF <- colSums(M2_EF) # 直接加總 column

length(M2_EF[,1])

p_freq_EF <- freq_EF /length(M2_EF[,1])
p_freq_EF

c(p_freq_EF)

bar_EF <- matrix(nc = 1, c(p_freq_EF))
bar_EF



M2_KP <- as.matrix(data[which(data$Species == "K. pneumoniae"),3:(ncol(data)-2)]) # 加 which 才會印出這筆資料的所有欄位，如果沒有加 which 只會印出 "Species" 這個欄位
colnames(M2_KP) <- colnames(dataset)
M2_KP

freq_KP <- colSums(M2_KP) # 直接加總 column

length(M2_KP[,1])

p_freq_KP <- freq_KP /length(M2_KP[,1])
p_freq_KP

c(p_freq_KP)

bar_KP <- matrix(nc = 1, c(p_freq_KP))
bar_KP



M2_PA <- as.matrix(data[which(data$Species == "P. aeruginosa"),3:(ncol(data)-2)]) # 加 which 才會印出這筆資料的所有欄位，如果沒有加 which 只會印出 "Species" 這個欄位
colnames(M2_PA) <- colnames(dataset)
M2_PA

freq_PA <- colSums(M2_PA) # 直接加總 column

length(M2_PA[,1])

p_freq_PA <- freq_PA /length(M2_PA[,1])
p_freq_PA

c(p_freq_PA)

bar_PA <- matrix(nc = 1, c(p_freq_PA))
bar_PA



M2_SA <- as.matrix(data[which(data$Species == "S. aureus"),3:(ncol(data)-2)]) # 加 which 才會印出這筆資料的所有欄位，如果沒有加 which 只會印出 "Species" 這個欄位
colnames(M2_SA) <- colnames(dataset)
M2_SA

freq_SA <- colSums(M2_SA) # 直接加總 column

length(M2_SA[,1])

p_freq_SA <- freq_SA /length(M2_SA[,1])
p_freq_SA

c(p_freq_SA)

bar_SA <- matrix(nc = 1, c(p_freq_SA))
bar_SA

#quit()

#sapply(dataset, as.numeric)
#class(dataset) <- "numeric"
#storage.mode(dataset) <- "numeric"



tM2 <- t(M2)

library("ComplexHeatmap")

freq <- colSums(M2) # 直接加總 column
#freq <- colSums(M2 == 1) # 計算數值為 1 的數量
#freq <- colSums(M2 == 0) # 計算數值為 0 的數量
#freq_AB <- colSums(M2[(M2$Species == "Acinetobacter baumannii"),]) # 直接加總 column

freq
#freq_AB

#quit()


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


pdf(file="results/figures/heatmap_all_species_pattern.pdf", width=27, height=32.5)


#ha = HeatmapAnnotation(freq. = anno_barplot(r_bar, gp = gpar(fill = c("#C4D79B", "#FEFF96", "#EB5953", "#E0E0E0")),
ha = HeatmapAnnotation("All species" = anno_barplot(bar, gp = gpar(fill = c("#C54032")),
  axis_param=list(gp=gpar(fontsize = 16), at = seq(0.4, 0.8, 0.4), labels = seq(0.4, 0.8, 0.4)),   # 改變軸上的刻度字型大小
  beside = TRUE, # beside = TRUE 時，要使用 reverse rows in matrix (bar -> r_bar) ，因為註解的順序會相反
  bar_width = 0.5,
  attach = TRUE,
#  add_numbers = TRUE, # It only works when x is a simple vector.
  height = unit(2, "cm")
  ),

  empty_1 = anno_empty(border = FALSE, height = unit(0.1, "cm")), # 新增空白註解行

  "A. baumannii" = anno_barplot(bar_AB, gp = gpar(fill = c("#AFADDE")),
  axis_param=list(gp=gpar(fontsize = 16), at = seq(0.4, 0.8, 0.4), labels = seq(0.4, 0.8, 0.4)),   # 改變軸上的刻度字型大小
  beside = TRUE, # beside = TRUE 時，要使用 reverse rows in matrix (bar -> r_bar) ，因為註解的順序會相反
  bar_width = 0.5,
  attach = TRUE,
#  add_numbers = TRUE, # It only works when x is a simple vector.
  height = unit(1.5, "cm")
  ),

  empty_2 = anno_empty(border = FALSE, height = unit(0.1, "cm")), # 新增空白註解行

  "E. faecium" = anno_barplot(bar_EF, gp = gpar(fill = c("#BEE3ED")),
  axis_param=list(gp=gpar(fontsize = 16), at = seq(0.4, 0.8, 0.4), labels = seq(0.4, 0.8, 0.4)),   # 改變軸上的刻度字型大小
  beside = TRUE, # beside = TRUE 時，要使用 reverse rows in matrix (bar -> r_bar) ，因為註解的順序會相反
  bar_width = 0.5,
  attach = TRUE,
#  add_numbers = TRUE, # It only works when x is a simple vector.
  height = unit(1.5, "cm")
  ),

  empty_3 = anno_empty(border = FALSE, height = unit(0.1, "cm")), # 新增空白註解行

  "K. pneumoniae" = anno_barplot(bar_KP, gp = gpar(fill = c("#FFF1BA")),
  axis_param=list(gp=gpar(fontsize = 16), at = seq(0.4, 0.8, 0.4), labels = seq(0.4, 0.8, 0.4)),   # 改變軸上的刻度字型大小
  beside = TRUE, # beside = TRUE 時，要使用 reverse rows in matrix (bar -> r_bar) ，因為註解的順序會相反
  bar_width = 0.5,
  attach = TRUE,
#  add_numbers = TRUE, # It only works when x is a simple vector.
  height = unit(1.5, "cm")
  ),

  empty_4 = anno_empty(border = FALSE, height = unit(0.1, "cm")), # 新增空白註解行

  "P. aeruginosa" = anno_barplot(bar_PA, gp = gpar(fill = c("#FFB3B3")),
  axis_param=list(gp=gpar(fontsize = 16), at = seq(0.4, 0.8, 0.4), labels = seq(0.4, 0.8, 0.4)),   # 改變軸上的刻度字型大小
  beside = TRUE, # beside = TRUE 時，要使用 reverse rows in matrix (bar -> r_bar) ，因為註解的順序會相反
  bar_width = 0.5,
  attach = TRUE,
#  add_numbers = TRUE, # It only works when x is a simple vector.
  height = unit(1.5, "cm")
  ),

  empty_5 = anno_empty(border = FALSE, height = unit(0.1, "cm")), # 新增空白註解行

  "S. aureus" = anno_barplot(bar_SA, gp = gpar(fill = c("#F595B2")),
  axis_param=list(gp=gpar(fontsize = 16), at = seq(0, 0.8, 0.4), labels = seq(0, 0.8, 0.4)),   # 改變軸上的刻度字型大小
  beside = TRUE, # beside = TRUE 時，要使用 reverse rows in matrix (bar -> r_bar) ，因為註解的順序會相反
  bar_width = 0.5,
  attach = TRUE,
#  add_numbers = TRUE, # It only works when x is a simple vector.
  height = unit(1.5, "cm")
  ),

  empty_6 = anno_empty(border = FALSE, height = unit(0.1, "cm")), # 新增空白註解行

  "Antibiotic class" = class_id, # 設定抗生素類別的標籤
  col = list("Antibiotic class" = class_col), # 設定抗生素類別的顏色

  show_legend = FALSE,
  annotation_name_gp= gpar(fontsize = 20, fontface = "italic")  # 改變 "freq." 標籤的字型大小
)



ht_opt(
    legend_title_gp = gpar(fontsize = 20, fontface = "plain"), # 改變右邊 Annotation 的 legend 的字型大小
    legend_labels_gp = gpar(fontsize = 16, fontface = "italic"),  # 改變右邊 Annotation 的 legend 的字型大小
    legend_grid_height = unit(5, "mm"), legend_grid_width = unit(5, "mm"), legend_gap = unit(5, "mm"), # 改變 Annotation 的 legend 的圖示大小
#    heatmap_column_names_gp = gpar(fontsize = 16),
    heatmap_row_names_gp = gpar(fontsize = 20),
#    heatmap_column_title_gp = gpar(fontsize = 10),
    heatmap_row_title_gp = gpar(fontsize = 22, fontface = "italic")  # 控制左邊每個分類名稱的字型大小 例如："Acinetobacter baumannii", "Enterococcus faecium", "Klebsiella pneumoniae", "Pseudomonas aeruginosa", "Staphylococcus aureus"
)

annotation_row = data.frame(
  Species = data$Species
)

#annotation_row

ann_colors = list(
    Species = c("#AFADDE", "#BEE3ED", "#FFF1BA", "#FFB3B3", "#F595B2")
)


data2 <- as.data.frame(data[,94])

colnames(data2) <- "Species"

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
abc = c("A. baumannii", "E. faecium", "K. pneumoniae", "P. aeruginosa", "S. aureus")
mypal = colorRampPalette( c( "#AFADDE", "#BEE3ED", "#FFF1BA", "#FFB3B3", "#F595B2" ) )( 5 )

names(mypal) = abc #非連續性的資料

library(circlize)
#col_fun = colorRamp2(abc, mypal)  #連續性的資料


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
    col = list(Species = mypal),
    annotation_name_side = "top",
    annotation_name_gp= gpar(fontsize = 18)  # annotation 標籤名稱的字型大小 (Species)

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
  height = nrow(M2)*unit(0.06, "mm"),

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
  column_title = "Heatmap and frequency distribution of antibiotic resistance fingerprints",
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



