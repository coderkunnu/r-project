#install.packages("RSelenium")
#install.packages("rvest")
#install.packages("stringr")
library(rvest)
library(stringr)
library(RSelenium)
url <- "https://www.youtube.com/watch?v=kJQP7kiw5Fk"
driver<- rsDriver(browser=c("chrome"))
remDr <- driver[["client"]]
help(read_html)
page <- "rtestyt.html"
html <- read_html(page)
html
get_comments <- function(html){
  html %>%
  html_nodes("#content-text") %>%   
  html_text() %>%
  str_trim() %>%
  unlist()
}

comments <- get_comments(html)


