/*
 * @author Eric Davis
 */
package updateplayerstatus;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.htmlunit.HtmlUnitDriver;
import com.gargoylesoftware.htmlunit.BrowserVersion;
import fantasy.library.FantasyLibrary; //<--Custom library
import java.util.logging.Level;
import java.util.logging.Logger;
import javafx.concurrent.Task;
import javafx.scene.control.Alert;
import javafx.scene.control.Alert.AlertType;

/**
 * Scrape NFL player status from NFL.com and write to .csv file
 * @author Eric Davis
 */
public class ScrapeStatus extends Task
{
    private final String FILE_URL;
    private final String DB_URL;
    private final HtmlUnitDriver driver;
    private final PrintWriter writer;
    private final String[] teamNames = FantasyLibrary.getArrayOfTeams();
    private final UpdatePlayerStatusFXMLController controller;
    
    /**
     * Default constructor.
     * @param fileURL file path for .csv file
     * @param control FXML controller class - for interacting with GUI
     * @throws Exception file not found exception
     */
   
    public ScrapeStatus(String fileURL, String dbURL, UpdatePlayerStatusFXMLController control) throws Exception
    {
        this.DB_URL = dbURL;
        this.FILE_URL = fileURL;
        this.controller = control;
	this.writer = new PrintWriter(FILE_URL);
        
        // Create and launch web driver (located in root directory)
	System.setProperty("webdriver.chrome.driver", "./chromedriver_win32/chromedriver.exe");
        driver = new HtmlUnitDriver(BrowserVersion.CHROME);
	driver.get("http://www.nfl.com/players");
        System.out.println(driver.getCurrentUrl());
        
        // Set progress label
        javafx.application.Platform.runLater( () ->
        controller.progressLabel1.setText("Connecting to website...")
        );
   }
   
    @Override
    protected Object call() throws Exception 
    {
        // Main Execution
        scrapeData();
        
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    /**
     * Scrape player status data and stores the web table data into local Array Lists.
     * Search players by team roster to determine active team. Write data from the Array
     * Lists into the .csv file.
     */
    public void scrapeData()
    {
        // Set label text
        javafx.application.Platform.runLater( () ->
        controller.progressLabel1.setText("Scraping rosters...")
        );
        
        // Iterate through team names and scape roster data
        for (int i = 0, numberTeams = teamNames.length; i < numberTeams; i++)
        {
            // Set label2 text to team name
            String teamLabel = teamNames[i];
            javafx.application.Platform.runLater( () ->
            controller.progressLabel2.setText(teamLabel)
            );
            
            // Create string lists to hold text from the web element objects
            ArrayList<String> nameList = new ArrayList<String>();
            ArrayList<String> positionList = new ArrayList<String>();
            ArrayList<String> statusList = new ArrayList<String>();
            
            // Navigate to each roster by team name
            WebElement teamLink = driver.findElementByPartialLinkText(teamNames[i]);
            teamLink.click();

            // Add text from elements to appropriate list using column number
            nameList.addAll(getTableColumnAsList(3));
            positionList.addAll(getTableColumnAsList(1));
            statusList.addAll(getTableColumnAsList(4));
			
            System.out.println(teamNames[i]);
            System.out.println(nameList.size());
		
            // Write to file used to update database
            for (int j = 0, jSize = nameList.size(); j < jSize; j++)
            {
            	writer.println(nameList.get(j) +","+ FantasyLibrary.fixPosition(positionList.get(j)) + "," + statusList.get(j) + ","+ FantasyLibrary.findTeamID(teamNames[i]));
            }
	}
	writer.flush();
	writer.close();
        
        // Set label text
        javafx.application.Platform.runLater( () ->
            controller.progressLabel1.setText("Updating database...")
        );
        javafx.application.Platform.runLater( () ->
            controller.progressLabel2.setText("")
        );
        
        // Update Database
        try 
        {
            Task task = new UpdateDatabase(FILE_URL, DB_URL);
            Thread thread = new Thread(task);
            thread.start();
            thread.join();
            
            controller.setProgressIndicatorVisibility(false);
            javafx.application.Platform.runLater( () ->
                controller.progressLabel1.setText("Database update successful")
            );
            
            // Success alert
            Alert alert = new Alert(AlertType.INFORMATION);
            alert.setTitle("Database updated");
            alert.setHeaderText("Database updated successfully");
            alert.setContentText("Your database has been updated succesfully.\n"
                                + "Location of .csv file: " + FILE_URL);
            alert.showAndWait();
        } 
        catch (ClassNotFoundException | InterruptedException ex) 
        {
            Logger.getLogger(ScrapeStatus.class.getName()).log(Level.SEVERE, null, ex);
            Logger.getLogger(ScrapeStatus.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Read the selected column from web table into string array.
     * @param columnNumber desired column to retrieve data from.
     * @return values from selected column into string List.
     */
    private List<String> getTableColumnAsList(int columnNumber)
    {
	// Create list to return
	List<String> returnList = new ArrayList<String>();
	
	// Get table & desired column. Add text form elements to return list.
	WebElement table = driver.findElementById("result");
	List<WebElement> column = table.findElements(By.xpath("//table[@class='data-table1']//tr/td["+ columnNumber +"]"));
	for (WebElement element : column)
	{
            // Column 3 is the player name field we need to use string manipulation on
            if (columnNumber == 3)
            {
		returnList.add(FantasyLibrary.reverseName(element.getText()));
            }
            else
            {
		returnList.add(element.getText());
            }
	}
	return returnList;
    }
}
