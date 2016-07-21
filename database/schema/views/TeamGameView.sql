CREATE VIEW TeamGameView AS SELECT
	Teams.Name AS 'Name',
	TeamGame.TeamID AS 'TeamID',
	TeamGame.GameID AS 'GameID',
	GameView.Date AS 'Date',
	GameView.Week AS 'Week',
	GameView.Day AS 'Day',
	GameView.Time AS 'Time',
	CASE
		WHEN (Name LIKE GameView.Winner)
			THEN 'Y'
		ELSE 
			'N' 
		END AS 'Won',
	CASE 		
		WHEN (Name LIKE GameView.Winner)
			THEN GameView.Loser
		ELSE 
			GameView.Winner
		END AS 'Opponent',
	CASE
		WHEN (Name LIKE GameView.Winner)
			THEN GameView.WinScore
		ELSE
			GameView.LoseScore
		END AS 'TotalScore',
	CASE 
		WHEN (Name LIKE GameView.Winner)
			THEN GameView.LoseScore
		ELSE
			GameView.WinScore
		END AS 'OppScore',
	GameView.Duration AS 'Duration',
	GameView.Stadium AS 'Stadium',
	GameView.Roof AS 'Roof',
	GameView.Surface AS 'Surface',
	GameView.Temp AS 'Temp',
	GameView.Humidity AS 'Humidity',
	GameView.Wind AS 'Wind',
	TeamGame."1stDowns" AS '1stDowns',
	TeamGame.RushAtt AS 'RushAtt',
	TeamGame.RushYds AS 'RushYds',
	TeamGame.RushTds AS 'RushTds',
	TeamGame.PassComp AS 'PassComp',
	TeamGame.PassAtt AS 'PassAtt',
	TeamGame.PassYds AS 'PassYds',
	TeamGame.PassTds AS 'PassTds',
	TeamGame.Ints AS 'Ints',
	TeamGame.Sacked AS 'SkTaken',
	TeamGame.SackedYds AS 'SkYds',
	TeamGame.NetPassYds AS 'NetPassYds',
	TeamGame.TotalYds AS 'TotalYds',
	TeamGame.Fumbles AS 'Fmb',
	TeamGame.FumblesLost AS 'FL',
	TeamGame.Turnovers AS 'Turnovers',
	TeamGame.Penalties AS 'Pen',
	TeamGame.PenaltyYds AS 'PenYds',
	TeamGame."3rdM" AS '3rdM',
	TeamGame."3rdAtt" AS '3rdAtt',
	TeamGame."4thM" AS '4thM',
	TeamGame."4thAtt" AS '4thAtt',
	TeamGame.TOP AS 'TOP',
	TeamGame.Q1 AS 'Q1',
	TeamGame.Q2 AS 'Q2',
	TeamGame.Q3 AS 'Q3',
	TeamGame.Q4 AS 'Q4',
	TeamGame.OT AS 'OT',
	TeamGame.URL AS 'URL'
FROM
	Teams, TeamGame
LEFT JOIN
	GameView ON GameView.GameID = TeamGame.GameID
WHERE
	TeamGame.TeamID = Teams.TeamID;
	
	

	
	
