#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
# Define UI for application that draws a histogram
shinyUI(
  dashboardPage(
    dashboardHeader(
      title = "Honda and Toyota Compared"
    ),
    dashboardSidebar(
      sidebarUserPanel(
        "Simon Joyce",
        image = "https://yt3.ggpht.com/-04uuTMHfDz4/AAAAAAAAAAI/AAAAAAAAAAA/Kjeupp-eNNg/s100-c-k-no-rj-c0xffffff/photo.jpg"
        ),
      sidebarMenu(
        menuItem("Intro", tabName = "intro", icon = icon("file")),
        menuItem("Categories", tabName = "categories")
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(
          tabName = "intro",
          fluidRow(
            box(
            tags$h1(
              "Honda and Toyota Compared Through User Reviews on ",
                    tags$a(href = "https://www.cars.com/", "Cars.com")
              ),
            width = 6
            ),
            box(
              tags$img(scr = "https://commons.wikimedia.org/wiki/File:2016_Honda_Civic_VTi_sedan_(2017-11-18)_01.jpg",
                       width = "300px",
                       height = "300px"),
              width = 6
            )
          )
        ),
        tabItem(
          tabName = "categories",
          fluidRow(
            box(
              checkboxGroupInput("newUsed",
                                 label = h3("New or Used"),
                                 choices = list("New" = "New", "Used" = "Used"),
                                 selected = c("New", "Used"))
            ),
            box(
              sliderInput("modelYears", label = h3("Model Years"), min = 13, 
                          max = 18, value = c(13, 18))
            )
          ),
          fluidRow(
            box(
              plotlyOutput("categories"),
              width = 12
            )
          )
        )
      )
    )
  ) 
)
