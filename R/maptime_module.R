#' MAP and TIME Module UI and SERVER functions
#'
#' @param id
#'
#' @return
#' @export
#'
#' @import dplyr forcats ggplot2 hrbrthemes leaflet shiny shinydashboard shinyWidgets stringr timevis

# Creating module UI
maptimeUI <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      column(width = 6, leafletOutput(ns("map"))),
      column(width = 6, plotOutput(ns("graph")))
    ),
    br(),
    hr(),
    fluidRow(
      column(width = 12, h4("Time Visualization for which cities the species observed"))
    ),
    timevisOutput(ns("timevis"))
  )
}

# Creating module SERVER
maptimeSERVER <- function(id, data, species) {
  moduleServer(
    id,
    function(input, output, session) {

      output$graph <- renderPlot({
        data_for_graph <- data() %>% group_by(town) %>% summarize(counts = sum(individualCount))
        ggplot(data_for_graph, aes(x = reorder(town, counts), y = counts)) + geom_col(fill = "#69b3a2", color = "black", show.legend = FALSE) +
          coord_flip() +
          labs(x = NULL, y = "Individual Count",
               title = paste0("Individual count distribution by city: ", species()),
               caption = "Source: www.gbif.org") +
          theme_ipsum()
          # theme(
          #       title = element_text(color = "black", face = "bold"),
          #       axis.ticks = element_blank(),
          #       plot.background = element_rect("white"),
          #       panel.background = element_rect("white"),
          #       panel.grid.minor = element_line(color = "black"),
          #       axis.title = element_text(color = "#292929", face = "bold"),
          #       axis.text = element_text(color = "#292929", face = "bold"),
          #       strip.text.x = element_text(face = "bold", color = "#292929"),
          #       # strip.background = element_blank(),
          #       panel.spacing = unit(2, "lines"))

      })


      output$map <- renderLeaflet({
        req(species())

        data() %>%
          leaflet() %>%
          addTiles() %>%
          addCircleMarkers(
            popup = ~ paste0("Observations : ", as.character(individualCount)),
            fillColor = "black",
            color = "green",
            weight = 2
          ) %>%
          addProviderTiles(
            "OpenStreetMap",
            group = "OpenStreetMap"
          ) %>%
          addProviderTiles(
            "CartoDB.Positron",
            group = "CartoDB.Positron"
          ) %>%
          addProviderTiles(
            "Esri.WorldImagery",
            group = "Esri.WorldImagery"
          ) %>%
          addLayersControl(
            baseGroups = c(
              "OpenStreetMap", "CartoDB.Positron", "Esri.WorldImagery"
            ),
            position = "topleft"
          ) %>%
          addLegend(
            colors = "blue",
            labels = "Biodiversity",
            title = "Poland data set",
            opacity = 1,
            position = "bottomleft"
          ) %>%
          addAwesomeMarkers(
            lat = data()$LAT,
            lng = data()$LON,
            label = paste0("Observations: ",data()$individualCount),
            icon = makeAwesomeIcon(
              icon = "flag",
              markerColor = "green",
              iconColor = "white"
            )
          )

      })

      output$timevis <- renderTimevis({
        req(species())
        veri <- data()
        veri$content <- substr(veri$locality, start = 10, stop = nchar(veri$locality))
        veri <- distinct(veri, start, .keep_all = TRUE)
        veri$className <- c("my_style")

        timevis(data = veri,
                options = list(editable = TRUE, multiselect = TRUE, align = "center"))
      })
    }
  )
}
