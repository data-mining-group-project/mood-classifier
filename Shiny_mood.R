#shinyapp
library(shiny)
library(spotifyr)
library(randomForest)
library(tree)
library(caret)
ui <- fluidPage(titlePanel("Mood Classifier"),
                sidebarLayout(
                  sidebarPanel(textInput(inputId = "song", label = "Enter Song URL"),
                               actionButton("submit", label = "Submit")),
                  mainPanel(htmlOutput("moodRF"))
                  )
      )
server <- function(input, output) {
  text_reactive <- observeEvent(input$submit, {
    output$moodRF <- renderUI({
      Sys.setenv(SPOTIFY_CLIENT_ID = '9911fb0ae7754159b26b9f120edf02f9')
      Sys.setenv(SPOTIFY_CLIENT_SECRET = 'a201b267bf23439a8f6f2dce5e77c102')
      access_token <- get_spotify_access_token()
      #modLR <- readRDS(file = "files/mod_log_regression.rds")
      modRF <- readRDS(file = "./mod_rf.rds")
      modLR <- readRDS(file = "./mod_log_regression.rds")
      songURL <- input$song
      temp <- sub(".*:", "", songURL)
      temp <- sub(".*/", "", temp)
      songID <- sub("\\?.*", "", temp)
      songTitle <- get_track(songID)$name
      songArtist <- get_track(songID)$artists$name
      songMoodPredictRF <- predict(modRF, get_track_audio_features(songID)[-c(12:16, 18)])
      songMoodPredictLR <- predict(modLR, get_track_audio_features(songID)[-c(12:16, 18)])
      if(songMoodPredictRF == 1){
        mood <- HTML(paste0("According to the Random Forest algorithm the song '", songTitle, "' from ", songArtist, " is happy", '<br/>'))
      } else{?
          mood <- HTML(paste0("According to the Random Forest algorithm the song '", songTitle, "' from ", songArtist, " is sad", '<br/>'))
      }
      if(songMoodPredictLR == 1){
        mood <- HTML(paste0(mood, "According to the Linear Regression algorithm the song '", songTitle, "' from ", songArtist, " is happy"))
      } else{?
          mood <- HTML(paste0(mood, "According to the Linear Regression algorithm the song '", songTitle, "' from ", songArtist, " is sad"))
      }
    })
  }) 
}
shinyApp(ui = ui, server = server)

