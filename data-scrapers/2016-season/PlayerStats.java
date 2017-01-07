import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.htmlunit.HtmlUnitDriver;

/**
 * ---- Directions ---->
 * 1) Set URL constant for the main boxscore page
 * 		- Create a local file of table in an html file using website's share feature
 * 2) Set FILENAME constants for each of the tables.
 * 		- Data is appended to the files if they already exist
 * 3) Set START_WEEK constant to determine where to begin scraping data
 * 4) Set dependencies for the build path
 * 
 * ---- Dependencies ---->
 * 1) htmlunit-driver-standalone-2.20.jar
 * 2) selenium-server-standalone-2.53.0.jar
 * 3) selenium-java-2.53.0.jar
 */

public class PlayerStats {

	static final String URL = "file:///home/eric/Documents/GitHub/Fantasy-Football-Database/data-scrapers/2016-season/11-29-table.html";
	static final String OFFENSE_FILENAME = "11-29-2016-offense.csv";
	static final String DEFENSE_FILENAME = "11-29-2016-defense.csv";
	static final String RETURNS_FILENAME = "11-29-2016-returns.csv";
	static final String KICKING_FILENAME = "11-29-2016-kicking.csv";
	
	// Pick starting week for scraping data
	static final int START_WEEK = 1;
	
	static HtmlUnitDriver driver;
	
	public static void main(String[] args) 
	{
		driver = new HtmlUnitDriver();
		driver.setJavascriptEnabled(true);
		//driver.manage().timeouts().implicitlyWait(20, TimeUnit.SECONDS);
		driver.get(URL);
		System.out.println(driver.getCurrentUrl());
		
		// List of the boxscore links
		List<WebElement> boxscoreLinks = driver.findElements(By.partialLinkText("boxscore"));
		System.out.println("Number of boxscore links: " + boxscoreLinks.size());
		
		// Find a starting index (relative to boxscoreLinks array) for user given START_WEEK. 
		// This way we don't have to scrape all the data each time. Find relative index for the
		// first game of desired week to begin the scraping loop
		int weekIndex = 0;
		WebElement table = driver.findElement(By.xpath("/html/body/div/table"));
		List<WebElement> week = table.findElements(By.xpath("//th[1]"));

		for (WebElement wk : week) 
		{
			// Try/Catch to handle headers that aren't parse-able (namely, the "week" headers on the table)
			try {
				if (Integer.parseInt(wk.getText()) == START_WEEK) {
					// First week of start week found. Subtract the chosen start week to account
					// for the "Week" header for each week (without the index won't be relative to boxscoreLinks)
					weekIndex -= START_WEEK;
					break;
				}
				else {
					weekIndex++;
				}
			}
			catch (Exception e) {
				// "Week" header exception - not parse-able. Increment counter, continue on with loop.
				System.out.println("Parse Integer Exception");
				weekIndex++;
			}
		}
		
		// Set flag to print header first time thru
		boolean header = true;
		for (int i = weekIndex, end = boxscoreLinks.size(); i < end; i++)
		{
			// Get links again to avoid stale elements
			boxscoreLinks = driver.findElements(By.partialLinkText("boxscore"));
			boxscoreLinks.get(i).click();
			
			// Write the different tables to csv files
			writeTable("player_offense", 5, 26, OFFENSE_FILENAME, header);
			writeTable("player_defense", 4, 16, DEFENSE_FILENAME, header);
			writeTable("returns", 3, 14, RETURNS_FILENAME, header);
			writeTable("kicking", 3, 12, KICKING_FILENAME, header);
						
			// Flip flag to stop printing header
			header = false;
			
			driver.navigate().back();
		}
		System.out.println("done!");
	}

	
	/**
	 * Write an HTML table element to .csv file. File will be placed in the same directory.
	 * @param tableID HTML ID to locate the table as a WebElement
	 * @param headerStartIndex Starting index for desired header elements. There are more headers than needed, choose the range desired. (only applies to headers)
	 * @param headerEndIndex Ending index for the desired header elements. Last header element to grab.
	 * @param fileName String file name for the .csv file. Full file name...(including ".csv")
	 * @param header Boolean value determining if header should be printed. Headers will be printed for each table/each game when set to true. (Use as flag to print once)
	 */
	public static void writeTable(String tableID, int headerStartIndex, int headerEndIndex, String fileName, boolean header)
	{
		WebElement table = driver.findElement(By.id(tableID));
		
		try {
			// Create writers for append-able file.
			FileWriter fw = new FileWriter(fileName, true);
			BufferedWriter bw = new BufferedWriter(fw);
			PrintWriter writer = new PrintWriter(bw);
	
			// Print header if flag is set true
			if (header) {
				// Get headers
				List<WebElement> headers = table.findElements(By.tagName("th"));
				// We only want headers between indices
				for (int i = headerStartIndex; i <= headerEndIndex; i++) {
					writer.print(headers.get(i).getText());
					writer.print(",");
					writer.flush();
				}
				writer.println();
				writer.flush();
			}
		
		// Print table data
		List<WebElement> rows = table.findElements(By.tagName("tr"));
		
		// Iterate each row
		for (int i = 0; i < rows.size(); i++) {
			// Get cells
			List<WebElement> cells = rows.get(i).findElements(By.tagName("td"));
			
			// Skip over empty rows
			if (cells.isEmpty()) { 
				continue; 
			}
			
			// Player Name is a header within the row
			WebElement player = rows.get(i).findElement(By.tagName("th"));
			writer.print(player.getText());
			writer.print(",");
			writer.flush();
			
			// Get stat line
			for (WebElement cell : cells) {
				writer.print(cell.getText());
				writer.print(",");
				writer.flush();
			}
			writer.println(driver.getCurrentUrl());
			writer.flush();
		}
		
		writer.close();
		} 
		catch (IOException e) {
			// TODO Auto-generated catch block
			System.out.println("Print Writer Exception");
		}
	}
	

	/**
	 * Print HTML table elements to console. Basically, the writeTable method without creating csv file
	 * @param tableID HTML ID to locate the table as a WebElement
	 * @param headerStartIndex Starting index for desired header elements. There are more headers than needed, choose the range desired. (only applies to headers)
	 * @param headerEndIndex Ending index for the desired header elements. Last header element to grab.
	 */
	public static void printTable(String tableID, int headerStartIndex, int headerEndIndex)
	{
		WebElement table = driver.findElement(By.id(tableID));
		
		// Get headers
		List<WebElement> headers = table.findElements(By.tagName("th"));
		// We only want headers between indices
		for (int i = headerStartIndex; i <= headerEndIndex; i++)
		{
			System.out.print(headers.get(i).getText());
			System.out.print(",");
		}
		System.out.println();
		
		// Get table data
		//List<List<String>> offenseTable = new ArrayList<List<String>>();
		List<WebElement> rows = table.findElements(By.tagName("tr"));
		
		// Iterate each row
		for (int i = 0; i < rows.size(); i++)
		{
			// Get cells
			List<WebElement> cells = rows.get(i).findElements(By.tagName("td"));
			
			// Skip over empty rows
			if (cells.isEmpty()) { continue; }
			
			// Player Name is a header within the row
			WebElement player = rows.get(i).findElement(By.tagName("th"));
			System.out.print(player.getText());
			System.out.print(",");
			
			// Get stat line
			for (WebElement cell : cells)
			{
				System.out.print(cell.getText());
				System.out.print(",");
			}
			System.out.println();
		}
	}
}
