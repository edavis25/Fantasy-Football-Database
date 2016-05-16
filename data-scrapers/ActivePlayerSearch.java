import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.util.List;

import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.htmlunit.HtmlUnitDriver;

import com.gargoylesoftware.htmlunit.BrowserVersion;

/*
*	Scrapes the active team rosters from espn to create a list of currently active players
*/
public class ActivePlayerSearch
{
	static HtmlUnitDriver driver;
	static String[] teamNames = {"Cardinals", "Falcons", "Ravens", "Bills", "Panthers", "Bears", "Bengals", "Browns", "Cowboys", "Broncos", "Lions", "Packers", "Texans", "Colts", "Jaguars", "Chiefs", "Rams", "Dolphins",
			"Vikings", "Patriots", "Saints", "Giants","Jets", "Raiders", "Eagles", "Steelers", "Chargers", "49ers", "Seahawks", "Buccaneers", "Titans", "Redskins" };

	public static void main(String[] args) throws FileNotFoundException
	{
		// Create and launch driver
		System.setProperty("webdriver.chrome.driver", "./chromedriver_win32/chromedriver.exe");
		driver = new HtmlUnitDriver(BrowserVersion.CHROME);

		driver.get("http://espn.go.com/nfl/players");

		PrintWriter writer = new PrintWriter("activePlayer-Reference.csv");

		// For each team name, navigate to associated link and then write active player names to file
		for (int i = 0; i < teamNames.length; i++)
		{
			WebElement link = driver.findElement(By.partialLinkText(teamNames[i]));
			link.click();

			WebElement table = driver.findElement(By.className("tablehead"));
			List<WebElement> column = table.findElements(By.xpath("//table[@class='tablehead']//tr/td["+2+"]"));

			writer.println(teamNames[i]);
			for (WebElement element : column)
			{
				writer.println(element.getText());
			}

			driver.navigate().back();
		}

		writer.flush();
		writer.close();

	}

}
