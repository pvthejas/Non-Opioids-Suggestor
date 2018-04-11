library(httr)
library(jsonlite)
library(dplyr)
library(data.table)
library(ggplot2)

drug_name <- "hydrocodone"
drug_query <- paste0("patient.drug.medicinalproduct:\"", drug_name, "\"")
drug_abuser <- "patient.reaction.reactionmeddrapt.exact:\"drug+abuser\""
count.by <- "patient.reaction.reactionmeddrapt.exact"
base.url <- "https://api.fda.gov/drug/event.json"
complete.query <- paste0("?search=", drug_query, "+AND+", drug_abuser)
var <- paste0("&count=", count.by)
url <- paste0(base.url, complete.query, var)
response <- GET(url)
data <- as.data.table(fromJSON(content(response, "text"))$results)
data