import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Scanner;

import fantasy.library.CSVReader;

public class PlayerSearch 
{
	private static ArrayList<String> missing = new ArrayList<String>();
	
	public static void main(String[] args) 
	{
		// .csv dump of the existing player names in DB (Used in Scanner)
		File existingPlayers = new File("existing-players-Jan-7.csv");
		// Player Stats .csv file to be inserted into DB (Used in CSVReader)
		File newPlayers = new File("../../database/data/2016/player-stats/16_all/16_all.csv");
		
		// Create a new CSVReader object (using the .csv file that needs imported)
		CSVReader reader = new CSVReader(newPlayers, 48, ",");
		
		// Get the first column as a String array
		String[] newNames = reader.getSelectedColumnAsString(0);
		
		try 
		{	
			// Loop thru each name in name array and look for names in the existing players .csv file
			for (String str : newNames)
			{
				Scanner scan;
				scan = new Scanner(existingPlayers);
			
				boolean found = false;
				
				// Scan dump with existing player names
				while ((scan.hasNextLine()) && !(found))
				{
					String scanStr = scan.nextLine();
					
					if (str.equals(scanStr))
					{
						found = true;
					}
				}
				
				if (!found) 
				{
					// Check to see if player was already added to the missing array (avoid duplicates)
					boolean foundMissing = false;
					int counter = 0;
					while (counter < missing.size() && !foundMissing)
					{
						if (str.equals(missing.get(counter)))
						{
							foundMissing = true;
							break;
						}
						counter++;
					}
					
					if (!foundMissing)
					{
						// If player missing and not in missing array already, add player
						missing.add(str);
					}
				}
				scan.close();
			}
			
			// Write missing player array to file
			File file = new File("missing-names.csv");
			PrintWriter writer = new PrintWriter(file);
			for (String str : missing)
			{	
				writer.println(str);
				writer.flush();
				System.out.println(str);
			}
			writer.close();
		}
		catch (FileNotFoundException e) 
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.out.println("Scanner or Print Writer Error! File Not Found!!");
		}
		finally
		{
			System.out.println("Number Missing Players: " + missing.size());
		}
	}
}
