library(dplyr)
library(plyr)

df <- read.csv("./player-game.csv")

# If we look at the 20061029 NYJ @ CLE game, we see that Josh Cribbs
# has two separate stat lines for this game.  This is because the boxscore
# d.f. is a combination of three different html tables from every game url.
# One line is produced by the offensive table and another by the return table.

CribbsVRaiders <- select(df, Name, GameID, Tm, RecTgt, Receptions, 
                         RecYds, RecTd, RecLng, KickRet, KickRetYds,
                         KickYds.Ret, KickRetTd, KickRetLng, PuntRet,
                         PuntRetYds, PuntYds.Ret, PuntRetTd, PuntRetLng) %>%
                  filter(Name == "Josh Cribbs", 
                         GameID == "http://www.pro-football-reference.com/boxscores/200610290cle.htm")

# Ideally, we want one stat line per player, per game.  This was pretty
# simple with group_by and summarize from dplyr.  There is likely a
# better way to sum all of the stat columns without typing each out.

newdf <- group_by(df, Name, GameID, Tm) %>% summarize(PassCmp = sum(PassCmp),
                                                  PassAtt = sum(PassAtt),
                                                  PassYds = sum(PassYds),
                                                  PassTd = sum(PassTd),
                                                  Int = sum(Int),
                                                  SkTaken = sum(SkTaken),
                                                  SkYds = sum(SkYds),
                                                  PassLng = sum(PassLng),
                                                  QbRating = sum(QbRating),
                                                  RushAtt = sum(RushAtt),
                                                  RushYds = sum(RushYds),
                                                  RushTD = sum(RushTD),
                                                  RushLng = sum(RushLng),
                                                  RecTgt = sum(RecTgt),
                                                  Receptions = sum(Receptions),
                                                  RecYds = sum(RecYds),
                                                  RecTd = sum(RecTd),
                                                  RecLng = sum(RecLng),
                                                  Fmb = sum(Fmb),
                                                  FL = sum(FL),
                                                  DefInt = sum(DefInt),
                                                  DefIntYds = sum(DefIntYds),
                                                  DefIntTd = sum(DefIntTd),
                                                  DefIntLng = sum(DefIntLng),
                                                  DefSk = sum(DefSk),
                                                  DefTkl = sum(DefTkl),
                                                  DefAst = sum(DefAst),
                                                  DefFR = sum(DefFR),
                                                  DefFRYds = sum(DefFRYds),
                                                  DefFRTd = sum(DefFRTd),
                                                  DefFF = sum(DefFF),
                                                  KickRet = sum(KickRet),
                                                  KickRetYds = sum(KickRetYds),
                                                  KickYds.Ret = sum(KickYds.Ret),
                                                  KickRetTd = sum(KickRetTd),
                                                  KickRetLng = sum(KickRetLng),
                                                  PuntRet = sum(PuntRet),
                                                  PuntRetYds = sum(PuntRetYds),
                                                  PuntYds.Ret = sum(PuntYds.Ret),
                                                  PuntRetTd = sum(PuntRetTd),
                                                  PuntRetLng = sum(PuntRetLng),
                                                  XPMade = sum(XPMade),
                                                  XPAtt = sum(XPAtt),
                                                  FGMade = sum(FGMade),
                                                  FGAtt = sum(FGAtt))

# Now if we look at the same stats for Josh Cribbs from above in the
# new d.f., they are combined into one observation.

newCribbsVRaiders <- select(newdf, Name, GameID, Tm, RecTgt, Receptions, 
                         RecYds, RecTd, RecLng, KickRet, KickRetYds,
                         KickYds.Ret, KickRetTd, KickRetLng, PuntRet,
                         PuntRetYds, PuntYds.Ret, PuntRetTd, PuntRetLng) %>%
    filter(Name == "Josh Cribbs", 
           GameID == "http://www.pro-football-reference.com/boxscores/200610290cle.htm")

write.csv(newdf, file = "./player-game2.csv")                                                  