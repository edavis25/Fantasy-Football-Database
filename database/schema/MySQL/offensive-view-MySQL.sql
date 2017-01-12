CREATE VIEW Offense_View AS
SELECT 
	PlayerGame.PlayerID AS PlayerID, 
	Players.Name AS Name, 
	Players.Position AS Position, 
	PlayerGame.GameID AS GameID, 
	Games.Date AS Date, 
	Stadiums.Name AS Location, 
	Stadiums.Surface AS Surface, 
	Stadiums.Roof AS Roof, 
	Games.Temperature AS Temp,
	Games.Humidity AS Humidity, 
	Games.Wind AS Wind, 
	PlayerGame.PassCmp AS PassCmp, 
	PlayerGame.PassAtt AS PassAtt,
	PlayerGame.PassYds AS PassYds, 
	PlayerGame.PassTd AS PassTD, 
	PlayerGame.Interceptions AS Ints, 
	PlayerGame.SkTaken AS SkTaken, 
	PlayerGame.SkYds AS SkYds,
	PlayerGame.PassLng AS PassLng, 
	PlayerGame.QbRating AS QBR, 
	PlayerGame.RushAtt AS RushAtt,
	PlayerGame.RushYds AS RushYds, 
	PlayerGame.RushTd AS RushTd, 
	PlayerGame.RushLng AS RushLng,
    PlayerGame.RecTgt AS RecTgt,
    PlayerGame.Receptions AS Rec,
    PlayerGame.RecYds AS RecYds,
    PlayerGame.RecTd AS RecTds,
    PlayerGame.PuntRetYds AS PRetYds,
    PlayerGame.PuntRetTd AS PRetTds,
    PlayerGame.KickRetYds AS KRetYds,
    PlayerGame.KickRetTd AS KRetTds,
	PlayerGame.Fmb AS Fmb, 
	PlayerGame.FL AS FL, 
	ROUND((PassYds * 0.04) + (PassTd * 4) + (RushYds * 0.1) + (RushTd * 6) + (FL * - 2) + (Interceptions * - 1) + (Receptions * 0.5) + (RecYds * 0.1) + (RecTd * 6), 2) AS FanDuel, 
	ROUND((PassYds * 0.04) + (PassTd * 4) + (RushYds * 0.1) + (RushTd * 6) + (FL * - 2) + (Interceptions * - 1) + (RecYds * 0.1) + (RecTd * 6), 2) AS Standard, 
	ROUND((PassYds * 0.04) + (PassTd * 4) + (RushYds * 0.1) + (RushTd * 6) + (FL * - 2) + (Interceptions * - 2) + (Receptions * 1) + (RecYds * 0.1) + (RecTd * 6), 2) AS PPR 
 FROM PlayerGame , Games , Players , Stadiums 
 WHERE PlayerGame.PlayerID = Players.PlayerID
 AND PlayerGame.GameID = Games.GameID 
 AND Games.StadiumID = Stadiums.StadiumID 
 AND Players.Position IN ('QB', 'RB', 'TE', 'WR')
 -- Add optional date