VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CSVsplitter"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private csvPath As String
Private pathRoot As String
Private csvName As String
Private fileString As String

Public Sub SplitCSV(filePath As String)
    csvPath = filePath
    GetPathComponents
    ReadFile
    SplitContents
End Sub

Private Sub GetPathComponents()
    Dim pathPts() As String
    Dim pieces() As String
    Dim pathPtsN As Integer
    pathPts = Split(csvPath, "\")
    pathPtsN = UBound(pathPts) - LBound(pathPts) + 1
    csvName = pathPts(pathPtsN - 1)
    ReDim Preserve pathPts(0 To pathPtsN - 2)
    pathRoot = Join(pathPts, "\")
End Sub

Private Sub ReadFile()
    Dim FSO As New FileSystemObject
    Dim fileObj As file
    Dim textStream As textStream
    
    Set fileObj = FSO.GetFile(csvPath)
    Set textStream = fileObj.OpenAsTextStream(1)
    fileString = textStream.ReadAll
    textStream.Close
    Set textStream = Nothing: Set fileObj = Nothing
End Sub

Private Sub SplitContents()
    Dim fileLines() As String, fileRows As Integer, header As String
    Dim prevName As String, nextName As String
    Dim batch() As String, batchCt As Integer, batchSize As Integer
    
    If InStr(fileString, vbCrLf) > 0 Then
        fileLines = Split(fileString, vbCrLf)
    Else
        fileLines = Split(fileString, vbLf)
    End If
    fileRows = UBound(fileLines) - LBound(fileLines) + 1
    header = fileLines(0)
    
    batchSize = 100
    ReDim batch(batchSize)
    batch(0) = header
    batch(1) = fileLines(1)
    batchCt = 2
    
    prevName = GetSampleName(fileLines(1))
    For i = 2 To fileRows - 1
        nextName = GetSampleName(fileLines(i))
        If StrComp(nextName, prevName) = 0 Then
            If batchSize = batchCt Then
                batchSize = batchSize + 100
                ReDim Preserve batch(batchSize)
            End If
            batch(batchCt) = fileLines(i)
            batchCt = batchCt + 1
        Else
            ReDim Preserve batch(0 To batchCt)
            WriteToCSV batch, prevName
            batchSize = 100
            ReDim batch(batchSize)
            batch(0) = header
            batch(1) = fileLines(i)
            batchCt = 2
        End If
        prevName = nextName
    Next
End Sub

Private Function GetSampleName(fileLine As String) As String
    Dim linePts() As String, fileNamePts() As String
    If fileLine <> "" Then
        linePts = Split(fileLine, ",")
        If InStr(linePts(0), "!") > 0 Then
            fileNamePts = Split(linePts(0), "!")
        Else
            fileNamePts = Split(linePts(0), " ")
        End If
        GetSampleName = fileNamePts(0)
    Else
        GetSampleName = "None"
    End If
End Function

Private Sub WriteToCSV(ByRef batch() As String, prevName As String)
    Dim nameAppend As String, kVloc As Integer, usLoc As Integer
    Dim outputPath As String
    Dim outputContents As String
    
    kVloc = InStr(csvName, "kV")
    If kVloc > 0 Then
        nameAppend = Mid(csvName, kVloc - 2, 4)
        usLoc = InStr(nameAppend, "_")
        If usLoc > 0 Then
            nameAppend = Mid(nameAppend, usLoc + 1, 3)
        End If
    Else
        nameAppend = ""
    End If
    outputPath = pathRoot + "\" + prevName + "_" + nameAppend + ".csv"
    outputContents = Join(batch, vbLf)
    outputContents = Replace(outputContents, vbCr, "")
    
    Dim FSO As New FileSystemObject
    Dim fileObj As textStream
    Set fileObj = FSO.CreateTextFile(outputPath, True, False)
    fileObj.Write outputContents
    fileObj.Close
    Set FSO = Nothing
End Sub
