# Fantasy-Football-Database
###Fantasy football data scraping bots, relational database, and data analysis.
-----
###Folders:

- **analysis** - Data analysis, charts, & projections.
- **database** - Relational database, SQL scripts, dump files, and raw data.
  - **data** - All scraped raw data. Duplicate player information.
  - **schema** - SQL scripts, views, and data dump files.
- **data-scrapers** - R and Java web bots used to scrape data.
  - **UpdatePlayerStatus** - Java app scrapes nfl.com for rosters and updates player status in DB.
  - **fantasy-java-library** - Small .jar file with commonly used functions in the java scrapers.
