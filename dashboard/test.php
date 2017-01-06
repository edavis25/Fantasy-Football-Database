<!DOCTYPE html>
<html>
	<head>
		
		<?php include 'resources/database-helper.inc'; ?>
	</head>
	
	<body>
		<h1>OFF RANK: <?php echo getOffRank('Browns'); ?></h1>
		<h1>DEF RANK: <?php echo getDefRank('Browns'); ?></h1>
		<h1>PASS RANK: <?php echo getPassRank('Browns'); ?></h1>
		<h1>RUSH RANK: <?php echo getRushRank('Browns'); ?></h1>
		<!-- h1>RUSH RANK: <?php echo getRushRank('Browns'); ?></h1 -->
		<?php getRecord('Browns'); ?>
	</body>
	
</html>