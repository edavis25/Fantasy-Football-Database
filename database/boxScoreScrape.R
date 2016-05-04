library("rvest")

url <- "http://www.pro-football-reference.com/boxscores/200809040nyg.htm"

## Game Info Table
gameInfo <- url %>%
    read_html() %>%
    html_nodes(xpath = '//*[@id="game_info"]')  %>%
    html_table()

gameInfo <- gameInfo[[1]]

## Team Stats Table
teamStats <- url %>%
    read_html() %>%
    html_nodes(xpath = '//*[@id="team_stats"]')  %>%
    html_table()

teamStats <- teamStats[[1]]

## Passing, Rushing, & Recieving Table

PassRushRecieve <- url %>%
    read_html() %>%
    html_nodes(xpath = '//*[@id="skill_stats"]') %>%
    html_table()

PassRushRecieve <- PassRushRecieve[[1]]
colnames(PassRushRecieve) <- c("Name", "Tm", "PassCmp", "PassAtt", "PassYds", "PassTd",
                              "Int", "SkTaken", "SkYds", "PassLng", "QbRating", 
                              "RushAtt", "RushYds", "RushTD", "RushLng", "RecTgt",
                              "Receptions", "RecYds", "RecTd", "RecLng", "Fmb", "FL")
delRowsPRR <- which(PassRushRecieve$Name == "")
PassRushRecieve <- PassRushRecieve[-delRowsPRR,]

## Defense Table

Defense <- url %>%
    read_html() %>%
    html_nodes(xpath = '//*[@id="def_stats"]') %>%
    html_table()

Defense <- Defense[[1]]
## Conditional is needed because the defensive tables before 2007 do not include
## forced fumbles.  General note: early defensive stats are incomplete.  Should
## consider getting defensive data elsewhere.
if (ncol(Defense) == 13) {
    colnames(Defense) <- c("Name", "Tm", "DefInt", "DefIntYds", "DefIntTd", "DefIntLng",
                       "DefSk", "DefTkl", "DefAst", "DefFR", "DefFRYds", "DefFRTd",
                       "DefFF")
} else {
    colnames(Defense) <- c("Name", "Tm", "DefInt", "DefIntYds", "DefIntTd", "DefIntLng",
                           "DefSk", "DefTkl", "DefAst", "DefFR", "DefFRYds", "DefFRTd")
}

delRowsD <- which(Defense$Name == "")
Defense <- Defense[-delRowsD,]

## Kick/Punt Returns Table

Returns <- url %>%
    read_html() %>%
    html_nodes(xpath = '//*[@id="st_stats"]') %>%
    html_table()

Returns <- Returns[[1]]
colnames(Returns) <- c("Name", "Tm", "KickRet", "KickRetYds", "KickYds/Ret", "KickRetTd", 
                       "KickRetLng", "PuntRet", "PuntRetYds", "PuntYds/Ret", 
                       "PuntRetTd", "PuntRetLng")
delRowsRet <- which(Returns$Name == "")
Returns <- Returns[-delRowsRet,]

## Kicking Table

Kicks <- url %>%
    read_html() %>%
    html_nodes(xpath = '//*[@id="kick_stats"]') %>%
    html_table()

Kicks <- Kicks[[1]]
Kicks <- Kicks[, c(1:6)]
colnames(Kicks) <- c("Name", "Tm", "XPMade", "XPAtt", "FGMade", "FGAtt")
delRowsKicks <- which(Kicks$Name == "")
Kicks <- Kicks[-delRowsKicks,]
