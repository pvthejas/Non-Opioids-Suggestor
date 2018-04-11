library(httr)
library(jsonlite)
library(dplyr)
library(data.table)
library(ggplot2)


drug <- "Hydrocodone"
count.by <- "patient.reaction.reactionmeddrapt"
base.url <- "https://api.fda.gov/drug/event.json?search=receivedate:[20040101+TO+20180302]"
drug.query <- paste0("+AND+", drug)
var <- paste0("&count=", count.by)
url <- paste0(base.url, drug.query, var)
response <- GET(url)
data <- as.data.table(fromJSON(content(response, "text"))$results)

b <- ggplot(data, aes(x=data$time, y=data$count)) +
  geom_bar(stat = "identity")
b
