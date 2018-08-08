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
library(plotly)
# Define UI for application that draws a histogram
shinyUI(
  dashboardPage(
    dashboardHeader(
      title = "Honda and Toyota 
      Compared"
    ),
    dashboardSidebar(
      sidebarUserPanel(
        "Simon Joyce",
        image = "https://yt3.ggpht.com/-04uuTMHfDz4/AAAAAAAAAAI/AAAAAAAAAAA/Kjeupp-eNNg/s100-c-k-no-rj-c0xffffff/photo.jpg"
        ),
      sidebarMenu(
        menuItem("Intro", tabName = "intro", icon = icon("file")),
        menuItem("Score Categories", tabName = "categories", icon = icon("car")),
        menuItem("Model Years", tabName = "years", icon = icon("calendar"))
      ),
      hr(),
      checkboxGroupInput("newUsed",
                         label = h3("New or Used"),
                         choices = list("New" = "New", "Used" = "Used"),
                         selected = c("New", "Used")),
      hr(),
      checkboxGroupInput("recommend",
                         label = h3("Reviewer Recommended"),
                         choices = list("Yes" = "Does", "No" = "Does not"),
                         selected = c("Does", "Does not"))
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
            tags$p("Explore a data set of roughly 18000 user reviews for all current models of Honda and Toyota for 
                   model years 2013 to 2018 that I scraped from ",
                   tags$a(href = "https://www.cars.com/", "Cars.com. ")),
            # tags$p("Since consulting user reviews online before committing to a purchase is so commonplace among consumers these days, 
            #        companies would be wise to pay close attention to what is being said about them within the reviews."),
            tags$p("In the sidebar, you can select reviews based on whether the car was bought new or used, 
                   or if the reviewer recommends the car or not. "),
            width = 6
            ),
            box(tags$img(src = "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4a/Honda_CR-V_2.2_i-DTEC_Lifestyle_(IV)_%E2%80%93_Frontansicht,_25._Januar_2014,_D%C3%BCsseldorf.jpg/1200px-Honda_CR-V_2.2_i-DTEC_Lifestyle_(IV)_%E2%80%93_Frontansicht,_25._Januar_2014,_D%C3%BCsseldorf.jpg",
                         #width = "300px",
                         height = "300px"
                         )),
            width = 6
          )
        ),
        tabItem(
          tabName = "categories",
          fluidRow(
            box(
              tags$p("Here are the average scores out of 5 for each of the seven categories that users rate the car in the review."),
              tags$p("You can select a range of model years to the right. Mouse over the plot to see number of reviews the score is based on and the p-value 
                     for how significant the difference between the groups is."),
              # height = "auto",
              width = 6
            ),
            box(
              sliderInput("modelYears",
                          label = h3("Model Year Range"),
                          min = 13, 
                          max = 18,
                          value = c(13, 18)),
              # height = "auto",
              width = 6
            )
          ),
          fluidRow(
            box(
              plotlyOutput("categories"),
              width = 12
            )
          )
        ),
        tabItem(
          tabName = "years",
          fluidRow(
            box(
             tags$p("See how average scores for each brand compare for each model year"),
             tags$p("Select the score category to compare of the right. Mouse over the bars to see number of reviews the score is based on and the p-value for the significance of the difference in the score.")
            ),
            box(
              selectizeInput("category",
                             label = h3("Score Category"),
                             choices = list("Overall" = "rating",
                                            "Comfort" = "comfort",
                                            "Exterior Styling" = "exteriorStyling",
                                            "Interior Styling" = "interior",
                                            "Performance" = "performance",
                                            "Reliability" = "reliability",
                                            "Value for Money" = "value"))
            )
          ),
          fluidRow(
            box(
              plotlyOutput("years"),
              width = 12
            )
          )
        )
      )
    )
  ) 
)
