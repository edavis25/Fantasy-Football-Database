<?php

	// Create MySQL connection. Params=(host, DB username, DB passwword, name of Database)
	$db = mysqli_connect('localhost', 'Read_User', 'readOnly', 'ffdatabase') or die('Error connecting to MySQL server.');
	// Create query
	$query = "SELECT * FROM TeamGameView WHERE Date BETWEEN '2010-04-20' AND '2017-04-20'"; //Add whatever query desired
	
	// Query database using variables
	mysqli_query($db, $query) or die('Error querying database.');
	
	echo "<h5 class=\"row-count\">Number of Results: " . mysqli_num_rows($result) . "</h5>";
	echo "<div class=\"table-responsive\"><table id=\"output-table\" class=\"table table-striped table-hover sortable\">
		  <thead><tr><th>Team</th><th>Date</th><th>Week</th><th>Day</th><th>Time</th>
		  <th>Won</th><th>Opponent</th><th>TeamScore</th><th>OppScore</th><th>Duration</th><th>Stadium</th>
		  <th>Home</th><th>Roof</th><th>Surface</th><th>Temp</th><th>Humid</th><th>Wind</th>
		  <th>1stD</th><th>RushAtt</th><th>RushYds</th><th>RushTds</th><th>PassComp</th>
		  <th>PassAtt</th><th>PassYds</th><th>PassTds</th><th>Ints</th><th>SkTaken</th>
		  <th>SkYds</th><th>NetPassYds</th><th>TotalYds</th><th>Fmb</th><th>FL</th>	
		  <th>Turnovers</th><th>Pen</th><th>PenYds</th><th>3rdM</th><th>3rdAtt</th>
		  <th>4thM</th><th>4thAtt</th><th>TOP</th><th>Q1</th><th>Q2</th>
		  <th>Q3</th><th>Q4</th><th>OT</th>
		  </tr></thead><tbody>";
	
	
	// Store results
	$result = mysqli_query($db, $query);
	
	// Iterate results
	while ($row = mysqli_fetch_array($result)) 
	{
		echo "<tr><td>" . $row['Name'] . "</td>
			  <td>" . $row['Date'] . "</td>
			  <td>" . $row['Week'] . "</td>
			  <td>" . $row['Day'] . "</td>
			  <td>" . $row['Time'] . "</td>
			  <td>" . $row['Won'] . "</td>
			  <td>" . $row['Opponent'] . "</td>
			  <td>" . $row['TotalScore'] . "</td>
			  <td>" . $row['OppScore'] . "</td>
			  <td>" . $row['Duration'] . "</td>
			  <td>" . $row['Stadium'] . "</td>
			  <td>" . $row['Home'] . "</td>
			  <td>" . $row['Roof'] . "</td>
			  <td>" . $row['Surface'] . "</td>
			  <td>" . $row['Temp'] . "</td>
			  <td>" . $row['Humidity'] . "</td>
			  <td>" . $row['Wind'] . "</td>
			  <td>" . $row['1stDowns'] . "</td>
			  <td>" . $row['RushAtt'] . "</td>
			  <td>" . $row['RushYds'] . "</td>
			  <td>" . $row['RushTds'] . "</td>
			  <td>" . $row['PassComp'] . "</td>
			  <td>" . $row['PassAtt'] . "</td>
			  <td>" . $row['PassYds'] . "</td>
			  <td>" . $row['PassTds'] . "</td>
			  <td>" . $row['Ints'] . "</td>
			  <td>" . $row['SkTaken'] . "</td>
			  <td>" . $row['SkYds'] . "</td>
			  <td>" . $row['NetPassYds'] . "</td>
			  <td>" . $row['TotalYds'] . "</td>
			  <td>" . $row['Fmb'] . "</td>
			  <td>" . $row['FL'] . "</td>
			  <td>" . $row['Turnovers'] . "</td>
			  <td>" . $row['Pen'] . "</td>
			  <td>" . $row['PenYds'] . "</td>
			  <td>" . $row['3rdM'] . "</td>
			  <td>" . $row['3rdAtt'] . "</td>
			  <td>" . $row['4thM'] . "</td>
			  <td>" . $row['4thAtt'] . "</td>
			  <td>" . $row['TOP'] . "</td>
			  <td>" . $row['Q1'] . "</td>
			  <td>" . $row['Q2'] . "</td>
			  <td>" . $row['Q3'] . "</td>
			  <td>" . $row['Q4'] . "</td>
			  <td>" . $row['OT'] . "</td>
 </tr>";
	}
	
	// Close connection to database
	mysqli_close($db);

?>
