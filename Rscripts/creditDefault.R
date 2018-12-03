# install.packages("dplyr")
# install.packages("tidyr")
# install.packages("caTools")
# install.packages("ggplot2")
# install.packages("ggthemes")
# install.packages("caret")
# install.packages("e1071", dependencies = TRUE)
# install.packages("rpart.plot")
# install.packages("rattle", dependencies = T)
# install.packages("RGtk2", depen=T)
# install.packages("xgboost")
# install.packages("MASS")
# install.packages("cluster")
# install.packages("fpc")
# install.packages("clustMisType")

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

# library(caTools)
# set.seed(101)
# sample <- sample.split(df$default, SplitRatio = 0.75)
# df.train <- subset(df, sample == TRUE)
# df.test <- subset(df, sample == FALSE)

is.data.frame(df)
df
any(is.na(df))
str (df)
summary(df)

set.seed(101)
credit <- kmeans(df[c("dependents","amount")], centers = 2)
credit

plot(df[c("dependents","amount")], col = credit$cluster)
points(credit$centers[, c("dependents","amount")], col = 1:21, pch = 8, cex = 2)

library(cluster)
help(plotcluster)
