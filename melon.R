#initialization
library(readr)
library(RJSONIO)
library(devtools)
library(ROAuth)
library(httr)
library(httpuv)
#install_github("tiagomendesdantas/Rspotify")
library(Rspotify)
library(assertthat)
library(bindr)
library(dplyr)
library(tidyr)
library(tidyverse)
library(caret)

#Fantano predictive model
df<-read_csv("C:/Users/denni/Downloads/Projects/Fantano/datasets_19292_37238_fantano_reviews.csv")
df$X1<-NULL

captions<- read_csv("C:/Users/denni/Downloads/Projects/Fantano/captions.csv")
captions$X1<-NULL

df$captions<-captions$caption
df$link<-captions$link
captions<-NULL

#datasets are now combined
#add to it using spotify api


#this next line gets you authenticated#
keys <- spotifyOAuth("LoveDaSystem","81cc700dd4b14417bffd6f4fb52ac8c0","a34ddd6bd44a464f92f6ada8007ad2ac")



#get rid of accented characters 
unwanted_array = list(    'S'='S', 's'='s', 'Z'='Z', 'z'='z', '�'='A', '�'='A', '�'='A', '�'='A', '�'='A', '�'='A', '�'='A', '�'='C', '�'='E', '�'='E',
                          '�'='E', '�'='E', '�'='I', '�'='I', '�'='I', '�'='I', '�'='N', '�'='O', '�'='O', '�'='O', '�'='O', '�'='O', '�'='O', '�'='U',
                          '�'='U', '�'='U', '�'='U', '�'='Y', '�'='B', '�'='Ss', '�'='a', '�'='a', '�'='a', '�'='a', '�'='a', '�'='a', '�'='a', '�'='c',
                          '�'='e', '�'='e', '�'='e', '�'='e', '�'='i', '�'='i', '�'='i', '�'='i', '�'='o', '�'='n', '�'='o', '�'='o', '�'='o', '�'='o',
                          '�'='o', '�'='o', '�'='u', '�'='u', '�'='u', '�'='y', '�'='y', '�'='b', '�'='y' )
for (i in 1:nrow(df)){
  df$artist[i] <- iconv(df$artist[i], to='ASCII//TRANSLIT')
}

df<-df[-20,]
df<-df[-38,]
df<-df[-44,]
df<-df[-54,]
df<-df[-199,]
df<-df[-295,]
df<-df[-455,]
df<-df[-525,]
df<-df[-530,]
df<-df[-554,]
df<-df[-616,]
df<-df[-637,]

df$genre=""
#kept changing loop guard until completion
for (j in 1693:nrow(df)){
  artist<-searchArtist(df[j,"artist"],keys)
  df[j,"genre"]<- artist[1,"genres"]
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

set.seed(1234)
index  <- createDataPartition(df$score, p=.7, list=T)
train   <- df[index,]
test    <- df[-index,]



