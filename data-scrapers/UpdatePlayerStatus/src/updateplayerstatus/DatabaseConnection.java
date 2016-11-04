/*
 * @author Eric Davis
 * Creates a connection to the database.
 */
package updateplayerstatus;

import java.sql.Connection;
import java.sql.DriverManager;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Connects to the database.
 * @author Eric Davis
 */
public class DatabaseConnection 
{
    private static String DB_URL = "";
    
    /**
     * Connect to the database
     * @return connection object for interacting with database
     */
    public static Connection getConnection()
    {
        try 
        {
            Class.forName("org.sqlite.JDBC");
          
            // Given Connection -->
            Connection connection = DriverManager.getConnection("jdbc:sqlite:"+ DB_URL);

            System.out.println("Database Connected");
            return connection;
        } 
        catch (Exception ex) 
        {
            Logger.getLogger(DatabaseConnection.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println("Database Not Connected");
            return null;
        }
    }
    
    /**
     * Sets the URL for the database when created in the database.java class
     * @param string Filepath url to the fantasy-football-database.db
     */
    public static void setURL(String string)
    {
        DB_URL = string;
    }
}
