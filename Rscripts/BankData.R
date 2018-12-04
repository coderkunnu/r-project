setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
setwd('..')
getwd()

library(dplyr)
library(tidyr)
library(ggplot2)
library(MASS)
library(caTools)
library(Amelia)

# import file from drive
df <- read.csv("Data/bank-loan-status-dataset/credit_train.csv")
str(df)

#list missing rows
df[!complete.cases(df),]
count(df[!complete.cases(df),])

# missingness map
## missmap(df)

# We found columns with missing values and we will handle them one by one - 
# Months.since.last.delinquent
# Annual.Income
# Credit.Score
# Bankruptcies
# Months.since.last.delinquent -- replace with max value of that column
df[is.na(df$Months.since.last.delinquent),]$Months.since.last.delinquent <- max(df[!is.na(df$Months.since.last.delinquent),]$Months.since.last.delinquent)
any(is.na(df$Months.since.last.delinquent))

# Annual.Income -- replace by grouped mean
df_tmp <- df[!is.na(df$Annual.Income),]
any(is.na(df_tmp$Annual.Income))
aggregate(df_tmp$Annual.Income, FUN=mean, by=list(Home.Ownership=df_tmp$Home.Ownership))
df[df$Home.Ownership == "HaveMortgage" & is.na(df$Annual.Income),]$Annual.Income <- 1402620
df[df$Home.Ownership == "Home Mortgage" & is.na(df$Annual.Income),]$Annual.Income <- 1575728
df[df$Home.Ownership == "Own Home" & is.na(df$Annual.Income),]$Annual.Income <- 1241610
df[df$Home.Ownership == "Rent" & is.na(df$Annual.Income),]$Annual.Income <- 1181737

# Credit.Score -- divide greater than 1000 by 10 and replace NA values with mean
df[df$Credit.Score > 1000 & !is.na(df$Credit.Score),]$Credit.Score <- (df[df$Credit.Score > 1000 & !is.na(df$Credit.Score),]$Credit.Score)/10
df[is.na(df$Credit.Score),]$Credit.Score <- round(mean(df[!is.na(df$Credit.Score),]$Credit.Score))
any(df$Credit.Score > 1000 | is.na(df$Credit.Score))

# Backrupcies -- replace NA with 0
df[is.na(df$Bankruptcies),]$Bankruptcies <- 0

# remove all other rows with unnecessary values
df <- df[complete.cases(df),]
any(is.na(df))
count(df)
str(df)
boxplot(df)
plot(df[,c(3)])

# selecting only integer and numeric columns
df_num <- df[,c(4,6,7,11,12,13,14,16,17)]
df_num <- lapply(df_num,as.numeric)
str(df_num)
boxplot(df_num)
boxplot(df_num[,c(2)])
plot(df_num[,c(10)])
