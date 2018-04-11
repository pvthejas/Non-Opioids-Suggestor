
# Load necessary pakages
library(httr)
library(jsonlite)
library(dplyr)
library(knitr)
library(stringr)
library(ggplot2)



top_5_side_effects <- function(drug_name) {
  response <- GET(paste0("https://api.fda.gov/drug/event.json?search=receivedate:[20040101+TO+20180309]+AND+patient.drug.medicinalproduct:\"", drug_name, "\"&count=patient.reaction.reactionmeddrapt.exact"))
  body = fromJSON(content(response, "text"))
  
  # flatten the data we want to work with from the results from the search
  side.effects <- flatten(body$results)
  
  side.effects <- side.effects %>% arrange() %>% head(n=5)
  
  
  ggplot(side.effects, aes(x=reorder(term, -count), y=count)) +
    geom_bar(stat = "identity", width = .4) +
    x_label("Side Effect")
  
}

top_5_side_effects("hydrocodone")


