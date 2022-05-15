#' SELECT Module UI and SERVER functions
#'
#' @param id
#'
#' @return
#' @export
#' @import dplyr forcats ggplot2 hrbrthemes leaflet shiny shinydashboard shinyWidgets stringr timevis

# Creating module UI
selectUI <- function(id) {
  ns <- NS(id)

    tagList(
      fluidRow(
        column(width = 6, h3(tags$b("Search Field :"), " You can search species by scientific / vernacular name.",
                                 br(),
                                 br(),
                                 tags$b("Search Button :"), " You can click on search button to display matched names.",
                                 br(),
                                 br(),
                                 tags$b("Select Field :"), " You can select a scientific / vernacular name. ")),

        column(width = 3, searchInput(ns("search_name"),
                                      label = "Search a name:",
                                      placeholder = NULL,
                                      btnSearch = icon("search"),
                                      btnReset = icon("remove"))),

        column(width = 3, selectInput(ns("select_name"),
                                      label = "Select species name:",
                                      choices = NULL))
      ),

      conditionalPanel(
        condition = "input.select_name == ''", ns = ns,
        box(
          background = "green",
          solidHeader = FALSE,
          collapsible = FALSE,
          width = 12,
          fluidRow(
            column(
              width = 9,
              h2(
                tags$i(tags$b("What Is Biodiversity?")),
                br(),
                "The term biodiversity (from “biological diversity”) refers to the variety of life on Earth at all its levels, from genes to ecosystems, and can encompass the evolutionary, ecological, and cultural processes that sustain life.",
                br(),
                br(),
                tags$i(tags$b("Why Is Biodiversity Important?")),
                br(),
                "Biodiversity is important to most aspects of our lives. We value biodiversity for many reasons, some utilitarian, some intrinsic. This means we value biodiversity both for what it provides to humans, and for the value it has in its own right. Utilitarian values include the many basic needs humans obtain from biodiversity such as food, fuel, shelter, and medicine. Further, ecosystems provide crucial services such as pollination, seed dispersal, climate regulation, water purification, nutrient cycling, and control of agricultural pests. Biodiversity also holds value for potential benefits not yet recognized, such as new medicines and other possible unknown services. Biodiversity has cultural value to humans as well, for spiritual or religious reasons for instance. The intrinsic value of biodiversity refers to its inherent worth, which is independent of its value to anyone or anything else. This is more of a philosophical concept, which can be thought of as the inalienable right to exist. Finally, the value of biodiversity can also be understood through the lens of the relationships we form and strive for with each other and the rest of nature. We may value biodiversity because of how it shapes who we are, our relationships to each other, and social norms. These relational values are part of peoples’ individual or collective sense of wellbeing, responsibility for, and connection with the environment. The different values placed on biodiversity are important because they can influence the conservation decisions people make every day.",
                br(),
                br(),
                tags$i(tags$b("Threats to Biodiversity")),
                br(),
                "Over the last century, humans have come to dominate the planet, causing rapid ecosystem change and massive loss of biodiversity across the planet. This has led some people to refer to the time we now live in as the “anthropocene.” While the Earth has always experienced changes and extinctions, today they are occurring at an unprecedented rate. Major direct threats to biodiversity include habitat loss and fragmentation, unsustainable resource use, invasive species, pollution, and global climate change. The underlying causes of biodiversity loss, such as a growing human population and overconsumption are often complex and stem from many interrelated factors.")
            ),

            column(
              width = 3,
              br(),
              fluidRow(tags$img(src = "www/bio.gif", align = "center", width = "90%", height = "190px")),
              br(),
              fluidRow(tags$img(src = "www/bio2.jpg", align = "center", width = "90%", height = "190px"))
            )
          )
        )
      )
    )
}

# Creating module SERVER
selectSERVER <- function(id) {
  moduleServer(id,
               function(input, output, session){

                 list_vernacular <- reactive({
                   req(input$select_name)

                   list_vernacular <- occurence %>% filter(vernacularName %in% input$select_name | scientificName %in% input$select_name)
                   list_vernacular
                 })

                 observeEvent(
                   input$search_name_search,
                   {
                     missing_removed <- unique(filter_at(occurence,
                                           vars(vernacularName, scientificName),
                                           any_vars(str_detect(., regex(input$search_name, ignore_case = T))))$vernacularName)
                     missing_removed <- missing_removed[!is.na(missing_removed)]

                     updateSelectInput(session,
                                       "select_name",
                                       choices = c(sort(missing_removed),
                                                   sort(unique(filter_at(occurence,
                                                                    vars(vernacularName, scientificName),
                                                                    any_vars(str_detect(., regex(input$search_name, ignore_case = T))))$scientificName))))}
                 )

                 send_out <- list(
                   datasend = reactive({list_vernacular()}),
                   namesend = reactive({input$select_name})
                 )
                 return(send_out)
               })
}
