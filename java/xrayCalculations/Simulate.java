package fpSimulation;

public class Simulate {
    
    public static void main(String[] args) {
        CSVReader tauReader = new CSVReader("fpSimulation/data/tau.csv");
        double[][] tau = tauReader.toDouble(1,0,0);
        CSVReader muReader = new CSVReader("fpSimulation/data/mu.csv");
        double[][] mu = muReader.toDouble(1,0,0);
        CSVReader RhReader = new CSVReader("fpSimulation/data/rhodium.csv");
        double[][] RhPeaks = RhReader.toDouble(1,1,0);
        CSVReader charReader = new CSVReader("fpSimulation/data/characteristics.csv");
        double[][] characteristics = charReader.toDouble(1,1,0);
        Elements elements = new Elements();
        
        double keVsrc = 9.0;
        double milliamps = 0.250;
        double steradians = 0.015;
        double thetaIn = 78.0;
        double thetaOut = 12.0;
        double contMult = 1.0;
        double charMult = 0.0;
        
        Source source = new Source(keVsrc, milliamps, steradians, thetaIn, thetaOut, contMult, charMult);
        double[][] sourceI = source.calculateIntensity(tau, RhPeaks);
        
        // Path Materials Format : Material#, Z, Ci(wtF), rho(g/cm3), t(cm)
        double[][] beamPath = { {1, 4, 1.000, 1.850, 0.0125},
                                {2, 7, 0.781, 0.001225, 1.000},
                                {2, 8, 0.210, 0.001225, 1.000},
                                {2, 18, 0.009, 0.001225, 1.000},
                                {3, 6, 0.850, 0.940, 0.0004},
                                {3, 1, 0.150, 0.940, 0.0004},
                                {4, 2, 1.000, 0.0001785, 3.000},
                                {5, 6, 0.850, 0.940, 0.0004},
                                {5, 1, 0.150, 0.940, 0.0004} };
                                
        Attenuator beam = new Attenuator();
        double[][] beamI = beam.modifyIntensity(sourceI, beamPath, mu);
        
        double geomFactor = 0.5;
        double[][] sample = { {14, 0.500},{13, 0.250},{8, 0.250} };
        Fluorescence fluor = new Fluorescence(geomFactor);
        double[][] fluorI = fluor.calculateSpectrum(beamI, sample, characteristics, tau, mu);
                                
        double[][] detectorPath = { {1, 6, 0.850, 0.940, 0.0004},
                                    {1, 1, 0.150, 0.940, 0.0004},
                                    {2, 2, 1.000, 0.0001785, 1.000},
                                    {3, 4, 1.000, 1.850, 0.00125} };
        
        int nElements = fluorI.length;
        int nCols = fluorI[0].length;
        for (int i = 0; i < nElements; i++) {
            for (int j = 0; j < nCols; j++) {
                System.out.print(fluorI[i][j] + ", ");
            }
            System.out.print("\n");
        }
        //String[] header = {"keV","I"};
        //CSVWriter sourceWriter = new CSVWriter("fpSimulation/data/source.csv");
        //sourceWriter.writeDoubles(sourceI, header);
        //CSVWriter beamWriter = new CSVWriter("fpSimulation/data/beam.csv");
        //beamWriter.writeDoubles(beamI, header);
        
        return;
    }
}