# Change the following parameters 
playlistID <- "5sjzvvlQ5CYz0b7d36Wroz"
playlistSize <- 280



i <- 1
getOffset <- 0
playlistTrack <- ''
for (i in 0:((playlistSize-1) %/% 100)) {
  playlistTrackTemp <- get_playlist_tracks(playlistID, fields = NULL, limit = 100,
                                         offset = (i*100),  market = NULL,
                                         authorization = get_spotify_access_token(),
                                         include_meta_info = FALSE)
  playlistTrackTrack <- playlistTrackTemp$track.external_urls.spotify
  playlistTrack <- rbind(data.frame(playlistTrackTrack), playlistTrack)
  Sys.sleep(1)
}

playlistTrack



for (user in 1:nrow(bdims)) {
  print(paste("next year you'll be ", bdims$age[user] + 1))
}

#for (i in 1:10) {
#  print(paste("next year you'll be ", bdims$age[i] + 1))
#}


for (user in 100:110) {
  if (bdims$age[user] <25){
    print("you're under 25!!")
  } else { print("OK you're over 25")}
  
}