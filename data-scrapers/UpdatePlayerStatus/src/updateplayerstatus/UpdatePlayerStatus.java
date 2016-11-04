/*
 * @author Eric Davis
 */
package updateplayerstatus;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

/**
 * Launch FXML Document Controller
 * @author Eric Davis
 */
public class UpdatePlayerStatus extends Application {
    
    @Override
    public void start(Stage stage) throws Exception {
        Parent root = FXMLLoader.load(getClass().getResource("UpdatePlayerStatusFXML.fxml"));
        
        Scene scene = new Scene(root);
        
        stage.setTitle("Update Player Status");
        stage.setScene(scene);
        stage.show();
    }

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        launch(args);
    }
    
}
