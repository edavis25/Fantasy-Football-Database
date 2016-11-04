/*
 * @author Eric Davis
 */
package updateplayerstatus;

/**
 *
 * @author Eric Davis
 */

import java.io.File;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import fantasy.library.CSVReader;
import javafx.concurrent.Task;

public class UpdateDatabase extends Task
{
    private final String FILE_URL;
    private final String DB_URL;
	
    private final Database database;
    private Connection connection = null;

    /**
     * Default constructor.
     * @param fileURL Filepath to the .csv file
     * @param dbURL Filepath to the Database
     * @throws ClassNotFoundException 
     */
    public UpdateDatabase(String fileURL, String dbURL) throws ClassNotFoundException
    {
	 this.FILE_URL = fileURL;
         this.DB_URL = dbURL;
        
         Class.forName("org.sqlite.JDBC");
         this.database = new Database(DB_URL);
    }
	
    @Override
    public void run()
    {
        database.updateDatabase(FILE_URL);
    }
    
    
    //@Override NOT USED
    protected Object call() throws Exception {
       // throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
       database.updateDatabase(FILE_URL);

       return null;
    }
}
	