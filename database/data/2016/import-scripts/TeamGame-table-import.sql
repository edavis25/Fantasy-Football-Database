-------------------------------------------------------------------
---------- TEAMGAME Stats Table Snippets -----------
------------------------------------------------------------------->

/*
***** CSV Cleaning Notes: *****
- Do a find/replace all and replace dashes (-) with plus sign (+)
	-- The data from HTML table that is entered with dashes opens in Excel as Date formatting causing issues
	-- Do NOT replace the dashes in the URL column
- Now use the plus sign as delimiter to split all the different columns
- DELETE blank column (column: Z) created by HTML table
- DELETE TeamName column in middle table (from the HTML table for per/quarter scores)
- Games that went into overtime have an extra column - Fix this in Excel
- Delete the Final Score column (This data is supplied in Games table)
- Flip GameID/NameID in first 2 columns to match DB - until changed in code
*/

-- Scripts using 2 Temp tables: TeamGameTemp and TeamGameTempTemp
-- TeamGameTemp is clone of TeamGame and TeamGameTempTemp will hold the newly imported data for final cleaning
-- If you change Temp table to be the Main table by renaming, Views will follow adjust themselves to the OLD NAME and won't work correctly


--- Set TeamID using the team abbreviation (Jacksonville is different in our DB) ----->
UPDATE TeamGameTempTemp SET TeamID = (SELECT Teams.TeamID FROM Teams WHERE TeamGameTempTemp.TeamID = Teams.Abbr);

--- Set the GameID using the URL as a temporary key ----->
UPDATE TeamGameTempTemp SET GameID = (SELECT Games.GameID FROM Games WHERE Games.URL = TeamGameTempTemp.URL);


/* Random Notes
- For some reason it gave me some grief with the GameID foreign key. Remove it and then add it back (TeamID foreign key was fine)
*/
