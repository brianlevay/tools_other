Attribute VB_Name = "Macros_ControlsSheet"
Sub Set_SourcePath()
    Dim wb As Workbook
    Dim ws As Worksheet
    Dim folderStr As String
    
    Set wb = ActiveWorkbook
    Set ws = wb.Sheets("Controls")
    folderStr = UserSelect_FileFolder(ws.Range("C3").Value, False)
    ws.Range("C3") = folderStr
End Sub

Sub Set_OutputPath()
    Dim wb As Workbook
    Dim ws As Worksheet
    Dim folderStr As String
    
    Set wb = ActiveWorkbook
    Set ws = wb.Sheets("Controls")
    folderStr = UserSelect_FileFolder(ws.Range("C10").Value, False)
    ws.Range("C10") = folderStr
End Sub

Sub Set_CSVpath()
    Dim wb As Workbook
    Dim ws As Worksheet
    Dim fileStr As String
    
    Set wb = ActiveWorkbook
    Set ws = wb.Sheets("Controls")
    fileStr = UserSelect_FileFolder(ws.Range("C17").Value, True)
    ws.Range("C17") = fileStr
End Sub

Sub Unique_Filenames()
    Dim rootPath As String
    Dim wb As Workbook
    Dim ws As Worksheet
    Set wb = ActiveWorkbook
    Set ws = wb.Sheets("Controls")
    rootPath = ws.Range("C3")
    
    Dim fileAccum As FileAccumulator
    Set fileAccum = New FileAccumulator
    fileAccum.Initialize
    Filename_Search rootPath, fileAccum
    fileAccum.PrintNames "Names"
    fileAccum.EmptyData
    Set fileAccum = Nothing
    
    MsgBox "Finished!"
End Sub

Sub Copy_Rename()
    Dim sourcePath As String, outputPath As String
    Dim wb As Workbook
    Dim ws As Worksheet
    Set wb = ActiveWorkbook
    Set ws = wb.Sheets("Controls")
    sourcePath = ws.Range("C3")
    outputPath = ws.Range("C10")
    
    Dim wantedList As WantedFiles
    Set wantedList = New WantedFiles
    wantedList.Initialize "Match", outputPath
    Copy_Search sourcePath, wantedList
    wantedList.EmptyData
    Set wantedList = Nothing
    
    MsgBox "Finished!"
End Sub

Sub Split_CSV()
    Dim csvPath As String
    Dim wb As Workbook
    Dim ws As Worksheet
    Set wb = ActiveWorkbook
    Set ws = wb.Sheets("Controls")
    csvPath = ws.Range("C17")
    
    Dim splitter As CSVsplitter
    Set splitter = New CSVsplitter
    splitter.SplitCSV csvPath
    
    MsgBox "Finished!"
End Sub
