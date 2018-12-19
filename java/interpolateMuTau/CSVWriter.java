package interpolateMuTau;

import java.io.File;
import java.io.FileWriter;

public class CSVWriter {
    String fileName;
    File file;
    
    public CSVWriter(String fileName) {
        this.fileName = fileName;
        this.file = new File(this.fileName);
        try {
            this.file.createNewFile();
        } catch (Exception ex) {
            System.err.println(ex);
        }
    }
    
    public void writeStrings(String[][] values, String[] header) {
        try {
            int rowsOut = values.length + 1;
            int colsOut = values[0].length;
            FileWriter fileWriter = new FileWriter(this.file);
            for (int i = 0; i < rowsOut; i++) {
                for (int j = 0; j < colsOut; j++) {
                    String valToWrite;
                    if (i==0) {
                        valToWrite = header[j];
                    } else {
                        valToWrite = values[i-1][j];
                    }
                    
                    if (j==(colsOut-1) && i<(rowsOut-1)) {
                        valToWrite = valToWrite + "\n";
                    } else if (j<(colsOut-1)) {
                        valToWrite = valToWrite + ",";
                    }
                    fileWriter.write(valToWrite);
                }
            }
            fileWriter.flush();
            fileWriter.close();
        } catch (Exception ex) {
            System.err.println(ex);
        }
        return;
    }
    
    public void writeDoubles(double[][] values, String[] header) {
        try {
            int rowsOut = values.length + 1;
            int colsOut = values[0].length;
            FileWriter fileWriter = new FileWriter(this.file);
            for (int i = 0; i < rowsOut; i++) {
                for (int j = 0; j < colsOut; j++) {
                    String valToWrite;
                    if (i==0) {
                        valToWrite = header[j];
                    } else if (j == 0) {
                        valToWrite = String.format("%.2f",values[i-1][j]);
                    } else {
                        valToWrite = String.format("%.6f",values[i-1][j]);
                    }
                    
                    if (j==(colsOut-1) && i<(rowsOut-1)) {
                        valToWrite = valToWrite + "\n";
                    } else if (j<(colsOut-1)) {
                        valToWrite = valToWrite + ",";
                    }
                    fileWriter.write(valToWrite);
                }
            }
            fileWriter.flush();
            fileWriter.close();
        } catch (Exception ex) {
            System.err.println(ex);
        }
        return;
    }
}