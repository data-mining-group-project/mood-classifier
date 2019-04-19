library(caret)
library(tidyr)


# Removing NAs
reducedSongFeatures <- reducedSongFeatures %>% drop_na()


# We need to change label as a 2 level factor, or we get the following warning message: 
# Warning message:
# In train.default(x, y, weights = w, ...) :
#  You are trying to do regression and your outcome only has two possible values 
# Are you trying to do classification? If so, use a 2 level factor as your outcome column.

reducedSongFeatures$label <- as.factor(reducedSongFeatures$label)


# Partitioning the dataset in training and testing
Train <- createDataPartition(reducedSongFeatures$label, p = 0.8, list = FALSE) 
training <- reducedSongFeatures[Train, ]
testing <- reducedSongFeatures[-Train, ]

# training the model
mod_fit <- train(label ~ ., data = training, method = "glm",
                 family = "binomial")

# testing the model
predictionsLR <- predict(mod_fit, testing[,-which(colnames(testing)=="label")])
table(predictionsLR, testing[, which(colnames(testing)=="label")])

# p = 0.6 -> 74.60 % correct
# predictions    0    1
#           0 1461  468
#           1  312  830

# p = 0.8 -> 74.00 % correct
# predictions   0   1
#           0 728 241
#           1 158 408

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



