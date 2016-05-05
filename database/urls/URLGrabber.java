import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.util.List;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.htmlunit.HtmlUnitDriver;
import com.gargoylesoftware.htmlunit.BrowserVersion;

public class URLGrabber 
{
	// Change constant to desired year
	static final String YEAR = "2015";
	
	
	static HtmlUnitDriver driver;
	
	static PrintWriter writer;

	public static void main(String[] args) throws FileNotFoundException 
	{
		
		// Find local driver and navigate to the given year
		System.setProperty("webdriver.chrome.driver", "./chromedriver_win32/chromedriver.exe");
		driver = new HtmlUnitDriver(BrowserVersion.CHROME);
		driver.get("http://www.pro-football-reference.com/years/" +YEAR+ "/games.htm");
		
		List<WebElement> size = driver.findElements(By.linkText("boxscore"));
		
		// Write each link to a separate .csv file
		for (int i = 0; i < size.size(); i++)
		{
			writer = new PrintWriter("./urls/" +YEAR+"/" + YEAR + "-" + (i) + ".csv");
			
			// Elements must be found again after navigating away from page.
			List<WebElement> boxScoreLinks = driver.findElements(By.linkText("boxscore"));
			
			boxScoreLinks.get(i).click();
			
			String string = driver.getCurrentUrl();
			
			writer.println(string + ",");
			writer.close();
			
			driver.navigate().back();
		}
	}
}
