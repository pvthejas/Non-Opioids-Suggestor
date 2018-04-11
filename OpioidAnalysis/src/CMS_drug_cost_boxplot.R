library(httr)
library(jsonlite)
library(dplyr)
library(ggplot2)

# Returns cost of a passed in drug name if it is in the CMS data file. 
drug_cost <- function(drug_name) {
  drug_name <- toupper(drug_name)
  base_url <- paste0("https://data.cms.gov/resource/uggq-gnqc.json?drug_name=", drug_name)
  response <- GET(base_url)
  body <- content(response, "text")
  data <- fromJSON(body)
  claims_and_cost <- data %>% select(total_30_day_fill_count, total_drug_cost)
  sums <- data.frame(Cost=((as.numeric(data$total_drug_cost))/as.numeric(data$total_30_day_fill_count)))
  return(sums)
}

cost_graph <- function() {
  opioids <- c("Vicodin", "Tramadol%20HCL", "Percocet", "Butrans", "Fentanyl", "Oxycontin", "Avinza")
  drug_data <- data.frame(Drug=character(), Alternative=character(), Opioid=character(), Cost=as.numeric(double()))
  
  for (i in opioids) {
    data <- data.frame(Drug="Opioid", Alternative=NA, Opioid=i, Cost=drug_cost(i))
    drug_data <- rbind(drug_data, data)
  }
  
  alternatives <- c("Gabapentin", "Etodolac", "Lyrica", "Cymbalta", "Suboxone", "Naprosyn", "Voltaren")

  for (i in alternatives) {
    data <- data.frame(Drug="Alternative", Alternative=i, Opioid=NA, Cost=drug_cost(i))
    drug_data <- rbind(drug_data, data)
  }
  
  return (ggplot(data=drug_data, aes(fill=Drug))
           + geom_boxplot(data=drug_data, aes(x=Alternative, y=Cost))
           + geom_boxplot(data=drug_data, aes(x=Opioid, y=Cost))
           + scale_y_continuous(trans='log10')
           + labs(x = "Drug"))
}

cost_graph()
