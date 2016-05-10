library("rvest")
library("XML")
library("data.table")
library("plyr")
library("dplyr")


weeklyPlayerStats <- data.table(Name = character(0), PlayerID = character(0), GameID = character(0))
urls <- read.csv("/Users/markeidsaune/Desktop/Fantasy-Football-Database/database/data/urls/combinedUrls.csv")
urls <- urls[,2]
urls <- as.character(urls)

for (i in 1:length(urls)) {
    repeat {
        html_page <- try(read_html(urls[i]), silent = TRUE)
        if (class(html_page) != "try-error") break
    }
    offense <- html_nodes(html_page, xpath = '//*[@id="skill_stats"]') %>%
        html_table()
    defense <- html_nodes(html_page, xpath = '//*[@id="def_stats"]') %>%
        html_table()
    returns <- html_nodes(html_page, xpath = '//*[@id="st_stats"]') %>%
        html_table()
    kicks <- html_nodes(html_page, xpath = '//*[@id="kick_stats"]') %>%
        html_table()
    
    # Format offensive table
    offense <- offense[[1]]
    if (length(offense) == 22) {
        colnames(offense) <- c("Name", "Tm", "PassCmp", "PassAtt", "PassYds", "PassTd",
                                       "Int", "SkTaken", "SkYds", "PassLng", "QbRating", 
                                       "RushAtt", "RushYds", "RushTD", "RushLng", "RecTgt",
                                       "Receptions", "RecYds", "RecTd", "RecLng", "Fmb", "FL")
    }
    else {
        colnames(offense) <- c("Name", "Tm", "PassCmp", "PassAtt", "PassYds", "PassTd",
                               "Int", "SkTaken", "SkYds", "PassLng", 
                               "RushAtt", "RushYds", "RushTD", "RushLng", "RecTgt",
                               "Receptions", "RecYds", "RecTd", "RecLng", "Fmb", "FL")
        offense$QbRating <- NA
    }
    delRowsOff <- which(offense$Name == "")
    offense <- offense[-delRowsOff,]
    offense$GameID <- urls[i]
    
    # Format defensive table
    if (length(defense) != 0) {
        defense <- defense[[1]]
        if (ncol(defense) == 13) {
            colnames(defense) <- c("Name", "Tm", "DefInt", "DefIntYds", "DefIntTd", "DefIntLng",
                                   "DefSk", "DefTkl", "DefAst", "DefFR", "DefFRYds", "DefFRTd",
                                   "DefFF")
        } else {
            colnames(defense) <- c("Name", "Tm", "DefInt", "DefIntYds", "DefIntTd", "DefIntLng",
                                   "DefSk", "DefTkl", "DefAst", "DefFR", "DefFRYds", "DefFRTd")
            defense$DefFF <- NA
        }
        
        delRowsD <- which(defense$Name == "")
        defense <- defense[-delRowsD,]
        defense$GameID <- urls[i]
    }
    else {
        defense <- data.frame("Name" = character(0), "Tm" = character(0), "DefInt" = integer(0), 
                              "DefIntYds" = integer(0), "DefIntTd" = integer(0), "DefIntLng" = integer(0),
                              "DefSk" = integer(0), "DefTkl" = integer(0), "DefAst" = integer(0), 
                              "DefFR" = integer(0), "DefFRYds" = integer(0), "DefFRTd" = integer(0))
    }
    
    # Format return table
    if (length(returns) != 0) {
        returns <- returns[[1]]
        colnames(returns) <- c("Name", "Tm", "KickRet", "KickRetYds", "KickYds/Ret", "KickRetTd", 
                               "KickRetLng", "PuntRet", "PuntRetYds", "PuntYds/Ret", 
                               "PuntRetTd", "PuntRetLng")
        delRowsRet <- which(returns$Name == "")
        returns <- returns[-delRowsRet,]
        returns$GameID <- urls[i]
    }
    else {
        returns <- data.frame("Name" = character(0), "Tm" = character(0), 
                              "KickRet" = integer(0), "KickRetYds" = integer(0), 
                              "KickYds/Ret" = integer(0), "KickRetTd" = integer(0), 
                              "KickRetLng" = integer(0), "PuntRet" = integer(0), 
                              "PuntRetYds" = integer(0), "PuntYds/Ret" = integer(0), 
                              "PuntRetTd" = integer(0), "PuntRetLng" = integer(0))
    }
   
    # Format kick table
    kicks <- kicks[[1]]
    kicks <- kicks[, c(1:6)]
    colnames(kicks) <- c("Name", "Tm", "XPMade", "XPAtt", "FGMade", "FGAtt")
    delRowsKicks <- which(kicks$Name == "")
    kicks <- kicks[-delRowsKicks,]
    kicks$GameID <- urls[i]
    
    # Join 4 tables w/ weeklyPlayerStats
    weeklyPlayerStats <- join(weeklyPlayerStats, offense, type = "full") %>%
        join(defense, type = "full") %>%
        join(returns, type = "full") %>%
        join(kicks, type = "full")
    
    message(urls[i])
    
}

# Format final table
weeklyPlayerStats[,5:ncol(weeklyPlayerStats)] <- sapply(weeklyPlayerStats[,5:ncol(weeklyPlayerStats)], as.numeric)
weeklyPlayerStats[is.na(weeklyPlayerStats)] <- 0


