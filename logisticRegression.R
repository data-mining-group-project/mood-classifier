library(caret)
library(tidyr)



# Partitioning the dataset in training and testing
set.seed(1)
Train <- createDataPartition(reducedSongFeatures$label, p = 0.8, list = FALSE) 
training <- reducedSongFeatures[Train, ]
testing <- reducedSongFeatures[-Train, ]

# training the model
mod_fit <- train(label ~ ., data = training, method = "glm",
                 family = "binomial")

# testing the model
predictionsLR <- predict(mod_fit, testing[,-which(colnames(testing)=="label")])
table(predictionsLR, testing[, which(colnames(testing)=="label")])

# OR
confusionMatrix(reference = testing$label, data = predictionsLR, mode='everything', 
                positive='1')


# predictionsLR   0   1
#              0 665 197
#              1 221 725

# saving the model

saveRDS(object = mod_fit, file = "files/mod_log_regression.rds")


## CALCULATING ROC CURVE AND AUC

# Load the pROC package
# install.packages("pROC")
library(pROC)


# Create a ROC curve
ROC <- roc(as.numeric(testing[, which(colnames(testing)=="label")]), as.numeric(predictionsLR))

# Plot the ROC curve
plot(ROC, col = "blue")

# Calculate the area under the curve (AUC)
auc(ROC)
#Area under the curve: 0.7648




