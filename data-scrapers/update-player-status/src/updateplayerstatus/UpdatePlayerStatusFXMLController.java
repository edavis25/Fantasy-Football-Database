/*
 * @author Eric Davis
 */
package updateplayerstatus;

import java.io.File;
import java.net.URL;
import java.util.ResourceBundle;

import javafx.concurrent.Task;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Alert;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.ProgressIndicator;
import javafx.stage.FileChooser;
import javafx.stage.FileChooser.ExtensionFilter;
import javafx.stage.Stage;

/**
 * FXML Document controller to update NFL player status
 * @author Eric Davis
 */
public class UpdatePlayerStatusFXMLController implements Initializable {
    
    // String URL filepath leading to .csv file
    private String FILE_URL;
    // String URL filepath leading to fantasy-football-database.db
    private String DB_URL;
    
    @FXML private Button updateDatabaseButton, connectDatabaseButton;
    @FXML private ProgressIndicator progressIndicator;
    @FXML private Label databaseConnectionLabel, databaseConnectionSuccessLabel;
    @FXML public Label progressLabel1, progressLabel2;
    
    @Override
    public void initialize(URL url, ResourceBundle rb) {
        // TODO
    }
    
    /**
     * Launches instances of Scrape Status and UpdateDatabase runnable classes.
     * @param e Button click event
     * @throws InterruptedException Thread interruption exception
     */
    @FXML
    public void updateDatabaseButtonClick(ActionEvent e) throws InterruptedException
    {
        setProgressIndicatorVisibility(true);
        updateDatabaseButton.setDisable(true);
        connectDatabaseButton.setDisable(true);
        execute();
    }
    
    /**
     * Connects to database. Open file-chooser and get database filepath with name matching:
     * fantasy-football-database.db
     */
    @FXML
    public void connectDatabaseButtonClick()
    {
        try 
        {
            FileChooser fileChooser = new FileChooser();
            ExtensionFilter extensionFilter = new ExtensionFilter("DB", "*.db");
            fileChooser.getExtensionFilters().add(extensionFilter);
            File file = fileChooser.showOpenDialog(new Stage());
            if (file.getAbsolutePath().endsWith("fantasy-football-database.db"))
            {
                Alert successAlert = new Alert(AlertType.INFORMATION);
                successAlert.setTitle("Database Selected");
                successAlert.setHeaderText("Database file name is correct");
                successAlert.setContentText("The database file you have chosen is a match. \n"
                                         +"This program will run with any database ending in \"fantasy-football-database.db\" \n"
                                         + "Your chosen database: " + file.getAbsolutePath());
                successAlert.showAndWait();
                databaseConnectionLabel.setVisible(false);
                databaseConnectionSuccessLabel.setVisible(true);
                updateDatabaseButton.setDisable(false);
                
                DB_URL = file.getAbsolutePath();
            }
            else
            {
                Alert failAlert = new Alert(AlertType.ERROR);
                failAlert.setTitle("Incorrect Database Selection");
                failAlert.setHeaderText("Database file name is incorrect");
                failAlert.setContentText("The database file you have chosen does not match the name criteria.\n"
                                    + "Your database file must end with: \"fantasy-football-database.db\"\n"
                                    + "Please try again");
                failAlert.showAndWait();
                updateDatabaseButton.setDisable(true);
                databaseConnectionSuccessLabel.setVisible(false);
                databaseConnectionLabel.setVisible(true);
            }
        }
        catch (Exception e)
        {
            // TODO: Catch "cancel" button click from file chooser dialog
        }
    }
    
    /**
     * Scrapes NFL player status and writes results to .csv file in chosen location.
     * This .csv file is used later to update the database.
     */
    @FXML
    public void execute()
    {
        try 
        {
            // Create file chooser to get filepath URL
            FileChooser fileChooser = new FileChooser();
            ExtensionFilter extensionFilter = new ExtensionFilter("CSV", "*.csv");
            fileChooser.getExtensionFilters().add(extensionFilter);
            File file = fileChooser.showSaveDialog(null);
  
            FILE_URL = file.getAbsolutePath();
            System.out.println(FILE_URL);
            
            // If filepath selected, start main program execution
            if (!FILE_URL.isEmpty())
            {
                Task task = new ScrapeStatus(FILE_URL, DB_URL, this);
                Thread thread = new Thread(task);
                thread.start();
            }
        }
        catch (Exception exception)
        {
            progressIndicator.setVisible(false);
            connectDatabaseButton.setDisable(false);
            updateDatabaseButton.setDisable(false);
        }
    }
    
    @FXML
    public void setProgressIndicatorVisibility(boolean choice)
    {
        progressIndicator.setVisible(choice);
    }
    
    
    @FXML
    public void disableButton()
    {
        updateDatabaseButton.setDisable(true);
    }
}
