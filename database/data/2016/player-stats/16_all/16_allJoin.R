# File: 16_allJoin.R
# Description: row bind 2016 player data
# Date: 6 January 2017
# Author: Mark Eidsaune

library("RCurl")
library("plyr")
library("dplyr")

x <- read.csv(text = getURL("https://raw.githubusercontent.com/edavis25/Fantasy-Football-Database/master/database/data/2016/player-stats/wk1-12/16data.csv"))
y <- read.csv(text = getURL("https://raw.githubusercontent.com/edavis25/Fantasy-Football-Database/master/database/data/2016/player-stats/wk13-16/16_wk13-16_data.csv"))

all <- rbind(x, y)