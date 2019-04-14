## Trying your own song by entering song URL or URI
## Example URL https://open.spotify.com/track/2acK24b60RQD2zBpW0Zsrw?si=HYTW4a8LSVSoaMmomlbaUA
## Example URI spotify:track:2acK24b60RQD2zBpW0Zsrw

# Loading models
modLR <- readRDS(file = "files/mod_log_regression.rds")


# Testing a chosen song with models

songURL <- readline(prompt="Enter song URL: ")
temp <- sub(".*:", "", songURL)
temp <- sub(".*/", "", temp)
songID <- sub("\\?.*", "", temp)
songTitle <- get_track(songID)$name
songArtist <- get_track(songID)$artists$name

songMoodPredictLR <- predict(modLR, get_track_audio_features(songID)[-c(12:16, 18, hc)])

if(songMoodPredictLR == 1){
  mood <- "happy"
} else{
  mood <- "sad"
}

cat("the song '", songTitle, "' from", songArtist, "is", mood)
