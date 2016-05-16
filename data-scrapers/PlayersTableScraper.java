import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

import org.openqa.selenium.By;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.htmlunit.HtmlUnitDriver;

import com.gargoylesoftware.htmlunit.BrowserVersion;


public class PlayerSearch
{

	static HtmlUnitDriver driver;

	static List<String> activePlayersReference = new ArrayList<String>();

	static List<String> activePlayers = new ArrayList<String>();
	static List<String> inactivePlayers = new ArrayList<String>();

	static String[] blacklist = {"Ben Roethlisberger", "Kenrick Ellis"};

	static WebElement stats;

	static PrintWriter writer;

	static List<String> errors = new ArrayList<String>();

	public static void main(String[] args) throws IOException
	{
		// Create and launch driver
		System.setProperty("webdriver.chrome.driver", "./chromedriver_win32/chromedriver.exe");
		driver = new HtmlUnitDriver(BrowserVersion.CHROME);

		driver.get("http://www.pro-football-reference.com/players/");

		readReferenceFile();
		populateArrays();

		//writer = new PrintWriter("PlayersTable-Active.csv");
		//for (String string : activePlayers)
		writer = new PrintWriter("PlayersTable-NOT-Active.csv");
		for (String string : inactivePlayers)
		{


			String name = string;
			if (checkBlacklist(name)){continue;}

			int index = name.lastIndexOf(" ");

			char mychar = name.charAt(index + 1);
			String lastNameLetter = Character.toString(mychar);

			try{
			if (lastNameLetter.equals("P") || lastNameLetter.equals("K"))
			{
				List<WebElement> link = driver.findElements(By.linkText(lastNameLetter));
				link.get(1).click();
			}
			else
			{
				WebElement firstLink = driver.findElement(By.linkText(lastNameLetter));
				firstLink.click();
			}


			WebElement secondLink = driver.findElement(By.partialLinkText(string));
			secondLink.click();


			// Get Player Name from web element
			WebElement playerName = driver.findElement(By.xpath("/html/body/div[1]/div[2]/div[2]/h1"));

			// Check first paragraph
			String checkFirst = driver.findElement(By.xpath("/html/body/div[1]/div[2]/div[2]/p[1]")).getText();

			// Adjust xpath to account for the extra pronunciation fields for some of the players.
			if (checkFirst.startsWith("\\") || checkFirst.endsWith("/"))
			{
				stats = driver.findElement(By.xpath("/html/body/div[1]/div[2]/div[2]/p[3]"));
			}
			else
			{
				// Get the stats paragraph
				stats = driver.findElement(By.xpath("/html/body/div[1]/div[2]/div[2]/p[2]"));
			}

			// Send stats paragraph to string for manipulation
			String statsString = stats.getText();
			String firstLine;
			String secondLine;

			// A little string manipulation. Some players have extra info listed, so find out how many lines are in the
			// paragraph element and adjust the desired indexs appropriately to get only the first 2 lines.
			int index1 = statsString.indexOf("\n");
			int index2 = statsString.lastIndexOf("\n");
			if (index2 > index1)
			{
				firstLine = statsString.substring(0, index1);
				secondLine = statsString.substring(index1+1, index2);
			}
			else
			{
				firstLine = statsString.substring(0, index1);
				secondLine = statsString.substring(index1+1);
			}

			// Find DOB of college info
			String DOB = driver.findElement(By.xpath("/html/body/div[1]/div[2]/p[1]/span[1]")).getText();
			String college = driver.findElement(By.xpath("/html/body/div[1]/div[2]/p[1]/a[2]")).getText();


			writer.print(playerName.getText() + "+");
			writer.println(firstLine +"+"+ secondLine +"+"+ DOB +"+"+ college);


			}
			catch (NoSuchElementException e)
			{
				// Player name missing from database
				errors.add(string);
				System.out.println("===== ERROR - No Element =====");
			}
			catch (IndexOutOfBoundsException ie)
			{
				// Player data missing/different causing string manipulation to fail.
				errors.add(string);
				System.out.println("===== ERROR - Index Out Of Bounds =====");
			}
			finally
			{

				driver.get("http://www.pro-football-reference.com/players/");
			}
		}

		writer.close();


		// Some players have no info listed while some newer players do not exist in the online database. During the main execution if an exception
		// is found in the info, that player's name is put into a string array. Print each name in the string array to show which players are missing info.
		for (String string : errors)
		{
			System.out.println(string);
		}

	}

	// A few player's info kept crashing the program. I coulnd't pinpoint the exact cause, so these names were added to a blacklist and are skipped in the execution.
	private static boolean checkBlacklist(String mystring)
	{
		for (String string : blacklist)
		{
			if (string.equals(mystring))
			{
				return true;
			}
		}
		return false;
	}

	// Populate the 2 arrays with all of the player names. While populating, the imported player list is compared to the reference list
	// of active players to determine currently active vs inactive players.
	private static void populateArrays() throws FileNotFoundException
	{
		File file = new File("names.csv");
		Scanner scan = new Scanner(file);

		scan.nextLine();
		while (scan.hasNextLine())
		{
			boolean found = false;
			String name = scan.nextLine();
			for (String string : activePlayersReference)
			{
				if (name.equals(string))
				{
					found = true;
					break;
				}
			}

			if (found)
			{
				activePlayers.add(name);
			}
			else
			{
				inactivePlayers.add(name);
			}
		}

		scan.close();
	}

	// Read the reference file of currently active players into an array.
	private static void readReferenceFile() throws FileNotFoundException
	{
		File file = new File("./activePlayer-Reference.csv");
		Scanner scan = new Scanner(file);

		while (scan.hasNextLine())
		{
			activePlayersReference.add(scan.nextLine());
		}

		scan.close();
	}
}
