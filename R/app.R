#' Main UI and SERVER functions
#'
#' @param ...
#'
#' @return
#' @export
#'
#' @import dplyr forcats ggplot2 hrbrthemes leaflet shiny shinydashboard shinyWidgets stringr timevis

biodiversityapp <- function(...) {

  ####################################
  # Defining CSS
  ####################################
  CSS <- "
  h2 {height: 400px; width: 100%; color: #F5F5DC; padding: 10px; border: 2px solid coral; border-radius: 10px; text-align: center; font-size: 16px;}
  h3 {margin-top: 0px; width: 100%; color: green; border: 2px solid coral; border-radius: 10px; text-align: left; font-size: 20px; padding: 10px;}
  h4 {color: green; border: 2px solid coral; border-radius: 10px; text-align: center; font-weight: bold; font-size: 20px; padding: 10px;}
  .content-wrapper {background-color: #ECF0BB;}
  .main-header .logo {text-align: center; height: 100px; background-color: #80D4A5 !important; color: green !important; font-weight: bold; font-size: 26px;}
  hr {border: 1px dashed green;}
  label {color: green; border: 2px solid coral; border-radius: 5px; font-weight: bold; font-size: 18px; padding: 5px; background-color: #ECF0BB;}
  .my_style {color: #F5F5DC; background-color: green;}
  "


  ####################################
  # Defining layout for App
  ####################################

  header <- dashboardHeader(title = tagList("APPSILON", br(), icon("bug", class = "fa-spin"), "Biodiversity Assignment", icon("globe", class = "fa-spin")),
                            titleWidth = "100%")

  body <- dashboardBody(
    tags$style(CSS),
    selectUI("select"),
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


  ####################################
  # Defining main UI
  ####################################

  ui <- dashboardPage(header = header, body = body, sidebar = sidebar)

  ####################################
  # Defining main SERVER
  ####################################

  server <- function(input, output, session) {
    getdata <- selectSERVER("select")
    maptimeSERVER("maptime", data = getdata$datasend, species = getdata$namesend)
    infoSERVER("info", data = getdata$datasend)

    output$monthly <- renderPlot({
      data <- getdata$datasend()
      data <- data %>% group_by(month_name) %>% summarize(occurence = sum(individualCount))
      data$month_name <- fct_relevel(data$month_name, "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")
      ggplot(data, aes(x = month_name, y = occurence, label = occurence)) +
        geom_col(fill = "#69b3a2", color = "black") +
        geom_text(vjust = -0.25, hjust = 0.5, colour = "black", size = 4) +
        theme_ipsum() +
        ggtitle(paste0("Occurence of '", getdata$namesend(), "' by month")) +
        xlab("Month") +
        ylab("Occurence")
    })

    output$yearly <- renderPlot({
      data <- getdata$datasend()
      data <- data %>% group_by(year) %>% summarize(occurence = sum(individualCount))
      ggplot(data, aes(x = year, y = occurence, group = 1)) +
        geom_line(color = "green") +
        geom_point(shape = 21, color = "black", fill = "#69b3a2", size = 6) +
        theme_ipsum() +
        ggtitle(paste0("Occurence of '", getdata$namesend(), "' by year")) +
        xlab("Year") +
        ylab("Occurence")
    })
  }

  shinyApp(ui, server, ...)
}
