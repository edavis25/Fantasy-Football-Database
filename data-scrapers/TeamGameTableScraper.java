import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.util.List;

import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.htmlunit.HtmlUnitDriver;

import com.gargoylesoftware.htmlunit.BrowserVersion;



public class TeamGameTableScraper
{
	static final String YEAR = "2015";

	static HtmlUnitDriver driver;

	static PrintWriter writer;

	public static void main(String[] args) throws FileNotFoundException
	{
		// Locate and launch driver
		System.setProperty("webdriver.chrome.driver", "./chromedriver_win32/chromedriver.exe");
		driver = new HtmlUnitDriver(BrowserVersion.CHROME);

		driver.get("http://www.pro-football-reference.com/years/" +YEAR+ "/games.htm");

		// Find the box score links
		List<WebElement> sizeFinder = driver.findElements(By.linkText("boxscore"));

		// For each boxscore link
		for (int i = 0, size = sizeFinder.size(); i < size; i++)
		{

			// Find the links each iteration to avoid stale elements
			List<WebElement> boxScoreLinks = driver.findElements(By.linkText("boxscore"));

			boxScoreLinks.get(i).click();

			// Get tables for reading
			WebElement table = driver.findElement(By.id("team_stats"));
			WebElement linescoreTable = driver.findElement(By.id("linescore"));

			// Get the team name headers
			List<WebElement> headers = table.findElements(By.tagName("th"));

			// Create file
			writer = new PrintWriter("./stats/teamstats/"+ YEAR +"/" + YEAR +"-"+ headers.get(1).getText() +"-vs-"+ headers.get(2).getText() +"-"+ (i+1) +".csv");

			// Get 2nd column data in team-stats table (team1 stats)
			List<WebElement> column2 = table.findElements(By.xpath("//table[@id='team_stats']//tr/td["+2+"]"));

			// Print team1 team name
			writer.print(headers.get(1).getText() +",");

			for (WebElement row : column2)
			{
				writer.print(row.getText() + ",");
			}

			// Get linescore for team1
			List<WebElement> row1 = linescoreTable.findElements(By.xpath("//table[@id='linescore']//tr[1]/td"));
			printLinescore(row1);

			// Print URL for temporary database key
			writer.println(driver.getCurrentUrl());


			// <------------START TEAM 2 DATA--------------->


			// Get 3rd column data in team-stats table (team2 stats)
			List<WebElement> column3 = table.findElements(By.xpath("//table[@id='team_stats']//tr/td["+3+"]"));

			// Print team2 team name
			writer.print(headers.get(2).getText() +",");

			for (WebElement row: column3)
			{
				writer.print(row.getText() + ",");
			}

			// Get linescore for team2
			List<WebElement> row2 = linescoreTable.findElements(By.xpath("//table[@id='linescore']//tr[2]/td"));
			printLinescore(row2);

			// Write URL to act as temporary key for relational database
			writer.println(driver.getCurrentUrl());


			writer.flush();
			writer.close();

			driver.navigate().back();

		}
	}

	// Write scores from each quarter from linescore table
	private static void printLinescore(List<WebElement> list)
	{

		for (WebElement element : list)
		{
			writer.print(element.getText() + ",");
		}
	}

}
