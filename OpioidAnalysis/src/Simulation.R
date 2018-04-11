library(foreach)
library(dplyr)
library(tidyr)
library(plotly)


#currNumber: base number of addic, must be greater than 0
#num_years: number of years to run simulation
#opioidUse: distribution of opioid claims rate
#alternativeUse: distribution of alternatives claim rate
#run: how many times to run simulation
simmulate_outcomes <- function(currNumber, num_years, opioidUse, alternativeUse, run) {

  sim <- data.frame("year" = 2018:(2018+num_years-1))
  
  for (r in 2:(run + 1)) {
    currentNumber <- currNumber
    for (y in 1:num_years) { 
      baseAddicRate <- runif(1, 0, .3) #base addiction rate from uncontrolled market
      baseNumber <- currentNumber*(1+baseAddicRate) #change from baseAddicRate
      numOClaims <- sample(100:200, 1) #rate of opioid claims being covered
      numAClaims <- sample(201:500, 1) #rate of alternative claims being covered
        
      currentNumber <- baseNumber + numOClaims - numAClaims
      if(currentNumber < 0) {
        sim[y, r] <- 0
      } else  {
        sim[y, r] <- currentNumber
      }
    }
  }
  return(sim)
}

d <- simmulate_outcomes(1000, 10, 100, 100, 10)
d$year <- factor(d$year)
levels(d$year)
data <- gather(d, key = section, value = sim, -year)

plot_ly(data, y = ~sim, color = ~year, type = "box")
