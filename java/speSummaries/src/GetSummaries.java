public class GetSummaries {
    public static void main(String[] args) throws Exception {
        RecursiveSearch search = new RecursiveSearch();
        SummaryAccum accum = new SummaryAccum();
        UseBrowser browser = new UseBrowser();
        
        String path = args[0];
        search.findFiles(path, accum);
        accum.printToFile();
        browser.open();
        System.out.println("Program complete");
    }
}