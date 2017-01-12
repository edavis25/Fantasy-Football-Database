<?php
	$team = $_REQUEST['team'];
	
	include 'resources/database-helper.inc';
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title><?php echo $team; ?> Dashboard</title>

    <!-- Bootstrap Core CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="css/sb-admin.css" rel="stylesheet">

    <!-- Morris Charts CSS -->
    <link href="css/plugins/morris.css" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    
    <!-- Custom CSS -->
    <link href="css/ffdatabase.css" rel="stylesheet">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

</head>

<body>

    <div id="wrapper">

        <?php require 'navigation.php'; ?>

		<!-- ==================================================
			 ========== MAIN PAGE CONTENT =====================
			 ================================================== -->
        <div id="page-wrapper">
            <div class="container-fluid">
                <!-- Page Heading -->
                <div class="row">
                    <div class="col-lg-12">
                        <h1>
                            <b><?php echo $team; ?></b> <small>Dashboard</small>
                        </h1>
                        <h3 class="team-record"><?php echo getRecord($team, "wins").' - '.getRecord($team, "losses"); ?></h3>
                    </div>
                </div>
                <!-- /.row -->

				<!-- BUTTONS FORR DYNAMIC TESTING 
                <div class="row">
                    <div class="col-lg-12">
                   			<a href="#" class="teamName" id="FIRST">1</a>
							<a class="teamName" id="SECOND">2</a>
							<input type="button" id="myBtn">
                    </div>
                </div>
               -->
               
                <!-- /.row -->

                <div class="row pad-bottom-10" style="background-color: #f2f2f2; ">
                	<h3 style="border-bottom: 1px solid #e7e7e7;" class="pad-left">League Rankings</h3>
                	<!-- Container 1 - Offense Ranking -->
                    <div class="col-md-2 col-sm-4 col-xs-6 border-right">
                    	<div class="row">
                    		<!-- h1 class="ranking-label"><b>OFF</b>&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: green; font-weight: 600; font-size: 150%;">5</span></h1 -->
                    		<h1 class="ranking-value"><?php echo getOffRank($team); ?></h1>
                    	</div>
                    	<div class="row">
                    		<p class="ranking-label" style="text-align: center;">Offense</p>
                    	</div>
                    </div>
                    
                    <!-- Container 2 - Defense Ranking -->
                    <div class="col-md-2 col-sm-4 col-xs-6 border-right">
                    	<div class="row">
                    		<!-- h1 class="ranking-label"><b>OFF</b>&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: green; font-weight: 600; font-size: 150%;">5</span></h1 -->
                    		<h1 class="ranking-value"><?php echo getDefRank($team); ?></h1>
                    	</div>
                    	<div class="row">
                    		<p class="ranking-label" style="text-align: center;">Defense</p>
                    	</div>
                    </div>
                    
                    <!-- Container 3 - Rush Ranking -->
                    <div class="col-md-2 col-sm-4 col-xs-6 border-right">
                    	<div class="row">
                    		<!-- h1 class="ranking-label"><b>OFF</b>&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: green; font-weight: 600; font-size: 150%;">5</span></h1 -->
                    		<h1 class="ranking-value"><?php echo getRushRank($team); ?></h1>
                    	</div>
                    	<div class="row">
                    		<p class="ranking-label" style="text-align: center;">Rushing</p>
                    	</div>
                    </div>
                    
                    <!-- Container 4 - Pass Ranking -->
                    <div class="col-md-2 col-sm-4 col-xs-6 border-right">
                    	<div class="row">
                    		<!-- h1 class="ranking-label"><b>OFF</b>&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: green; font-weight: 600; font-size: 150%;">5</span></h1 -->
                    		<h1 class="ranking-value"><?php echo getPassRank($team); ?></h1>
                    	</div>
                    	<div class="row">
                    		<p class="ranking-label" style="text-align: center;">Passing</p>
                    	</div>
                    </div>
                    
                    <!-- Container 5 -->
                    <div class="col-md-2 col-sm-4 col-xs-6 border-right">
                    	<div class="row">
                    		<!-- h1 class="ranking-label"><b>OFF</b>&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: green; font-weight: 600; font-size: 150%;">5</span></h1 -->
                    		<h1 class="ranking-value" style="color: green;">67%</h1>
                    	</div>
                    	<div class="row">
                    		<p class="ranking-label" style="text-align: center;">Win %</p>
                    	</div>
                    </div>
                    
                    <!-- Container 6 -->
                   	<div class="col-md-2 col-sm-4 col-xs-6">
                    	<div class="row">
                    		<!-- h1 class="ranking-label"><b>OFF</b>&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: green; font-weight: 600; font-size: 150%;">5</span></h1 -->
                    		<h1 class="ranking-value">23</h1>
                    	</div>
                    	<div class="row">
                    		<p class="ranking-label" style="text-align: center;">Offense</p>
                    	</div>
                    </div>
                </div>
                <!-- /.End top container row -->

                <div class="row v-margin-15">
                    <div class="col-lg-12">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h3 class="panel-title"><i class="fa fa-bar-chart-o fa-fw"></i>  Current Season</h3>
                            </div>
                            <div class="panel-body">
                            	<div class="row">
                            		<div class="col-xs-12 col-sm-8 border-right">
                            			<div id="tester"></div>
                            		</div>
                            		<div class="col-xs-12 col-sm-4">
                            			<p>This will be the key/checkboxes</p>
                            		</div>
                            	</div>
                                <!-- div id="morris-area-chart"></div -->
                                
                            </div>
                        </div>
                    </div>
                </div>
                <!-- /.row -->
				
				<!-- 3rd Row -->
                <div class="row">
                	
                	<!-- Season Yard Totals Bar Graph -->
                    <div class="col-lg-4">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h3 class="panel-title"><i class="glyphicon glyphicon-align-left"></i> Season Totals</h3>
                            </div>
                            <div class="panel-body">
                                <div id="bar-test"></div>
                                <div class="text-right">
                                    <a href="#">View Details <i class="fa fa-arrow-circle-right"></i></a>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Season Leaders Table -->
                    <div class="col-lg-4">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h3 class="panel-title"><i class="glyphicon glyphicon-user"></i> Offensive Leaders</h3>
                            </div>
                            <div class="panel-body">
								<table class="table table-striped">
                                	<tr>
                                		<th><b>Passing</b></th><th><b>YDs</b></th><th><b>TDs</b></th><th><b>COMP</b></th><th><b>ATT</b></th><th><b>COMP%</b></th>
                                	</tr>
                                	<!-- Get Passing Leader Stats -->
									<?php 
                                		$arr = array("Name", "PassYds", "PassTD", "PassCmp", "PassAtt"); 
                                		$print = getSeasonLeader($team, $arr, 'PassYds', 2);
											
										echo "<tr><td>".$print[0][0]."</td><td>".$print[0][1]."</td><td>".$print[0][2]."</td><td>".$print[0][3]."</td><td>".$print[0][4]."</td><td>".round((($print[0][3] / $print[0][4]) * 100), 2)."</td></tr>";
										echo "<tr><td>".$print[1][0]."</td><td>".$print[1][1]."</td><td>".$print[1][2]."</td><td>".$print[1][3]."</td><td>".$print[1][4]."</td><td>".round((($print[1][3] / $print[1][4]) * 100), 2)."</td></tr>";
                                	?>

                                	</tr>
                                	<tr>
                                		<th><b>Rushing</b></th><th><b>YDs</b></th><th><b>TDs</b></th><th><b>FUMB</b></th><th><b>ATT</b></th><th><b>YDs/ATT</b></th><th>
                                	</tr>
                                	<!-- Get Rushing Leader Stats -->
                                	<?php
                                		$arr = array("Name", "RushYds", "RushTD", "Fmb", "RushAtt");
										$print = getSeasonLeader($team, $arr, 'RushYds', 2);
										
										echo "<tr><td>".$print[0][0]."</td><td>".$print[0][1]."</td><td>".$print[0][2]."</td><td>".$print[0][3]."</td><td>".$print[0][4]."</td><td>".round(($print[0][1] / $print[0][4]), 2)."</td></tr>";
										echo "<tr><td>".$print[1][0]."</td><td>".$print[1][1]."</td><td>".$print[1][2]."</td><td>".$print[1][3]."</td><td>".$print[1][4]."</td><td>".round(($print[1][1] / $print[1][4]), 2)."</td></tr>";
                                	?>


                           			<tr>
                           				<th><b>Receiving</b></th><th><b>YDs</b></th><th><b>TDs</b></th><th><b>TGT</b></th><th><b>REC</b></th><th><b>YDs/REC</b></th><th>
                           			</tr>
                           			
                           			<?php
                           				
                                		$arr = array("Name", "RecYds", "RecTds", "RecTgt", "Rec");
										$print = getSeasonLeader($team, $arr, 'RecYds', 3);
										
										echo "<tr><td>".$print[0][0]."</td><td>".$print[0][1]."</td><td>".$print[0][2]."</td><td>".$print[0][3]."</td><td>".$print[0][4]."</td><td>".round(($print[0][1] / $print[0][4]), 2)."</td></tr>";
										echo "<tr><td>".$print[1][0]."</td><td>".$print[1][1]."</td><td>".$print[1][2]."</td><td>".$print[1][3]."</td><td>".$print[1][4]."</td><td>".round(($print[1][1] / $print[1][4]), 2)."</td></tr>";
										echo "<tr><td>".$print[2][0]."</td><td>".$print[2][1]."</td><td>".$print[2][2]."</td><td>".$print[2][3]."</td><td>".$print[1][4]."</td><td>".round(($print[2][1] / $print[2][4]), 2)."</td></tr>";
                 
									?>
                           			
                           		</table>
                            </div> <!-- End pain panel body -->
                        </div>
                    </div> <!-- End Container -->
                    
                    
                    <div class="col-lg-4">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h3 class="panel-title"><i class="fa fa-money fa-fw"></i> Transactions Panel</h3>
                            </div>
                            <div class="panel-body">
                                <div class="table-responsive">
                                    <table class="table table-bordered table-hover table-striped">
                                        <thead>
                                            <tr>
                                                <th>Order #</th>
                                                <th>Order Date</th>
                                                <th>Order Time</th>
                                                <th>Amount (USD)</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>3326</td>
                                                <td>10/21/2013</td>
                                                <td>3:29 PM</td>
                                                <td>$321.33</td>
                                            </tr>
                                            <tr>
                                                <td>3325</td>
                                                <td>10/21/2013</td>
                                                <td>3:20 PM</td>
                                                <td>$234.34</td>
                                            </tr>
                                            <tr>
                                                <td>3324</td>
                                                <td>10/21/2013</td>
                                                <td>3:03 PM</td>
                                                <td>$724.17</td>
                                            </tr>
                                            <tr>
                                                <td>3323</td>
                                                <td>10/21/2013</td>
                                                <td>3:00 PM</td>
                                                <td>$23.71</td>
                                            </tr>
                                            <tr>
                                                <td>3322</td>
                                                <td>10/21/2013</td>
                                                <td>2:49 PM</td>
                                                <td>$8345.23</td>
                                            </tr>
                                            <tr>
                                                <td>3321</td>
                                                <td>10/21/2013</td>
                                                <td>2:23 PM</td>
                                                <td>$245.12</td>
                                            </tr>
                                            <tr>
                                                <td>3320</td>
                                                <td>10/21/2013</td>
                                                <td>2:15 PM</td>
                                                <td>$5663.54</td>
                                            </tr>
                                            <tr>
                                                <td>3319</td>
                                                <td>10/21/2013</td>
                                                <td>2:13 PM</td>
                                                <td>$943.45</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="text-right">
                                    <a href="#">View All Transactions <i class="fa fa-arrow-circle-right"></i></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- /.row -->

            </div>
            <!-- /.container-fluid -->

        </div>
        <!-- /#page-wrapper -->

    </div>
    <!-- /#wrapper -->

    <!-- jQuery -->
    <script src="js/jquery.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="js/bootstrap.min.js"></script>

    <!-- Morris Charts JavaScript -->
    <script src="js/plugins/morris/raphael.min.js"></script>
    <!-- script src="js/plugins/morris/morris.min.js"></script -->
    <!-- script src="js/plugins/morris/morris-data.js"></script -->
	
	<!-- Plotly -->
	<script src="https://cdn.plot.ly/plotly-latest.min.js"></script>

	<!-- Custom -->
	<script src="js/dashboard-helper.js"></script>

	
	<!-- Document Ready -->
	<script>
		$(document).ready(function()
		{
			setRankColors();
			
			
			
		});
	</script>
	
	
	<script>
		
		<?php $arr = getYardTotals($team); ?>
	
		var rushTrace = 
		{
			x: [<?php echo $arr['RushEarned']; ?>],
			y: ['Rush YDs'],
			orientation: 'h',
			marker: 
			{
				color: '#03a81c'
			},
			type: 'bar',
			showlegend: false
		};

		var rushAllowTrace = 
		{
			x: [<?php echo $arr['RushAllowed']; ?>],
			y: ['Rush YDs\nAllowed'],
			orientation: 'h',
			marker:
			{
				color: '#b71500'
			},
			type: 'bar',
			showlegend: false
		};
		
		var passTrace =
		{
			x: [<?php echo $arr['PassEarned']; ?>],
			y: ['PassYDs'],
			orientation: 'h',
			marker:
			{
				color: '#03a81c'
			},
			type: 'bar',
			showlegend: false
		};
		
		var passAllowTrace = 
		{
			x: [<?php echo $arr['PassAllowed']; ?>],
			y: ['Pass YDs\nAllowed'],
			orientation: 'h',
			marker:
			{
				color: '#b71500'
			},
			type: 'bar',
			showlegend: false
		};

		var data = [rushAllowTrace, rushTrace, passAllowTrace, passTrace];
		var layout = 
		{
			// Margin removes empy chart title space
			margin: 
			{
				t: 45,
    			pad: 4
  			},
			barmode: 'stack'
		};
		Plotly.newPlot('bar-test', data, layout);
		
		
		
		// Plotly Testing BAR GRAPH
		/*
		var data = [{
  		type: 'bar',
  			x: [729, 1223, 954, 1392],
 			y: ['Rush YDs\nAllowed', 'Rush YDs','Pass YDs\nAllowed', 'Pass YDs'],
  			orientation: 'h'
		}];

		Plotly.newPlot('bar-test', data);
		*/
	</script>
		
	<script>
		//Plotly Testing LINE GRAPH
		TESTER = document.getElementById('tester');
		Plotly.plot( TESTER, [{
		x: [1, 2, 3, 4, 5],
		y: [1, 2, 4, 8, 16] }], {
		margin: { t: 0 } } );
		
		Plotly.plot( TESTER, [{
		x: [1, 2, 3, 4, 5],
		y: [3, 2, 3, 2, 8] }], {
		margin: { t: 0 } } );
		
		Plotly.plot( TESTER, [{
		x: [1, 2, 3, 4, 5],
		y: [11, 6, 8, 12, 8] }], {
		margin: { t: 0 } } );
	</script>
	
</body>

</html>
