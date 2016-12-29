<?php // Get team names json and decode into basic array
//$teamNames = json_decode(str_replace('\\', '', $_REQUEST['teamNames']));
// Get rest of radio button parameters
//$wonLost = $_REQUEST['wonLost'];

$query = buildQuery();

// Create MySQL connection.
//$db = mysqli_connect('localhost', 'Read_User', 'readOnly', 'test') or die('Error connecting to MySQL server.');
$db = mysqli_connect('localhost', 'Read_User', 'readOnly', 'ffdatabase') or die('Error connecting to MySQL server.');


// Query database using variables
mysqli_query($db, $query) or die('Error querying database.');

// Store results
$result = mysqli_query($db, $query);

// Echo row count of results and user query (query for testing)
echo "<h5 class=\"row-count\">Number of Results: " . mysqli_num_rows($result) . "</h5>";
//echo $query;

// Create table opening tag & headers
// Also add div for bootstrap responsive table
echo "<div class=\"table-responsive\"><table id=\"output-table\" class=\"table table-striped table-hover sortable\">
		  <thead><tr><th>GameID</th><th>Date</th><th>Week</th><th>Day</th><th>Time</th>
		  <th>Winner</th><th>Loser</th><th>WinScore</th><th>LoseScore</th><th>Duration</th><th>Stadium</th>
		  <th>Atten</th><th>Roof</th><th>Surface</th><th>Temp</th><th>Humid</th><th>Wind</th>
		  <th>Favored</th><th>Spread</th><th>Covered</th><th>OULine</th><th>OUResult</th></tr></thead><tbody>";

// Iterate results
while ($row = mysqli_fetch_array($result)) {
	// Build results into table
	echo "<tr><td>" . $row['GameID'] . "</td>
			  <td>" . $row['Date'] . "</td>
			  <td>" . $row['Week'] . "</td>
			  <td>" . $row['Day'] . "</td>
			  <td>" . $row['Time'] . "</td>
			  <td>" . $row['Winner'] . "</td>
			  <td>" . $row['Loser'] . "</td>
			  <td>" . $row['WinScore'] . "</td>
			  <td>" . $row['LoseScore'] . "</td>
			  <td>" . $row['Duration'] . "</td>
			  <td>" . $row['Stadium'] . "</td>
			  <td>" . $row['Attendance'] . "</td>
			  <td>" . $row['Roof'] . "</td>
			  <td>" . $row['Surface'] . "</td>
			  <td>" . $row['Temp'] . "</td>
			  <td>" . $row['Humidity'] . "</td>
			  <td>" . $row['Wind'] . "</td>
			  <td>" . $row['Favored'] . "</td>
			  <td>" . $row['Spread'] . "</td>
			  <td>" . $row['SpreadCovered'] . "</td>
			  <td>" . $row['OULine'] . "</td>
			  <td>" . $row['OUResult'] . "</td></tr>";
}

// Close table
echo "</tbody></table></div>";

// Close connection to database
mysqli_close($db);
?>

<?php
function buildQuery() {
	$query = "";

	// --- Decode JSON and begin building query with selected teams --->
	$teamNames = json_decode(str_replace('\\', '', $_REQUEST['teamNames']));
	$wonLost = $_REQUEST['wonLost'];

	if ($teamNames[0] != '%' && $teamNames[0] != null) {
		// Format selected team names into sql query
		$teamQuery = getTeamQuery($teamNames);

		// Check won/lost radio value
		if ($wonLost == "won") {
			//$query .= "SELECT * FROM 2016_Game_View WHERE Winner IN " . $teamQuery . "AND ";
			$query .= "SELECT * FROM GameView WHERE Winner IN " . $teamQuery . "AND ";
		} elseif ($wonLost == "lost") {
			//$query .= "SELECT * FROM 2016_Game_View WHERE Loser IN " . $teamQuery . "AND ";
			$query .= "SELECT * FROM GameView WHERE Loser IN " . $teamQuery . "AND ";
		} else {
			//$query .= "SELECT * FROM 2016_Game_View WHERE (Winner IN " . $teamQuery . "OR Loser IN" . $teamQuery . ") AND ";
			$query .= "SELECT * FROM GameView WHERE (Winner IN " . $teamQuery . "OR Loser IN" . $teamQuery . ") AND ";
		}
	} else {
		// All teams selected
		//$query .= "SELECT * FROM 2016_Game_View WHERE ";
		$query .= "SELECT * FROM GameView WHERE ";
	}

	// --- Add indoor/outdoor constraint --->
	$query .= "Roof LIKE '" . $_REQUEST['roof'] . "' AND ";

	// --- Add surface type constraint --->
	$query .= "Surface LIKE '" . $_REQUEST['surface'] . "' AND ";

	// --- Add spread covered constraint --->
	$spread = $_REQUEST['spread'];
	if ($spread == "%")
	{
		$query.= "(SpreadCovered LIKE '".$spread."' OR SpreadCovered IS NULL) AND ";
	}
	else {
		$query .= "SpreadCovered LIKE '" .$spread . "' AND ";
	}
	//$query .= "SpreadCovered LIKE '" . $_REQUEST['spread'] . "' AND ";

	// --- Add over/under constraint --->
	$query .= "OUResult LIKE '" . $_REQUEST['overUnder'] . "' AND ";

	// --- Add start/end week constraint --->
	if ($_REQUEST['end'] == null) 
	{
		$endWeek = "21";
	} else {
		$endWeek = $_REQUEST['end']; 
	}
	$query .= "Week BETWEEN " .$_REQUEST['start'] ." AND ". $endWeek;
	
	// Add year constraint --->
	if ($_REQUEST['startYear'] != 'allYears')
	{
		$query.= " AND Date BETWEEN '".$_REQUEST['startYear']."-04-20' AND '".$_REQUEST['endYear']."-04-20'";
	}
	
	return $query;
}
?>

<?php
// Create sql IN statement for the given team array
function getTeamQuery($array) {
	// Begin building sql query string
	$result = "(";

	// Iterate each item in array and append to string with appropriate commas
	for ($i = 0; $i < sizeof($array); $i++) {
		$result .= "'" . $array[$i] . "'";

		// Do not append a comma on last value (mysql say no way)
		if ($i == (sizeof($array) - 1)) {
			return $result .= ")";
		} else {
			$result .= ",";
		}
	}
}
?>