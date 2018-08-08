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
library(tm)
library(wordcloud)
library(slam)

carsDotComReviews <- read_csv("carsDotComReviews.csv")
carsDotComReviews$recommend = as.factor(carsDotComReviews$recommend)

#function to calculate p-values
pValue = function(df){
  function(s){
    t.test(df[[s]][df$make == "Honda"],
           df[[s]][df$make == "Toyota"],
           alternative = "two.sided")$p.value %>%
      signif(digits = 3)
  }
}

shinyServer(function(input, output) {
  #filter table by sidebar selections
  sidebarFiltered = reactive({
    (if (length(input$newUsed) == 2){
      return(carsDotComReviews)
    } else {
      return(carsDotComReviews %>% 
               filter(new == input$newUsed))
    }) %>% 
      filter(recommend %in% input$recommend)
  })
  
  sWords = reactive({
    strsplit(input$stopWords, split = " ")
  })
  
  output$categories = renderPlotly({
    
    pageFiltered = sidebarFiltered() %>% 
      filter(
        between(modelYear, input$modelYears[1] + 2000, input$modelYears[2] + 2000)
        )
    #generate table for plot
    catPlot = pageFiltered %>% 
      group_by(make) %>% 
      summarise(rating = mean(rating, na.rm = T),
                comfort = mean(comfort, na.rm = T),
                exteriorStyling = mean(exteriorStyling, na.rm = T),
                interior = mean(interior, na.rm = T),
                performance = mean(performance, na.rm = T),
                reliability = mean(reliability, na.rm = T),
                value = mean(value, na.rm = T),
                count = n()) %>%
      gather(key = "category", value = "avgScore", rating:value) %>% 
    #calculate p-values between brands
      mutate(pValue = sapply(category, pValue(pageFiltered)))
    
    #find bounds for plot
    yMin = floor(min(catPlot$avgScore)*10)/10
    yMax = ceiling(max(catPlot$avgScore)*10)/10
    
    #render plot
    (ggplot(catPlot, aes(x = category)) +
      geom_col(aes(y = avgScore, fill = make, color = pValue, group = count), position = 'dodge') +
      coord_cartesian(ylim = c(yMin, yMax)) +
      guides(colour = 'none')) %>% 
      ggplotly(tooltip = c("y", "pValue", "count"))
  })
  output$years = renderPlotly({
    #function to generate p-values
    pValue0 = function(y){
      t.test(sidebarFiltered()[[input$category]][(sidebarFiltered()$modelYear == y) & sidebarFiltered()$make == "Honda"],
             sidebarFiltered()[[input$category]][(sidebarFiltered()$modelYear == y) & sidebarFiltered()$make == "Toyota"],
             alternative = "two.sided")$p.value %>% 
        signif(digits = 3)
    }
    #generate table for plot
    yearPlot = sidebarFiltered() %>%
      select(make, modelYear, score = input$category) %>% 
      group_by(make, modelYear) %>% 
      summarise(score = mean(score, na.rm = T),
                pValue = pValue0(modelYear),
                count = n())
    
    #find bounds for plot
    yMin = floor(min(yearPlot$score)*10)/10
    yMax = ceiling(max(yearPlot$score)*10)/10
    
    #render plot
    (ggplot(yearPlot, aes(x = modelYear)) +
      geom_col(aes(y = score, fill = make, color = pValue, group = count), position = 'dodge') +
      coord_cartesian(ylim = c(yMin, yMax)) +
      guides(colour = 'none')) %>% 
      ggplotly(tooltip = c("y", "pValue", "count"))
  })
  output$wordCloudH = renderPlot({
    plotWords = sidebarFiltered() %>% 
      filter((make == "Honda") &
               between(modelYear,
                       input$modelYears1[1] + 2000,
                       input$modelYears1[2] + 2000)
             ) %>% 
      cloud(sWords()[[1]])
    
    wordcloud_rep(words = plotWords$word,
              freq = plotWords$freq,
              max.words=100,
              random.order=FALSE,
              rot.per=0.35,
              colors=brewer.pal(8, "Dark2"))
    
  })
  output$wordCloudT = renderPlot({
    plotWords = sidebarFiltered() %>% 
      filter((make == "Toyota") &
               between(modelYear,
                       input$modelYears1[1] + 2000,
                       input$modelYears1[2] + 2000)
      ) %>%  
      cloud(sWords()[[1]])
    
    wordcloud_rep(words = plotWords$word,
              freq = plotWords$freq,
              max.words=100,
              random.order=FALSE,
              rot.per=0.35,
              colors=brewer.pal(8, "Dark2"))
    
  })
})
