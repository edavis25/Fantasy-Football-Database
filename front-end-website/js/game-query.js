/** ==============================================================
 * Scripts specific to the Game Query page
 * @author Eric Davis
 * 
 * I.     Listeners/Event Handlers
 * II.    Table query scripts
 * III.   Chart building scripts  
 * ============================================================== */


/* ============================================================
 * ==  I. Listeners/Event Handlers	===========================
 * ============================================================ */
$(document).ready(function()
{	
	/*
	 * Clear all form data
	 */
	clearForm();
	
	/*
	 * Start year/week Select box changes 
	 */
	$("#start-year").on("change", function()
	{
		populateEndBox("start-year", "end-year", "allYears", 1, true);				
	});
	$("#start-week").on("change", function()
	{
		populateEndBox("start-week", "end-week", 0, 20, false);
	});
	
	/*
	 * Spread Covered Chart Button Click
	 */
	$('#spread-covered-button').on('click', function()
	{
		$('#spread-covered-modal').modal('show');
		
		// Create array of objects for counting the values in the column. Every time the tableValue is found
		// in the table column, increment data. The number in data will be sum of matching elements to use in piechart.
		var objects = [];
		objects.push({title:'Covered', data: 0, tableValue: 'Y'});
		objects.push({title:'Not Covered', data: 0, tableValue: 'N'});
		
		// Count values in HTML table that match the provided objects in the array
		columnCounter(20, objects, true, "Push");
		// Format the results to match the needed Data property nested array type needed by Highcharts
		var dataArray = [];
		buildPiechartDataArray(objects, dataArray);
		// Draw the pie chart using formated array.
		drawPieChart("Spread Covered", dataArray, "Spread Covered Percentage", "#spread-modal-output");
	});
	
	/*
	 * Over/Under Chart Button Click
	 */
	$('#ou-button').on('click', function()
	{
		$('#ou-modal').modal('show');
		var objects = [];
		objects.push({title:'Over', data: 0, tableValue: 'O'});
		objects.push({title:'Under', data: 0, tableValue: 'U'});
		objects.push({title:'Push', data: 0, tableValue: 'P'});
		
		// Count values in HTML table that match the provided objects in the array
		columnCounter(22, objects);
		// Format the results to match the needed Data property nested array type needed by Highcharts
		var dataArray = [];
		buildPiechartDataArray(objects, dataArray);
		// Draw the pie chart using formated array.
		drawPieChart("Over/Under Result", dataArray, "Over/Under Percentage", "#ou-modal-output");
	});
	
	/*
	 * Won/Lost Chart Button Click
	 */
	$('#wl-button').on('click', function()
	{
		$('#wl-modal').modal('show');
		var teamNames = getSelectedOptions("select-team");
		var team = teamNames[0];
		var objects = [];
		objects.push({title:'Won', data: 0, tableValue: team});
		columnCounter(6, objects, true, "Lost");
		// Format the results to match the needed Data property nested array type needed by Highcharts
		var dataArray = [];
		buildPiechartDataArray(objects, dataArray);	
		// Draw the pie chart using formated array.
		drawPieChart("Won/Lost Percentages", dataArray, "Won/Lost Percentage", "#wl-modal-output");
	});
	
}); //End Document Ready Block


/* ============================================================
 * ==  II. Table Query Scripts	===============================
 * ============================================================ */

/**
 * Team Query - Call the Game Query php script to populate table
 */
function teamQuery()
{
	var teamNames = getSelectedOptions("select-team");
	var teamNamesJSON = JSON.stringify(teamNames);
	var wonLost = getRadioSelected("won-radios");
	var roof = getRadioSelected("roof-radios");
	var surface = getRadioSelected("surface-radios");
	var spread = getRadioSelected("spread-radios");
	var overUnder = getRadioSelected("overUnder-radios");
	var startWeek = document.getElementById("start-week").value;
	var endWeek = document.getElementById("end-week").value;
	var startYear = document.getElementById("start-year").value;
	var endYear = document.getElementById("end-year").value;

	// Build URL parameter string for PHP script
	var phpVars = "?teamNames="+teamNamesJSON+ "&wonLost="+ wonLost+ "&roof="+roof +"&surface="+surface +"&spread="
								+ spread +"&overUnder="+ overUnder+ "&start="+startWeek +"&end="+endWeek +"&startYear="+startYear +"&endYear="+endYear;
	
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
	xhttp.open("GET", "/php/game-query.php" + phpVars, false);	
	xhttp.send();
	
	var outputTable = document.getElementById("output-table");
	sorttable.makeSortable(outputTable);
}



/* ============================================================
 * ==  III. Chart Building Scripts	===========================
 * ============================================================ */

/* =========================================
 * =========  Pie Charts   =================
 * ========================================= */
/**
 * Take object array containing the title, data, and table values used from the columnCounter. Format
 * the newArray to the correct nested array format needed by the Data property in the HighCharts pie
 * chart creation.
 */
function buildPiechartDataArray(objectArray, newArray)
{
	for (var i = 0; i < objectArray.length; i++)
	{
		newArray.push([objectArray[i].title, objectArray[i].data]);
	}
}
		
/**
 * Receive an array of objects with properties for data and table value. The table value
 * is compared against the innerHTML of given table column to look for matching values to build pie chart
 * example: Y/N  O/U . For every match, the object's data is incremented to build the value used 
 * for the pie chart.
 * @param {Number} colNum HTML table's column number with desired data
 * @param {Array} array Reference to the array being manipulated
 * @param {Boolean} other -Optional- Define if function should create a new object in original array to handle
 * 						  undefined cases (cases not matching any objects tableValue) 
 * @param {Boolean} otherTitle -Optional- Define a title for the newly created column
 */
function columnCounter(colNum, array, other, otherTitle)
{
	other = other || false;
	otherTitle = otherTitle || "Other";
	var totalFound = 0;
	var cells = document.querySelectorAll("table td:nth-child("+ colNum +")");
				
	for (var i = 0; i < cells.length; i++) 
	{
		for (var j = 0; j < array.length; j++)
		{
			if (cells[i].innerHTML == array[j].tableValue)
			{
				array[j].data += 1;
				totalFound++;
			}
		}
	}
	
	// Add an extra object to the array containing number of results not matching the tableValues in the other objects
	// Only if function was called with the other paramater = true.
	if(other)
	{
		array.push({title: otherTitle, data: (cells.length - totalFound)});
	}
}

/**
 * 
 * @param {Object} chartTitle
 * @param {Object} dataArray
 * @param {Object} hoverTitle
 * @param {Object} outputElement
 */
function drawPieChart(chartTitle, dataArray, hoverTitle, outputElement)
{
	// Colors for pie chart
	Highcharts.setOptions(
	{
		colors: ['#3fad46', '#d9534f', 'ededed']
	});
    			
    // Create chart
    var chart = 
    {
    	plotBackgroundColor: null,
    	plotBorderWidth: null,
    	plotShadow: false
    };
    var title =
    {
    	text: chartTitle,
    	style:
    	{
    		fontFamily: 'Audiowide'
    	}
    };
    var tooltip = 
    {
		pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
    };
	var plotOptions = 
	{
		pie: 
		{
			allowPointSelect: true,
			cursor: 'pointer',
			dataLabels:
			{
				enabled: true,
				format: '<b>{point.name}%</b>: {point.percentage:.1f} %',
				style:
				{
					//color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black',
					fontSize: '12px',
					fontFamily: 'Consolas'
				}
			}
		}
	};
	// Set table data
	var series =
	[{
		type: 'pie',
		name: hoverTitle,
		data: dataArray
	}];
	
	//jsonify the chart	
	var json = {};
	json.chart = chart;
	json.title = title;
	json.tooltip = tooltip;
	json.series = series;
	json.plotOptions = plotOptions;

	// Set chart to html element
	$(outputElement).highcharts(json);						
}


/* =========================================
 * =========  Line Charts   ================
 * ========================================= */

