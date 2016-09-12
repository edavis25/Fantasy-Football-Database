/*
 * @author Eric Davis
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
         
            // Given Connection from file chooser-->
            Connection connection = DriverManager.getConnection("jdbc:sqlite:"+ DB_URL);

            return connection;
        } 
        catch (Exception ex) 
        {
            Logger.getLogger(DatabaseConnection.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println("Not Connected");
            return null;
            //TODO: Add error alert for no connetion - remove printlines
        }
    }
    
    public static void setURL(String string)
    {
        DB_URL = string;
    }
}
