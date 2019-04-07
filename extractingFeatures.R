##################################################################
## This script return all the track's IDs, features and         ##
## chosen label for a playlist of more than 100 tracks          ##
## Then export in a CSV file                                    ##
## More information:                                            ##
## https://github.com/data-mining-group-project/mood-classifier ##
##################################################################


## CHANGE THE FOLLOWING PARAMETERS#################################
                                                                  #
playlistID <- "2IZSOqDOyshh1thqoJ4pLi"                            #
filename <- "featuresHappy.csv"        # File to save the dataset #
label <- 1                             # Label for classification # 
maxTracksNb <- 5000                 # max nb of tracks to extract #
                                                                  #
###################################################################

library(spotifyr)
library(dplyr)

# Getting the size of the playlist
playlist <- get_playlist(playlistID)
playlistSize <- playlist$tracks$total
cat("Number of songs in the playlist: ", playlistSize,"\n")


## Looping to get all the songs of the playlist, as we can only import 100 track 
## at the time. offset allow us to set the first song to import.

features <- NULL
playlistTrack <- NULL
timeStart <- Sys.time()
for (i in 0:min((maxTracksNb - 1) %/% 100,((playlistSize - 1) %/% 100))) {
  playlistTrackTemp <- get_playlist_tracks(playlistID, fields = NULL, limit = 100,
                                           offset = (i*100),  market = NULL,
                                           authorization = get_spotify_access_token(),
                                           include_meta_info = FALSE)
  
  # For each 100 songs, looping to get the feature of each song by binding
  playlistTrackTemp <- playlistTrackTemp$track.id
  featuresTmp <- NULL
  for(j in playlistTrackTemp) { 
      # ignoring na lines
      if (!is.na(j)) {
      names(j) <- "id"
      names(label) <- "label"
      featuresTmp <- bind_rows(c(j,get_track_audio_features(j)[c(1:11,17)],label), 
                               featuresTmp)
      # print(featuresTmp)
    }
  }
  # binding all the features together
  features <- bind_rows(features, featuresTmp)
  playlistTrack <- rbind(playlistTrackTemp, playlistTrack)
}
## 1 minute 30 seconds to process 1000 songs. Error 429 isn't blocking
timeElapsed <- as.numeric(Sys.time() - timeStart, units = "secs")
cat("Processed", playlistSize, "rows in", timeElapsed %/% 60, "minutes and",
    timeElapsed %% 60, "seconds\n")

## Saving in csv
write.csv(features, file = filename)
