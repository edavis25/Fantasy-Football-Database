library('XML')
library('rvest')
library('stringr')
library('RSelenium')

baseUrl <- "http://fftoday.com/stats/playerstats.php?Season="
years <- 2005:2005
weeks <- c(1:1)

startServer()
remDr <- remoteDriver(browserName = "chrome")
remDr$open(silent = TRUE)

################
## Quarterbacks
################

qb <- data.frame("Name" = character(0), "Tm" = character(0), "Week" = integer(0),
                 "PassCmp" = numeric(0), "PassAtt" = numeric(0), "PassYds" = numeric(0),
                 "PassTD" = numeric(0), "Int" = numeric(0), "RushAtt" = numeric(0),
                 "RushYds" = numeric(0), "RushTD" = numeric(0), "FPts" = numeric(0),
                 "FPts_G" = numeric(0), "Year" = integer(0))

for (i in 1:length(years)) {
    urlYear <- paste(baseUrl, years[i], sep = "")
    for (j in 1:length(weeks)) {
        url <-paste(urlYear, "&GameWeek=", weeks[j], "&PosID=10&LeagueID=1", sep = "")
        QB_stats <- readHTMLTable(url, stringsAsFactors = FALSE)[11]
        QB_stats <- QB_stats[[1]]
        
        names(QB_stats) <- c("Name", "Tm", "Week", "PassCmp", "PassAtt",
                             "PassYds", "PassTD", "Int", "RushAtt", "RushYds", "RushTD",
                             "FPts", "FPts_G")
        QB_stats <- QB_stats[-1,]
        QB_stats$Name <- str_replace_all(QB_stats$Name, "[^a-zA-Z\\s]", "")
        QB_stats$Name <- str_trim(QB_stats$Name)
        QB_stats$Week <- weeks[j]
        QB_stats$Year <- years[i]
        QB_stats$PassCmp <- as.numeric(QB_stats$PassCmp)
        QB_stats$PassAtt <- as.numeric(QB_stats$PassAtt)
        QB_stats$PassYds <- as.numeric(QB_stats$PassYds)
        QB_stats$PassTD <- as.numeric(QB_stats$PassTD)
        QB_stats$Int <- as.numeric(QB_stats$Int)
        QB_stats$RushAtt <- as.numeric(QB_stats$RushAtt)
        QB_stats$RushYds <- as.numeric(QB_stats$RushYds)
        QB_stats$RushTD <- as.numeric(QB_stats$RushTD)
        QB_stats$FPts <- as.numeric(QB_stats$FPts)
        QB_stats$FPts_G <- as.numeric(QB_stats$FPts_G)
        qb <- rbind(qb, QB_stats)
        
        remDr$navigate(url)
        nextPg <- try(remDr$findElement(using = "link text", "Next Page"), silent = TRUE)
        while (class(nextPg) != "try-error") {
            nextPg$clickElement()
            url <- nextPg$getCurrentUrl()
            url <- url[[1]]
            QB_stats <- readHTMLTable(url, stringsAsFactors = FALSE)[11]
            QB_stats <- QB_stats[[1]]
            
            names(QB_stats) <- c("Name", "Tm", "Week", "PassCmp", "PassAtt",
                                 "PassYds", "PassTD", "Int", "RushAtt", "RushYds", "RushTD",
                                 "FPts", "FPts_G")
            QB_stats <- QB_stats[-1,]
            QB_stats$Name <- str_replace_all(QB_stats$Name, "[^a-zA-Z\\s]", "")
            QB_stats$Name <- str_trim(QB_stats$Name)
            QB_stats$Week <- weeks[j]
            QB_stats$Year <- years[i]
            QB_stats$PassCmp <- as.numeric(QB_stats$PassCmp)
            QB_stats$PassAtt <- as.numeric(QB_stats$PassAtt)
            QB_stats$PassYds <- as.numeric(QB_stats$PassYds)
            QB_stats$PassTD <- as.numeric(QB_stats$PassTD)
            QB_stats$Int <- as.numeric(QB_stats$Int)
            QB_stats$RushAtt <- as.numeric(QB_stats$RushAtt)
            QB_stats$RushYds <- as.numeric(QB_stats$RushYds)
            QB_stats$RushTD <- as.numeric(QB_stats$RushTD)
            QB_stats$FPts <- as.numeric(QB_stats$FPts)
            QB_stats$FPts_G <- as.numeric(QB_stats$FPts_G)
            qb <- rbind(qb, QB_stats)
            
            nextPg <- try(remDr$findElement(using = "link text", "Next Page"))
        }
    }
}

#################
## Running Backs
#################

rb <- data.frame("Name" = character(0), "Tm" = character(0), "Week" = integer(0),
                 "RushAtt" = numeric(0), "RushYds" = numeric(0), "RushTD" = numeric(0),
                 "Target" = numeric(0), "Rec" = numeric(0), "RecYds" = numeric(0),
                 "RecTD" = numeric(0), "FPts" = numeric(0), "FPts_G" = numeric(0), 
                 "Year" = integer(0))

for (i in 1:length(years)) {
    urlYear <- paste(baseUrl, years[i], sep = "")
    for (j in 1:length(weeks)) {
        url <-paste(urlYear, "&GameWeek=", weeks[j], "&PosID=20&LeagueID=1", sep = "")
        RB_stats <- readHTMLTable(url, stringsAsFactors = FALSE)[11]
        RB_stats <- RB_stats[[1]]
        
        names(RB_stats) <- c("Name", "Tm", "Week", "RushAtt", "RushYds",
                             "RushTD", "Target", "Rec", "RecYds", "RecTD",
                             "FPts", "FPts_G")
        RB_stats <- RB_stats[-1,]
        RB_stats$Name <- str_replace_all(RB_stats$Name, "[^a-zA-Z\\s]", "")
        RB_stats$Name <- str_trim(RB_stats$Name)
        RB_stats$Week <- weeks[j]
        RB_stats$Year <- years[i]
        RB_stats$RushAtt <- as.numeric(RB_stats$RushAtt)
        RB_stats$RushYds <- as.numeric(RB_stats$RushYds)
        RB_stats$RushTD <- as.numeric(RB_stats$RushTD)
        RB_stats$Target <- as.numeric(RB_stats$Target)
        RB_stats$Rec <- as.numeric(RB_stats$Rec)
        RB_stats$RecYds <- as.numeric(RB_stats$RecYds)
        RB_stats$RecTD <- as.numeric(RB_stats$RecTD)
        RB_stats$FPts <- as.numeric(RB_stats$FPts)
        RB_stats$FPts_G <- as.numeric(RB_stats$FPts_G)
        rb <- rbind(rb, RB_stats)
        
        remDr$navigate(url)
        nextPg <- try(remDr$findElement(using = "link text", "Next Page"), silent = TRUE)
        while (class(nextPg) != "try-error") {
            nextPg$clickElement()
            url <- nextPg$getCurrentUrl()
            url <- url[[1]]
            RB_stats <- readHTMLTable(url, stringsAsFactors = FALSE)[11]
            RB_stats <- RB_stats[[1]]
            
            names(RB_stats) <- c("Name", "Tm", "Week", "RushAtt", "RushYds", "RushTD",
                                 "Target", "Rec", "RecYds", "RecTD", "FPts", "FPts_G")
            RB_stats <- RB_stats[-1,]
            RB_stats$Name <- str_replace_all(RB_stats$Name, "[^a-zA-Z\\s]", "")
            RB_stats$Name <- str_trim(RB_stats$Name)
            RB_stats$Week <- weeks[j]
            RB_stats$Year <- years[i]
            RB_stats$RushAtt <- as.numeric(RB_stats$RushAtt)
            RB_stats$RushYds <- as.numeric(RB_stats$RushYds)
            RB_stats$RushTD <- as.numeric(RB_stats$RushTD)
            RB_stats$Target <- as.numeric(RB_stats$Target)
            RB_stats$Rec <- as.numeric(RB_stats$Rec)
            RB_stats$RecYds <- as.numeric(RB_stats$RecYds)
            RB_stats$RecTD <- as.numeric(RB_stats$RecTD)
            RB_stats$FPts <- as.numeric(RB_stats$FPts)
            RB_stats$FPts_G <- as.numeric(RB_stats$FPts_G)
            rb <- rbind(rb, RB_stats)
            
            nextPg <- try(remDr$findElement(using = "link text", "Next Page"))
        }
        remDr$close()
    }
}

##################
## Wide Recievers
##################

# wr <- data.frame("Name" = character(0), "Tm" = character(0), "Week" = integer(0),
#                  "Target" = numeric(0), "Rec" = numeric(0), "RecYds" = numeric(0),
#                  "RecTD" = numeric(0), "RushAtt" = numeric(0), "RushYds" = numeric(0), 
#                  "RushTD" = numeric(0),"FPts" = numeric(0), "FPts_G" = numeric(0), 
#                  "Year" = integer(0))
# 
# for (i in 1:length(years)) {
#     urlYear <- paste(baseUrl, years[i], sep = "")
#     for (j in 1:length(weeks)) {
#         url <-paste(urlYear, "&GameWeek=", weeks[j], "&PosID=30&LeagueID=1", sep = "")
#         WR_stats <- readHTMLTable(url, stringsAsFactors = FALSE)[11]
#         WR_stats <- WR_stats[[1]]
#         
#         names(WR_stats) <- c("Name", "Tm", "Week", "Target", "Rec", "RecYds", "RecTD",
#                              "RushAtt", "RushYds", "RushTD", "FPts", "FPts_G")
#         WR_stats <- WR_stats[-1,]
#         WR_stats$Name <- str_replace_all(WR_stats$Name, "[^a-zA-Z\\s]", "")
#         WR_stats$Name <- str_trim(WR_stats$Name)
#         WR_stats$Week <- weeks[j]
#         WR_stats$Year <- years[i]
#         WR_stats$Target <- as.numeric(WR_stats$Target)
#         WR_stats$Rec <- as.numeric(WR_stats$Rec)
#         WR_stats$RecYds <- as.numeric(WR_stats$RecYds)
#         WR_stats$RecTD <- as.numeric(WR_stats$RecTD)
#         WR_stats$RushAtt <- as.numeric(WR_stats$RushAtt)
#         WR_stats$RushYds <- as.numeric(WR_stats$RushYds)
#         WR_stats$RushTD <- as.numeric(WR_stats$RushTD)
#         WR_stats$FPts <- as.numeric(WR_stats$FPts)
#         WR_stats$FPts_G <- as.numeric(WR_stats$FPts_G)
#         wr <- rbind(wr, WR_stats)
#     }
# }