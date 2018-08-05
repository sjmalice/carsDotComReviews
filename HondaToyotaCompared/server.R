#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(plotly)

carsDotComReviews <- read_csv("carsDotComReviews.csv")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  sidebarFiltered = reactive({
    carsDotComReviews %>% 
      filter(new %in% input$newUsed)
  })
  output$categories = renderPlotly({
    #generate table for plot
    catPlot = sidebarFiltered() %>% 
      filter(
        between(modelYear, input$modelYears[1] + 2000, input$modelYears[2] + 2000)
        ) %>% 
      group_by(make) %>% 
      summarise(overall = mean(rating, na.rm = T),
                comfort = mean(comfort, na.rm = T),
                exteriorStyling = mean(exteriorStyling, na.rm = T),
                interior = mean(interior, na.rm = T),
                performance = mean(performance, na.rm = T),
                reliability = mean(reliability, na.rm = T),
                value = mean(value, na.rm = T)) %>%
      gather(key = "category", value = "avgScore", overall:value)
    
    #find bounds for plot
    yMin = floor(min(catPlot$avgScore)*10)/10
    yMax = ceiling(max(catPlot$avgScore)*10)/10
    
    #render plot
    ggplot(catPlot, aes(x = category)) +
      geom_col(aes(y = avgScore, fill = make), position = 'dodge') +
      coord_cartesian(ylim = c(yMin, yMax))
  })
  output$years = renderPlotly({
    #generate table for plot
    yearPlot = sidebarFiltered() %>%
      select(make, modelYear, score = input$category) %>% 
      group_by(make, modelYear) %>% 
      summarise(score = mean(score, na.rm = T))
    
    #find bounds for plot
    yMin = floor(min(yearPlot$score)*10)/10
    yMax = ceiling(max(yearPlot$score)*10)/10
    
    #render plot
    ggplot(yearPlot, aes(x = modelYear)) +
      geom_col(aes(y = score, fill = make), position = 'dodge') +
      coord_cartesian(ylim = c(yMin, yMax))
  })
})
