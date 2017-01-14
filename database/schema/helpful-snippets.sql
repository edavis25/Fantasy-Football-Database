-------------------------------------------------------------------
---------- Random Useful SQL Snippets  -----------
------------------------------------------------------------------->


-- Find All Duplicate Players
SELECT
    Name, COUNT(*)
FROM
    Players
GROUP BY
    Name
HAVING 
    COUNT(*) > 1
	
	
-- Find Duplicate Players With Duplicate Positions
SELECT
    Name, Position
FROM
    Players
GROUP BY
    Name, Position
HAVING 
    COUNT(*) > 1

	
-- Select Team Leaders (Replace appropriate names)
SELECT SUM(PlayerGame.RushYds), Players.Name -- Choose desired stat
FROM PlayerGame
JOIN Players ON Players.PlayerID = PlayerGame.PlayerID
JOIN Games ON Games.GameID = PlayerGame.GameID
JOIN Teams ON Teams.TeamID = Players.ActTeam
WHERE Games.Date > '2016-04-20'
AND Teams.Name = 'Seahawks'
GROUP BY Players.Name
ORDER BY SUM(PlayerGame.RushYds) DESC -- Choose same stat
LIMIT 3 -- Adjust limit 


-- Select Team Leaders From View
SELECT SUM(RushYds), Name
FROM QBView
INNER JOIN Players ON Players.PlayerID = QBView.PlayerID
INNER JOIN Teams ON Teams.TeamID = Players.ActTeam
WHERE Date > '2016-04-20'
AND Players.ActTeam = Teams.TeamID
AND Teams.Name = 'Browns'
GROUP BY QBView.Name
ORDER BY SUM(RushYds) DESC
LIMIT 3


-- Add Temp Ranking Value to Ordered Results
SELECT @r := @r+1 AS Rank, innerTbl.*
FROM
  (SELECT
     Name, 
     ((SUM(PassYds) * 0.04) + (SUM(PassTds) * 6) + (SUM(RushYds) * 0.1) + (SUM(RushTds) * 6) + (SUM(FL) * - 2) + (SUM(Ints) * - 1)) AS OffRank
   FROM TeamGame2016_View
   GROUP BY Name
   ORDER BY OffRank desc
) innerTbl, (select @r:=0) x;


-- Select Only the Rank From Above Query (WHERE = 'TeamName')
SELECT Rank
FROM
  (SELECT 
    @r := @r+1 AS Rank, 
    Name
   FROM
     (SELECT
	Name,
	((SUM(PassYds) * 0.04) + (SUM(PassTds) * 6) + (SUM(RushYds) * 0.1) + (SUM(RushTds) * 6) + (SUM(FL) * - 2) + (SUM(Ints) * - 1)) AS OffRank
	FROM TeamGame2016_View
	GROUP BY Name
	ORDER BY OffRank DESC
      ) innerTbl
) outerTbl, (SELECT @r:=0) y
WHERE outerTbl.Name = 'Browns'
