# File: WeeklyBoxscoreScraper.R
# Description: downloads weekly boxscores for updating fantasy-football-database
# Date: 13 October 2016
# Author: Mark Eidsaune

library('RSelenium')
library('XML')

WeeklyScrape <- function(year, week, position) {
    df <- data.frame("Name" = character(0), "Tm" = character(0), "Week" = integer(0),
                     "PassCmp" = numeric(0), "PassAtt" = numeric(0), "PassYds" = numeric(0),
                     "PassTD" = numeric(0), "Int" = numeric(0), "RushAtt" = numeric(0),
                     "RushYds" = numeric(0), "RushTD" = numeric(0), "FPts" = numeric(0),
                     "FPts_G" = numeric(0), "Year" = integer(0))
    
    startServer()
    remDr <- remoteDriver(browserName = "chrome")
    remDr$open(silent = TRUE)
    
    baseUrl1 <- "http://www.fftoday.com/stats/playerstats.php?Season="
    baseUrl2 <- "&GameWeek=" 
    baseUrl3 <- "&PosID="
    baseUrl4 <- "&LeagueID=1"

############QB##########
    if (position == "QB" | position == "qb") {
        url <- paste(baseUrl1, year, baseUrl2, week, baseUrl3, "10", baseUrl4, sep = "")
        
        remDr$navigate(url)
            
        qb_stats <- readHTMLTable(url, stringsAsFactors = FALSE)[11]
        qb_stats <- qb_stats[[1]]
        
        names(qb_stats) <- c("Name", "Tm", "Week", "PassCmp", "PassAtt",
                             "PassYds", "PassTD", "Int", "RushAtt", "RushYds", "RushTD",
                             "FPts", "FPts_G")
        
        qb_stats <- qb_stats[-1,]
        qb_stats$Name <- str_replace_all(qb_stats$Name, "[^a-zA-Z\\s]", "")
        qb_stats$Name <- str_trim(qb_stats$Name)
        qb_stats$Week <- week
        qb_stats$Year <- year
        qb_stats$PassCmp <- as.numeric(qb_stats$PassCmp)
        qb_stats$PassAtt <- as.numeric(qb_stats$PassAtt)
        qb_stats$PassYds <- as.numeric(qb_stats$PassYds)
        qb_stats$PassTD <- as.numeric(qb_stats$PassTD)
        qb_stats$Int <- as.numeric(qb_stats$Int)
        qb_stats$RushAtt <- as.numeric(qb_stats$RushAtt)
        qb_stats$RushYds <- as.numeric(qb_stats$RushYds)
        qb_stats$RushTD <- as.numeric(qb_stats$RushTD)
        qb_stats$FPts <- as.numeric(qb_stats$FPts)
        qb_stats$FPts_G <- as.numeric(qb_stats$FPts_G)
        df <- rbind(df, qb_stats)
        
        nextPg <- try(remDr$findElement(using = "link text", "Next Page"), silent = TRUE)
        while (class(nextPg) != "try-error") {
            nextPg$clickElement()
            url <- nextPg$getCurrentUrl()
            url <- url[[1]]
            qb_stats <- readHTMLTable(url, stringsAsFactors = FALSE)[11]
            qb_stats <- qb_stats[[1]]
            
            names(qb_stats) <- c("Name", "Tm", "Week", "PassCmp", "PassAtt",
                                 "PassYds", "PassTD", "Int", "RushAtt", "RushYds", "RushTD",
                                 "FPts", "FPts_G")
            qb_stats <- qb_stats[-1,]
            qb_stats$Name <- str_replace_all(qb_stats$Name, "[^a-zA-Z\\s]", "")
            qb_stats$Name <- str_trim(qb_stats$Name)
            qb_stats$Week <- weeks[j]
            qb_stats$Year <- years[i]
            qb_stats$PassCmp <- as.numeric(qb_stats$PassCmp)
            qb_stats$PassAtt <- as.numeric(qb_stats$PassAtt)
            qb_stats$PassYds <- as.numeric(qb_stats$PassYds)
            qb_stats$PassTD <- as.numeric(qb_stats$PassTD)
            qb_stats$Int <- as.numeric(qb_stats$Int)
            qb_stats$RushAtt <- as.numeric(qb_stats$RushAtt)
            qb_stats$RushYds <- as.numeric(qb_stats$RushYds)
            qb_stats$RushTD <- as.numeric(qb_stats$RushTD)
            qb_stats$FPts <- as.numeric(qb_stats$FPts)
            qb_stats$FPts_G <- as.numeric(qb_stats$FPts_G)
            df <- rbind(df, qb_stats)
            
            nextPg <- try(remDr$findElement(using = "link text", "Next Page"))
        }
    }
##########RB##########
    else if (position == "RB" | position == "rb") {
        url <- paste(baseUrl1, year, baseUrl2, week, baseUrl3, "20", baseUrl4, sep = "")
        
        remDr$navigate(url)
        
        rb_stats <- readHTMLTable(url, stringsAsFactors = FALSE)[11]
        rb_stats <- rb_stats[[1]]
        
        names(rb_stats) <- c("Name", "Tm", "Week", "RushAtt", "RushYds",
                             "RushTD", "Target", "Rec", "RecYds", "RecTD",
                             "FPts", "FPts_G")
        
        rb_stats <- rb_stats[-1,]
        rb_stats$Name <- str_replace_all(rb_stats$Name, "[^a-zA-Z\\s]", "")
        rb_stats$Name <- str_trim(rb_stats$Name)
        rb_stats$Week <- week
        rb_stats$Year <- year
        rb_stats$RushAtt <- as.numeric(rb_stats$RushAtt)
        rb_stats$RushYds <- as.numeric(rb_stats$RushYds)
        rb_stats$RushTD <- as.numeric(rb_stats$RushTD)
        rb_stats$Target <- as.numeric(rb_stats$Target)
        rb_stats$Rec <- as.numeric(rb_stats$Rec)
        rb_stats$RecYds <- as.numeric(rb_stats$RecYds)
        rb_stats$RecTD <- as.numeric(rb_stats$RecTD)
        rb_stats$FPts <- as.numeric(rb_stats$FPts)
        rb_stats$FPts_G <- as.numeric(rb_stats$FPts_G)
        df <- rbind(df, rb_stats)
        
        nextPg <- try(remDr$findElement(using = "link text", "Next Page"), silent = TRUE)
        while (class(nextPg) != "try-error") {
            nextPg$clickElement()
            url <- nextPg$getCurrentUrl()
            url <- url[[1]]
            rb_stats <- readHTMLTable(url, stringsAsFactors = FALSE)[11]
            rb_stats <- rb_stats[[1]]
            
            names(rb_stats) <- c("Name", "Tm", "Week", "RushAtt", "RushYds",
                                 "RushTD", "Target", "Rec", "RecYds", "RecTD",
                                 "FPts", "FPts_G")
            rb_stats <- rb_stats[-1,]
            rb_stats$Name <- str_replace_all(rb_stats$Name, "[^a-zA-Z\\s]", "")
            rb_stats$Name <- str_trim(rb_stats$Name)
            rb_stats$Week <- week
            rb_stats$Year <- year
            rb_stats$RushAtt <- as.numeric(rb_stats$RushAtt)
            rb_stats$RushYds <- as.numeric(rb_stats$RushYds)
            rb_stats$RushTD <- as.numeric(rb_stats$RushTD)
            rb_stats$Target <- as.numeric(rb_stats$Target)
            rb_stats$Rec <- as.numeric(rb_stats$Rec)
            rb_stats$RecYds <- as.numeric(rb_stats$RecYds)
            rb_stats$RecTD <- as.numeric(rb_stats$RecTD)
            rb_stats$FPts <- as.numeric(rb_stats$FPts)
            rb_stats$FPts_G <- as.numeric(rb_stats$FPts_G)
            df <- rbind(df, rb_stats)
            
            nextPg <- try(remDr$findElement(using = "link text", "Next Page"))
        }
    } 
##########WR##########
    else if (position == "WR" | position == "wr") {
        url <- paste(baseUrl1, year, baseUrl2, week, baseUrl3, "30", baseUrl4, sep = "")
        
        remDr$navigate(url)
        
        wr_stats <- readHTMLTable(url, stringsAsFactors = FALSE)[11]
        wr_stats <- wr_stats[[1]]
        
        names(wr_stats) <- c("Name", "Tm", "Week", "Target", "Rec", "RecYds", "RecTD",
                             "RushAtt", "RushYds", "RushTD", "FPts", "FPts_G")
        
        wr_stats <- wr_stats[-1,]
        wr_stats$Name <- str_replace_all(wr_stats$Name, "[^a-zA-Z\\s]", "")
        wr_stats$Name <- str_trim(wr_stats$Name)
        wr_stats$Week <- week
        wr_stats$Year <- year
        wr_stats$Target <- as.numeric(wr_stats$Target)
        wr_stats$Rec <- as.numeric(wr_stats$Rec)
        wr_stats$RecYds <- as.numeric(wr_stats$RecYds)
        wr_stats$RecTD <- as.numeric(wr_stats$RecTD)
        wr_stats$RushAtt <- as.numeric(wr_stats$RushAtt)
        wr_stats$RushYds <- as.numeric(wr_stats$RushYds)
        wr_stats$RushTD <- as.numeric(wr_stats$RushTD)
        wr_stats$FPts <- as.numeric(wr_stats$FPts)
        wr_stats$FPts_G <- as.numeric(wr_stats$FPts_G)
        df <- rbind(df, wr_stats)
        
        nextPg <- try(remDr$findElement(using = "link text", "Next Page"), silent = TRUE)
        while (class(nextPg) != "try-error") {
            nextPg$clickElement()
            url <- nextPg$getCurrentUrl()
            url <- url[[1]]
            wr_stats <- readHTMLTable(url, stringsAsFactors = FALSE)[11]
            wr_stats <- wr_stats[[1]]
            
            names(wr_stats) <- c("Name", "Tm", "Week", "Target", "Rec", "RecYds", "RecTD",
                                 "RushAtt", "RushYds", "RushTD", "FPts", "FPts_G")
            wr_stats <- wr_stats[-1,]
            wr_stats$Name <- str_replace_all(wr_stats$Name, "[^a-zA-Z\\s]", "")
            wr_stats$Name <- str_trim(wr_stats$Name)
            wr_stats$Week <- week
            wr_stats$Year <- year
            wr_stats$Target <- as.numeric(wr_stats$Target)
            wr_stats$Rec <- as.numeric(wr_stats$Rec)
            wr_stats$RecYds <- as.numeric(wr_stats$RecYds)
            wr_stats$RecTD <- as.numeric(wr_stats$RecTD)
            wr_stats$RushAtt <- as.numeric(wr_stats$RushAtt)
            wr_stats$RushYds <- as.numeric(wr_stats$RushYds)
            wr_stats$RushTD <- as.numeric(wr_stats$RushTD)
            wr_stats$FPts <- as.numeric(wr_stats$FPts)
            wr_stats$FPts_G <- as.numeric(wr_stats$FPts_G)
            df <- rbind(df, wr_stats)
            
            nextPg <- try(remDr$findElement(using = "link text", "Next Page"))
        }
    } 
##########TE##########
    else if (position == "TE" | position == "te") {
        url <- paste(baseUrl1, year, baseUrl2, week, baseUrl3, "40", baseUrl4, sep = "")
        
        remDr$navigate(url)
        
        te_stats <- readHTMLTable(url, stringsAsFactors = FALSE)[11]
        te_stats <- te_stats[[1]]
        
        names(te_stats) <- c("Name", "Tm", "Week", "Target", "Rec", "RecYds", "RecTD",
                             "FPts", "FPts_G")
        
        te_stats <- te_stats[-1,]
        te_stats$Name <- str_replace_all(te_stats$Name, "[^a-zA-Z\\s]", "")
        te_stats$Name <- str_trim(te_stats$Name)
        te_stats$Week <- week
        te_stats$Year <- year
        te_stats$Target <- as.numeric(te_stats$Target)
        te_stats$Rec <- as.numeric(te_stats$Rec)
        te_stats$RecYds <- as.numeric(te_stats$RecYds)
        te_stats$RecTD <- as.numeric(te_stats$RecTD)
        te_stats$FPts <- as.numeric(te_stats$FPts)
        te_stats$FPts_G <- as.numeric(te_stats$FPts_G)
        df <- rbind(df, te_stats)
        
        nextPg <- try(remDr$findElement(using = "link text", "Next Page"), silent = TRUE)
        while (class(nextPg) != "try-error") {
            nextPg$clickElement()
            url <- nextPg$getCurrentUrl()
            url <- url[[1]]
            te_stats <- readHTMLTable(url, stringsAsFactors = FALSE)[11]
            te_stats <- te_stats[[1]]
            
            names(te_stats) <- c("Name", "Tm", "Week", "Target", "Rec", "RecYds", "RecTD",
                                 "FPts", "FPts_G")
            te_stats <- te_stats[-1,]
            te_stats$Name <- str_replace_all(te_stats$Name, "[^a-zA-Z\\s]", "")
            te_stats$Name <- str_trim(te_stats$Name)
            te_stats$Week <- week
            te_stats$Year <- year
            te_stats$Target <- as.numeric(te_stats$Target)
            te_stats$Rec <- as.numeric(te_stats$Rec)
            te_stats$RecYds <- as.numeric(te_stats$RecYds)
            te_stats$RecTD <- as.numeric(te_stats$RecTD)
            te_stats$FPts <- as.numeric(te_stats$FPts)
            te_stats$FPts_G <- as.numeric(te_stats$FPts_G)
            df <- rbind(df, te_stats)
            
            nextPg <- try(remDr$findElement(using = "link text", "Next Page"))
        }
    }
    write.csv(df, paste(position, "_", year, "_", week, ".csv"))
    return(df)
}

    