package scheduler.modele;

import java.time.LocalDateTime;

public class Ufr {
    private int id;
    private String nom;
    private String description;
    private LocalDateTime dateCreation;
    
    public Ufr() {}
    
    public Ufr(String nom, String description) {
        this.nom = nom;
        this.description = description;
        this.dateCreation = LocalDateTime.now();
    }
    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public LocalDateTime getDateCreation() { return dateCreation; }
    public void setDateCreation(LocalDateTime dateCreation) { this.dateCreation = dateCreation; }
}