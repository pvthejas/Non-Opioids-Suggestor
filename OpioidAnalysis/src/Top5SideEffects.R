
# Load necessary pakages
library(httr)
library(jsonlite)
library(dplyr)
library(knitr)
library(stringr)
library(plotly)

top_5_side_effects <- function(drug_name) {
  response <- GET(paste0("https://api.fda.gov/drug/event.json?search=receivedate:[20040101+TO+20180309]+AND+patient.drug.medicinalproduct:\"", drug_name, "\"&count=patient.reaction.reactionmeddrapt.exact"))
  body = fromJSON(content(response, "text"))
  
  # flatten the data we want to work with from the results from the search
  side.effects <- flatten(body$results) %>% top_n(5)
  side.effects$term <- factor(side.effects$term, levels = side.effects$term[order(side.effects$count, decreasing = TRUE)])
  p <- plot_ly(side.effects, x = ~term, y = ~count, type = "bar") %>% 
    layout(margin = list(l = 0, r = 0, b = 100, t = 0))
  return(p)
}

# drug_name <- "methadone+hcl" # Substitute "+" for spaces
# top_5_side_effects(drug_name)
