/*
 * @author Eric Davis
 */
package updateplayerstatus;

/**
 * @author Eric Davis
 */
import java.sql.Connection;
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
     * @throws ClassNotFoundException 
     */
    public UpdateDatabase(String fileURL, String dbURL) throws ClassNotFoundException
    {
	 this.FILE_URL = fileURL;
         this.DB_URL = dbURL;
	 System.out.println("Created");
        
         Class.forName("org.sqlite.JDBC");
         this.database = new Database(DB_URL);
    }
	

    @Override
    protected Object call() throws Exception 
    {
       database.updateDatabase(FILE_URL);
       
       throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
}
	