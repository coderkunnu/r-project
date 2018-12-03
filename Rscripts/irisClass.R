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

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
setwd('..')
getwd()

library(dplyr)
library(tidyr)

#Getting the data
df <- iris
#View(df)
str(df)

#Splitting the data into train and test
library(caTools)
set.seed(101)
sample = sample.split(df$Species, SplitRatio = 0.8)
df.train = subset(df, sample == TRUE)
df.test = subset(df, sample == FALSE)

#Exploring the data
dim(df.train)
str(df.train)
summary(df.train)
levels(df.train$Species)

#Basic Plots
hist(df.train$Sepal.Width)
plot(df.train$Petal.Length,df.train$Petal.Width)

#Box plot to observe distribution
par (mfrow=c(1,4))
for(i in 1:4) {
  boxplot(df.train[,i], main=names(df.train)[i])
}

#ggplot2
library(ggplot2)

g <- ggplot(data = df.train, aes(x = Petal.Length, y = Petal.Width))
print(g)

#line plot
g <- g +
  geom_point(aes(color = Species, shape = Species )) +
  xlab("Petal Length") +
  ylab("Petal Width") +
  ggtitle("Petal Length-Width") +
  geom_smooth(method = "lm")
print(g)

#Box plot
box <- ggplot(data = df.train, aes(x = Species, y = Sepal.Length)) +
  geom_boxplot(aes(fill=Species)) +
  ylab("Sepal Length") +
  ggtitle("Iris Boxplot") +
  stat_summary(fun.y = mean, geom = "point", shape = 5, size = 4)
print(box)

#ggthemes
library(ggthemes)

#Histogram
Histogram <- ggplot(data=df.train, aes(x = Sepal.Width)) +
  geom_histogram(binwidth = 0.2, color = "black", aes(fill=Species)) +
  xlab("Sepal.Width") +
  ylab("Frequency") +
  ggtitle("Histogram of Sepal Length") +
  theme_economist()
print(Histogram)

#Faceting
facet <- ggplot(data = df.train, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point(aes(shape = Species), size = 1.5) +
  geom_smooth(method="lm") +
  xlab("Sepal Length") +
  ylab("Sepal Width") +
  ggtitle("Faceting") +
  theme_fivethirtyeight() +
  facet_grid(. ~ Species)
print(facet)

# Decision tree classification
library(rpart)
library(caret)
model.rpart <- train(Species ~ ., data = df.train, method = "rpart", trControl = trainControl(method = "cv"))
print(model.rpart)
#plot(model.rpart$finalModel)
#text(model.rpart$finalModel)

#Better plot
#library(rpart.plot)
#rpart.plot(model.rpart$finalModel)
#text(model.rpart$finalModel)

#rattle may not work due to dependency issues
#library(RGtk2)
library(rattle)
fancyRpartPlot(model.rpart$finalModel)
text(model.rpart$finalModel)

#Predictionon training set
pred <- table(predict(object = model.rpart$finalModel, newdata = df.train[, 1:4], type = "class"))
pred

#Checking the accuracy of training data using a confusion matrix
confusionMatrix(predict(object = model.rpart$finalModel, newdata = df.train[, 1:4], type = "class"), df.train$Species)

#checking accuray of test data
pred_test <- predict(object = model.rpart$finalModel, newdata = df.test[, 1:4], type = "class")
confusionMatrix(pred_test, df.test$Species)

#random forest classification
set.seed(101)
model.rf <- train(Species ~., data = df.train, method = "rf", trControl = trainControl(method = "cv"))
print(model.rf)

#Checking the accuracy using a confusion matrix on training data
pred <- predict(object = model.rf$finalModel, newdata = df.train[, 1:4], type = "class")
pred
confusionMatrix(pred,df.train$Species)

#Checking the accuracy using a confusion matrix on test data
pred_test <- predict(object = model.rf$finalModel, newdata = df.test[, 1:4], type = "class")
pred_test
confusionMatrix(pred_test,df.test$Species)

#gradient boosting classification
set.seed(101)
model.gbm <- train(Species ~., data = df.train, method = "gbm", trControl = trainControl(method = "cv"))
print(model.gbm)
plot(model.gbm)
summary(model.gbm)
pred<-predict(object = model.gbm, newdata = df.train[,1:4])
confusionMatrix(pred,df.train$Species)

pred_test <- predict(object = model.gbm, newdata = df.test[,1:4])
confusionMatrix(pred_test, df.test$Species)

#xgboost classification
#library(xgboost)
#model.xgbm <- train(Species ~., data = df.train, method = "xgbTree", trControl = trainControl(method = "cv"))
#print(model.xgbm)
#plot(model.xgbm)

#clustering
set.seed(101)
irisCluster <- kmeans(df[, 1:4], centers = 3, nstart = 50)
irisCluster
help(kmeans)
#check classifiction accuracy
table(irisCluster$cluster, df$Species)

plot(df[c("Petal.Width", "Sepal.Length")], col = irisCluster$cluster)
points(irisCluster$centers[, c("Sepal.Length", "Sepal.Width")], col = 1:3, pch = 8, cex = 2)

# Linear Discriminant Analysis
library(caret)
library(MASS)
set.seed(101)
model.lda <- train(x = df.train[, 1:4], y = df.train[, 5], method = "lda", metric = "Accuracy")
print(model.lda)



#verify accuracy on training set
pred <- predict(object = model.lda, newdata = df.train[, 1:4])
confusionMatrix(pred, df.train$Species)

#summarizing the accuracy of the models
results <- resamples(list(TREE = model.rpart, RandomForest = model.rf, GBM = model.gbm, LDA = model.lda))
summary(results)