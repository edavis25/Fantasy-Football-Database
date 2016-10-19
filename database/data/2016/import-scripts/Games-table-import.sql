-------------------------------------------------------------------
---------- GAMES Table Snippets -----------
------------------------------------------------------------------->

-- Check Table Names. Used 2 Temp Tables: GamesTemp and GamesTempTemp.
-- GamesTemp was a copy of Games and GamesTempTemp held the new imported csv data.
-- Final cleaning of GamesTempTemp followed by INSERT INTO SELECT * 

--- Correct the Stadium Names to Run Name to ID update ----->
UPDATE GamesTempTemp SET StadiumID = 'Mile High Stadium' WHERE StadiumID = 'Sports Authority Field at Mile High';
UPDATE GamesTempTemp SET StadiumID = 'Ralph Wilson Stadium' WHERE StadiumID = 'New Era Field';
UPDATE GamesTempTemp SET StadiumID = 'LA Memorial Coliseum' WHERE StadiumID = 'Los Angeles Memorial Coliseum';
UPDATE GamesTempTemp SET StadiumID = 'New Miami Stadium' WHERE StadiumID = 'Sun Life Stadium';
UPDATE GamesTempTemp SET StadiumID = 'US Bank Stadium' WHERE StadiumID = 'U.S. Bank Stadium';
UPDATE GamesTempTemp SET StadiumID = 'FedEx Field' WHERE StadiumID = 'FedExField';

--- Name to Stadium Update (After correcting above names) ----->
UPDATE GamesTempTemp SET StadiumID = (SELECT Stadiums.StadiumID FROM Stadiums WHERE GamesTempTemp.StadiumID = Stadiums.Name);

--- Insert the data imported into GamesTempTemp into GamesTemp after final cleaning ----->
INSERT INTO GamesTemp SELECT * FROM GamesTempTemp;

/*
***** RANDOM NOTES *****
- Use create similar table to create GamesTemp from Games - Run INSERT INTO SELECT * FROM Games into GamesTempTemp
- Remove foreign/primary keys from the GamesTempTemp table when importing the un-cleaned CSV dat
- Check stadium names (mismatch/spelling) - For the UPDATE statement getting ID to work
- Set GameID from imported data to NULL - So auto-increment works
- Make sure columns are in correct places
*/ 