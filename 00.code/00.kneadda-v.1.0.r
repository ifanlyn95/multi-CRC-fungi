require(readr)
mydata <- read_tsv("F:/GitHub/multi-CRC-fungi/00.RawData/matrix_kraken2.tsv")
myhead <- read_tsv("F:/GitHub/multi-CRC-fungi/00.RawData/head_kraken2.tsv")

mydata2 <- mydata[, c(1, 4110, 4111, 4112, grep("_all", colnames(mydata)))]

my_kingdom <- mydata2[(mydata2$lvl_type == "D"| mydata2$lvl_type == "U") , ]

myhead2 <- myhead[-1, ] %>% as.data.frame()

colnames(myhead2) <- c('temp_name', 'sample_name')
myhead2$temp_name <- paste0(gsub('#S', "", myhead2$temp_name),"_all")
myhead2$sample_name <- myhead2$sample_name %>% 
  gsub('./kraken2/','', .) %>%
  gsub('_kraken.report','', .)

rownames(myhead2) <- myhead2$temp_name

my_kingdom2 <- my_kingdom[, c(4, 6:ncol(my_kingdom))] %>% as.data.frame()
colnames(my_kingdom2) <- c("name", myhead2[colnames(my_kingdom2)[-1], 2])
rownames(my_kingdom2) <- my_kingdom2[,1]
my_kingdom2 <- my_kingdom2[,-1]
my_kingdom2["Ratio", ] <- my_kingdom2[3,]/my_kingdom2[2,]*100

my_kingdom3 <- my_kingdom2 %>% t() %>% as.data.frame()
write.csv(my_kingdom3, "F:/GitHub/multi-CRC-fungi/00.RawData/kraken2_kingdoms.csv")
