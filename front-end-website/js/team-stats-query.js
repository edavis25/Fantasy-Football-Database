$(document).ready(function()
{
	$("#submit-button").on('click', function()
	{
		populateTable();
	});
});

function populateTable()
{
	var phpVars = "";
	var xhttp = new XMLHttpRequest();
	document.getElementById("output-div").innerHTML = "<img src=\"img/loader-red.gif\" />";
	xhttp.onreadystatechange = function() 
	{
		if (this.readyState == 4 && this.status == 200) 
		{
			document.getElementById("output-div").innerHTML = this.responseText;
		}
	};
	// False = synchronous call to Ajax making Javascript wait to continue. Otherwise, sortable will execute before table loads.
	//xhttp.open("GET", "/php/game-query.php?teamNames=" + teamNamesJSON, false);	
	xhttp.open("GET", "/php/team-stats-query.php" + phpVars, false);	
	xhttp.send();
	
	var outputTable = document.getElementById("output-table");
	sorttable.makeSortable(outputTable);
}
