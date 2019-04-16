#install.packages("rvest")
#install.packages("stringr")
library(rvest)
library(stringr)

url <- "https://www.drugshortagescanada.ca/?short=50"

html <- read_html(url)

get_table_DSC <- function(html){
  html %>%
  html_nodes("#drug-shortage-reports tbody tr td") %>%   
  html_text() %>%
  str_trim() %>%
  unlist()
}

dest_table <- get_table_DSC(html)
dest_table

rows50columns7table<-matrix(comments,7,floor(length(comments)/7))
rows50columns7table
