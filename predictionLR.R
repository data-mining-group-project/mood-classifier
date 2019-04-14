## Trying your own song   https://open.spotify.com/track/2acK24b60RQD2zBpW0Zsrw?si=HYTW4a8LSVSoaMmomlbaUA
## spotify:track:2acK24b60RQD2zBpW0Zsrw

songURL <- readline(prompt="Enter song URL: ")
temp <- sub(".*:", "", songURL)
temp <- sub(".*/", "", temp)
songID <- sub("\\?.*", "", temp)
songTitle <- get_track(songID)$name
songArtist <- get_track(songID)$artists$name


songMoodPredict <- predict(mod_fit, get_track_audio_features(songID)[c(1,3:6,8:11,17)])

if(songMoodPredict == 1){
  mood <- "happy"
} else{
  mood <- "sad"
}

cat("the song '", songTitle, "' from", songArtist, "is", mood)