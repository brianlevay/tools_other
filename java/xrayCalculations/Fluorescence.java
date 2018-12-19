package fpSimulation;

public class Fluorescence {
    double geomFactor;
    double angleCorrection;
    
    public Fluorescence(double geomFactor) {
        this.geomFactor = geomFactor;
        this.angleCorrection = Math.sin(Math.toRadians(45));
    }
    
    // This currently only handles Kalpha and Kbeta lines
    // characteristics : Z, Edge, Kb, Ka, epsilon Kb, epsilon Ka
    // Sample Format : Z, Ci(wtF)
    // Output Format: Z, keVbeta, keValpha, Ibeta, Ialpha
    
    public double[][] calculateSpectrum(double[][] beamI, double[][]sample, double[][] characteristics, double[][] tau, double[][] mu) {
        int nEnergies = beamI.length;
        int nElements = sample.length;
        double[][] peakI = createPeakArray(sample, characteristics);
        double[][] muSample = createMuSample(beamI, sample, mu);
        
        int zi;
        int zj;
        double Ci;
        double Cj;
        double Pfluor;
        double Sfluor;
        double Ifluor;
        for (int k = 0; k < nEnergies; k++) {
            for (int i = 0; i < nElements; i++) {
                zi = (int) sample[i][0];
                Ci = sample[i][1];
                for (int pi = 0; pi < 2; pi++) {
                    Pfluor = primaryFluor(k, zi, Ci, pi, characteristics, muSample, tau);
                    Sfluor = 0.0;
                    for (int j = 0; j < nElements; j++) {
                        zj = (int) sample[j][0];
                        Cj = sample[j][1];
                        for (int pj = 0; pj < 2; pj++) {
                            Sfluor = Sfluor + secondaryFluor(k, Pfluor, zi, zj, Cj, pi, pj, characteristics, muSample, tau);
                        }
                    }
                    Ifluor = beamI[k][1] * (Pfluor + Sfluor) * 0.02;
                    peakI[i][pi+3] = peakI[i][pi+3] + Ifluor;
                }
            }
        }
        
        return peakI;
    }
    
    private int rowFromE(double keV) {
        return (int) (keV/0.02);
    }
    
    private double[][] createPeakArray(double[][] sample, double[][] characteristics) {
        int nElements = sample.length;
        double[][] peakI = new double[nElements][5];
        int zi;
        for (int i = 0; i < nElements; i++) {
            zi = (int) sample[i][0];
            peakI[i][0] = sample[i][0];
            peakI[i][1] = characteristics[zi-1][2];
            peakI[i][2] = characteristics[zi-1][3];
            peakI[i][3] = 0.0;
            peakI[i][4] = 0.0;
        }
        return peakI;
    }
    
    private double[][] createMuSample(double[][] beamI, double[][] sample, double[][] mu) {
        int nEnergies = beamI.length;
        int nElements = sample.length;
        double[][] muSample = new double[nEnergies][2];
        int zi;
        double Ci;
        for (int k = 0; k < nEnergies; k++) {
            muSample[k][0] = beamI[k][0];
            for (int i = 0; i < nElements; i++) {
                zi = (int) sample[i][0];
                Ci = sample[i][1];
                muSample[k][1] = muSample[k][1] + (Ci * mu[k][zi]);
            }
        }
        return muSample;
    }
    
    private double primaryFluor(int k, int zi, double Ci, int pi, double[][] characteristics, double[][] muSample, double[][] tau) {
        double Pfluor = 0.0;
        double keV = muSample[k][0];
        double keVedgeI = characteristics[zi-1][1];
        double keVlineI = characteristics[zi-1][2+pi];
        double epsilonI = characteristics[zi-1][4+pi];
        double tauIE = tau[k][zi];
        double muE = muSample[k][1] / this.angleCorrection;
        double muLineI = muSample[rowFromE(keVlineI)][1] / this.angleCorrection;
        if (keV > keVedgeI) {
            Pfluor = (this.geomFactor/this.angleCorrection) * Ci * epsilonI * (tauIE / (muE + muLineI));
        }
        return Pfluor;
    }
    
    // Note that Ji(lambda_j)/Ji(lambda) is treated as 1 because JK is energy independent
    private double secondaryFluor(int k, double Pfluor, int zi, int zj, double Cj, int pi, int pj, double[][] characteristics, double[][] muSample, double[][] tau) {
        double Sfluor = 0.0;
        double keV = muSample[k][0];
        double keVedgeI = characteristics[zi-1][1];
        double keVlineI = characteristics[zi-1][2+pi];
        double epsilonI = characteristics[zi-1][4+pi];
        double keVedgeJ = characteristics[zj-1][1];
        double keVlineJ = characteristics[zj-1][2+pj];
        double epsilonJ = characteristics[zj-1][4+pj];
        double tauIE = tau[k][zi];
        double tauJE = tau[k][zj];
        double tauIlineJ = tau[rowFromE(keVlineJ)][zi];
        double muE = muSample[k][1] / this.angleCorrection;
        double muLineI = muSample[rowFromE(keVlineI)][1] / this.angleCorrection;
        double muLineJ = muSample[rowFromE(keVlineJ)][1];   // No angle correction for this term!
        if ( (keV > keVedgeI) && (keV > keVedgeJ) && (keVlineJ > keVedgeI) ) {
            double L = (muLineJ / muLineI) * Math.log(1.0 + (muLineI / muLineJ)) + (muLineJ / muE) * Math.log(1.0 + (muE / muLineJ));
            Sfluor = 0.5 * Pfluor * Cj * epsilonJ * ((tauJE * tauIlineJ)/(tauIE * muLineJ)) * L;
        }
        return Sfluor;
    }
}