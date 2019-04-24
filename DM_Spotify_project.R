library(spotifyr)
library(knitr)
library(tidyverse)
library(lubridate)
library(dplyr)


Sys.setenv(SPOTIFY_CLIENT_ID = 'x')
Sys.setenv(SPOTIFY_CLIENT_SECRET = 'x')

access_token <- get_spotify_access_token


# Get my playlists and filter the ones that we need 
my_playlist <- get_my_playlists(limit = 50, offset = 0,
                  authorization = get_spotify_authorization_code(),
                                   include_meta_info = FALSE)


# Get Id's

my_playlist_id <- my_playlist$id


tracks <- lapply(my_playlist_id, function(x) { 
  get_playlist_tracks(x, authorization = get_spotify_access_token()) 
})  


tracks_id <- lapply(tracks, "[", 16)
sad_id <- unlist(tracks_id, use.names = F) # list with all track ID's



# Get the tracks variable  from the playlist test

sad_data <- lapply(sad_id, function(x) { 
  get_track_audio_features(x, authorization = get_spotify_access_token()) 
}) 


sad_final <- bind_rows(sad_data)
write.csv(sad_final, file = "sad_final.csv")

# check dublication 

sad_test[duplicated(sad_test$id), ]

# Filter only variables 

sad_variables <- sad_final %>% 
  select(id, danceability, energy, key, loudness, mode, speechiness, acousticness, instrumentalness,
         liveness, valence, tempo, duration_ms)

# ADD label 

sad_variables$label <- 0
write.csv(sad_variables, file = "sad_variables.csv")

happy_variables <- read.csv(file = "featuresHappy.csv", header = TRUE, sep = ",")
happy_variables$label <- 1

sad_v <- sad_variables %>% 
  select( danceability, energy, key, loudness, mode, speechiness, acousticness, instrumentalness,
         liveness, valence, tempo, duration_ms, label)

happy_v <- happy_variables %>% 
  select( danceability, energy, key, loudness, mode, speechiness, acousticness, instrumentalness,
          liveness, valence, tempo, duration_ms, label)

Spotify_mood <- read.csv(file = "songFeatures.csv", header = TRUE, sep = ",")
Spotify <- Spotify_mood %>%
  na.omit() %>%
  select(danceability, energy, key, loudness, mode, speechiness, acousticness, instrumentalness,
         liveness, valence, tempo, duration_ms, label) 
 

na <- subset(Spotify, is.na(Spotify))


