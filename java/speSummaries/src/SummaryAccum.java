import java.io.File;
import java.io.FileWriter;
import java.util.Scanner;
import java.io.IOException;

public class SummaryAccum {
    private StringBuilder summaryStrBuilder = new StringBuilder();
    
    public SummaryAccum() {
        String[] headerVals = new String[] {"Name","X","Date","CPS","kVp","mA","DC Slit","CC Slit"};
        String header = CSVformat(headerVals);
        summaryStrBuilder.append(header);
    }
    
    private String CSVformat(String[] dataVals) {
        String lineToAppend = "";
        int nVals = dataVals.length;
        for (int i = 0; i < nVals - 1; i++) {
            lineToAppend = lineToAppend + dataVals[i] + ",";
        }
        lineToAppend = lineToAppend + dataVals[nVals-1] + "\n";
        return lineToAppend;
    }
    
    public void readFile(File fileObj) {
        try {
            String fileName, firstLine, secondLine, lineToAppend;
            String[] dataVals = new String[8];
            String[] nameParts;
            
            fileName = fileObj.getName();
            if (fileName.indexOf("!") != -1) {
                nameParts = fileName.split("!");
            } else {
                nameParts = fileName.split(" ");
            }
            dataVals[0] = nameParts[0];
            
            Scanner scanner = new Scanner(fileObj);
            firstLine = scanner.nextLine();
            while(scanner.hasNextLine()) {
                secondLine = scanner.nextLine();
                if (firstLine.equals("$X_Position:")) {
                    dataVals[1] = secondLine.replace(",",".");
                } else if (firstLine.equals("$DATE_MEA:")) {
                    dataVals[2] = secondLine;
                } else if (firstLine.equals("$TotalCPS:")) {
                    dataVals[3] = secondLine;
                } else if (firstLine.equals("$ACC_VOLT:")) {
                    dataVals[4] = secondLine.replace(",",".");
                } else if (firstLine.equals("$TUBE_CUR:")) {
                    dataVals[5] = secondLine.replace(",",".");
                } else if (firstLine.equals("$Slit_DC:")) {
                    dataVals[6] = secondLine.replace(",",".");
                } else if (firstLine.equals("$Slit_CC:")) {
                    dataVals[7] = secondLine.replace(",",".");
                }
                firstLine = secondLine;
            }
            scanner.close();
            
            lineToAppend = CSVformat(dataVals);
            summaryStrBuilder.append(lineToAppend);
            return;
        } catch(IOException exc) {
            return;
        }
    }
    
    public void printToFile() {
        String dataStr = summaryStrBuilder.toString();
        File outFile = new File("./display/summaries.csv");
        FileWriter writer;
        try {
            writer = new FileWriter(outFile,false);
            writer.write(dataStr);
            writer.close();
            return;
        } catch (IOException exc) {
            exc.printStackTrace();
            return;
        }
    }
}