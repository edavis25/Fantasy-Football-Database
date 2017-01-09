-------------------------------------------------------------------
---------- Players Table Update -----------------------
------------------------------------------------------------------->

-- Make sure to update Players Table before the PlayerGame table (obviously)

-- Run the search script to find players that are going to be added that are currently missing from the DB

-- Add all missing players to DB
	-- Problem Players:
		-- De'Vante Bausby - in DB as DeVante Bausby
		-- William Compton - In DB as Will Compton
		-- Seth Devalve - In DB as Seth DeValve
		-- Joshua Perkins - In DB as Josh Perkins
		-- Robert Kelley - In DB as Rob Kelley
		-- JJ Nelson - In DB as J.J. Nelson (periods)
		-- Matthew Bosher - In DB as Matt Bosher
		-- Ladarius Gunter - In DB as LaDarius Gunter
		-- Trenton Brown - In DB as Trent  Brown
		-- Leterrius Walton - In DB as L.T. Walton
		-- C.B. Bryant - In DB as Christian Bryant


--  Create TEMP Players Table
CREATE TABLE `Players_TEMP` (
  `PlayerID` int(11),
  `Name` varchar(30) NOT NULL,
  `Position` varchar(2) NOT NULL,
  `DOB` date DEFAULT NULL,
  `College` varchar(30) DEFAULT NULL,
  `DraftTeam` varchar(20) DEFAULT NULL,
  `DraftRound` int(11) DEFAULT NULL,
  `DraftPick` int(11) DEFAULT NULL,
  `DraftYear` int(11) DEFAULT NULL,
  `Status` varchar(3) DEFAULT NULL,
  `ActTeam` int(11) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=4513 DEFAULT CHARSET=latin1;

-- Upload into Players from TEMP
INSERT INTO Players
	(PlayerID,
	Name,
	Position,
	DOB,
	College,
	DraftTeam,
	DraftRound,
	DraftPick,
	DraftYear,
	Status,
	ActTeam)
SELECT
	PlayerID,
	Name,
	Position,
	DOB,
	College,
	DraftTeam,
	DraftRound,
	DraftPick,
	DraftYear,
	Status,
	ActTeam
FROM Players_TEMP