#################################################
## This script return all the url of tracks of ##
## a playlist of more than 100 tracks          ##
#################################################


## Change the following parameters 
playlistID <- "7vZuDT5TEpvzx72XCwpevN"
playlistSize <- 3445


## Looping to get all the songs
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
  #Sys.sleep(1)
}

playlistTrack



