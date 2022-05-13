
<!-- README.md is generated from README.Rmd. Please edit that file -->

# biodiversityapp

![R](https://img.shields.io/badge/r-%23276DC3.svg?style=for-the-badge&logo=r&logoColor=white)
![appsilon](https://img.shields.io/badge/Appsilon-rshiny-orange)
![marine](https://img.shields.io/badge/biodiversity-map-green)
![license](https://img.shields.io/badge/license-MIT-red)

# Overview

Application is based on biodiversity data provided by **APPSILON**.  
  
**shiny**, **shinydashboard**, **shinyWidgets** and **timevis** packages
are mainly used for the application and the tests are conducted by
**testthat** package.  

Basically, users search for a name of the species in **searchInput**
field and the matching results are displayed on **selectInput** field.
Users can search with both *vernacular* and *scientific* name of the
species.  

Results are summarized with 3 **infoBoxOutput**, 3 **plotOutput**, 1
**leafletOutput** and 1 **timevisOutput**.  

<span style="text-decoration: underline">**infoBoxOutput (by
month)**</span>  
There are 3 infoBoxOutput in a row;  
**Left:** All the cities are listed for the selected species.  
**Middle:** The kingdom of the selected species is shown.  
**Right:** Individual count total for the selected species is
calculated.  

![info](www/infoBoxOutput.JPG)  

<span style="text-decoration: underline">**plotOutput (by
month)**</span>  
Data for selected species is grouped by **month** and the total
individual counts are displayed on bar graph.  

![month](www/by_month.JPG)  

<span style="text-decoration: underline">**plotOutput (by
year)**</span>  
Data for selected species is grouped by **year** and the total
individual counts are displayed on line graph.  

![year](www/by_year.JPG)  

<span style="text-decoration: underline">**plotOutput (by
city)**</span>  
Data for selected species is grouped by **city** and the total
individual counts are displayed on horizontal bar graph.  

![city](www/by_city.JPG)  

<span style="text-decoration: underline">**leafletOutput**</span>  
Longitude and Latitude information are used to visualize observed
species on the map. You can also see the number of individual counts on
markers.

![map](www/map.JPG)  

<span style="text-decoration: underline">**timevisOutput**</span>  
The places where the selected species are observed are shown on time
visualization output.  

![timevis](www/timevis.JPG)
