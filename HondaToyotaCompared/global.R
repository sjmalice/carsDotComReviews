#function to calculate p-values
pValue = function(df){
  function(s){
    t.test(df[[s]][df$make == "Honda"],
           df[[s]][df$make == "Toyota"],
           alternative = "two.sided")$p.value %>%
      signif(digits = 3)
  }
}