# Fantasy-Football-Database
### Fantasy football data scraping bots, relational database, and data analysis.
-----
### Directory Tree:

- **analysis** - Data analysis, charts, & projections.
- <a href="https://github.com/edavis25/Fantasy-Football-Database/tree/master/dashboard">**dashboard**</a> - Web browser dashboard front-end
- <a href="https://github.com/edavis25/Fantasy-Football-Database/tree/master/database">**database**</a> - Relational database, SQL scripts, dump files, and raw data.
  - **data** - All scraped raw data. Duplicate player information.
    - <a href="https://github.com/edavis25/Fantasy-Football-Database/tree/master/database/data/2016">**2016**</a> - Current working data for 2016-17 season.
    - Everything else = mess of 2005-2015 data.
  - **schema** - SQL scripts, views, and data dump files.
    - <a href="https://github.com/edavis25/Fantasy-Football-Database/tree/master/database/schema/views">**SQLite**</a> - SQLite DB Schema and Views
    - <a href="https://github.com/edavis25/Fantasy-Football-Database/tree/master/database/schema/MySQL">**MySQL**</a> - MySQL DB Schema and Views
- <a href="https://github.com/edavis25/Fantasy-Football-Database/tree/master/data-scrapers">**data-scrapers**</a> - R and Java web bots used to scrape data.
  - **UpdatePlayerStatus** - Java app scrapes nfl.com for rosters and updates player status in DB.
  - **fantasy-java-library** - Small .jar file with commonly used functions in the java scrapers.

#### TODO:
- [ ] Backup DB
- [ ] Add 2016 postseason data
- [ ] Clean project directory
