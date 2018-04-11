library(highcharter)
library(RColorBrewer)
source("src/year_drug_abuse.R")

#Base graph with total drug abuse levels
drug_addiction_graph_base <- function(color) {
  d <- abuse_count("")
  hc <- hchart(d, hcaes(x = time, low = low, high = high), type = "areasplinerange", name = "Under Reporting Range: Total", color = paste(color), fillOpacity = 0.3, lineWidth = 0, zIndex = 0, showInLegend = TRUE) %>% 
    # hc_add_series(d, type = "spline", hcaes(x = time, y = V1), name = "Total", zIndex = 1, showInLegend = TRUE, color = paste(color)) %>% 
    # hc_add_series(d, hcaes(x = time, low = low, high = high), type = "areasplinerange", name = "Under Reporting Range: Total", color = paste(color), fillOpacity = 0.3, lineWidth = 0, zIndex = 0, showInLegend = TRUE) %>%
    hc_title(text = "Addiction Rate") %>% 
    hc_yAxis(title = list(text = "# of Events of Drug Abuse"), type = "logarithmic") %>% 
    hc_xAxis(title = list(text = "Year"))
  return(hc)
}

#Adds drug series to base graph, returns highcharter graph
drug_addiction_graph <- function(d, hc, drug, color) {
  hc <- hc %>% 
    # hc_add_series(d, type = "spline", hcaes(x = time, y = V1), name = paste(drug), zIndex = 1, showInLegend = TRUE, id = paste(drug), color = paste(color)) %>% 
    hc_add_series(d, hcaes(x = time, low = low, high = high), type = "areasplinerange", name = paste("Under Reporting Range:", drug), color = paste(color), fillOpacity = 0.3, lineWidth = 0, zIndex = 0, showInLegend = TRUE)
  return(hc)
}

#Runs drug_addiction_graph for each drug specified
addiction_graph <- function(hc, drug, colors) {
  for(i in 1:length(drug)) {
    data <- abuse_count(drug[[i]])
    hc <- drug_addiction_graph(data, hc, drug[[i]], colors[i])
  }
  return(hc)
}

colors <- function(n) {
  qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
  col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))
  return(sample(col_vector, n))
}

# drug_addiction_graph_base(c[1])
# 
# d <- abuse_count("")
# 
# c <- colors(12)
# c[1]

# pie(rep(1,n), col=sample(col_vector, n))

