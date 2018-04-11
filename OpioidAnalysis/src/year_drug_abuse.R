library("httr")
library("jsonlite")
library("data.table")

#https://api.fda.gov/drug/event.json?search=patient.reaction.reactionmeddrapt:%22drug+abuser%22+AND+patient.drug.medicinalproduct:%22Hydrocodone%22&count=receivedate&limit=100

#Data fetch from API and cleaning
abuse_count <- function(drug) {
  base_url <- "https://api.fda.gov/drug/event.json?search="
  reaction_query <- "patient.reaction.reactionmeddrapt:%22drug+abuser%22"
  drug_query <- "+AND+patient.drug.medicinalproduct:"
  drug <- paste0("%22", drug, "%22") #Drug parameter
  end_query <- "&count=receivedate&limit=100"
  api_query <- paste0(base_url, reaction_query, drug_query, drug, end_query) #final query
  response <- GET(api_query)
  body <- content(response, "text")
  parsed_data <- as.data.table(fromJSON(body)$result)
  abuse_counts_by_year <- rbindlist(list(parsed_data, data.table(time = c(2004:2017), count = 0)))[, time := as.character(time)] #add consistent year range
  abuse_counts_by_year <- abuse_counts_by_year[, time := substr(time, 1, 4)][, sum(count), time][order(time)][V1 == 0, V1 := 0.001][, c("low", "high") := list(round(V1 / 0.4467, digits = 4), round(V1 / .00071, digits = 4))] #data cleaning
  return(abuse_counts_by_year)
}

