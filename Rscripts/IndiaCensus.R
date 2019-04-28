setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
setwd('..')
getwd()

all <- read.csv("Data/all-census-data/all.csv")
head(all,10)
is.data.frame(all)
summary(all)
nrow(all)
ncol(all)
str(all)
summary(all$State)
str(all$State)

#Sex Ratio
#df <- all[, c("State","District","Growth..1991...2001.","Sex.ratio..females.per.1000.males.")]
#df <- df[order(df$Sex.ratio..females.per.1000.males.,decreasing = TRUE) ,]
#df <- df[df$Sex.ratio..females.per.1000.males. > 1000,]
#df <- df[df$State == "Maharashtra",]

#Literacy Rate 
df <- all[, c("State","District","Persons..literacy.rate","Males..Literatacy.Rate","Females..Literacy.Rate","Sex.ratio..females.per.1000.males.")]
df <- df[order(df$Persons..literacy.rate,decreasing = TRUE), ]
df <- df[df$State == "CG",]
df