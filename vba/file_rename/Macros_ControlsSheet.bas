Attribute VB_Name = "Macros_ControlsSheet"
Sub Files_Path_toSheet()
    Dim rootPath As String
    Dim wb As Workbook
    Dim ws As Worksheet
    Set wb = ActiveWorkbook
    Set ws = wb.Sheets("Controls")
    
    rootPath = Get_Folder()
    ws.Range("C3") = rootPath
End Sub

Sub Rename_Files()
    Dim rootPath As String
    Dim wb As Workbook
    Dim ws As Worksheet
    Set wb = ActiveWorkbook
    Set ws = wb.Sheets("Controls")
    
    Dim funcName As String
    funcName = "Change_Filename"
    
    Dim nameObj As NameChange
    Set nameObj = New NameChange
    nameObj.OldName = ws.Range("C8")
    nameObj.NewName = ws.Range("C9")
    
    rootPath = ws.Range("C3")
    Recursive_Search rootPath, funcName, nameObj
    MsgBox "Finished!"
End Sub
