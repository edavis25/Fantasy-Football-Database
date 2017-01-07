/*
* *** NOTE ***  This is literally the grossest scraper ever. Not only is the code terrible and
* 				impossible to follow, but the output csv file needs tons of cleaning. This needs a
*				complete rewrite... ps. its also super slow
*/

import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.htmlunit.HtmlUnitDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import com.gargoylesoftware.htmlunit.BrowserVersion;

import fantasy.library.FantasyLibrary;

public class GamesTable
{
	//static WebDriver driver;
	static HtmlUnitDriver driver;
	//static ChromeDriver driver;
	static final String YEAR = "2016";

	// Arrays for the overall boxscreen info (Game info). These are created with CreateArray class (initialize only)
	static List<String> day, date, week, time, winner, loser, winnerFinalScore, loserFinalScore;

	// Arrays for info on individual game pages. Info added directly to arrays (initialize and create)
	static List<String> stadium = new ArrayList<String>();
	static List<String> attendance = new ArrayList<String>();
	static List<String> duration = new ArrayList<String>();
	static List<String> gameInfo = new ArrayList<String>();
	static List<String> url = new ArrayList<String>();

	// Array for Team Stats .csv file (Each element in array = 1 complete data row as string.
	static List<String> team1Stats = new ArrayList<String>();
	static List<String> team2Stats = new ArrayList<String>();

	// Array for Game Info .csv file (Each element in array = 1 complete data row as string.
	static List<String> gameInfoArray = new ArrayList<String>();

	// Insert the last Game's GameID from DB for easier entry.
	static int NUMBER_GAMES = 2938;

	public static void main(String[] args)
	{
		//System.setProperty("webdriver.chrome.driver", "./chromedriver.exe");

		//driver = new ChromeDriver();

		driver = new HtmlUnitDriver();
		driver.setJavascriptEnabled(true);
		driver.manage().timeouts().implicitlyWait(20, TimeUnit.SECONDS);

		// Download local copy of HTML file (the website added a ton of JavaScript that breaks scraper (I know,gross)
		driver.get("file:///home/eric/Documents/Eclipse%20Workspace/CurrentSeasonScrapers/1-6-table.html");

		createArrays();

		// Go Thru Boxscore Links
		for (int i = 0, size = driver.findElements(By.linkText("boxscore")).size(); i < size; i++)
		//for (int i = 0; i < 3; i++)
		{
			List<WebElement> boxscoreLinks = driver.findElements(By.linkText("boxscore"));
			boxscoreLinks.get(i).click();
			url.add(driver.getCurrentUrl());

			// Get Stadium
			stadium.add(driver.findElement(By.xpath("/html/body/div[2]/div[3]/div[2]/div[3]/div[3]")).getText());

			// Get Attendance
			attendance.add(driver.findElement(By.xpath("/html/body/div[2]/div[3]/div[2]/div[3]/div[4]")).getText());
			// Get Duration
			duration.add(driver.findElement(By.xpath("/html/body/div[2]/div[3]/div[2]/div[3]/div[5]")).getText());

			// Get weather info/betting table info
			WebElement infoTable = driver.findElement(By.xpath("//*[@id=\"game_info\"]"));
			List<WebElement> infoTableData = infoTable.findElements(By.xpath("//table[@id='game_info']//tr/td"));
			//WebElement infoTable = driver.findElement(By.xpath("/html/body/div/table"));
			//List<WebElement> infoTableData = infoTable.findElements(By.xpath("/html/body/div/table//tr/td"));

			String buildString = "";
			for (WebElement element : infoTableData)
			{
				buildString += element.getText();
				buildString += ",";
			}
			gameInfo.add(buildString);

			// Add all info into array as formatted .csv row
			gameInfoArray.add(NUMBER_GAMES + "," + week.get(i) + "," + day.get(i) +","+ date.get(i) +","+ FantasyLibrary.findTeamID(winner.get(i)) + "," + FantasyLibrary.findTeamID(loser.get(i)) +
								"," + winnerFinalScore.get(i) + "," + loserFinalScore.get(i) + "," + stadium.get(i) + "," + time.get(i) + "," + duration.get(i) + "," + attendance.get(i) + "," + gameInfo.get(i) + url.get(i));

			// Function performing operations to format Team Stats into .csv rows
			getTeamStats();

			NUMBER_GAMES++;
			driver.navigate().back();
		}

		writeCsvFiles();

		/*

		// Game Info String for Writing to File --> Change printline to write to .csv
		for (int i = 0; i < 3; i++)
		{
			System.out.println(NUMBER_GAMES + ", " + week.get(i) + ", " + day.get(i) +", "+ date.get(i) +", "+ FantasyLibrary.findTeamID(winner.get(i)) + ", " + FantasyLibrary.findTeamID(loser.get(i)) +
								", " + winnerFinalScore.get(i) + ", " + loserFinalScore.get(i) + ", " + stadium.get(i) + ", " + attendance.get(i) + ", " + duration.get(i) + ", " + gameInfo.get(i) + url.get(i));
		}

		*/
	}

	public static void writeCsvFiles()
	{
		try
		{
			PrintWriter writer = new PrintWriter("./team-stats.csv");
			PrintWriter gameWriter = new PrintWriter("./game-info.csv");

			//Print Headers
			writer.println("GameID,Team,1stD,Rush-Yds-Tds,Cmp-Att-Yd-Td-Int,Sacked-Yds,NetPassYds,TotalYds,Fmb-Lost,Turnovers,Plty-Yds,3rdConv-Att,4thConv-Att,TOP,Blank,TeamName,Q1,Q2,Q3,Q4,Final,URL");
			gameWriter.println("GameID,Week,Day,Date,WinnerID,LoserID,WinnerScore,LoserScore,Stadium,Time,Duration,Attendance,Atten2,GameInfo,WonToss,Roof,Surface,Weather,Wind,Favored,OverUnder,URL");

			writer.flush();
			gameWriter.flush();

			for (int i = 0, size = driver.findElements(By.linkText("boxscore")).size(); i < size; i++)
			{
				System.out.println("Team 1: " + team1Stats.get(i));
				System.out.println("Team 2: " + team2Stats.get(i));
				writer.println(team1Stats.get(i));
				writer.println(team2Stats.get(i));

				gameWriter.println(gameInfoArray.get(i));
				//gameWriter.println(NUMBER_GAMES + ", " + week.get(i) + ", " + day.get(i) +", "+ date.get(i) +", "+ FantasyLibrary.findTeamID(winner.get(i)) + ", " + FantasyLibrary.findTeamID(loser.get(i)) +
				//				", " + winnerFinalScore.get(i) + ", " + loserFinalScore.get(i) + ", " + stadium.get(i) + ", " + attendance.get(i) + ", " + duration.get(i) + ", " + gameInfo.get(i) + url.get(i));
				writer.flush();
				gameWriter.flush();
			}

			//writer.flush();
			writer.close();
			//gameWriter.flush();
			gameWriter.close();
		}
		catch (FileNotFoundException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}


	public static void getTeamStats()
	{
		String team1String = NUMBER_GAMES + ",";
		String team2String = NUMBER_GAMES + ",";

		// Get tables for reading
		WebElement table = driver.findElement(By.id("team_stats"));
		//WebElement linescoreTable = driver.findElement(By.id("linescore"));
		WebElement linescoreTable = driver.findElement(By.xpath("/html/body/div[2]/div[3]/table"));

		// Get the team name headers
		List<WebElement> headers = table.findElements(By.tagName("th"));
		// Get 2nd column data in team-stats table (team1 stats)
		List<WebElement> column2 = table.findElements(By.xpath("//table[@id='team_stats']//tr/td["+1+"]"));

		// Print team1 team name
		team1String += headers.get(1).getText() + ",";

		for (WebElement row : column2)
		{
			team1String += row.getText() + ",";
		}

		// Get linescore for team1
		List<WebElement> row1 = linescoreTable.findElements(By.xpath("/html/body/div[2]/div[3]/table//tr[1]/td"));
		for (WebElement element : row1)
		{
			team1String += element.getText() + ",";
		}
		team1String += driver.getCurrentUrl();

		team1Stats.add(team1String);

		//-------- TEAM 2 -------->

		team2String += headers.get(2).getText() + ",";
		// Get 3rd column data in team-stats table (team2 stats)
		List<WebElement> column3 = table.findElements(By.xpath("//table[@id='team_stats']//tr/td["+2+"]"));
		for (WebElement row : column3)
		{
			team2String += row.getText() + ",";
		}

		// Get linescore for team1
		List<WebElement> row2 = linescoreTable.findElements(By.xpath("/html/body/div[2]/div[3]/table//tr[2]/td"));
		for (WebElement element : row2)
		{
			team2String += element.getText() + ",";
		}

		team2String += driver.getCurrentUrl();

		team2Stats.add(team2String);
	}


	/**
	 * Create the arrays from main screen
	 */
	public static void createArrays()
	{
		HtmlUnitDriver localDriver = new HtmlUnitDriver(BrowserVersion.CHROME);
		localDriver.get("file:///home/eric/Documents/Eclipse%20Workspace/CurrentSeasonScrapers/1-6-table.html");


		WebElement table = localDriver.findElement(By.xpath("/html/body/div/table"));
		// Day
		List<WebElement> dayElement = table.findElements(By.xpath("//tr/td["+1+"]"));
		day = CreateArray.getListAsArray(dayElement);
		// Date
		List<WebElement> dateElement = table.findElements(By.xpath("//tr/td["+2+"]"));
		date = CreateArray.getListAsArray(dateElement);
		// Week
		List<WebElement> weekElement = table.findElements(By.xpath("//th[1]"));
		week = createWeekArray(weekElement);
		// Time
		List<WebElement> timeElement = table.findElements(By.xpath("//tr/td["+3+"]"));
		time = CreateArray.getListAsArray(timeElement);
		// Winner
		List<WebElement> winnerElement = table.findElements(By.xpath("//tr/td["+4+"]"));
		winner = CreateArray.getListAsArray(winnerElement);
		// Loser
		List<WebElement> loserElement = table.findElements(By.xpath("//tr/td["+6+"]"));
		loser = CreateArray.getListAsArray(loserElement);
		// Winner Score
		List<WebElement> winnerScore = table.findElements(By.xpath("//tr/td["+8+"]"));
		winnerFinalScore = CreateArray.getListAsArray(winnerScore);
		// Loser Score
		List<WebElement> loserScore = table.findElements(By.xpath("//tr/td["+9+"]"));
		loserFinalScore = CreateArray.getListAsArray(loserScore);
	}

	/**
	 * Create week array - (different from all other arrays)
	 * @param elementList
	 * @return
	 */
	private static List<String> createWeekArray(List<WebElement> elementList)
	{
		List<String> returnArray = new ArrayList<String>();

		for (int i = 0, size = elementList.size(); i < size; i++)
		{
			if (!elementList.get(i).getText().equals("Week"))
			{
				returnArray.add(elementList.get(i).getText());
			}
		}
		return returnArray;
	}
}
