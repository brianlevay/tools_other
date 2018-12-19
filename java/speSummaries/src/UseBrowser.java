// Modified from: //
// https://stackoverflow.com/questions/5226212/how-to-open-the-default-webbrowser-using-java //
// Only works on Windows //

import java.io.File;

public class UseBrowser {
    public void open() throws Exception {
        try {
            File plotHTML = new File("./display/plot.html");
            String plotHTMLPath = plotHTML.getCanonicalPath();
            Runtime rt = Runtime.getRuntime();
            rt.exec("rundll32 url.dll,FileProtocolHandler " + plotHTMLPath);
        } catch(Exception exc) {
            System.out.println("Cannot open browser.");
            return;
        }
    }
}