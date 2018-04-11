
# Load necessary pakages
library(httr)
library(jsonlite)
library(dplyr)
library(knitr)
library(stringr)


  base.url <- "https://api.fda.gov/"
  resource <- "drug/event.json"
  query.params <- list("search"="patient.reaction.reactionmeddrapt:\"drug+abuser\"", "limit"="5")
  response <- GET(paste0(base.url, resource), query=query.params)
  body = fromJSON(content(response, "text"))
  
  # flatten the data we want to work with from the results from the search
  abuse.events <- flatten(body$results)
  
# Self file  
  reports.json<- fromJSON("Q1.json")
  
  reports <- flatten(reports.json$results)
  num.drugs <- length(reports$patient.drug)
  
  drugs.list <- character()
  
  for(i in 1:num.drugs) {
    drugs.list[i] <- reports$patient.drug[[i]]$medicinalproduct
  }
  
  drugs.list <- unique(drugs.list) %>% sort()
  
  # Reference list filter opioids
  opioids.ref <- read.csv("opioids.csv", header = TRUE)
  opioids.ref.gen <- as.character(opioids.ref$Generic.Name)  
  
  opioids.ref.gen <- opioids.ref.gen %>% strsplit("/") %>% as.character()
  opioids.ref.gen <- str_replace_all(opioids.ref.gen, "WITH", "W/")
  
  View(opioids.ref.gen)
  
  opioids.list <- character()
  
  prev <- 1
  
  for(i in 1:length(opioids.ref.gen)) {
    curr.list <- drugs.list[grepl(opioids.ref.gen[i], drugs.list, fixed = TRUE)]
    print(curr.list)
    if(length(curr.list) > 0) {
      for(j in 1:length(curr.list)) {
        opioids.list[prev+j] <- curr.list[j]
      }
    }
    prev <- prev + length(curr.list)
  }
  
  View(unique(opioids.list))
  