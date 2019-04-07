

# subsetting to only useful columns

features <- songFeatures[-c(1,2)]

# Examine the dataset to identify potential independent variables
str(features)

# Explore the dependent variable
table(features$label)

# Build the donation model
moodModel <- glm(label ~ danceability + energy + key + loudness + mode + speechiness + acousticness + 
                   instrumentalness + liveness + valence + tempo + duration_ms, 
                         data = features, family = "binomial")

# Summarize the model results
summary(moodModel)
