#' Main UI and SERVER functions
#'
#' @param ...
#'
#' @return
#' @export
#'
#' @import dplyr forcats ggplot2 hrbrthemes leaflet shiny shinydashboard shinyWidgets stringr timevis

biodiversityapp <- function(...) {

  CSS <- "
  h2 {height: 400px; width: 100%; color: #F5F5DC; padding: 10px; border: 2px solid coral; border-radius: 10px; text-align: center; font-size: 16px;}
  .content-wrapper {background-color: #ECF0BB;}
  .main-header .logo {text-align: center; height: 100px; background-color: #80D4A5 !important; color: green !important; font-weight: bold; font-size: 26px;}
  h3 {height: 100%; width: 100%; color: green; border: 2px solid coral; border-radius: 10px; text-align: left; font-size: 20px; padding: 10px;}
  h4 {color: green; border: 2px solid coral; border-radius: 10px; text-align: center; font-weight: bold; font-size: 20px; padding: 10px;}

  #search_name {color: coral; border: 2px solid coral; border-radius: 10px;}
  label {color: green; border: 2px solid coral; border-radius: 5px; font-weight: bold; font-size: 18px; padding: 5px; background-color: #ECF0BB;}
  hr {border: 1px dashed green;}
  .my_style {color: #F5F5DC; background-color: green;}
  "

  header <- dashboardHeader(title = tagList("APPSILON", br(), icon("bug", class = "fa-spin"), "Biodiversity Assignment", icon("globe", class = "fa-spin")),
                            titleWidth = "100%")

  body <- dashboardBody(
    tags$style(CSS),
    selectUI("select"),
    hr(),
    infoUI("info"),
    hr(),

    fluidRow(
      column(width = 6, plotOutput("monthly")),
      column(width = 6, plotOutput("yearly"))
    ),
    br(),
    maptimeUI("maptime")
  )

  sidebar = dashboardSidebar(disable = TRUE)

  ui <- dashboardPage(header = header, body = body, sidebar = sidebar)

  server <- function(input, output, session) {
    getdata <- selectSERVER("select")
    maptimeSERVER("maptime", data = getdata$datasend, species = getdata$namesend)
    infoSERVER("info", data = getdata$datasend)

    output$monthly <- renderPlot({
      data <- getdata$datasend()
      data2 <- data %>% group_by(month_name) %>% summarize(occurence = sum(individualCount))
      data2$month_name <- fct_relevel(data2$month_name, "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")
      ggplot(data2, aes(x = month_name, y = occurence, label = occurence)) +
        geom_col(fill = "#69b3a2", color = "black") +
        geom_text(vjust = -0.25, hjust = 0.5, colour = "black", size = 4) +
        theme_ipsum() +
        ggtitle(paste0("Occurence of '", getdata$namesend(), "' by month")) +
        xlab("Month") +
        ylab("Occurence")
    })

    output$yearly <- renderPlot({
      data <- getdata$datasend()
      data2 <- data %>% group_by(year) %>% summarize(occurence = sum(individualCount))
      ggplot(data2, aes(x = year, y = occurence, group = 1)) +
        geom_line(color = "green") +
        geom_point(shape = 21, color = "black", fill = "#69b3a2", size = 6) +
        theme_ipsum() +
        ggtitle(paste0("Occurence of '", getdata$namesend(), "' by year")) +
        xlab("Year") +
        ylab("Occurence")
    })


    # output$deneme <- renderDataTable({
    #   req(getdata$namesend())
    #   # list_vernacular <- occurence[grepl(input$search_name, occurence$vernacularName, ignore.case = TRUE), ]
    #   list_vernacular <- filter_at(occurence, vars(vernacularName, scientificName), any_vars(str_detect(., regex(getdata$namesend(), ignore_case = T))))
    #   list_vernacular
    # })

  }

  shinyApp(ui, server, ...)
}
