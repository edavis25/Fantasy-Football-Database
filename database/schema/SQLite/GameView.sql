CREATE VIEW TeamGameView AS
SELECT Games.GameID AS 'GameID',
     Games.Date AS 'Date',
     Games.Week AS 'Week',
	 Games.Day AS 'Day',
	 Games.Time AS 'Time',
     Games.WinnerID AS 'WinID',
     Games.LoserID AS 'LoseID',
     win.Name AS 'Winner',
     lose.Name AS 'Loser',
	 Games.WinnerScore AS 'WinScore',
	 Games.LoserScore AS 'LoseScore',
	 Games.Duration AS 'Duration',
	 Stadiums.Name AS 'Stadium',
	 Games.Attendance AS 'Attendance',
	 Stadiums.Roof AS 'Roof',
	 Stadiums.Surface AS 'Surface',
	 Games.Temperature AS 'Temp',
	 Games.Humidity AS 'Humidity',
	 Games.Wind AS 'Wind',
	 favored.Name AS 'Favored',
	 Games.Spread AS 'Spread',
	 CASE 
		WHEN (win.name LIKE favored.name) AND ((Games.WinnerScore - Games.LoserScore) > Games.Spread) 
			THEN 'Y' 
		WHEN Games.Spread = 0
			THEN null
		ELSE 'N' 
	 END AS 'SpreadCovered',
	 Games.OverUnder AS 'OULine',
	 Games.OUResult AS 'OUResult'
FROM Games, Stadiums
LEFT JOIN Teams as win ON win.TeamID = Games.WinnerID
LEFT JOIN Teams as lose on lose.TeamID = Games.LoserID
LEFT JOIN Teams as favored on favored.TeamID = Games.FavoredTeam
WHERE Games.StadiumID = Stadiums.StadiumID;