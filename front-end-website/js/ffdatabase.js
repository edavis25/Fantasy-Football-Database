/**
 * Get Column Values - Return array containing string values from the specified table column number.
 *(Column numbers are not 0 based. Ex: The first column in a table is column 1)
 * param {Integer} columnNumber - Integer value specifying desired column
 * param {Function} parseFunction - (Optional) function to parse the column values
 * return {String[]} Returns an array of string values  
 */
function getColumnValues(columnNumber, parseFunction) 
{
	var result = [];

	var cells = document.querySelectorAll("table td:nth-child(" + columnNumber + ")");

	for (var i = 0; i < cells.length; i++) {
		if (typeof parseFunction === "function")
		{
			result.push(parseFunction(cells[i].innerHTML));
		}
		else 
		{
			result.push(cells[i].innerHTML);
		}	
	}

	return result;
}




/* Change nav button text based on screen size for page load and page resize */
$(window).bind("load resize", function() 
{
	var text = document.getElementById("menu-toggle").firstChild;
	if (screen.width <  768)
	{
		text.data = ">>Nav";
	}
	else
	{
		text.data ="<<Nav";
	}
});



function populateEndBox(startID, endID, allVal, maxIndex, descending)
{
	// Clear end box each time a value is changed
	document.getElementById(endID).options.length = 0;
	var startValue = document.getElementById(startID).value;
	
	// If select box option for all is chosen
	if (startValue == allVal)
	{
		$("#"+endID).attr('disabled', 'disabled');
	}
	else
	{
		$("#"+endID).removeAttr('disabled');
		
		var startOptions = document.getElementById(startID).options;
		var endElement = document.getElementById(endID);
		var maxValue = parseInt(document.getElementById(startID).options[maxIndex].value);
		
		if (descending)
		{
			var selectedIndex = document.getElementById(startID).selectedIndex;
			
			while (selectedIndex >= maxIndex)
			{
				var option = document.createElement("option");
				option.value = parseFloat(startOptions[selectedIndex].value) +1; // Parse and add 1 so end cannot equal start
				option.text = parseFloat(startOptions[selectedIndex].text) +1;
				endElement.add(option);
				selectedIndex--;
			}
		}
		else
		{
			var selectedIndex = document.getElementById(startID).selectedIndex;
			while (selectedIndex <= maxIndex)
			{
				var option = document.createElement("option");
				option.value = startOptions[selectedIndex].value;
				option.text = startOptions[selectedIndex].text;
				endElement.add(option);
				selectedIndex++;
			}
		}
	}
}


/*
 * Toggle the << button when clicked to represent nav hiding action
 * Currently moved  to  event listener 
 */
function toggleCollapseButton()
{
	var text = document.getElementById("menu-toggle").firstChild;
	text.data = text.data == ">>Nav" ? "<<Nav" : ">>Nav";
}


/*
 * Get seletected items from <select>
 * @param {String} String HTML ID of the <select> element
 * @return {Array} Array of selected values
 */
function getSelectedOptions(selectID)
{
	var result = [];
	var options = document.getElementById(selectID).options;
  
  	for (var i = 0; i < options.length; i++)
  	{
    	if (options[i].selected)
    	{
      		result.push(options[i].value);
    	}
  	}
  	return result;
}


/*
 * @param {String} HTML Name for group of radio buttons
 * @return {String} Value for selected radio button
 */
function getRadioSelected(elementName)
{
	var radios = document.getElementsByName(elementName);

	for (var i = 0, length = radios.length; i < length; i++) 
	{
    	if (radios[i].checked) 
    	{
        	return radios[i].value;
        }
    }
}


/*
 * Enable or disable buttons of given class
 */
function enableButtons(enabled, className)
{
	//var buttons = document.getElementsByClassName(className);
	
	if (enabled)
	{
		$("."+ className).removeAttr('disabled');
	}
	else
	{
		$("."+ className).attr('disabled', 'disabled');
	}
}


/*
 * Disable/Enable WonLost button based on the number of teams selected.
 * Enable ONLY when 1 team selected 
 */
function setWonLostButton()
{
	var teamNames = getSelectedOptions("select-team");
	if (teamNames.length > 1 || teamNames[0] == "%")
	{
		$("#wl-button").attr('disabled', 'disabled');
	}
}



function clearForm()
{
	// Reset form
	$("#game-form").trigger("reset");
		
	// Clear and disable select boxes
	$(".disable-on-clear option").each(function(index, option)
	{
		$(option).remove();
	});
		
	$(".disable-on-clear").attr("disabled", "disabled");
}

/* *******************************************************
 ************  EVENT LISTENERS  **************************
 *********************************************************/
$(document).ready(function()
{
	/*
	 * Add all tooltips to document
	 */
	$('.add-tooltip').tooltip();
	
	
	/* 
	 * MOVED TO SPECIFIC PAGE SCRIPT -
	 
	 * Start year/week Select box changes 
	
	$("#start-year").on("change", function()
	{
		populateEndBox("start-year", "end-year", "allYears", 1, true);				
	});
	$("#start-week").on("change", function()
	{
		populateEndBox("start-week", "end-week", 0, 20, false);
	});
	*/
	
	/*
	 * Run Query Submit Button
	*/
	enableButtons(false, "viz-buttons");
	$(".submit-button").on("click", function()
	{
		 enableButtons(false, "viz-buttons");
		 teamQuery();
		 enableButtons(true, "viz-buttons");
		 setWonLostButton();
	});
 	
	
	/*
	 * Clear All Button
	 */ 
	$(".clear-button").on("click", function()
	{
		// Reset form
		$("#game-form").trigger("reset");
		
		// Clear and disable select boxes
		$(".disable-on-clear option").each(function(index, option)
		{
			$(option).remove();
		});
		
		$(".disable-on-clear").attr("disabled", "disabled");
	});
	
	
	/*
	 * Toggle Nav Button
	 */
	$("#menu-toggle").on("click", function()
	{
		var text = document.getElementById("menu-toggle").firstChild;
		text.data = text.data == ">>Nav" ? "<<Nav" : ">>Nav";
	});
	
	
	/* 
	 * Smooth scroll snippet for anchors on same page (W3 I think?)
	 */
	$(".smooth-scroll").on('click', function(event) {

    // Make sure this.hash has a value before overriding default behavior
    if (this.hash !== "") {
      // Prevent default anchor click behavior
      event.preventDefault();

      // Store hash
      var hash = this.hash;

      // Using jQuery's animate() method to add smooth page scroll
      // The optional number (600) specifies the number of milliseconds it takes to scroll to the specified area
      $('html, body').animate({
        scrollTop: $(hash).offset().top
      }, 600, function(){
   
        // Add hash (#) to URL when done scrolling (default click behavior)
        window.location.hash = hash;
      });
    } // End if
  });
	
}); //<--  End document.ready()




