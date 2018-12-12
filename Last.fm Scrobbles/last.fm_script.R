library(readr)
library(tidyverse)
library(ggplot2)
library(lubridate)
library(readxl)
library(urltools)
library(jsonlite)
library(memoise)

# Load df
last_fm_plays <- read_csv("~/Work/Last.fm Scrobbles/last.fm plays.csv", 
                          col_names = c("Artist", "Album", "Song", "Date"), skip = 1)

last_fm_plays$Date <- dmy_hm(last_fm_plays$Date, tz="Australia/Melbourne",
                             locale=Sys.getlocale("LC_TIME"))

last_fm_plays <- select(last_fm_plays, Date, Song, Artist, Album)

api <- "19fcc9dfc1aaeba4688dbce850ab5113"

build_artist_toptags_query <- function(artist, api_key, base = "http://ws.audioscrobbler.com/2.0/") {
  base <- param_set(base, "method", "artist.gettoptags")
  base <- param_set(base, "artist", URLencode(artist))
  base <- param_set(base, "api_key", api)
  base <- param_set(base, "format", "json")
  
  return(base)
}

fetch_artist_toptags <- function(artist) {

  json <- fromJSON(build_artist_toptags_query(artist))
  
  if (length(json$toptags$tag) == 0) return(NA)
  
  return(c(as.vector(json$toptags$tag[,"name"])))
}

Tags1 <- function(data, artist){
                          for (i in 1:length(data$Artist))
                            fetch_artist_toptags(data$Artist)[1]
    }

last_fm_plays$Tag1 <- Tags1(last_fm_plays, Artist)

Tags2 <- function(data, artist){
  for (i in 1:length(data$Artist))
    fetch_artist_toptags(data$Artist)[2]
}

last_fm_plays$Tag2 <- Tags2(last_fm_plays, Artist)

Tags3 <- function(data, artist){
  for (i in 1:length(data$Artist))
    fetch_artist_toptags(data$Artist)[3]
}

last_fm_plays$Tag3 <- Tags3(last_fm_plays, Artist)

Tags4 <- function(data, artist){
  for (i in 1:length(data$Artist))
    fetch_artist_toptags(data$Artist)[4]
}

last_fm_plays$Tag4 <- Tags4(last_fm_plays, Artist)

Tags5 <- function(data, artist){
  for (i in 1:length(data$Artist))
    fetch_artist_toptags(data$Artist)[5]
}

last_fm_plays$Tag5 <- Tags5(last_fm_plays, Artist)

library(beepr)
beep(2)