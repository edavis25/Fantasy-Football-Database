package fantasy.library;

/**
 * Eric Davis - October 13, 2016
 */

public class FantasyLibrary 
{
	/**
	 * Takes a full team name and compare to sorted list of team names to find TeamID.
	 * @param teamName Team name and find TeamID to match Database.
	 * @return Return an integer that equals the appropriate TeamID for the Database
	 */
	public static int findTeamID(String teamName)
	{
		String[] teamNamesArray = getArrayOfTeams();
				
		int returnID = -1;
		
		for (int i = 0, size = teamNamesArray.length; i < size; i++)
		{
			if (teamName.endsWith(teamNamesArray[i]))
			{
				returnID = i +1;
				break;
			}
		}
		return returnID;
	}
	
	
	/**
	 * Fixes a position abbreviation to match the position abbreviations in our database.
	 * @param position Given position abbreviation to fix for database.
	 * @return Return fixed position as string to match the types in our database.
	 */
	public static String fixPosition(String position)
	{
		String returnString = "";
		
		if (position.equals("LS") || position.equals("C") || position.equals("G") || position.equals("OG") || position.equals("T") ||position.equals("OT"))
		{
			returnString = "OL";
		}
		else if (position.equals("S") || position.equals("SS") || position.equals("FS") || position.equals("CB") || position.equals("SAF"))
		{
			returnString = "DB";
		}
		else if (position.equals("OLB") || position.equals("ILB") || position.equals("MLB"))
		{
			returnString = "LB";
		}
		else if (position.equals("NT") || position.equals("DE") || position.equals("DT"))
		{
			returnString = "DL";
		}
		else if (position.equals("FB"))
		{
			returnString = "RB";
		}
		else if (position.equals("PR"))
		{
			returnString = "WR";
		}
		else
		{
			returnString = position;
		}
		
		return returnString;
	}
	
	
	/**
	 * Return a String array of all teams sorted in order of TeamID within database. The index of the
	 * name in the array +1 is equal to the TeamID in the Database.
	 * @return A String array containing team names in order of TeamID
	 */
	public static String[] getArrayOfTeams()
	{
		String[] teamNamesArray = {"Cardinals", "Falcons", "Ravens", "Bills", "Panthers", "Bears", "Bengals", "Browns", "Cowboys", "Broncos", 
				"Lions", "Packers", "Texans", "Colts", "Jaguars", "Chiefs", "Rams", "Dolphins","Vikings", "Patriots", "Saints", "Giants","Jets", 
				"Raiders", "Eagles", "Steelers", "Chargers", "49ers", "Seahawks", "Buccaneers", "Titans", "Redskins" };
		
		return teamNamesArray;
	}
	
	
	/**
	 * reverseName takes a name in the format: "Last, First" and uses string manipulation
	 * to return the name in the format: "First Last" (Note: No comma)
	 * @param name Player name in format: "Last, First"
	 * @return Player name in format: "First Last"
	 */
	public static String reverseName(String name)
	{
		int index = name.indexOf(",");
		String firstName = name.substring(index +2);
		String lastName = name.substring(0, index);
		
		return firstName + " " + lastName;
	}
}
