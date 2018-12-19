VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CSVsplitter"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private inputPath As String
Private outputFolder As String
Private csvName As String

Private fileString As String
Private header As String
Private expedition As String
Private holeData As New Dictionary

Public Sub SplitCSV(filePath As String, folderPath As String)
    inputPath = filePath
    outputFolder = folderPath
    GetFileName
    ReadFile
    SplitContents
    WriteToCSVs
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
    csvName = namePts(0)
End Sub

Private Sub ReadFile()
    Dim FSO As New FileSystemObject
    Dim fileObj As file
    Dim textStream As textStream
    
    Set fileObj = FSO.GetFile(inputPath)
    Set textStream = fileObj.OpenAsTextStream(1)
    fileString = textStream.ReadAll
    textStream.Close
    Set textStream = Nothing: Set fileObj = Nothing
End Sub

Private Sub SplitContents()
    Dim i As Integer
    Dim fileLines() As String, fileLinesN As Integer
    Dim rowCols() As String
    Dim hole As String
    Dim holeStr As String
    
    If InStr(fileString, vbCrLf) > 0 Then
        fileLines = Split(fileString, vbCrLf)
    Else
        fileLines = Split(fileString, vbLf)
    End If
    fileLinesN = UBound(fileLines) - LBound(fileLines) + 1
    header = fileLines(0)
    
    For i = 1 To fileLinesN - 1
        If StrComp(fileLines(i), "") <> 0 Then
            rowCols = Split(fileLines(i), ",")
            If ValidRow(rowCols) = True Then
                hole = rowCols(1) + rowCols(2)
                If Not holeData.Exists(hole) Then
                    holeData.Add hole, fileLines(i)
                Else
                    holeStr = holeData(hole) + vbLf + fileLines(i)
                    holeData(hole) = holeStr
                End If
            End If
        End If
    Next
End Sub

Private Sub WriteToCSVs()
    Dim outputContents As String
    Dim outputPath As String
    Dim hole As Variant
    Dim FSO As New FileSystemObject
    Dim fileObj As textStream
    
    For Each hole In holeData.Keys
        outputContents = header + vbLf + holeData(hole)
        'outputContents = Replace(outputContents, vbCr, "")
        outputPath = outputFolder + "\" + csvName + "_" + hole + ".csv"
        Set fileObj = FSO.CreateTextFile(outputPath, True, False)
        fileObj.Write outputContents
        fileObj.Close
    Next hole
    Set FSO = Nothing
    Set holeData = Nothing
End Sub

Private Function ValidRow(rowCols() As String) As Boolean
    Dim valid As Boolean
    Dim i As Integer
    valid = True
    For i = 0 To 7
        If StrComp(rowCols(i), "") = 0 Then
            valid = False
        End If
    Next
    ValidRow = valid
End Function
