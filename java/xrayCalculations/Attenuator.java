package fpSimulation;

public class Attenuator {
    
    public double[][] modifyIntensity(double[][] incomingI, double[][] pathMaterials, double[][] mu) {
        // Path Materials Format : Material#, Z, Ci(wtF), rho(g/cm3), t(cm)
        int nEnergies = incomingI.length;
        int nPathRows = pathMaterials.length;
        
        double muAtEi;
        int zCol;
        double Ci;
        double rho;
        double thickness;
        double exponentSum;
         
        double[][] modifiedI = new double[nEnergies][2];
         
        for (int k = 0; k < nEnergies; k++) {
            exponentSum = 0;
            for (int r = 0; r < nPathRows; r++) {
                zCol = (int) pathMaterials[r][1];
                Ci = pathMaterials[r][2];
                rho = pathMaterials[r][3];
                thickness = pathMaterials[r][4];
                muAtEi = mu[k][zCol];
                exponentSum = exponentSum + (-muAtEi * Ci * rho * thickness);
            }
            modifiedI[k][0] = incomingI[k][0];
            modifiedI[k][1] = incomingI[k][1] * Math.exp(exponentSum);
        }
        return modifiedI;
    }
    
}