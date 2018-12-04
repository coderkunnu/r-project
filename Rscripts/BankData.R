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

# missingness map
missmap(df)

# We found 3 columns with missing values and we will handle them one by one - 
# Months.since.last.delinquent
# Annual.Income
# Credit.Score

# Months.since.last.delinquent -- replace with max value of that column
df[is.na(df$Months.since.last.delinquent),]$Months.since.last.delinquent <- max(df[!is.na(df$Months.since.last.delinquent),]$Months.since.last.delinquent)
any(is.na(df$Months.since.last.delinquent))

# Annual.Income -- replace by grouped mean
df_tmp <- df[!is.na(df$Annual.Income),]
any(is.na(df_tmp$Annual.Income))
g1 <- aggregate(df_tmp$Annual.Income, FUN=mean, by=list(Purpose=df_tmp$Purpose))

# Credit.Score -- divide greater than 1000 by 10 and replace NA values with mean
df[df$Credit.Score > 1000 & !is.na(df$Credit.Score),]$Credit.Score <- (df[df$Credit.Score > 1000 & !is.na(df$Credit.Score),]$Credit.Score)/10
df[is.na(df$Credit.Score),]$Credit.Score <- round(mean(df[!is.na(df$Credit.Score),]$Credit.Score))
any(df$Credit.Score > 1000 | is.na(df$Credit.Score))

