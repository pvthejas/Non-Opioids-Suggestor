library(httr)
library(jsonlite)
library(dplyr)
library(data.table)

drug_cost <- function(drug_name) {
  drug_name <- toupper(drug_name)
  base_url <- paste0("https://data.cms.gov/resource/uggq-gnqc.json?drug_name=", drug_name)
  response <- GET(base_url)
  body <- content(response, "text")
  data <- fromJSON(body)
  claims_and_cost <- data %>% select(total_30_day_fill_count, total_drug_cost)
  sums <- data.frame(claims=sum(as.numeric(data$total_30_day_fill_count)), 
                     cost=sum(as.numeric(data$total_drug_cost)))
  
  drug_cost <- sums$cost / sums$claims
  return(drug_cost)
}

drug_cost("SUBOXONE")


popular_opioids <- c("hydrocodone-acetaminophen", "tramadol hcl", "oxycontin", "fentanyl", "percocet")
alternative <- c("gabapentin", "neurontin", "celebrex", )