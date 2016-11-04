/*
 * @author Eric Davis
 */
package updateplayerstatus;

import fantasy.library.CSVReader;
import java.io.File;
import java.io.FileNotFoundException;
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

/**
 * Database class used for database interactions (queries, updates, etc...)
 * @author Eric Davis
 */
public class Database {

    private Connection connection;
    private final String DB_URL;
    private ResultSet resultSet;
    private ArrayList<String> problemPlayers = new ArrayList<>();
    private ArrayList<String> newPlayers = new ArrayList<>();
    
    
    /**
     * Default constructor - Use DB filepath to connect to DB
     * @param dbURL String value containing the filepath url to the fantasy-football-database.db
     */
    public Database(String dbURL) {
        this.DB_URL = dbURL;
        // Create connection
        DatabaseConnection.setURL(DB_URL);
        connection = DatabaseConnection.getConnection();
        if (connection == null) {
            System.out.println("no connection, exit");
            System.exit(1);
        }
    }

    /**
     * Use the .csv file that was created to update player status in the database
     * @param FILE_URL String value for the filepath url for the created .csv file
     * This is the filepath chosen in dialog box
     */
    public void updateDatabase(String FILE_URL) {
        try 
        {
            // Open File
            File inputCSVfile = new File(FILE_URL);
            System.out.println("FILE OPEN");
           
            // Create CSVReader to read the created .csv file; create array for each column in .csv file
            CSVReader csv = new CSVReader(inputCSVfile, 4, ",");
            String[] csvNames = csv.getSelectedColumnAsString(0);
            String[] csvPositions = csv.getSelectedColumnAsString(1);
            String[] csvStatus = csv.getSelectedColumnAsString(2);
            String[] csvTeam = csv.getSelectedColumnAsString(3);
                    
            // For each name in the .csv file (outermost loop)
            for (int i = 0, length = csvNames.length; i < length; i++) 
            {
                // Check for ' - an apostrophe will break query. Pass these names to fixName() to add escape characters
                if (csvNames[i].contains("'")) 
                {
                    csvNames[i] = fixName(csvNames[i]);
                } 
                    // Create SQL Query for counting number of players to locate duplicates
                    String countQuery = "SELECT COUNT(Name), COUNT(Position) FROM Players WHERE Name = '" + csvNames[i] + "' AND Position = '" + csvPositions[i] + "'";
                    Statement countStatement = connection.createStatement();
                    ResultSet countResults = countStatement.executeQuery(countQuery);
                    
                    // Parse the SQL count results to local integers
                    int nameCount = Integer.parseInt(countResults.getString(1));
                    int positionCount = Integer.parseInt(countResults.getString(2));

                    // If there is only one in the DB, update status
                    if (nameCount == 1 && positionCount == 1)
                    {
                            String updateStatus = "UPDATE Players SET Status = '" + csvStatus[i] + "', ActTeam = '" + csvTeam[i] + "' WHERE Name = '" + csvNames[i] + "' AND Position = '" + csvPositions[i] + "'";
                            Statement updateStatement = connection.createStatement();
                            updateStatement.executeUpdate(updateStatus);
                    }
                    else if (nameCount == 0 && positionCount == 0)
                    {
                        // No player found in DB, INSERT them into DB
                        String insertQuery = "INSERT INTO Players (Name, Position, Status, ActTeam) VALUES (\'" + csvNames[i] + "\', \'" + csvPositions[i] + "', \'" + csvStatus[i] +"\', '" +csvTeam[i] + "\')";
                        Statement insertStatement = connection.createStatement();
                        insertStatement.executeUpdate(insertQuery);
                        
                        // Look for newly created players - Just a double check for errors
                        countQuery = "SELECT COUNT(Name), COUNT(Position) FROM Players WHERE Name = '" + csvNames[i] + "' AND Position = '" + csvPositions[i] + "'";
                        countStatement = connection.createStatement();
                        countResults = countStatement.executeQuery(countQuery);
                        nameCount = Integer.parseInt(countResults.getString(1));
                        positionCount = Integer.parseInt(countResults.getString(2));
                       
                        if (nameCount == 0 && positionCount == 0)
                        {
                            // Player still not in DB, add to error array
                            problemPlayers.add(csvNames[i] + ", " + csvPositions[i] + ", ERROR: Not in database");
                        }
                        else
                        {
                            // Player successfully added to DB. Add details to newPlayers array
                            newPlayers.add(csvNames[i] + ", " + csvPositions[i] + ", Inserted into database");
                        }
                    }
                    else
                    {
                        // Duplicate players were found. Add to error array for manual inspection
                        problemPlayers.add(csvNames[i] + ", " + csvPositions[i] + ", ERROR: Duplicate or unknown error");
                    }
                
            }
            
            // Set any null values to inactive
            String setInactive = "UPDATE Players SET Status = 'IAV' WHERE Status IS NULL";
            Statement inactiveStatement = connection.createStatement();
            inactiveStatement.executeUpdate(setInactive);
            
            // Write the error and the insert confimation .csv files
            writeArray(FILE_URL+"-errors.csv", problemPlayers);
            writeArray(FILE_URL+"-insertions.csv", newPlayers);
        } 
        catch (SQLException ex) 
        {
            System.out.println("DATABASE ERROR (in database.java)");
            Logger.getLogger(Database.class.getName()).log(Level.SEVERE, null, ex);
        } 
    }

    /**
     * Write a string ArrayList to a file
     * @param filePath String filepath for the location of file
     * @param array String ArrayList to be written to file
     */
    private static void writeArray(String filePath, ArrayList<String> array)
    {
        PrintWriter writer = null;
        try 
        { 
            writer = new PrintWriter(filePath);
            for (String name : array)
            {
                writer.println(name);
                writer.flush();
            }
            writer.close();
        } 
        catch (FileNotFoundException ex) 
        {
            System.out.println("PRINT WRITER ERROR (in database.java)");
            Logger.getLogger(Database.class.getName()).log(Level.SEVERE, null, ex);
        } 
        finally 
        {
            writer.close();
        }
    }
    
    /**
     * Fix names with apostrophes by adding another apostrophe. SQLite3 uses this
     * as an escape character for any player names that contain an apostrophe '
     * @param name String player name containing apostrohpe
     * @return String player name containing 2 apostrophes (1 is an escape character for SQLite3)
     */
    public String fixName(String name)
    {
       int index = name.indexOf("'");
       String newName = name.substring(0,index) + "'" + name.substring(index);
       return newName;
    }
    
    /**
     * Runs a simple SELECT query and prints results to console in .csv-like format
     * @param query select query to be executed
     */
    public void runQuery(String query) {
        try {
            // Create statement and run query
            PreparedStatement statement;
            statement = connection.prepareStatement(query);
            statement.setFetchSize(1000);
            resultSet = statement.executeQuery();
            
            // Get Meta data for table to print headers
            ResultSetMetaData metaData = resultSet.getMetaData();
            for (int i = 0; i < metaData.getColumnCount(); i++) {
                System.out.print(metaData.getColumnName(i + 1) + ", ");
            }
            System.out.println();

            // Print rows of the result query
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
