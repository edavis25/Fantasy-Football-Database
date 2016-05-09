import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.util.List;

import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

import org.openqa.selenium.htmlunit.HtmlUnitDriver;

import com.gargoylesoftware.htmlunit.BrowserVersion;


public class GamesTableScraper
{
	// Change constant to scrape all game data from given year.
	static final String YEAR = "2015";

	// 267 = Total number of games played between all teams during regular season (256) + 11 post-season games
	static final int SIZE = 267;

	static HtmlUnitDriver driver;

	static PrintWriter writer;

	static String[] day = new String[SIZE];
	static String[] date = new String[SIZE];
	static String[] week = new String[SIZE];
	static String[] winner = new String[SIZE];
	static String[] loser = new String[SIZE];
	static String[] winnerFinalScore = new String[SIZE];
	static String[] loserFinalScore = new String[SIZE];


	/*
	*	main - Open yearly box scores page to given year and grab all of the "boxscore" links. Scrape all the data from the main table on the main page
	*			and put it into arrays. For each boxscore link (each game in season), navigate thru each boxscore link and grab the game info table and
	*			then write this data to a .csv file merged with the matching game data from the arrays.
	*/
	public static void main(String[] args) throws FileNotFoundException
	{
		// Create and launch driver to given year
		System.setProperty("webdriver.chrome.driver", "./chromedriver_win32/chromedriver.exe");
		driver = new HtmlUnitDriver(BrowserVersion.CHROME);
		driver.get("http://www.pro-football-reference.com/years/" +YEAR+ "/games.htm");

		WebElement table = driver.findElement(By.id("games"));

		// Grab all the elements in the specified column rows. (We only want columns 1,2,3,5,7,8,9).
		List<WebElement> weekElement = table.findElements(By.xpath("//tr/td["+1+"]"));
		List<WebElement> dayElement = table.findElements(By.xpath("//tr/td["+2+"]"));
		List<WebElement> dateElement = table.findElements(By.xpath("//tr/td["+3+"]"));
		List<WebElement> winnerElement = table.findElements(By.xpath("//tr/td["+5+"]"));
		List<WebElement> loserElement = table.findElements(By.xpath("//tr/td["+7+"]"));
		List<WebElement> winnerScoreElement = table.findElements(By.xpath("//tr/td["+8+"]"));
		List<WebElement> loserScoreElement = table.findElements(By.xpath("//tr/td["+9+"]"));

		// Create arrays from the web elements for printing
		createArray(dayElement, day);
		createArray(weekElement, week);
		createArray(winnerElement, winner);
		createArray(dateElement, date);
		createArray(loserElement, loser);
		createArray(winnerScoreElement, winnerFinalScore);
		createArray(loserScoreElement, loserFinalScore);

		// For each "boxscore" link. (each game has a boxscore, so for each game in season)
		for (int i = 0; i < SIZE; i++)
		{
			// boxscore links must be found again each iteration
			List<WebElement> boxScoreLinks = driver.findElements(By.linkText("boxscore"));
			boxScoreLinks.get(i).click();

			// Write file. Send iteration number from loop for unique entries for each game.
			writeFile(i);

			driver.navigate().back();

		}

	}



	/*
	*	writeFile - Create and write the scraped game info data from the various tables to a file. Accept integer parameter to use as a unique identifier to the file name (loop iteration #).
	*/
	public static void writeFile(int index) throws FileNotFoundException
	{
		// Create the file.
		writer = new PrintWriter("./stats/games/"+ YEAR +"/" + YEAR + "-WK-"+ week[index] +"-"+ winner[index] +"-vs-"+ loser[index]+".csv");

		// Write appropriate values from arrays into the file.
		writer.print(week[index] +","+ day[index] +","+ date[index] +","+ getTeamID(winner[index]) +","+ getTeamID(loser[index]) +","+ winnerFinalScore[index] +","+ loserFinalScore[index] +",");

		// Grab the game info table and select only values from 2nd column.
		WebElement table1 = driver.findElement(By.id("game_info"));
		List<WebElement> column = table1.findElements(By.xpath("//table[@id='game_info']//tr/td["+2+"]"));

		for (WebElement element : column)
		{
			writer.print(element.getText());
			writer.print(",");
		}

		// Print the boxscore url to act as a temporary key for each game.
		writer.print(driver.getCurrentUrl().toString());
		writer.close();
	}



	/*
	*	createArray - Accept both an arraylist of web elements and string array. Read the text from each web element in the array to the
	*				  string array skipping over blank table data and "Playoffs" headers.
	*/
	public static void createArray(List<WebElement> elementList, String[] stringArray)
	{
		// Index only increments when text is found to skip over null values & 'Playoffs' header
		int  index = 0;

		for (int i = 0, length = elementList.size(); i < length; i++)
		{
			if (elementList.get(i).getText().equals("") || elementList.get(i).getText().equals("Playoffs"))
			{
				continue;
			}
			else
			{
				String string = elementList.get(i).getText();
				stringArray[index] = string;
				index++;
			}
		}
	}



	/*
	*	getTeamID - Accept a team name and find its TeamID from the relational database. The teams are ordered in the teamName array by TeamID in the relational database (proprietary).
	*/
	public static int getTeamID(String team)
	{
		String[] teamNames = {"Cardinals", "Falcons", "Ravens", "Bills", "Panthers", "Bears", "Bengals", "Browns", "Cowboys", "Broncos", "Lions", "Packers", "Texans", "Colts", "Jaguars", "Chiefs", "Rams", "Dolphins",
								"Vikings", "Patriots", "Saints", "Giants","Jets", "Raiders", "Eagles", "Steelers", "Chargers", "49ers", "Seahawks", "Buccaneers", "Titans", "Redskins" };

		for (int i = 0; i < teamNames.length; i++)
		{
			if (team.endsWith(teamNames[i]))
			{
				return i + 1;
			}
		}
		return -1;
	}
}
