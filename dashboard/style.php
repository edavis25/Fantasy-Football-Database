<?php

	function create($num)
	{
		echo $num;
	}

?>

<!DOCTYPE html>
<html>
	<head>
		<!-- jQuery 3.1.1 -->
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
		<!-- Bootstrap 3.3.7 CSS & JavaScript-->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	</head>
	<body>
		<h1 class="league-rank"><?php create(1); ?></h1>
		<h1 class="league-rank"><?php create(11); ?></h1>
		<h1 class="league-rank"><?php create(21); ?></h1>
		
		<script>
			function changeColor()
			{
				var elements = document.getElementsByClassName("league-rank");
				for (var i = 0; i < elements.length; i++)
				{
					var parse = parseInt(elements[i].innerHTML);
					
					if (parse <= 10)
					{
						$(elements[i]).css( {color: "green"});
					}
					else if (parse <= 20)
					{
						$(elements[i]).css( {color: "orange"});
					}
					else
					{
						$(elements[i]).css( {color: "red"});
					}
				}
			}
			$(document).ready(function()
			{
				changeColor();
			});
		</script>
	</body>
</html>