package fpSimulation;

public class Energies {
    double[] keV;
    
    public Energies(double minE, double maxE, double stepE) {
        int nE = (int) ((maxE-minE)/stepE);
        nE = nE + 1;
        this.keV = new double[nE];
        this.keV[0] = minE;
        for (int i=1; i<nE; i++) {
            this.keV[i] = this.keV[i-1] + stepE;
        }
    }
}