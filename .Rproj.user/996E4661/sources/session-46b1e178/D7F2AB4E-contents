library(shiny)
library(bslib)
library(dplyr)

library(DBI)
library(datamods)
library(reactable)

source(here::here('modules/artist_module.R'))
source(here::here('module_specific_data.R'))
source(here::here('module_functions.R'))


ui <- page_fluid(
  shinyjs::useShinyjs(),
  navset_card_tab(
    nav_panel(title = "Artist",
              artist_ui('artist'))
  )
)

server<- function(input, output, session){
  artist_server('artist',artistData)
}


shinyApp(ui,server)