#install.packages("rvest")
#install.packages("stringr")
library(rvest)
library(stringr)

url <- "https://www.drugshortagescanada.ca/?short=50"

html <- read_html(url)

get_comments <- function(html){
  html %>%
  html_nodes("#drug-shortage-reports tbody tr td") %>%   
  html_text() %>%
  str_trim() %>%
  unlist()
}

comments <- get_comments(html)
comments






count = 1
col1 <- sapply(comments, function(i) {
  if (mod(count,7) == 1){
    print(i)
  }
  count = count + 1
})


length(new_vector)
head(new_vector)
class(new_vector)


table <- breakArray(comment)
print(tab)
