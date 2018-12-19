package fpSimulation;

import java.io.File;
import java.util.Scanner;

public class CSVReader {
    String fileName;
    File file;
    int rows;
    int cols;
    
    public CSVReader(String fileName) {
        this.fileName = fileName;
        this.file = new File(this.fileName);
        int rowCt = 0;
        int colCt = 0;
        try {
            Scanner inputStream = new Scanner(this.file);
            while(inputStream.hasNextLine()){
                String line = inputStream.nextLine();
                String[] fields = line.split(",");
                if (fields.length > colCt) {
                    colCt = fields.length;
                }
                rowCt = rowCt + 1;
            }
            this.rows = rowCt;
            this.cols = colCt;
            inputStream.close();
        } catch (Exception ex) {
            System.err.println(ex);
        }
    }
    
    public String[][] toString(int rowsHeader, int colFromStart, int colFromEnd) {
        int nRows = this.rows - rowsHeader;
        int nCols = this.cols - colFromEnd - colFromStart;
        String[][] values = new String[nRows][nCols];
        
        try {
            Scanner inputStream = new Scanner(this.file);
            int rowCt = 0;
            while(inputStream.hasNextLine()){
                String line = inputStream.nextLine();
                String[] fields = line.split(",");
                if (fields.length == this.cols) {
                    if (rowCt >= rowsHeader) {
                        for (int j = 0; j < nCols; j++) {
                            values[rowCt-rowsHeader][j] = fields[j+colFromStart];
                        }
                    }
                }
                rowCt = rowCt + 1;
            }
            inputStream.close();
        } catch (Exception ex) {
            System.err.println(ex);
        }
        return values;
    }
    
    public double[][] toDouble(int rowsHeader, int colFromStart, int colFromEnd) {
        int nRows = this.rows - rowsHeader;
        int nCols = this.cols - colFromEnd - colFromStart;
        double[][] values = new double[nRows][nCols];
        
        try {
            Scanner inputStream = new Scanner(this.file);
            int rowCt = 0;
            while(inputStream.hasNextLine()){
                String line = inputStream.nextLine();
                String[] fields = line.split(",");
                if (fields.length == this.cols) {
                    if (rowCt >= rowsHeader) {
                        for (int j = 0; j < nCols; j++) {
                            values[rowCt-rowsHeader][j] = Double.parseDouble(fields[j+colFromStart]);
                        }
                    }
                }
                rowCt = rowCt + 1;
            }
            inputStream.close();
        } catch (Exception ex) {
            System.err.println(ex);
        }
        return values;
    }

}