# install.packages("rvest")
# install.packages("stringr")
# install.packages("dplyr")
library(rvest)
library(stringr)
library(dplyr)

getElementText <- function(html,cssSelector){
  html %>%
    html_nodes(cssSelector) %>%   
    html_text() %>%
    str_trim() %>%
    unlist()
}

getElementAttr <- function(html,cssSelector,Attr){
  html %>%
    html_nodes(cssSelector) %>%   
    html_attr(Attr) %>%
    str_trim() %>%
    unlist()
}

getReportTable <- function(html) {
  html %>%
    html_nodes("table") %>%
    .[[1]] %>%
    html_table()
}

extractTableData <- function(url,tableID){
  html <- read_html(url)
  
  cssSelectorHead <- paste("#",tableID," thead tr th", sep = "")
  cssSelectorBody <- paste("#",tableID," tbody tr td", sep = "")
  
  tableHeader <- getElementText(html,cssSelectorHead)
  colCount <- length(tableHeader)
  
  tableData <- getElementText(html,cssSelectorBody)
  rowCount <- length(tableData)/colCount
  rowCount
  
  dataTable <- data.frame(matrix(ncol = colCount, nrow= rowCount))
  colnames(dataTable) <- tableHeader
  
  for(n in 1:colCount) {
    dataTable[,n] <- tableData[seq(n,length(tableData),colCount)]
  }
  
  # outputFileName <- paste("Output/",tableID,".csv",sep = "")
  # write.csv(dataTable,file=outputFileName, row.names = FALSE)
  return(dataTable)
}

extractLinksFromTable <- function(url,tableID) {
  html <- read_html(url)
  
  cssSelectorLinks <- paste("#",tableID," tbody tr td a", sep = "")
  tableLinks <- getElementAttr(html, cssSelectorLinks, "href")
  rowCount <- length(tableLinks)/3
  
  dataTable <- data.frame(matrix(ncol = 3, nrow= rowCount))
  for(n in 1:3) {
    dataTable[,n] <- tableLinks[seq(n,length(tableLinks),3)]
  }
  return(dataTable)
}


extractDataFromLinks <- function(url,links) {
  newUrl <- paste(url,links[1],sep="")
  newUrl
  html <- read_html(newUrl)
  
  reportTable <- getReportTable(html)
  
  reportDF <- data.frame(matrix(ncol = length(reportTable[,1])))
  colnames(reportDF) <- reportTable[,1]
  
  for (n in 1:length(links)) {
    tempurl <- paste(url,links[n],sep = "")
    html <- read_html(tempurl)
    temptable <- getReportTable(html)
    tempDF <- data.frame(matrix(ncol = length(temptable[,1])))
    colnames(tempDF) <- temptable[,1]
    tempDF[1,] <- temptable[,2]
    reportDF <- bind_rows(reportDF,tempDF)
  }
  reportDF <- reportDF[-1,]
  return(reportDF)
}