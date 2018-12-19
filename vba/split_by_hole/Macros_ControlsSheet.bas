Attribute VB_Name = "Macros_ControlsSheet"
Sub Set_InputFile()
    Dim wb As Workbook
    Dim ws As Worksheet
    Dim fileStr As String
    
    Set wb = ActiveWorkbook
    Set ws = wb.Sheets("Controls")
    fileStr = UserSelect_FileFolder(ws.Range("C2").Value, True)
    If fileStr <> "" Then
        ws.Range("C2") = fileStr
    End If
End Sub

Sub Set_OutputPath()
    Dim wb As Workbook
    Dim ws As Worksheet
    Dim folderStr As String
    
    Set wb = ActiveWorkbook
    Set ws = wb.Sheets("Controls")
    folderStr = UserSelect_FileFolder(ws.Range("C7").Value, False)
    If folderStr <> "" Then
        ws.Range("C7") = folderStr
    End If
End Sub

Sub Split_File()
    Dim filePath As String
    Dim folderPath As String
    Dim wb As Workbook
    Dim ws As Worksheet
    Set wb = ActiveWorkbook
    Set ws = wb.Sheets("Controls")
    filePath = ws.Range("C2")
    folderPath = ws.Range("C7")
    
    Dim splitterXLS As New XLSsplitter
    Dim splitterCSV As New CSVsplitter
    
    If (InStr(filePath, ".xls") > 0 Or InStr(filePath, ".xlsx")) Then
        splitterXLS.splitXLS filePath, folderPath
        MsgBox "Finished!"
    ElseIf (InStr(filePath, ".csv") > 0) Then
        splitterCSV.splitCSV filePath, folderPath
        MsgBox "Finished!"
    Else
        MsgBox "Invalid file type to split"
    End If
End Sub

