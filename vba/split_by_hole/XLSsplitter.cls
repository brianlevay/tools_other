VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "XLSsplitter"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private inputPath As String
Private outputFolder As String
Private xlsName As String
Private wbIn As Workbook
Private wsIn As Worksheet
Private holeList As New Dictionary

Public Sub splitXLS(filePath As String, folderPath As String)
    inputPath = filePath
    outputFolder = folderPath
    GetFileName
    OpenSourceFile
    SplitFileContents
    WriteContents
    DestroyObject
End Sub

Private Sub GetFileName()
    Dim pathPts() As String
    Dim pieces() As String
    Dim pathPtsN As Integer
    Dim fileNameFull As String
    Dim namePts() As String
    
    pathPts = Split(inputPath, "\")
    pathPtsN = UBound(pathPts) - LBound(pathPts) + 1
    fileNameFull = pathPts(pathPtsN - 1)
    namePts = Split(fileNameFull, ".")
    xlsName = namePts(0)
End Sub

Private Sub OpenSourceFile()
    Set wbIn = Workbooks.Open(inputPath)
    'wbIn.Windows(1).Visible = False
    Set wsIn = wbIn.Worksheets(1)
End Sub

Private Sub SplitFileContents()
    Dim inputArea As Range
    Dim inputRowN, inputColN As Long
    Dim hole As String
    Dim header, rowContents As Variant
    Dim rows As Collection
    
    Set inputArea = wsIn.UsedRange
    inputRowN = inputArea.rows.Count
    inputColN = inputArea.Columns.Count
    header = wsIn.Range(Cells(1, 1).Address(), Cells(1, inputColN).Address()).Value
    
    For i = 2 To inputRowN
        If Not IsEmpty(wsIn.Cells(i, 1)) And _
        Not IsEmpty(wsIn.Cells(i, 2)) And _
        Not IsEmpty(wsIn.Cells(i, 3)) And _
        Not IsEmpty(wsIn.Cells(i, 4)) And _
        Not IsEmpty(wsIn.Cells(i, 5)) And _
        Not IsEmpty(wsIn.Cells(i, 6)) And _
        Not IsEmpty(wsIn.Cells(i, 7)) Then
            hole = wsIn.Cells(i, 2).Value + wsIn.Cells(i, 3).Value
            rowContents = wsIn.Range(wsIn.Cells(i, 1).Address(), wsIn.Cells(i, inputColN).Address()).Value
            If Not holeList.Exists(hole) Then
                Set rows = New Collection
                rows.Add header
                rows.Add rowContents
                holeList.Add hole, rows
            Else
                holeList.Item(hole).Add rowContents
            End If
        End If
    Next
    Set rows = Nothing
End Sub

Private Sub WriteContents()
    Dim hole As Variant
    Dim rows As Collection
    Dim rowArr(), contentsArr() As Variant
    Dim i, j, nRows, nCols As Integer
    Dim wbOut As Workbook
    Dim wsOut As Worksheet
    Dim rgOut As Range
    Dim wbName, wbPath As String
    
    For Each hole In holeList.Keys
        Set rows = holeList.Item(hole)
        nRows = rows.Count
        rowArr = rows.Item(1)
        nCols = UBound(rowArr, 2) - LBound(rowArr, 2) + 1
        ReDim contentsArr(1 To nRows, 1 To nCols)
        For i = 1 To nRows
            rowArr = rows.Item(i)
            For j = 1 To nCols
                contentsArr(i, j) = rowArr(1, j)
            Next
        Next
        
        wbName = xlsName + "_" + hole + ".xlsx"
        wbPath = outputFolder + "\" + wbName
        Set wbOut = Workbooks.Add
        Set wsOut = wbOut.Worksheets(1)
        Set rgOut = wsOut.Range("A1")
        Set rgOut = rgOut.Resize(nRows, nCols)
        rgOut.Value = contentsArr
        wbOut.SaveAs Filename:=wbPath
        wbOut.Close savechanges:=False
    Next
    wbIn.Saved = True
    wbIn.Close
    Set rows = Nothing
End Sub

Private Sub DestroyObject()
    Set holeList = Nothing
End Sub
