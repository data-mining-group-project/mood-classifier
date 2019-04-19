## Merging Happy and Sad dataset

happy <- read.csv("featuresHappy.csv")
sad <- read.csv("sad_variables.csv")

# Merging
songFeatures <- rbind(happy, sad)

# Removing NAs

library(tidyr)
songFeatures <- songFeatures %>% drop_na()


# We need to change label as a 2 level factor, or we get the following warning message: 
# Warning message:
# In train.default(x, y, weights = w, ...) :
#  You are trying to do regression and your outcome only has two possible values 
# Are you trying to do classification? If so, use a 2 level factor as your outcome column.

songFeatures$label <- as.factor(songFeatures$label)

write.csv(songFeatures, file = "songFeatures.csv")
