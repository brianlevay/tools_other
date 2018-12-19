VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "FileAccumulator"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private fileNames As Dictionary

Public Sub Initialize()
    Set fileNames = New Dictionary
End Sub

Public Sub AddFilename(fileObj As file)
    Dim filePath As String
    Dim filePathPts() As String
    Dim filePathPtsN As Integer
    Dim fileName As String
    Dim fileNamePts() As String
    Dim uniqueName As String
    
    filePathPts = Split(fileObj.Path, "\")
    filePathPtsN = UBound(filePathPts) - LBound(filePathPts) + 1
    
    If InStr(filePathPts(filePathPtsN - 2), "Run") > 0 Then
        filePath = filePathPts(filePathPtsN - 3)
    Else
        filePath = filePathPts(filePathPtsN - 2)
    End If
    
    If InStr(fileObj.name, "!") > 0 Then
        fileNamePts = Split(fileObj.name, "!")
    Else
        fileNamePts = Split(fileObj.name, " ")
    End If
    fileName = fileNamePts(0)
    
    uniqueName = filePath + "\" + fileName
    If Not fileNames.Exists(uniqueName) Then
        fileNames.Add uniqueName, True
    End If
End Sub

Private Function DictionaryToArray(dict As Dictionary) As Variant()
    Dim A() As Variant
    Dim dictKeys() As Variant, dictItems() As Variant
    Dim i As Integer
    Dim n As Integer
    Dim uniquePts() As String
    
    ReDim A(0 To dict.Count - 1, 0 To 1)
    dictKeys = dict.Keys
    dictItems = dict.Items
    n = dict.Count
    
    For i = 0 To n - 1
        uniquePts = Split(dictKeys(i), "\")
        A(i, 0) = uniquePts(0)
        A(i, 1) = uniquePts(1)
    Next
    DictionaryToArray = A
End Function

Public Sub PrintNames(sheetName As String)
    Dim output() As Variant
    output = DictionaryToArray(fileNames)
    Dim size As Integer
    size = UBound(output, 1) - LBound(output, 1) + 1
    
    Dim wb As Workbook
    Dim ws As Worksheet
    Set wb = ActiveWorkbook
    Set ws = wb.Sheets(sheetName)
    ws.UsedRange.ClearContents
    
    ws.Range("A1") = "Folders"
    ws.Range("B1") = "Names"
    Dim rgNames As Range
    Set rgNames = ws.Range("A2")
    
    If size > 0 Then
        rgNames.ReSize(size, 2).Value = output
    End If
End Sub

Public Sub EmptyData()
    Set fileNames = Nothing
End Sub
