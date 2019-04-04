#################################################
## This script return all the track's IDs of   ##
## a playlist of more than 100 tracks          ##
## then get all the features needed for the    ##
## project in the parameter feature            ##
#################################################


## CHANGE THE FOLLOWING PARAMETERS#########
                                          #
playlistID <- "2IZSOqDOyshh1thqoJ4pLi"    #
filename <- "featuresHappy.csv"           #
                                          #
###########################################



# Getting the size of the playlist
playlist <- get_playlist(playlistID)
playlistSize <- playlist$tracks$total
cat("Number of songs in the playlist: ",playlistSize)


## Looping to get all the songs of the playlist, as we can only import 100 track 
## at the time. offset allow us to set the first song to import.

features <- NULL
playlistTrack <- NULL
for (i in 13:min(15,((playlistSize-1) %/% 100))) {
  playlistTrackTemp <- get_playlist_tracks(playlistID, fields = NULL, limit = 100,
                                           offset = (i*100),  market = NULL,
                                           authorization = get_spotify_access_token(),
                                           include_meta_info = FALSE)
  
  # For each 100 songs, looping to get the feature of each song by binding
  playlistTrackTemp <- playlistTrackTemp$track.id
  featuresTmp <- NULL
  for(j in playlistTrackTemp) { 
    if (!is.na(j)) {
      featuresTmp <- bind_rows(get_track_audio_features(j)[c(1:11,17)], featuresTmp)
    }
  }
  # binding all the features together
  features <- bind_rows(features, featuresTmp)
  playlistTrack <- rbind(playlistTrackTemp, playlistTrack)
  #Sys.sleep(1)
}
## 1 minute 30 seconds to process 1000 songs. Error 429 isn't blocking
features

## Saving in csv
write.csv(features, file = filename)
