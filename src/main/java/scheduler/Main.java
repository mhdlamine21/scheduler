package scheduler;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

public class Main extends Application {
    
    public static void main(String[] args) {
        launch(args);
    }
    
    @Override
    public void start(Stage primaryStage) {
        try {
            System.out.println("Application démarrée avec succès !");
            
            // Pour tester, on crée une fenêtre simple
            Parent root = FXMLLoader.load(getClass().getResource("/fxml/Login.fxml"));
            Scene scene = new Scene(root);
            scene.getStylesheets().add(getClass().getResource("/css/style.css").toExternalForm());
            
            primaryStage.setTitle("SCHEDULER - Gestion des emplois du temps");
            primaryStage.setScene(scene);
            primaryStage.show();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}