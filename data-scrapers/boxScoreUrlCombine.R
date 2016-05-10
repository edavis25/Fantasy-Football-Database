urls_05 <- read.csv(file = "/Users/markeidsaune/Desktop/Fantasy-Football-Database/database/data/urls/2005-boxscoreURLS.csv")
urls_05 <- urls_05[,1]
urls_05 <- as.character(urls_05)
urls_06 <- read.csv(file = "/Users/markeidsaune/Desktop/Fantasy-Football-Database/database/data/urls/2006-boxscoreURLS.csv")
urls_06 <- urls_06[,1]
urls_06 <- as.character(urls_06)
urls_07 <- read.csv(file = "/Users/markeidsaune/Desktop/Fantasy-Football-Database/database/data/urls/2007-boxscoreURLS.csv")
urls_07 <- urls_07[,1]
urls_07 <- as.character(urls_07)
urls_08 <- read.csv(file = "/Users/markeidsaune/Desktop/Fantasy-Football-Database/database/data/urls/2008-boxscoreURLS.csv")
urls_08 <- urls_08[,1]
urls_08 <- as.character(urls_08)
urls_09 <- read.csv(file = "/Users/markeidsaune/Desktop/Fantasy-Football-Database/database/data/urls/2009-boxscoreURLS.csv")
urls_09 <- urls_09[,1]
urls_09 <- as.character(urls_09)
urls_10 <- read.csv(file = "/Users/markeidsaune/Desktop/Fantasy-Football-Database/database/data/urls/2010-boxscoreURLS.csv")
urls_10 <- urls_10[,1]
urls_10 <- as.character(urls_10)
urls_11 <- read.csv(file = "/Users/markeidsaune/Desktop/Fantasy-Football-Database/database/data/urls/2011-boxscoreURLS.csv")
urls_11 <- urls_11[,1]
urls_11 <- as.character(urls_11)
urls_12 <- read.csv(file = "/Users/markeidsaune/Desktop/Fantasy-Football-Database/database/data/urls/2012-boxscoreURLS.csv")
urls_12 <- urls_12[,1]
urls_12 <- as.character(urls_12)
urls_13 <- read.csv(file = "/Users/markeidsaune/Desktop/Fantasy-Football-Database/database/data/urls/2013-boxscoreURLS.csv")
urls_13 <- urls_13[,1]
urls_13 <- as.character(urls_13)
urls_14 <- read.csv(file = "/Users/markeidsaune/Desktop/Fantasy-Football-Database/database/data/urls/2014-boxscoreURLS.csv")
urls_14 <- urls_14[,1]
urls_14 <- as.character(urls_14)
urls_15 <- read.csv(file = "/Users/markeidsaune/Desktop/Fantasy-Football-Database/database/data/urls/2015-boxscoreURLS.csv")
urls_15 <- urls_15[,1]
urls_15 <- as.character(urls_15)

urls <- as.character(c(urls_05, urls_06, urls_07, urls_08, urls_09, urls_10, urls_11, urls_12, urls_13, urls_14, urls_15))
write.csv(urls, file = "/Users/markeidsaune/Desktop/Fantasy-Football-Database/database/data/urls/combinedUrls.csv")



