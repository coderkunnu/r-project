# install.packages("rvest")
# install.packages("stringr")
library(rvest)
library(stringr)

#SCRIPT VARIABLES

# Provide URL -
url <- "https://www.drugshortagescanada.ca/?short=50"

# Provide Table ID -
tableID <- "drug-shortage-reports"

# Provide output Filename -
outputFileName<- "drug-shortage.csv"

html <- read_html(url)
cssSelectorHead <- paste("#",tableID," thead tr th", sep = "")
cssSelectorBody <- paste("#",tableID," tbody tr td", sep = "")

getTableHeader <- function(html){
  html %>%
    html_nodes(cssSelectorHead) %>%   
    html_text() %>%
    str_trim() %>%
    unlist()
}

getTableData <- function(html){
  html %>%
  html_nodes(cssSelectorBody) %>%   
  html_text() %>%
  str_trim() %>%
  unlist()
}

tableHeader <- getTableHeader(html)
colCount <- length(tableHeader)

tableData <- getTableData(html)
rowCount <- length(tableData)/colCount
rowCount

dataTable <- data.frame(matrix(ncol = colCount, nrow= rowCount))
colnames(dataTable) <- tableHeader

for(n in 1:colCount) {
  dataTable[,n] <- tableData[seq(n,length(tableData),colCount)]
}

write.csv(dataTable,file=outputFileName, row.names = FALSE)