/*
 * Javascript Helper Functions for Dashboard
 */

function setRankColors()
{
	var elements = document.getElementsByClassName("ranking-value");
	for (var i = 0, end = elements.length; i < end; i++)
	{
		// Parse rank as integer
		var parsed = parseInt(elements[i].innerHTML);
		// Set colors for rank (4 colors, 8 teams per color)
		if (parsed <= 8)
		{
			$(elements[i]).addClass("rank-color-green")
		}
		else if (parsed <= 16)
		{
			$(elements[i]).addClass("rank-color-yellow")
		}
		else if (parsed <= 24)
		{
			$(elements[i]).addClass("rank-color-orange")
		}
		else
		{
			$(elements[i]).addClass("rank-color-red")
		}
	}
}
