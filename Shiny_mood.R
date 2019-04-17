#shinyapp
library(shiny)
library(spotifyr)
ui <- fluidPage(titlePanel("Mood Classifier"),
                   
  sidebarLayout(
    sidebarPanel( textInput(inputId = "song", label = "Enter Song URL"),
                   # submit button
                   actionButton("submit", label = "Submit")),
     mainPanel(textOutput("mood"))
)
)
server <- function(input, output) {
  text_reactive <- observeEvent(input$submit, {
output$mood <- renderText({
    Sys.setenv(SPOTIFY_CLIENT_ID = '9911fb0ae7754159b26b9f120edf02f9')
    Sys.setenv(SPOTIFY_CLIENT_SECRET = 'a201b267bf23439a8f6f2dce5e77c102')
    access_token <- get_spotify_access_token()
    #modLR <- readRDS(file = "files/mod_log_regression.rds")
    modLR <- readRDS(file = "./mod_log_regression.rds")
    songURL <- input$song
    temp <- sub(".*:", "", songURL)
    temp <- sub(".*/", "", temp)
    songID <- sub("\\?.*", "", temp)
  songTitle <- get_track(songID)$name
  songArtist <- get_track(songID)$artists$name
  songMoodPredictLR <- predict(modLR, get_track_audio_features(songID)[-c(12:16, 18)])
  if(songMoodPredictLR == 1){
    mood <- "Happy :)"
  } else{
    mood <- "Sad :("
  }
 #cat("the song '", songTitle, "' from", songArtist, "is", mood)
}) })}
shinyApp(ui = ui, server = server)

