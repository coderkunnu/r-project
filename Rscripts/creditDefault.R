setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
setwd('..')
getwd
library(dplyr)
library(tidyr)
df <- read.csv("Data/credit-default.csv")
head(df)
#View(df)
str(df)
unique(df$existing_credits)
df$default <- as.factor(df$default)
str(df)

# train test split

library(caTools)
set.seed(101)
sample <- sample.split(df$default, SplitRatio = 0.75)
df.train <- subset(df, sample == TRUE)
df.test <- subset(df, sample == FALSE)