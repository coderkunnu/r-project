# Uncomment these are run if package not present
# install.packages("plyr")
# install.packages("dplyr")
# install.packages("tidyr")
# install.packages("caTools")
# install.packages("Amelia")

# Setting relative path for data files (CAN IGNORE)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
setwd('..')

# importing the required libraries
library(plyr)
library(dplyr)
library(tidyr)
library(caTools)
library(Amelia)

## GETTIING AND ANALYSING DATA

# this is how we get csv data and save into data frame
df <- read.csv("WorkSpace/Data/titanic/train.csv")

summary(df) # summary of data
str(df) # structure of data


missmap(df) # Graphical representation of NA values

df2 <- na.omit(df) # removing the rows with NA values and saving into df2

aggregate(df2$Age, FUN=mean, by=list(Pclass=df2$Pclass, Sex=df2$Sex), sort=df$Pclass) # Finding grouped mean with remaining data

# replacing NA values with there respective mean of their group in which they lie
df[df$Pclass==1 & df$Sex=='female' & is.na(df$Age),]$Age <- 34
df[df$Pclass==2 & df$Sex=='female' & is.na(df$Age),]$Age <- 28
df[df$Pclass==3 & df$Sex=='female' & is.na(df$Age),]$Age <- 21
df[df$Pclass==1 & df$Sex=='male' & is.na(df$Age),]$Age <- 41
df[df$Pclass==2 & df$Sex=='male' & is.na(df$Age),]$Age <- 30
df[df$Pclass==3 & df$Sex=='male' & is.na(df$Age),]$Age <- 26

any(is.na(df)) # check if there is any NA value in data frame
missmap(df) # graphical representation of na values

## BUILDING MODEL

# splitting the data into test and train
set.seed(101)
sample <- sample.split(df$Name,SplitRatio = 0.8)
df.train <- subset(df, sample==TRUE)
df.test <- subset(df, sample==FALSE)
df.train # train data
df.test # test data

# Model
glm.fit <- glm(Survived~Age+Sex+Pclass+SibSp, data = df.train, family = binomial)
summary(glm.fit)
df.test$survived_prob <- predict(glm.fit, df.test[,c("Age","Sex","Pclass","SibSp")], type="response")
str(df.test$survived_prob)
df.test$pred <- ifelse(df.test$survived_prob > 0.6, 1, 0)
table(df.test$pred, df.test$Survived)
count(df.test)
