<?php
	/**
	 * PHP Database helper functions
	 * NOTES:
	 *  1) Global variable for date for SQL queries?
	 *  2) Global variables for tables/views instead?
	 */
	
	// Create Global Database
	$DB = mysqli_connect('localhost', 'Read_User', 'readOnly', 'ffdatabase') or die('Error connecting to MySQL server.');
	
	// Create Global Tables (for easy changing)
	$TEAM_GAME_VIEW = 'TeamGame2016_View';
	$OFFENSE_VIEW = 'Offense2016_View';
	
	
	function getPassLeader($teamName)
	{
		
	}
	
	
	/*
	 * NOTE: Change this function and remove the SUM function and rewrite somehow (maybe optional)
	 */
	function getSeasonLeader($teamName, $columnArray, $orderBy, $limit)
	{
		// Get global references to Database and Table
		global $DB;		
		global $OFFENSE_VIEW;
		
		// Initialize the return array
		$returnArr = array();
		
		// Start building query
		$query = "SELECT ";
		
		// First row MUST be Player Name
		$query.= $OFFENSE_VIEW .".". $columnArray[0];
		
		// If other elements in array exist, add to query
		for ($i = 1; $i < count($columnArray); $i++)
		{
			$query.=",";		
			$query.= "SUM(".$OFFENSE_VIEW .".". $columnArray[$i] .")";
		}
		
		$query.= " FROM ". $OFFENSE_VIEW;
		$query.= " INNER JOIN Players ON Players.PlayerID = ".$OFFENSE_VIEW.".PlayerID";
		$query.= " INNER JOIN Teams ON Teams.TeamID = Players.ActTeam";
		$query.= " AND Players.ActTeam = Teams.TeamID";
		$query.= " AND Teams.Name = '" .$teamName ."'";
		$query.= " GROUP BY ". $OFFENSE_VIEW .".".$columnArray[0];
		$query.= " ORDER BY SUM(". $orderBy .") DESC";
		$query.= " LIMIT ". $limit;
		
		// Query DB
		mysqli_query($DB, $query) or die('Error querying database.');
		$result = mysqli_query($DB, $query);
		
		// Fetch each row from return result into return array
		while ($row = mysqli_fetch_array($result)) 
		{
			$returnArr[] = $row;
		}
		
		return $returnArr;
	}
	
	/**
	 * Get Team Offensive Rank
	 */
	function getOffRank($teamName)
	{
		global $TEAM_GAME_VIEW;
			
		$query = "SELECT
 					Name,
 					((SUM(PassYds) * 0.04) + (SUM(PassTds) * 6) + (SUM(RushYds) * 0.1) + (SUM(RushTds) * 6) + (SUM(FL) * - 2) + (SUM(Ints) * - 1)) AS OffRank
 					FROM ".$TEAM_GAME_VIEW." 
 					GROUP BY Name
 					ORDER BY OffRank DESC";
		
		return countRank($teamName, $query, 'Name');
	}
	
	
	/**
	 * Get Team Defensive Rank 
	 */
	function getDefRank($teamName)
	{
		global $TEAM_GAME_VIEW;
			
		$query = " SELECT
 					Opponent,
 					((SUM(PassYds) * 0.04) + (SUM(PassTds) * 6) + (SUM(RushYds) * 0.1) + (SUM(RushTds) * 6) + (SUM(FL) * - 2) + (SUM(Ints) * - 1)) AS OffRank
 					FROM ".$TEAM_GAME_VIEW." 
 					GROUP BY Opponent
 					ORDER BY OffRank ASC";
 		
		return countRank($teamName, $query, 'Opponent');
	}
	
	
	/**
	 * Get Team Rushing Rrank
	 */
	function getRushRank($teamName)
	{
		global $TEAM_GAME_VIEW;	
			
		$query = "SELECT
 						Name,
 						((SUM(RushYds) * 0.1) + (SUM(RushTds) * 6) + (SUM(FL) * - 2)) AS OffRank
 					FROM ".$TEAM_GAME_VIEW." 
 					GROUP BY Name
 					ORDER BY OffRank DESC";
					
		return countRank($teamName, $query, 'Name');
	}
	
	
	/**
	 * Get Team Passing Rank
	 */
	function getPassRank($teamName)
	{
		global $TEAM_GAME_VIEW;		
				
		$query = "SELECT
 					Name,
 					((SUM(PassYds) * 0.1) + (SUM(PassTds) * 6) + (SUM(Ints) * - 2)) AS OffRank
 				FROM ".$TEAM_GAME_VIEW." 
 				GROUP BY Name
 				ORDER BY OffRank DESC";
 				
 		return countRank($teamName, $query, 'Name');
	}
	
	
	/**
	 * Get Team Win/Loss Record
	 */
	function getRecord($teamName, $outcome)
	{
		global $DB;
		global $TEAM_GAME_VIEW;
		
		$query = "SELECT 
    				(SELECT 
        				COUNT(Won)
    				FROM ".$TEAM_GAME_VIEW." 
    				WHERE Won = 'Y'
    				AND Name = '".$teamName."') AS Won,
    				(SELECT 
        				COUNT(Won)
    				FROM ".$TEAM_GAME_VIEW." 
    				WHERE Won = 'N'
    				AND Name = '".$teamName."') AS Lost";
		
		// Query database and store results
		mysqli_query($DB, $query) or die('Error querying database. - Record');
		$result = mysqli_query($DB, $query);
		
		$record = array();
		while ($row = mysqli_fetch_array($result)) 
		{
			$record[] = $row['Won'];
			$record[] = $row['Lost'];
		}

		if ($outcome == "wins")
		{
			return $record[0];
		}
		else if ($outcome == "losses")
		{
			return $record[1];
		} 
		else
		{
			return "Record Error";
		}
	}
	
	
	/**
	 * Get Team Season Total Yards
	 */
	function getYardTotals($teamName)
	{
		global $DB;
		global $TEAM_GAME_VIEW;
		
		$query = "SELECT
  				(
         			SELECT SUM(NetPassYds)
         			FROM ".$TEAM_GAME_VIEW." 
         			WHERE Name = '".$teamName."'
     			) AS PassEarned,
    			(
         			SELECT SUM(NetPassYds)
         			FROM ".$TEAM_GAME_VIEW." 
         			WHERE Opponent = '".$teamName."'
     			) AS PassAllowed,
     			(
         			SELECT SUM(RushYds)
         			FROM ".$TEAM_GAME_VIEW." 
         			WHERE Name = '".$teamName."'
     			) AS RushEarned,
     			(
         			SELECT SUM(RushYds)
         			FROM ".$TEAM_GAME_VIEW." 
         			WHERE Opponent = '".$teamName."'
     			) AS RushAllowed";
				
		// Query database and store results
		mysqli_query($DB, $query) or die('Error querying database. - Yards');
		$result = mysqli_query($DB, $query);
		
		$row = mysqli_fetch_array($result);
		return $row; 
	}
	
	/**
	 * Count Rank - Return a team's league ranking from an ordered query.
	 * param teamName - Name of team for ranking
	 * query - Ordered SQL query
	 * columnName - Name of the column containing the team names (look in this column for given team name)
	 */
	function countRank($teamName, $query, $columnName)
	{
		global $DB;
		global $TEAM_GAME_VIEW;
		
		// Query database and store results
		mysqli_query($DB, $query) or die('Error querying database. - Rank');
		$result = mysqli_query($DB, $query);
		
		// Look for team and return rank (from ordered DB query ONLY)
		$counter = 1;
		while ($row = mysqli_fetch_array($result)) 
		{
			if ($teamName == $row[$columnName])
			{
				return $counter;
			}
			$counter++;
		}
		
		// Team not found (return -1 for now)
		return -1; 	
	}
?>