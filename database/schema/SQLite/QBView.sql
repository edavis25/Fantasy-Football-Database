CREATE VIEW QBView AS SELECT
		PlayerGame2010.PlayerID AS 'PlayerID',
		Players.Name AS 'Name',
		Players.Position AS 'Position',
		PlayerGame2010.GameID AS 'GameID',
		Games.Date AS 'Date',
		Stadiums.Name AS 'Location',
		Stadiums.Surface AS 'Surface',
		Stadiums.Roof AS 'Roof',
		Games.Temperature AS 'Temp',
		Games.Humidity AS 'Humidity',
		Games.Wind AS 'Wind',
		PlayerGame2010.PassCmp AS 'PassCmp',
		PlayerGame2010.PassAtt AS 'PassAtt',
		PlayerGame2010.PassYds AS 'PassYds',
		PlayerGame2010.PassTd AS 'PassTD',
		PlayerGame2010.Int AS 'Int',
		PlayerGame2010.SkTaken AS 'SkTaken',
		PlayerGame2010.SkYds AS 'SkYds',
		PlayerGame2010.PassLng AS 'PassLng',
		PlayerGame2010.QbRating AS 'QBR',
		PlayerGame2010.RushAtt AS 'RushAtt',
		PlayerGame2010.RushYds AS 'RushYds',
		PlayerGame2010.RushTd AS 'RushTd',
		PlayerGame2010.RushLng AS 'RushLng',
		PlayerGame2010.Fmb AS 'Fmb',
		PlayerGame2010.FL AS 'FL',
		((PassYds * 0.04) + (PassTd * 4) +  (RushYds * 0.1) + (RushTd * 6) + 
			(FL * -2) + (Int * -1))  AS 'FanDuel',
        ((PassYds * 0.04) + (PassTd * 4) +  (RushYds * 0.1) + (RushTd * 6) + 
            (FL * -2) + (Int * -1)) AS 'Standard',
        ((PassYds * 0.04) + (PassTd * 4) +  (RushYds * 0.1) + (RushTd * 6) + 
            (FL * -2) + (Int * -2))  AS 'PPR'
FROM PlayerGame2010, Games, Players, Stadiums
WHERE PlayerGame2010.PlayerID = Players.PlayerID AND
	  PlayerGame2010.GameID = Games.GameID AND
	  Games.StadiumID = Stadiums.StadiumID AND
	  Players.Position = 'QB';