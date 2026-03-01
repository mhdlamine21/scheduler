package scheduler.modele;

public class Enseignant extends Utilisateur {
    private String matricule;
    
    public Enseignant() {
        super();
        this.role = "enseignant";
    }
    
    public Enseignant(String nom, String prenom, String email, String motDePasse, String matricule) {
        super(nom, prenom, email, motDePasse, "enseignant");
        this.matricule = matricule;
    }
    
    public String getMatricule() { return matricule; }
    public void setMatricule(String matricule) { this.matricule = matricule; }
}