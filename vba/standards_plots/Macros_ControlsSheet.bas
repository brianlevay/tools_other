Attribute VB_Name = "Macros_ControlsSheet"
Sub Standards_Path_toSheet()
    Dim rootPath As String
    Dim wb As Workbook
    Dim ws As Worksheet
    Set wb = ActiveWorkbook
    Set ws = wb.Sheets("Controls")
    
    rootPath = Get_Folder()
    ws.Range("C3") = rootPath
End Sub

Sub Update_Standards()
    Dim rootPath As String
    Dim wb As Workbook
    Dim ws As Worksheet
    Set wb = ActiveWorkbook
    Set ws = wb.Sheets("Controls")
    
    rootPath = ws.Range("C3")
    Standards_Summaries rootPath
End Sub
