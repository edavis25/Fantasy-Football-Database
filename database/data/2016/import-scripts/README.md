###database/data/2016/import-scripts
This directory contains Random SQL functions and directions for importing 2016 data.
Some of the data is partially cleaned in CSV form and then finished cleaning using the SQL statements in this directory.


IMPORTANT --- DONT JUST RUN THESE SQL FILES!! 

Open them and follow the instructions inside!!!

Once the MySQL DB has been updated, look for discrepencies in local/server DB
	-- Players - I found it easiest to just dump MySQL table w/data and recreate
	-- Games - Dump a query restricting only the new Game rows in current DB. (Use GameID, date, etc.). Import into TEMP table and insert w/ SELECT
	-- TeamGame - Dump another query to csv restricting only the new TeamGame rows in current DB. Import into TEMP table and insert w/ SELECT
	-- PlayerGame - Dump yet another query to csv restricting only the new PlayerGame rows in the current DB. Import into TEMP table and insert w/ SELECT


NOTES: 
	1. Check foreign keys and views after updating TEMP tables
	2. Check row counts between 2 DBs
	3. Look for NULL values in any IDs
