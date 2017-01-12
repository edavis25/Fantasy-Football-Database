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
