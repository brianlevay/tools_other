package fpSimulation;

public class Source {
    double keVsrc;
    double milliamps;
    double steradians;
    double thetaIn;
    double thetaOut;
    double contMult;
    double charMult;
    
    int z = 45;
    double bremC = 1.36 * Math.pow(10,9);
    double bremX;
    double angleTerm;
    double ATerm = 102.906;
    double mTerm;
    double JTerm;
    double nTerm;
    double rhozmTerm;
    double rhozbarTerm;
    double[][] I;
    
    public Source(double keVsrc, double milliamps, double steradians, double thetaIn, double thetaOut, double contMult, double charMult) {
        this.keVsrc = keVsrc;
        this.milliamps = milliamps;
        this.steradians = steradians;
        this.thetaIn = thetaIn;
        this.thetaOut = thetaOut;
        this.contMult = contMult;
        this.charMult = charMult;
        
        this.bremX = 1.0314 - 0.0032*this.z + 0.0047*this.keVsrc;
        this.angleTerm = Math.sin(Math.toRadians(this.thetaIn))/Math.sin(Math.toRadians(this.thetaOut));
        this.mTerm = 0.1382 - (0.9211/Math.pow(this.z,0.5));
        this.JTerm = 0.0135 * this.z;
        this.nTerm = Math.pow(this.keVsrc,this.mTerm) * ( 0.1904 - 0.2236*Math.log(this.z) + 0.1292*Math.pow(Math.log(this.z),2) - 0.0149*Math.pow(Math.log(this.z),3) );
        this.rhozmTerm = (this.ATerm/this.z) * ( 0.787*Math.pow(10,-5)*Math.sqrt(this.JTerm)*Math.pow(this.keVsrc,1.5) + 0.735*Math.pow(10,-6)*Math.pow(this.keVsrc,2) );
        this.rhozbarTerm = (0.49269 - 1.0987*this.nTerm + 0.78557*Math.pow(this.nTerm,2));
        
        Energies energies = new Energies(1.00,50.00,0.02);
        int nEnergies = energies.keV.length;
        this.I = new double[nEnergies][2];
        for (int n = 0; n < nEnergies; n++) {
            this.I[n][0] = energies.keV[n];
            this.I[n][1] = 0.0;
        }
    }
    
    public double[][] calculateIntensity(double[][] tau, double[][] RhPeaks) {
        double totalI;
        double contI;
        double charI;
        double keVi;
        double tauAtEi;
        
        double shell;
        double keVline;
        double keVedge;
        double fYield;
        double pTrans;
        
        int nEnergies = this.I.length;
        int nPeaks = RhPeaks.length;
        for (int n = 0; n < nEnergies; n++) {
            keVi = this.I[n][0];
            tauAtEi = tau[n][this.z+1];
            if (keVi <= this.keVsrc) {
                contI = calculateContEi(keVi, tauAtEi);
                totalI = contI;
                for (int p = 0; p < nPeaks; p++) {
                    shell = RhPeaks[p][0];
                    keVline = RhPeaks[p][1];
                    keVedge = RhPeaks[p][2];
                    fYield = RhPeaks[p][3];
                    pTrans = RhPeaks[p][4];
                    if ( (keVedge <= this.keVsrc) && matchEi(keVi, keVline) ) {
                        charI = calculateCharEi(keVi, tauAtEi, shell, keVedge, fYield, pTrans);
                        totalI = totalI + charI;
                    }
                }
                if (totalI > 1) {
                    this.I[n][1] = totalI;
                }
            } else {
                break;
            }
        }
        return this.I;
    }
    
    private double calculateContEi(double keVi, double tauAtEi) {
        double Uo = this.keVsrc / keVi;
        double lnUo = Math.log(Uo);
        double rhozbar = (this.rhozmTerm * this.rhozbarTerm * lnUo) / (0.70256 - 1.09865*this.nTerm + 1.0046*Math.pow(this.nTerm,2) + lnUo);
        double corrTerm = 2 * tauAtEi * rhozbar * this.angleTerm;
        double fChi = (1 - Math.exp(-corrTerm)) / corrTerm;
        fChi = 1 - (1-fChi)*this.contMult;
        
        double bremI = 0.02 * (this.steradians * this.milliamps * this.bremC * this.z * Math.pow(Uo-1,this.bremX));
        double contI = bremI * fChi;
        return contI;
    }
    
    private double calculateCharEi(double keVi, double tauAtEi, double shell, double keVedge, double fYield, double pTrans) {
        double Uo = this.keVsrc / keVedge;
        double lnUo = Math.log(Uo);
        double rhozbar = (this.rhozmTerm * this.rhozbarTerm * lnUo) / (0.70256 - 1.09865*this.nTerm + 1.0046*Math.pow(this.nTerm,2) + lnUo);
        double corrTerm = 2 * tauAtEi * rhozbar * this.angleTerm;
        double fChi = (1 - Math.exp(-corrTerm)) / corrTerm;
        fChi = 1 - (1-fChi)*this.contMult;
        
        double invStopPow = 1 + 16.05 * Math.sqrt(this.JTerm/keVedge) * ( ( Math.sqrt(Uo)*lnUo + 2*(1-Math.sqrt(Uo)) ) / (Uo*lnUo + 1 - Uo) );
        double invStopRow = (1/this.z) * (Uo*lnUo + 1 - Uo) * invStopPow;
        double backScatter = 1 - 0.0081517*this.z + 3.613*Math.pow(10,-5)*Math.pow(this.z,2) + 0.009583*this.z*Math.exp(-Uo) + 0.001141*this.keVsrc;
        
        double charI = this.steradians * this.milliamps * invStopPow * backScatter * fYield * pTrans * fChi;
        if (shell == 1.0) {
            charI = (2.0 * 0.35 * 5.0*Math.pow(10,13)) * charI;
        } else {
            charI = (8.0 * 0.25 * 6.9*Math.pow(10,13)) * charI;
        }
        charI = charI * this.charMult;
        return charI;
    }
    
    private boolean matchEi(double keVi, double keVpeak) {
        boolean match = false;
        int eVi = (int) (keVi*100);
        int eVpeak = (int) (keVpeak*100);
        if ((eVpeak % 2) != 0) {
            eVpeak = eVpeak + 1;
        }
        if (eVi == eVpeak) {
            match = true;
        }
        return match;
    }
}