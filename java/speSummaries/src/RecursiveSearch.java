import java.io.File;
import java.io.IOException;

public class RecursiveSearch {
    public boolean findFiles(String rootPath, SummaryAccum accum) {
        File root = new File(rootPath);
        File[] contents = root.listFiles();
        String fileName, filePath;
        for (int i = 0; i < contents.length; i++) {
            if (contents[i].isFile()) {
                fileName = contents[i].getName();
                filePath = contents[i].getPath();
                if (fileName.indexOf(".spe") != -1) {
                    accum.readFile(contents[i]);
                }
            } else if (contents[i].isDirectory()) {
                findFiles(contents[i].getPath(), accum);
            }
        }
        return true;
    }
}