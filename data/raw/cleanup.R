URL <- "https://data.cms.gov/api/views/qywy-pajd/rows.csv?accessType=DOWNLOAD"
data <- download.file(URL, destfile="data.csv", method="curl", cacheOK=FALSE)

opioid_data <- select(data, npi, contains("opioid")) %>% filter(complete.cases(.))
opioid_data_no_zero <- filter(opioid_data, opioid_drug_cost != 0)

write.csv(opioid_data_no_zero, file="opioid_data.csv")


install.packages("data.table")


