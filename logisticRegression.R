
# Examine the dataset to identify potential independent variables
str(reducedSongFeatures)

# removing lines with NA
library(tidyr)
reducedSongFeatures <- reducedSongFeatures %>% drop_na()

# Explore the dependent variable
table(reducedSongFeatures$label)

# Build the donation model
moodModel <- glm(label ~ danceability + key + loudness + mode + speechiness + 
                   instrumentalness + liveness + valence + tempo + duration_ms, 
                         data = reducedSongFeatures, family = "binomial")

# Summarize the model results
summary(moodModel)
str(moodModel)
test <- predict(moodModel, type = "response")
str(test)

# Estimate the happiness probability
reducedSongFeatures$moodProb <- predict(moodModel, type = "response")

# Find the donation probability of the average prospect
mean(reducedSongFeatures$label)

# Predict a donation if probability of donation is greater than average
reducedSongFeatures$moodPred <- ifelse(reducedSongFeatures$moodProb > 0.4225, 1, 0)

# Calculate the model's accuracy
mean(reducedSongFeatures$label == reducedSongFeatures$moodPred)
# [1] 0.746842

## CALCULATING ROC CURVE AND AUC

# Load the pROC package
install.packages("pROC")
library(pROC)

# Create a ROC curve
ROC <- roc(reducedSongFeatures$label, reducedSongFeatures$moodPred)

# Plot the ROC curve
plot(ROC, col = "blue")

# Calculate the area under the curve (AUC)
auc(ROC)
#Area under the curve: 0.7445
