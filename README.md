# Fantasy-Football-Database
###Fantasy football data scraping bots, relational database, and data analysis.
-----
###Directory:

- **analysis** - Data analysis, charts, & projections.
- **database** - Relational database, SQL scripts, dump files, and raw data.
  - **data** - All scraped raw data. Duplicate player information.
    - **2016** - Current working data for 2016-17 season.
    - Everything else = mess of 2005-2015 data.
  - **schema** - SQL scripts, views, and data dump files.
    - **Views** - SQL Views for easier queries of relevant results.
- **data-scrapers** - R and Java web bots used to scrape data.
  - **UpdatePlayerStatus** - Java app scrapes nfl.com for rosters and updates player status in DB.
  - **fantasy-java-library** - Small .jar file with commonly used functions in the java scrapers.
