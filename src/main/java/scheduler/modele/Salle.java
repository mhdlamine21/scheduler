package scheduler.modele;

import java.util.ArrayList;
import java.util.List;

public class Salle {
    private int id;
    private String numero;
    private int capacite;
    private String type;
    private int batimentId;
    private int etage;
    private String statut;
    private String motifIndisponibilite;
    private String dateDebutIndisponibilite;
    private String dateFinIndisponibilite;
    private List<Integer> equipements;
    
    public Salle() {
        this.equipements = new ArrayList<>();
    }
    
    public Salle(String numero, int capacite, String type, int batimentId, int etage) {
        this.numero = numero;
        this.capacite = capacite;
        this.type = type;
        this.batimentId = batimentId;
        this.etage = etage;
        this.statut = "disponible";
        this.equipements = new ArrayList<>();
    }
    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getNumero() { return numero; }
    public void setNumero(String numero) { this.numero = numero; }
    
    public int getCapacite() { return capacite; }
    public void setCapacite(int capacite) { this.capacite = capacite; }
    
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    
    public int getBatimentId() { return batimentId; }
    public void setBatimentId(int batimentId) { this.batimentId = batimentId; }
    
    public int getEtage() { return etage; }
    public void setEtage(int etage) { this.etage = etage; }
    
    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }
    
    public String getMotifIndisponibilite() { return motifIndisponibilite; }
    public void setMotifIndisponibilite(String motifIndisponibilite) { this.motifIndisponibilite = motifIndisponibilite; }
    
    public String getDateDebutIndisponibilite() { return dateDebutIndisponibilite; }
    public void setDateDebutIndisponibilite(String dateDebutIndisponibilite) { this.dateDebutIndisponibilite = dateDebutIndisponibilite; }
    
    public String getDateFinIndisponibilite() { return dateFinIndisponibilite; }
    public void setDateFinIndisponibilite(String dateFinIndisponibilite) { this.dateFinIndisponibilite = dateFinIndisponibilite; }
    
    public List<Integer> getEquipements() { return equipements; }
    public void setEquipements(List<Integer> equipements) { this.equipements = equipements; }
    public void addEquipement(int equipementId) { this.equipements.add(equipementId); }
    public void removeEquipement(int equipementId) { this.equipements.remove(Integer.valueOf(equipementId)); }
}