setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
setwd('..')

source("Rscripts/webScrape.R")

# install.packages("rvest")
# install.packages("stringr")
library(rvest)
library(stringr)

#SCRIPT VARIABLES

# Provide URL -
baseurl <- "https://www.drugshortagescanada.ca"

mainurl <- "https://www.drugshortagescanada.ca/?disc=20&short=50"

drugShortageReports <- extractTableData(mainurl,"drug-shortage-reports")
# drugDiscontinuanceReports <- extractTableData(mainurl,"drug-discontinuance-reports")
links <- extractLinksFromTable(mainurl,"drug-shortage-reports")

reportData <- extractDataFromLinks(baseurl,links[,3])

df <- merge(reportData,drugShortageReports,by.x = c("Report ID","Brand name","Company Name"),by.y = c("View Report","Brand name","Company Name"))
str(drugShortageReports)
str(reportData)
str(df)
write.csv(df,file="Output/DrugShortageReports.csv", row.names = FALSE)

