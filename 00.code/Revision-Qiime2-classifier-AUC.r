
require(randomForest)
require(pROC) 
require(ROCR)

group_df <- read.table("../15.Revision/11.Classifier/Qiime2_classifer/ade-crc-group.tsv", row.names =1, header = T)
bac_auc_500 <- read.table("../15.Revision/11.Classifier/Qiime2_classifer/ade-crc-bac-500/probabilitie/90c7fe3d-dff6-4570-ae01-e9eb422e11de/data/class_probabilities.tsv")
all_auc_500 <- read.table("../15.Revision/11.Classifier/Qiime2_classifer/ade-crc-all-500/probabilitie/4b0282f9-07cf-41bb-a081-c35c934bb3d6/data/class_probabilities.tsv")
group_df2 <- group_df[rownames(bac_auc_500),, drop =F]

bac_pred <- prediction(bac_auc_500[,2], group_df2[,1])
bac_auc_value <- round(performance(bac_pred, measure = "auc")@y.values[[1]]*100, 2)
bac_roc <- roc(group_df2[,1], bac_auc_500[,2], legacy.axes = T, percent = T)


all_pred <- prediction(all_auc_500[,2], group_df2[,1])
all_auc_value <- round(performance(all_pred, measure = "auc")@y.values[[1]]*100, 2)
all_roc <- roc(group_df2[,1], all_auc_500[,2], legacy.axes = T, percent = T)



roc_pdf <- FileCreate(DirPath = "../15.Revision/11.Classifier/Qiime2_classifer/", Prefix = 'comparision-ROC', Suffix = 'pdf')
pdf(file = roc_pdf)
par(pty = "s")
plot(all_roc, col = '#ff0000', lwd = 3, legacy.axes = T, 
     xlab = "False Postive Percentage", ylab = "True Postive Percentage")
lines(bac_roc, col = '#004586', lwd = 1, lty = 1)
dev.off()