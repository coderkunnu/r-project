#install.packages("rvest")
#install.packages("stringr")
library(rvest)
library(stringr)

url <- "https://www.trustpilot.com/review/www.amazon.com"

html <- read_html(url)

get_comments <- function(html){
  html %>%
  html_nodes(".review-content__text") %>%   
  html_text() %>%
  str_trim() %>%
  unlist()
}

comments <- get_comments(html)
comments
write.csv(comments, file = "Amazon comments.csv")