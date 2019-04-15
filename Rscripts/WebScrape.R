#install.packages("rvest")
#install.packages("stringr")
library(rvest)
library(stringr)

url <- "https://www.youtube.com/watch?v=kJQP7kiw5Fk"

html <- read_html(url)

get_comments <- function(html){
  html %>%
  html_nodes(".yt-formatted-string") %>%   
  html_text() %>%
  str_trim() %>%
  unlist()
}

comments <- get_comments(html)
comments