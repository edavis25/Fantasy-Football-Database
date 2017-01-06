CREATE VIEW RBView AS SELECT
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
		PlayerGame2010.RushAtt AS 'RushAtt',
		PlayerGame2010.RushYds AS 'RushYds',
		PlayerGame2010.RushTd AS 'RushTds',
		PlayerGame2010.RushLng AS 'RushLng',
		PlayerGame2010.RecTgt AS 'RecTgt',
		PlayerGame2010.Receptions AS 'Rec',
		PlayerGame2010.RecYds AS 'RecYds',
		PlayerGame2010.RecTd AS 'RecTds',
		PlayerGame2010.RecLng AS 'RecLng',
		PlayerGame2010.Fmb AS 'Fmb',
		PlayerGame2010.FL AS 'FL',
		PlayerGame2010.KickRet AS 'KickRet',
		PlayerGame2010.KickRetYds AS 'KickRetYds',
		PlayerGame2010.KickYdsRet AS 'KickYdsRet',
		PlayerGame2010.KickRetTD AS 'KickRetTD',
		PlayerGame2010.KickRetLng AS 'KickRetLng',
		PlayerGame2010.PuntRet AS 'PuntRet',
		PlayerGame2010.PuntRetYds AS 'PuntRetYds',
		PlayerGame2010.PuntYdsReturn AS 'PuntYdsRet',
		PlayerGame2010.PuntRetTd AS 'PuntRetTD',
		PlayerGame2010.PuntRetLng AS 'PuntRetLng',
		((RecYds * 0.1) + (RecTd * 6) +  (RushYds * 0.1) + (RushTd * 6) + 
            (KickRetTd * 6) + (PuntRetTd * 6) + (FL * -2) + (Receptions * 0.5))  AS 'FanDuel',
        ((RecYds * 0.1) + (RecTd * 6) +  (RushYds * 0.1) + (RushTd * 6) + 
			(KickRetTd * 6) + (PuntRetTd * 6) + (FL * -2)) AS 'Standard',
        ((RecYds * 0.1) + (RecTd * 6) +  (RushYds * 0.1) + (RushTd * 6) + 
             (KickRetTd * 6) + (PuntRetTd * 6) + (FL * -2) + (Receptions * 1))  AS 'PPR'
FROM PlayerGame2010, Games, Players, Stadiums
WHERE PlayerGame2010.PlayerID = Players.PlayerID AND
	  PlayerGame2010.GameID = Games.GameID AND
	  Games.StadiumID = Stadiums.StadiumID AND
	  Players.Position = 'RB';