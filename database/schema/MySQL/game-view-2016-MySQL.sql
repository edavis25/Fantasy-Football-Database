CREATE VIEW Games2016_View AS SELECT 
g.GameID AS GameID, 
g.Date AS Date, 
g.Week AS Week, 
g.Day AS Day, 
g.Time AS Time, 
g.WinnerID AS WinID, 
g.LoserID AS LoseID, 
win.Name AS Winner, 
lose.Name AS Loser, 
g.WinnerScore AS WinScore, 
g.LoserScore AS LoseScore, 
g.Duration AS Duration, 
s.Name AS Stadium, 
g.Attendance AS Attendance, 
s.Roof AS Roof, 
s.Surface AS Surface, 
g.Temperature AS "Temp", 
g.Humidity AS Humidity, 
g.Wind AS Wind, 
favored.Name AS Favored,
 g.Spread AS Spread, 
CASE WHEN (win.name LIKE favored.name) AND ((g.WinnerScore - g.LoserScore) > g.Spread) THEN 'Y' WHEN g.Spread = 0 THEN NULL ELSE 'N' END AS SpreadCovered, 
g.OverUnder AS OULine, 
g.OUResult AS OUResult 
FROM (Games g, Stadiums s)
LEFT JOIN Teams win ON win.TeamID = g.WinnerID 
LEFT JOIN Teams lose ON lose.TeamID = g.LoserID 
LEFT JOIN Teams favored ON favored.TeamID = g.FavoredTeam WHERE g.StadiumID = s.StadiumID AND g.Date BETWEEN '2016-04-20' AND '2017-04-20'
