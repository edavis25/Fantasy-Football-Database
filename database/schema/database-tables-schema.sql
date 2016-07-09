--
-- File generated with SQLiteStudio v3.0.7 on Wed Jun 22 23:50:19 2016
-- Eric Davis, Mark Eidsaune
--
-- Text encoding used: UTF-8
--
PRAGMA foreign_keys = on;
BEGIN TRANSACTION;

-- Table: TeamGame
CREATE TABLE TeamGame 
(
	TeamID VARCHAR REFERENCES Teams (TeamID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL, 
	GameID INTEGER REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL, 
	"1stDowns" INTEGER, 
	RushAtt INTEGER, 
	RushYDs INTEGER, 
	RushTDs INTEGER, 
	PassComp INTEGER, 
	PassAtt INTEGER, 
	PassYDs INTEGER, 
	PassTDs INTEGER, 
	Ints INTEGER, 
	Sacked INTEGER, 
	SackedYDs INTEGER, 
	NetPassYDs INTEGER, 
	TotalYDs INTEGER,
	Fumbles INTEGER, 
	FumblesLost INTEGER,
	Turnovers INTEGER, 
	Penalties INTEGER, 
	PenaltyYDs INTEGER, 
	"3rdM" INTEGER, 
	"3rdAtt" INTEGER, 
	"4thM" INTEGER, 
	"4thAtt" INTEGER,
	TOP VARCHAR,
	Q1 INTEGER, 
	Q2 INTEGER, 
	Q3 INTEGER, 
	Q4 INTEGER,
	OT INTEGER, 
	URL VARCHAR,
	PRIMARY KEY (TeamID, GameID)
);

-- Table: Stadiums
CREATE TABLE Stadiums 
(
	StadiumID INTEGER PRIMARY KEY AUTOINCREMENT, 
	Name VARCHAR (20), 
	Capacity INTEGER, 
	Roof CHAR 
		CONSTRAINT "Stadiums-Roof-Constraint" CHECK ((Roof IN ('Y', 'N'))), 
	Surface CHAR 
		CONSTRAINT "Stadiums-Surface-Constraint" CHECK ((Surface IN ('T', 'G')))
);

-- Table: Players
CREATE TABLE Players 
(
	PlayerID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
	Name VARCHAR NOT NULL, 
	Position VARCHAR (2) 
		CONSTRAINT "Position-Constraint" CHECK (Position IN ('QB', 'RB', 'WR', 'TE', 'K', 'P', 'OL', 'DL', 'DB', 'LB')) NOT NULL, 
	DOB DATE, 
	College VARCHAR, 
	DraftTeam VARCHAR, 
	DraftRound INTEGER, 
	DraftPick INTEGER, 
	DraftYear INTEGER
);

-- Table: Games
CREATE TABLE Games 
(
	GameID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
	Week VARCHAR, 
	Day VARCHAR,
	Date DATE NOT NULL,
	WinnerID INTEGER REFERENCES Teams (TeamID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL, 
	LoserID INTEGER REFERENCES Teams (TeamID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	WinnerScore INTEGER, 
	LoserScore INTEGER, 
	StadiumID INTEGER REFERENCES Stadiums (StadiumID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL, 
	Time TIME, 
	Duration TIME, 
	Attendance INTEGER, 
	Temperature VARCHAR, 
	Humidity VARCHAR, 
	Wind INTEGER, 
	"Favored Team" VARCHAR, 
	Spread DOUBLE, 
	OverUnder DOUBLE, 
	OUResult CHAR,
	URL VARCHAR
);

-- Table: Teams
CREATE TABLE Teams 
(
	TeamID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
	City VARCHAR (20) NOT NULL, 
	Name VARCHAR (20) NOT NULL, 
	StadiumID INTEGER REFERENCES Stadiums (StadiumID) ON UPDATE CASCADE, 
	Conference VARCHAR (3) NOT NULL CHECK (Conference IN ('AFC', 'NFC', 'NA')), 
	Division VARCHAR (5) NOT NULL CHECK (Division IN ('North', 'South', 'East', 'West', 'NA')), 
	Coach VARCHAR (20), 
	Abbr VARCHAR (3) NOT NULL, 
	OffenseStyle VARCHAR (10), 
	DefenseStyle VARCHAR (10)
);

-- Table: PlayerGame2010
CREATE TABLE PlayerGame2010 
(
	PlayerID INTEGER REFERENCES Players (PlayerID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	GameID INTEGER REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL, 
	PassCmp INTEGER, 
	PassAtt INTEGER, 
	PassYds INTEGER,
	PassTd INTEGER, 
	Int INTEGER, 
	SkTaken INTEGER, 
	SkYds INTEGER, 
	PassLng INTEGER,
	QbRating DOUBLE, 
	RushAtt INTEGER, 
	RushYds INTEGER, 
	RushTd INTEGER,
	RushLng INTEGER,
	RecTgt INTEGER,
	Receptions INTEGER,
	RecYds INTEGER,
	RecTd INTEGER,
	RecLng INTEGER,
	Fmb INTEGER, 
	FL INTEGER,
	DefInt INTEGER, 
	DefIntYds INTEGER, 
	DefIntTd INTEGER,
	DefIntLng INTEGER, 
	DefSk DECIMAL, 
	DefTkl DOUBLE,
	DefAst DOUBLE,
	DefFR INTEGER, 
	DefFRYrds INTEGER, 
	DefFRTd INTEGER,
	DefFF INTEGER, 
	KickRet INTEGER, 
	KickRetYds INTEGER, 
	KickYdsRet DOUBLE, 
	KickRetTD INTEGER,
	KickRetLng INTEGER, 
	PuntRet INTEGER, 
	PuntRetYds INTEGER,
	PuntYdsReturn DOUBLE,
	PuntRetTd INTEGER, 
	PuntRetLng INTEGER,
	XPMade INTEGER,
	XPAtt INTEGER, 
	FGMade INTEGER,
	FGAtt INTEGER, 
	URL VARCHAR
);

-- Table: TeamHomeStadium
CREATE TABLE TeamHomeStadium 
(
	StadiumID INTEGER, 
	TeamID INTEGER
);

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
