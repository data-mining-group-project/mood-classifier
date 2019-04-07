## Merging Happy and Sad dataset

happy <- read.csv("featuresHappy.csv")
sad <- read.csv("sad_variables.csv")

# Merging
songFeatures <- rbind(happy, sad)

write.csv(songFeatures, file = "songFeatures.csv")
