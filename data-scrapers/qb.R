library('XML')
library('rvest')
library('stringr')
library('RSelenium')
library('dplyr')

baseUrl <- "http://fftoday.com/stats/playerstats.php?Season="
years <- 2005:2015
weeks <- c(1:17, 21:24)

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

qb$Position <- "QB"
qb <- select(qb, Name, Position, Year, Week, PassCmp, PassAtt, PassYds, PassTd, Int, RushAtt, RushYds, RushTD, FPts, FPts_G)
write.csv(qb, "./qb.csv")

