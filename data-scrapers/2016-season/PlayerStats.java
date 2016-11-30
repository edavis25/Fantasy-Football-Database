import java.io.BufferedWriter;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.htmlunit.HtmlUnitDriver;

public class PlayerStats {

	static HtmlUnitDriver driver;
	//static HtmlUnitDriver driver;
	
	public static void main(String[] args) 
	{
		driver = new HtmlUnitDriver();
		driver.setJavascriptEnabled(true);
		//driver.manage().timeouts().implicitlyWait(20, TimeUnit.SECONDS);
		driver.get("file:///C:/Users/ericrocksmyworld/OneDrive/Random%20Code/Eclipse%20Workspace/CurrentSeasonScrapers/11-29-table.html");
		System.out.println(driver.getCurrentUrl());
		
		// List of the boxscore links
		List<WebElement> boxscoreLinks = driver.findElements(By.partialLinkText("boxscore"));
		System.out.println("Number of boxscore links: " + boxscoreLinks.size());
		
		boolean header = true;
		for (int i = 0, end = boxscoreLinks.size(); i < 3; i++)
		{
			boxscoreLinks = driver.findElements(By.partialLinkText("boxscore"));
			boxscoreLinks.get(i).click();
			writeTable("kicking", 3, 12, "11-29-2016-kicking.csv", header);
			driver.navigate().back();
			header = false;
		}
		System.out.println("done!");
		//boxscoreLinks.get(0).click();
		//System.out.println(driver.getCurrentUrl());
		
		//printTable("player_offense", 5, 26);
		//printTable("player_defense", 4, 16);
		//printTable("returns", 3, 14);
		//printTable("kicking", 3, 12);
		//writeTable("kicking", 3, 12, "11-29-2016-kicking.csv");
	}
	
	
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
	
	public static void writeTable(String tableID, int headerStartIndex, int headerEndIndex, String fileName, boolean header)
	{
		WebElement table = driver.findElement(By.id(tableID));
		
		try {
		FileWriter fw = new FileWriter(fileName, true);
		BufferedWriter bw = new BufferedWriter(fw);
		//PrintWriter writer = new PrintWriter("./" + fileName);
		PrintWriter writer = new PrintWriter(bw);
	
		if (header)
		{
		// Get headers
		List<WebElement> headers = table.findElements(By.tagName("th"));
		// We only want headers between indices
		for (int i = headerStartIndex; i <= headerEndIndex; i++)
		{
			writer.print(headers.get(i).getText());
			writer.print(",");
			writer.flush();
		}
		writer.println();
		writer.flush();
		}
		
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
			writer.print(player.getText());
			writer.print(",");
			writer.flush();
			
			// Get stat line
			for (WebElement cell : cells)
			{
				writer.print(cell.getText());
				writer.print(",");
				writer.flush();
			}
			writer.println(driver.getCurrentUrl());
			//writer.println();
			writer.flush();
		}
		writer.close();
		
		} catch (IOException e) {
			// TODO Auto-generated catch block
			System.out.println("Print Writer Exception");
		}
	}
}
