package interpolateMuTau;

public class Interpolate {
    
    public static void main(String[] args) {
        Energies energies = new Energies(1.00,50.00,0.02);
        CSVReader reader = new CSVReader("interpolateMuTau/data/mass_absorption.csv");
        double[][] rawData = reader.toDouble(1,1,1);
        int rowsRaw = rawData.length;
        int colsRaw = rawData[0].length;
        int maxZ = (int) rawData[rowsRaw-1][0];
        int rowsEn = energies.keV.length;
        
        double[][] tau = new double[rowsEn][maxZ+1];
        double[][] mu = new double[rowsEn][maxZ+1];
        String[] header = new String[maxZ+1];
        header[0] = "keV";
        
        int z1;
        int z2;
        double keVi;
        double keV1;
        double keV2;
        int eVi;
        int eV1;
        int eV2;
        double tauI;
        double tau1;
        double tau2;
        double muI;
        double mu1;
        double mu2;
        double nTau;
        double nMu;
        
        // blunt force implementation - not optimized! //
        for (int z = 1; z <= maxZ; z++) {
            header[z] = String.valueOf(z);
            for (int k = 0; k < rowsEn; k++) {
                keVi = energies.keV[k];
                eVi = (int) (keVi * 100);
                if (z==1) {
                    tau[k][0] = keVi;
                    mu[k][0] = keVi;
                }
                for (int r = 0; r < (rowsRaw-1); r++) {
                    z1 = (int) rawData[r][0];
                    z2 = (int) rawData[r+1][0];
                    keV1 = rawData[r][1];
                    keV2 = rawData[r+1][1];
                    eV1 = (int) (keV1 * 100);
                    eV2 = (int) (keV2 * 100);
                    tau1 = rawData[r][2];
                    tau2 = rawData[r+1][2];
                    mu1 = rawData[r][3];
                    mu2 = rawData[r+1][3];
                    if ( (z1 == z) && (z2 == z) && (eV1 <= eVi) && (eV2 >= eVi) ) {
                        nTau = -Math.log10(tau1/tau2) / Math.log10(keV1/keV2);
                        nMu = -Math.log10(mu1/mu2) / Math.log10(keV1/keV2);
                        tauI = tau1 * Math.pow((keV1/keVi),nTau);
                        muI = mu1 * Math.pow((keV1/keVi),nMu);
                        tau[k][z] = tauI;
                        mu[k][z] = muI;
                        break;
                    }
                }
            }
        }
        CSVWriter tauWriter = new CSVWriter("interpolateMuTau/data/tau.csv");
        tauWriter.writeDoubles(tau,header);
        CSVWriter muWriter = new CSVWriter("interpolateMuTau/data/mu.csv");
        muWriter.writeDoubles(mu,header);
    }
    
}