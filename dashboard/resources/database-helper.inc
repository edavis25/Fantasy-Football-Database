<?php
	/**
	 * PHP Database helper functions
	 * NOTES:
	 *  1) Global variable for date for SQL queries?
	 */
	
	//Create Global Database
	$DB = mysqli_connect('localhost', 'Read_User', 'readOnly', 'ffdatabase') or die('Error connecting to MySQL server.');
	
	function getOffRank($teamName)
	{
		$query = "SELECT
 					Name,
 					((SUM(PassYds) * 0.04) + (SUM(PassTds) * 6) + (SUM(RushYds) * 0.1) + (SUM(RushTds) * 6) + (SUM(FL) * - 2) + (SUM(Ints) * - 1)) AS OffRank
 					FROM TeamGameView
 					WHERE Date > '2016-04-20'
 					GROUP BY Name
 					ORDER BY OffRank DESC";
		
		return countRank($teamName, $query, 'Name');
	}
	
	function getDefRank($teamName)
	{
		$query = " SELECT
 					Opponent,
 					((SUM(PassYds) * 0.04) + (SUM(PassTds) * 6) + (SUM(RushYds) * 0.1) + (SUM(RushTds) * 6) + (SUM(FL) * - 2) + (SUM(Ints) * - 1)) AS OffRank
 					FROM TeamGameView
 					WHERE Date > '2016-04-20'
 					GROUP BY Opponent
 					ORDER BY OffRank ASC";
 		
		return countRank($teamName, $query, 'Opponent');
	}
	
	function getRushRank($teamName)
	{
		$query = "SELECT
 						Name,
 						((SUM(RushYds) * 0.1) + (SUM(RushTds) * 6) + (SUM(FL) * - 2)) AS OffRank
 					FROM TeamGameView
 					WHERE Date > '2016-04-20'
 					GROUP BY Name
 					ORDER BY OffRank DESC";
					
		return countRank($teamName, $query, 'Name');
	}
	
	function getPassRank($teamName)
	{	
		$query = "SELECT
 					Name,
 					((SUM(PassYds) * 0.1) + (SUM(PassTds) * 6) + (SUM(Ints) * - 2)) AS OffRank
 				FROM TeamGameView
 				WHERE Date > '2016-04-20'
 				GROUP BY Name
 				ORDER BY OffRank DESC";
 				
 		return countRank($teamName, $query, 'Name');
	}
	
	function getRecord($teamName, $outcome)
	{
		global $DB;
		
		$query = "SELECT 
    				(SELECT 
        				COUNT(Won)
    				FROM TeamGameView
    				WHERE Date > '2016-04-20'
    				AND Won = 'Y'
    				AND Name = '".$teamName."') AS Won,
    				(SELECT 
        				COUNT(Won)
    				FROM TeamGameView
    				WHERE Date > '2016-04-20'
    				AND Won = 'N'
    				AND Name = '".$teamName."') AS Lost";
		
		// Query database and store results
		mysqli_query($DB, $query) or die('Error querying database.');
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
	
	function getYardTotals($teamName)
	{
		global $DB;
		
		$query = "SELECT
  				(
         			SELECT SUM(NetPassYds)
         			FROM TeamGameView
         			WHERE Date > '2016-04-20'
         			AND Name = '".$teamName."'
     			) AS PassEarned,
    			(
         			SELECT SUM(NetPassYds)
         			FROM TeamGameView
         			WHERE Date > '2016-04-20'
         			AND Opponent = '".$teamName."'
     			) AS PassAllowed,
     			(
         			SELECT SUM(RushYds)
         			FROM TeamGameView
         			WHERE Date > '2016-04-20'
         			AND Name = '".$teamName."'
     			) AS RushEarned,
     			(
         			SELECT SUM(RushYds)
         			FROM TeamGameView
         			WHERE Date > '2016-04-20'
         			AND Opponent = '".$teamName."'
     			) AS RushAllowed";
				
		// Query database and store results
		mysqli_query($DB, $query) or die('Error querying database.');
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
		
		// Query database and store results
		mysqli_query($DB, $query) or die('Error querying database.');
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