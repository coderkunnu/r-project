setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
setwd('..')
getwd()

library(dplyr)
library(tidyr)
library(ggplot2)
library(MASS)

df <- read.csv("Data/bank-loan-status-dataset/credit_train.csv")
str(df)

df_new <- df[df$Credit.Score < 1000,]
df_new <- df_new[!is.na(df_new$Monthly.Debt),]
df_new <- df_new[!is.na(df_new$Credit.Score),]
df_new
a <- ggplot(df_new, aes(x = Credit.Score)) + geom_histogram(stat = "count")
plot(a)

b <- ggplot(df_new, aes(x = Monthly.Debt)) + geom_histogram(stat = "count")
plot(b)

str(df_new)
set.seed(101)
creditCluster <- kmeans(df_new[c("Annual.Income","Current.Loan.Amount","Monthly.Debt","Current.Credit.Balance")], centers = 2)
creditCluster
plot(df_new[c("Annual.Income","Current.Loan.Amount")], col = creditCluster$cluster)

library(cluster)
library(fpc)
plotcluster(df_new[c("Annual.Income","Current.Loan.Amount","Monthly.Debt","Current.Credit.Balance")],creditCluster$cluster)
points(creditCluster$centers,col=1:8,pch=16)

any(is.na(df_new$Credit.Score))
help(cluster)
help(fpc)
