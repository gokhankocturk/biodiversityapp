#' INFO Module UI and SERVER functions
#'
#' @param id
#'
#' @return
#' @export
#'
#' @import dplyr forcats ggplot2 hrbrthemes leaflet shiny shinydashboard shinyWidgets stringr timevis

# Creating module UI
infoUI <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      infoBoxOutput(ns("city"), width = 8),
      infoBoxOutput(ns("kingdom"), width = 2),
      infoBoxOutput(ns("observations"), width = 2)
    )
  )

}

# Creating module SERVER
infoSERVER <- function(id, data) {
  moduleServer(id,
               function(input, output, session) {

                 output$kingdom <- renderInfoBox({
                   kingdom <- data() %>% group_by(kingdom) %>% summarize(x = n())
                   text <- ""
                   for(x in kingdom$kingdom) {
                     text = paste0(text, " * ", x)
                   }
                   infoBox(title = "Kingdom", value = text, icon = icon("sitemap"), color = "green", fill = TRUE)
                 })

                 output$city <- renderInfoBox({
                   city <- data() %>% group_by(town) %>% summarize(x = n())
                   text <- ""
                   for(x in city$town) {
                     text = paste0(text, " * ", x)
                   }
                   infoBox(title = "City", value = text, icon = icon("city"), color = "green", fill = TRUE)
                 })

                 output$observations <- renderInfoBox({
                   total <- sum(data()$individualCount)
                   infoBox(title = HTML(paste("Ind. Count", br(), "Total")), value = total, icon = icon("bug"), color = "green", fill = TRUE)
                 })
               })

}
