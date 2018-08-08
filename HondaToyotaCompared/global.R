library(tm)
library(wordcloud)
library(slam)
library(tidyverse)

#function to calculate p-values
pValue = function(df){
  function(s){
    t.test(df[[s]][df$make == "Honda"],
           df[[s]][df$make == "Toyota"],
           alternative = "two.sided")$p.value %>%
      signif(digits = 3)
  }
}

#function to generate data for wordclouds
hondas = c('accord', 'accord_hybrid', 'civic', 'civic_type_r', 'clarity_plug_in_hybrid', 'fit', 'insight', 'cr_v', 'hr_v', 'pilot', 'ridgeline', 'odyssey')
toyotas = c('86', 'avalon', 'avalon_hybrid', 'camry', 'camry_hybrid', 'corolla', 'corolla_im', 'mirai', 'prius', 'prius_prime', 'prius_c', 'prius_v', 'yaris', '4runner', 'c_hr', 'highlander', 'highlander_hybrid', 'land_cruiser', 'rav4', 'rav4_hybrid', 'sequoia', 'tacoma', 'tundra', 'sienna')

cloud = function(df, w){
  myCorpus = df[, c("title", "reviewBody")] %>% 
    unlist() %>% 
    VectorSource() %>% 
    Corpus() %>% 
    tm_map(tolower) %>% 
    tm_map(removePunctuation) %>% 
    tm_map(removeNumbers) %>% 
    tm_map(removeWords, c(stopwords("SMART"),
                          "honda",
                          "toyota",
                          "car",
                          "vehicle",
                          "rav",
                          "crv",
                          hondas,
                          toyotas,
                          w)) %>% 
    TermDocumentMatrix(control = list(minWordLength = 1)) %>% 
    removeSparseTerms(sparse = 0.99) %>% 
    rollup(2,na.rm=TRUE, FUN=sum) %>% 
    as.matrix() %>% 
    rowSums() %>% 
    sort(decreasing = T)
  
  return(data.frame(word = names(myCorpus),freq=myCorpus))
}

wordcloud_rep <- repeatable(wordcloud)