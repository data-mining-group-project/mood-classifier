library(caret)


# Removing NAs
reducedSongFeatures <- reducedSongFeatures %>% drop_na()


# We need to change label as a 2 level factor, or we get the following warning message: 
# Warning message:
# In train.default(x, y, weights = w, ...) :
#  You are trying to do regression and your outcome only has two possible values 
# Are you trying to do classification? If so, use a 2 level factor as your outcome column.

reducedSongFeatures$label <- as.factor(reducedSongFeatures$label)



Train <- createDataPartition(reducedSongFeatures$label, p = 0.8, list = FALSE) 
training <- reducedSongFeatures[Train, ]
testing <- reducedSongFeatures[-Train, ]
mod_fit <- train(label ~ danceability + key + loudness + mode + speechiness + instrumentalness + 
                   liveness + valence + tempo + duration_ms, data = training, method = "glm",
                 family = "binomial")
predictions <- predict(mod_fit, testing[, -11])
table(predictions, testing[, 11])

# p = 0.6 -> 74.60 % correct
# predictions    0    1
#           0 1461  468
#           1  312  830

# p = 0.8 -> 74.00 % correct
# predictions   0   1
#           0 728 241
#           1 158 408




