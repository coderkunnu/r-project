#install.packages("vosonSML")
#devtools::install_github("voson-lab/SocialMediaLab/SocialMediaLab",ref="develop")
library(magrittr)
library(igraph)
library(vosonSML)
APIKey <- "AIzaSyDTK1Ymgoe6REsIf9qTQQ_E2_j5tBGeKOM" 
#Authorize <- AuthenticateWithYoutubeAPI(APIKey)
VideoID <- c("FoEnacgofzc")
#videoID_1 <- GetYoutubeVideoIDs(c("https://www.youtube.com/watch?v=kJQP7kiw5Fk")

#myData <- Authenticate("youtube", apiKey= APIKey) %>% Collect(videoIDs = VideoID) %>% Create("Actor")

youtubeData <- Authenticate("youtube", apiKey= APIKey) %>%
  Collect(videoIDs=VideoID,verbose=FALSE,writeToFile=FALSE)
head(youtubeData)


Video_Data <- as.data.frame(youtubeData)
#Video_Data <- as.data.frame(youtubeData$Comment)
write.csv(Video_Data,"Despacito first 100 comments with replies")
write.csv(youtubeData$Comment,"Desp_alt_2")
write.csv(youtubeData,"Desp_alt_full")
write.csv(Video_Data,"Desp_alt_full_df")

#myData_youtube <- Authenticate("youtube", apiKey= APIKey) %>%
  Collect(myData_youtube,videoIDs = videoID, writeToFile = FALSE,verbose = TRUE) %>% 
  Create("Comment")

#myutubedata<-Collect(videoIDs = VideoID, apiKeyYoutube = myutubeapikey, writeToFile = FALSE)
Video_Data <- as.data.frame(myutubedata)
Video_Data <- as.data.frame(myutubedata$Comment)


