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
unwanted_array = list(    'S'='S', 's'='s', 'Z'='Z', 'z'='z', 'À'='A', 'Á'='A', 'Â'='A', 'Ã'='A', 'Ä'='A', 'Å'='A', 'Æ'='A', 'Ç'='C', 'È'='E', 'É'='E',
                          'Ê'='E', 'Ë'='E', 'Ì'='I', 'Í'='I', 'Î'='I', 'Ï'='I', 'Ñ'='N', 'Ò'='O', 'Ó'='O', 'Ô'='O', 'Õ'='O', 'Ö'='O', 'Ø'='O', 'Ù'='U',
                          'Ú'='U', 'Û'='U', 'Ü'='U', 'Ý'='Y', 'Þ'='B', 'ß'='Ss', 'à'='a', 'á'='a', 'â'='a', 'ã'='a', 'ä'='a', 'å'='a', 'æ'='a', 'ç'='c',
                          'è'='e', 'é'='e', 'ê'='e', 'ë'='e', 'ì'='i', 'í'='i', 'î'='i', 'ï'='i', 'ð'='o', 'ñ'='n', 'ò'='o', 'ó'='o', 'ô'='o', 'õ'='o',
                          'ö'='o', 'ø'='o', 'ù'='u', 'ú'='u', 'û'='u', 'ý'='y', 'ý'='y', 'þ'='b', 'ÿ'='y' )
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



