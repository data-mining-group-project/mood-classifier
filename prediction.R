## Trying your own song by entering song URL or URI
## Example URL https://open.spotify.com/track/2acK24b60RQD2zBpW0Zsrw?si=HYTW4a8LSVSoaMmomlbaUA
## Example URI spotify:track:2acK24b60RQD2zBpW0Zsrw
library(spotifyr)
Sys.setenv(SPOTIFY_CLIENT_ID = '99a73bb020fa434c9dd297c35c45d12d')
Sys.setenv(SPOTIFY_CLIENT_SECRET = 'fd31c8e400c448e1bf6e7d90edef915b')

access_token <- get_spotify_access_token()

# Loading models
modLR <- readRDS(file = "files/mod_log_regression.rds")
modRF <- readRDS(file = "files/mod_rf.rds")


# Testing a chosen song with models

songURL <- readline(prompt="Enter song URL: ")
temp <- sub(".*:", "", songURL)
temp <- sub(".*/", "", temp)
songID <- sub("\\?.*", "", temp)
songTitle <- get_track(songID)$name
songArtist <- get_track(songID)$artists$name

songMoodPredictLR <- predict(modLR, get_track_audio_features(songID)[-c(12:16, 18, hc)])
# songMoodPredictNN <- predict(nnetMood, get_track_audio_features(songID)[-c(12:16, 18, hc)])
# songMoodPredictMars <- predict(marsMod, get_track_audio_features(songID)[-c(12:16, 18, hc)])

library(randomForest)
songMoodPredictRF <- predict(modRF, newdata = get_track_audio_features(songID)[-c(12:16, 18)] , 
                           type = "class")

if(songMoodPredictLR == 1){
  mood <- "happy"
} else{
  mood <- "sad"
}

# if(songMoodPredictNN == 1){
#   moodNN <- "happy"
# } else{
#   moodNN <- "sad"
# }

if(songMoodPredictRF == 1){
  moodRF <- "happy"
} else{
  moodRF <- "sad"
}

# if(songMoodPredictMars == 1){
#   moodMars <- "happy"
# } else{
#   moodMars <- "sad"
# }

cat("According to Logistic regression, the song '", songTitle, "' from", songArtist, "is", mood)
# cat("\nAccording to Neural Network, the song '", songTitle, "' from", songArtist, "is", moodNN)
cat("\nAccording to Random Forest, the song '", songTitle, "' from", songArtist, "is", moodRF)
# cat("\nAccording to Multivariate Adaptive Regression Splines (MARS), the song '", songTitle, "' from", songArtist, "is", moodMars)
