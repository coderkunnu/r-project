library(readxl)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
setwd('..')
getwd()

df.input <- read_xlsx("Data/Test2_Inputfile.xlsx")
head(df.input)

names <-  colnames(df.input)
names
x.func <- function(x){ sub(".*\\[(.*)\\].*", "\\1", x, perl=TRUE)}
names.unique <- x.func(names)
names.unique <- unique(names.unique)
str(names.unique)
x.func2 <- function(x){ sub('\\[.*','', x)}
ques.unique <- x.func2(names)
ques.unique <- unique(ques.unique)
str(ques.unique)
names.unique <- names.unique[2:241]
str(names.unique)
ques.unique <- ques.unique[2:16]
str(ques.unique)
ques.unique
df <- data.frame(matrix(ncol = 16, nrow = 240))
colnames(df) <- c("Names", c(ques.unique))
df$Names <- names.unique
str(df)