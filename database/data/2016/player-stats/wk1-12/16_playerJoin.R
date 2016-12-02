# File: 16_playerJoin.R
# Description: combines multiple player csv's into one
# Date: 1 December 2016
# Author: Mark Eidsaune

library("RCurl")
library("plyr")
library("dplyr")

durl <- "https://raw.githubusercontent.com/edavis25/Fantasy-Football-Database/master/database/data/2016/player-stats/wk1-12/11-29-2016-defense.csv"
defense <- read.csv(text = getURL(durl))
names(defense) <- c("Name", "Tm", "DefInt","DefIntYds", "DefIntTd", "DefIntLng",
                    "DefSk", "DefTkl", "DefAst", "DefFR", "DefFRYrds", "DefFRTd",
                    "DefFF", "URL")

kurl <- "https://raw.githubusercontent.com/edavis25/Fantasy-Football-Database/master/database/data/2016/player-stats/wk1-12/11-29-2016-kicking.csv"
kicks <- read.csv(text = getURL(kurl))
# Remove punting stats
kicks <- kicks[, c(1,2,3,4,5,6,11)]
names(kicks) <- c("Name", "Tm", "XPMade", "XPAtt", "FGMade", "FGAtt", "URL")

ourl <- "https://raw.githubusercontent.com/edavis25/Fantasy-Football-Database/master/database/data/2016/player-stats/wk1-12/11-29-2016-offense.csv"
offense <- read.csv(text = getURL(ourl))
names(offense) <- c("Name", "Tm", "PassCmp", "PassAtt", "PassYds", "PassTD", 
                    "Interceptions", "SkTaken", "SkYds", "PassLng", "QbRating", "RushAtt", 
                    "RushYds", "RushTd", "RushLng", "RecTgt", "Receptions", "RecYds", 
                    "RecTd", "RecLng", "Fmb", "FL", "URL")

rurl <- "https://raw.githubusercontent.com/edavis25/Fantasy-Football-Database/master/database/data/2016/player-stats/wk1-12/11-29-2016-returns.csv"
returns <- read.csv(text = getURL(rurl))
names(returns) <- c("Name", "Tm", "KickRet", "KickRetYds", "KickYdsRet", "KickRetTD",
                    "KickRetLng", "PuntRet", "PuntRetYds","PuntYdsReturn", "PuntRetTd", "PuntRetLng", 
                    "URL")

allStats <- rbind.fill(defense, kicks, offense, returns)
allStats[is.na(allStats)] <- 0
allStats <- allStats %>% select(Name, URL, PassCmp, PassAtt, PassYds, PassTD,
                                Interceptions, SkTaken, SkYds, PassLng, QbRating,
                                RushAtt, RushYds, RushTd, RushLng, RecTgt, Receptions,
                                RecYds, RecTd, RecLng, Fmb, FL, DefInt, DefInt, DefIntYds,
                                DefIntTd, DefIntLng, DefSk, DefTkl, DefAst, DefFR, DefFRYrds,
                                DefFRTd, DefFF, KickRet, KickRetYds, KickYdsRet, KickRetTD,
                                KickRetLng, PuntRet, PuntRetYds, PuntYdsReturn, PuntRetTd,
                                PuntRetLng, XPMade, XPAtt, FGMade, FGAtt)
