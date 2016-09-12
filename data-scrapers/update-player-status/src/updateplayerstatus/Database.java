/*
 * @author Eric Davis
 */
package updateplayerstatus;

import java.io.File;
import java.io.PrintWriter;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;

import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

import javafx.scene.control.Alert;
import javafx.scene.control.Alert.AlertType;

import fantasy.library.CSVReader; //<-- Custom Library


/**
 * Database class used for database interactions (queries, updates, etc...)
 *
 * @author Eric Davis
 */
public class Database {

    private Connection connection;
    private final String DB_URL;
    private ResultSet resultSet;
    private ArrayList<String> problemPlayers = new ArrayList<>();

    /**
     * Default constructor
     * @param dbURL String filepath for the fantasy-football-database.db
     */
    public Database(String dbURL) 
    {
        this.DB_URL = dbURL;
        DatabaseConnection.setURL(DB_URL);
        connection = DatabaseConnection.getConnection();
        if (connection == null) 
        {
            System.out.println("no connection, exit");
            System.exit(1);
            //TODO: Change printline to alert error
        }
    }

    /**
     * Update database with .csv file created during scraping. Filepath is located when
     * user selects directory with file chooser before scraping.
     * @param FILE_URL Filepath leading to the .csv file created during scraping
     */
    public void updateDatabase(String FILE_URL) {
        try 
        {
            File inputCSVfile = new File(FILE_URL);
            // CSVReader part of custom library. Reads a column of data from .csv to an array.
            CSVReader csv = new CSVReader(inputCSVfile, 4, ",");
            String[] csvNames = csv.getSelectedColumnAsString(0);
            String[] csvPositions = csv.getSelectedColumnAsString(1);
            String[] csvStatus = csv.getSelectedColumnAsString(2);
            String[] csvTeam = csv.getSelectedColumnAsString(3);
                    
            // For each name in the .csv file (outermost loop)
            for (int i = 0, length = csvNames.length; i < length; i++) 
            {
                // Check for ' - an apostrophe will break query. TODO: Add escape characters/handle this error
                if (csvNames[i].contains("'")) 
                {
                    problemPlayers.add(csvNames[i] + ", " + csvPositions[i] + ", ERROR: Apostrophe in name");
                } 
                else 
                {
                    // Check for same name/position
                    String countQuery = "SELECT COUNT(Name), COUNT(Position) FROM Players WHERE Name = '" + csvNames[i] + "' AND Position = '" + csvPositions[i] + "'";
                    Statement countStatement = connection.createStatement();
                    ResultSet countResults = countStatement.executeQuery(countQuery);
                    
                    int nameCount = Integer.parseInt(countResults.getString(1));
                    int positionCount = Integer.parseInt(countResults.getString(2));
                    System.out.println("Integer Counts: NAME: " + nameCount + " POSITION: " + positionCount);                    
                    
                    // If only one matching player in database, update status
                    if (nameCount == 1 && positionCount == 1)
                    {
                            String updateStatus = "UPDATE Players SET Status = '" + csvStatus[i] + "', ActTeam = '" + csvTeam[i] + "' WHERE Name = '" + csvNames[i] + "' AND Position = '" + csvPositions[i] + "'";
                            Statement updateStatement = connection.createStatement();
                            updateStatement.executeUpdate(updateStatus);
                    }
                    // Else if no matching player found; not in database
                    else if (nameCount == 0 && positionCount == 0)
                    {
                        System.out.println("ERROR - NOT FOUND --> " + csvNames[i]);
                        problemPlayers.add(csvNames[i] + ", " + csvPositions[i] + ", ERROR: Not in database");
                    }
                    // Else probably a duplicate player: 1+ players w/ same name/position combo
                    else
                    {
                        System.out.println("ERROR - DUPLICATE --> " + csvNames[i]);
                        problemPlayers.add(csvNames[i] + ", " + csvPositions[i] + ", ERROR: Duplicate or unknown error");
                    }
                }
            }
            
            // Set player status to INACTIVE if they weren't given a status from .csv 
            String setInactive = "UPDATE Players SET Status = 'IAV' WHERE Status IS NULL";
            Statement inactiveStatement = connection.createStatement();
            inactiveStatement.executeUpdate(setInactive);
            
            // Print out player errors. TODO: Turn into a dump file
            System.out.println("PROBLEM PLAYERS -------->");
            for (String name : problemPlayers) 
            {
                System.out.println(name);
            }
        } 
        catch (SQLException ex) 
        {
            System.out.println("ERROR");
            Logger.getLogger(Database.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Runs a simple SELECT query and prints results to console in .csv-like
     * format
     *
     * @param query select query to be executed
     */
    public void runQuery(String query) {
        try {
            PreparedStatement statement;

            statement = connection.prepareStatement(query);
            statement.setFetchSize(1000);
            resultSet = statement.executeQuery();

            ResultSetMetaData metaData = resultSet.getMetaData();
            System.out.println(metaData.getColumnCount());

            for (int i = 0; i < metaData.getColumnCount(); i++) {
                System.out.print(metaData.getColumnName(i + 1) + ", ");
            }
            System.out.println();

            while (resultSet.next()) {
                for (int i = 0; i < metaData.getColumnCount(); i++) {
                    String row = resultSet.getString(i + 1);
                    System.out.print(row + ", ");
                }
                System.out.println();
            }
        } catch (SQLException ex) {
            Alert alert = new Alert(AlertType.ERROR);
            alert.setTitle("SQL Select Query Error");
            alert.setHeaderText("Error with Select Query");
        }
    }
}
