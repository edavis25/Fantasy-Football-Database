-------------------------------------------------------------------
---------- PlayerGame Stats Table Snippets -----------
------------------------------------------------------------------->

-- Make sure Games table contains all games referenced in the PlayerGame import table

-- Make sure the Players table contains all the new players for import. 
-- Run the PlayerSearch .java file to look for anyone missing from the DB that exists within the import file

-- Move URL Column and leave a blank column for GameID

-- Copy PlayerGame schema into temporary table
--     - Change columns in temp schema to remove keys and allow IDs to accept varchar until updated later

-- Set Game ID (This wont be very quick... 15,000 records =~ 4 mins)
UPDATE PlayerGame_TEMP
SET GameID =
	(SELECT Games.GameID FROM Games WHERE Games.URL = PlayerGame_TEMP.URL);

-- Make sure every row has a valid GameID
SELECT * FROM PlayerGame_TEMP 
WHERE GameID NOT BETWEEN 1 AND (SELECT MAX(GameID) FROM Games)

-- Find Duplicate Players
SELECT
    Name, COUNT(*)
FROM
    Players
GROUP BY
    Name
HAVING 
    COUNT(*) > 1
	

-- Find the players in TEMP table that will have a problem with PlayerID
-- These will be any player names that have a possibility of 2+ PlayerIDs (Duplicate names)
-- We have to use "DISTINCT" when updating PlayerIDs later and then fix the guys returned
-- from the following query manually (until I find a better solution..) (this query is slow....15,000 records =~ 9 mins)
SELECT DISTINCT PlayerID FROM PlayerGame_TEMP
WHERE PlayerID IN 
(
    SELECT Name
	FROM Players
	GROUP BY  Name
	HAVING COUNT(*) > 1
)
	
-- Update PlayerID. The group by forces all duplicate players to use a single PlayerID, the list created above
-- should be used to manually separate the duplicates (gross)
UPDATE PlayerGame_TEMP
SET PlayerID =
	(SELECT DISTINCT Players.PlayerID 
	FROM Players 
	WHERE Players.Name = PlayerGame_TEMP.PlayerID 
	GROUP BY Players.Name);
	
-- Check valid IDs
SELECT * FROM PlayerGame_TEMP 
WHERE PlayerID NOT BETWEEN 1 AND (SELECT MAX(PlayerID) FROM  Players)

INSERT INTO PlayerGame --Existing table for import
	(PlayerID, 
	GameID, 
	PassCmp, 
	PassAtt,
	PassYds, 
	PassTd, 
	Interceptions, 
	SkTaken, 
	SkYds, 
	PassLng, 
	QbRating,
	RushAtt,
	RushYds,
	RushTd,
	RushLng,
	RecTgt, 
	Receptions, 
	RecYds,
	RecTd,
	RecLng, 
	Fmb, 
	FL,
	DefInt,
	DefIntYds, 
	DefIntTd, 
	DefIntLng, 
	DefSk, 
	DefTkl, 
	DefAst, 
	DefFR, 
	DefFRYrds,
	DefFRTd,
	DefFF,
	KickRet,
	KickRetYds,
	KickYdsRet,
	KickRetTD,
	KickRetLng,
	PuntRet,
	PuntRetYds,
	PuntYdsReturn,
	PuntRetTd,
	PuntRetLng,
	XPMade,
	XPAtt,
	FGMade,
	FGAtt,
	URL)
SELECT
	(PlayerID, 
	GameID, 
	PassCmp, 
	PassAtt,
	PassYds, 
	PassTd, 
	Interceptions, 
	SkTaken, 
	SkYds, 
	PassLng, 
	QbRating,
	RushAtt,
	RushYds,
	RushTd,
	RushLng,
	RecTgt, 
	Receptions, 
	RecYds,
	RecTd,
	RecLng, 
	Fmb, 
	FL,
	DefInt,
	DefIntYds, 
	DefIntTd, 
	DefIntLng, 
	DefSk, 
	DefTkl, 
	DefAst, 
	DefFR, 
	DefFRYrds,
	DefFRTd,
	DefFF,
	KickRet,
	KickRetYds,
	KickYdsRet,
	KickRetTD,
	KickRetLng,
	PuntRet,
	PuntRetYds,
	PuntYdsReturn,
	PuntRetTd,
	PuntRetLng,
	XPMade,
	XPAtt,
	FGMade,
	FGAtt,
	URL)
FROM PlayerGame_TEMP --Temp table w/ imported CSV

