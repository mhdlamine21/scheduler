package scheduler.modele;

public class Etudiant extends Utilisateur {
    private String numeroEtudiant;
    private int ufrId;
    private int classeId;
    
    public Etudiant() {
        super();
        this.role = "etudiant";
    }
    
    public Etudiant(String nom, String prenom, String email, String motDePasse, 
                    String numeroEtudiant, int ufrId, int classeId) {
        super(nom, prenom, email, motDePasse, "etudiant");
        this.numeroEtudiant = numeroEtudiant;
        this.ufrId = ufrId;
        this.classeId = classeId;
    }
    
    public String getNumeroEtudiant() { return numeroEtudiant; }
    public void setNumeroEtudiant(String numeroEtudiant) { this.numeroEtudiant = numeroEtudiant; }
    
    public int getUfrId() { return ufrId; }
    public void setUfrId(int ufrId) { this.ufrId = ufrId; }
    
    public int getClasseId() { return classeId; }
    public void setClasseId(int classeId) { this.classeId = classeId; }
}