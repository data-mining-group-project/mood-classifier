# Final Data 

library(dplyr)

Spotify_mood <- read.csv(file = "songFeatures.csv", header = TRUE, sep = ",")
Spotify <- Spotify_mood %>%
  na.omit() %>% # exclude 26 NA
  select(danceability, energy, key, loudness, mode, speechiness, acousticness, instrumentalness,
         liveness, valence, tempo, duration_ms, label) 



#Ensure that Class is categorical

is.factor(Spotify$label)
Spotify$label <- as.factor(Spotify$label)

#Load the rpart and partykit libraries
library(rpart)
library(partykit)
library(rpart.plot)

# Split the data
#80% of values are used as training data
# The remaining 20% are used as test data
set.seed(345)
N <- nrow(Spotify)
spotify_train <- sample(1:N,size=0.80*N)
spotify_train <- sort(spotify_train)
spotify_test <- setdiff(1:N,spotify_train)

#Fit a classifier to only the training data
spotify_model <- rpart(label~.,data=Spotify,  subset=spotify_train, method = "class")
rpart.plot(fit.r, type = 5, box.palette = c("red", "green"), fallen.leaves = TRUE)
plot(as.party(spotify_model))


# Check best size (complexty of the tree)
printcp(spotify_model)
plotcp(spotify_model)

# Classify for ALL of the observations
pred <- predict(spotify_model, type="class", newdata= Spotify)

#Look at the results for the test data only
pred[spotify_test]

# Look at table for the test data only 
test_matrix <- table(Spotify$label[spotify_test],pred[spotify_test])
test_matrix

# Work out the accuracy
sum(diag(test_matrix))/sum(test_matrix)

#Look at the results for the training data only
training_matrix <- table(Spotify$label[spotify_train],pred[spotify_train])
training_matrix

# Work out the accuracy
sum(diag(training_matrix))/sum(training_matrix)

 
