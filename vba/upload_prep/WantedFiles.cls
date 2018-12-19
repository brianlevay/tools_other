VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "WantedFiles"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private fileNames As Dictionary
Private outputDir As String
Private folderSet() As String
Private folderNum As Integer

Public Sub Initialize(sheetName As String, outputPath As String)
    Dim wb As Workbook
    Dim ws As Worksheet
    Dim lastRow As Integer
    Dim concFileName As String
    
    Set wb = ActiveWorkbook
    Set ws = wb.Sheets(sheetName)
    Set fileNames = New Dictionary
    lastRow = ws.Range("A" & Rows.Count).End(xlUp).Row
    For i = 2 To lastRow
        concFileName = ws.Cells(i, 1).Value & "\" & ws.Cells(i, 2)
        fileNames.Add concFileName, ws.Cells(i, 3)
    Next
    
    outputDir = outputPath
    CreateFolders
End Sub

Private Sub CreateFolders()
    '' Only need to sort according to voltage and filter ''
    '' Slit size, current, and other settings don't impact model ''
    folderNum = 5
    ReDim folderSet(0 To folderNum - 1)
    folderSet(0) = "9kV_No-Filter"
    folderSet(1) = "10kV_No-Filter"
    folderSet(2) = "30kV_Pd-Thin"
    folderSet(3) = "30kV_Pd-Thick"
    folderSet(4) = "50kV_Cu"
    
    Dim FSO As New FileSystemObject
    Dim folderPath As String
    For Each folderDest In folderSet
        folderPath = outputDir & "\" & folderDest
        If Not FSO.FolderExists(folderPath) Then
            FSO.CreateFolder folderPath
        End If
    Next
    Set FSO = Nothing
End Sub

Public Sub CopyFile(fileObj As File)
    Dim nameFolder As String, info As Variant, uniqueSample As String
    Dim newSampleName As String, newFileName As String, needsClean As Boolean
    If InStr(fileObj.name, ",") > 0 Then
        needsClean = True
    Else
        needsClean = False
    End If
    
    nameFolder = GetNameFolder(fileObj)
    info = GetInfo(fileObj)
    uniqueSample = nameFolder & "\" & info(0)
    If fileNames.Exists(uniqueSample) Then
        newSampleName = fileNames.Item(uniqueSample)
        newFileName = Replace(fileObj.name, info(0), newSampleName)
        For i = 0 To folderNum - 1
           If (info(1) & "_" & info(2)) = folderSet(i) Then
                If needsClean = True Then
                    CleanCopy fileObj, newFileName, folderSet(i)
                Else
                    SimpleCopy fileObj, newFileName, folderSet(i)
                End If
           End If
       Next
    End If
End Sub

Private Function GetNameFolder(fileObj As File) As String
    Dim nameFolder As String
    Dim filePathPts() As String
    Dim filePathPtsN As Integer
    filePathPts = Split(fileObj.Path, "\")
    filePathPtsN = UBound(filePathPts) - LBound(filePathPts) + 1
    If InStr(filePathPts(filePathPtsN - 2), "Run") > 0 Then
        nameFolder = filePathPts(filePathPtsN - 3)
    Else
        nameFolder = filePathPts(filePathPtsN - 2)
    End If
    GetNameFolder = nameFolder
End Function

Private Function GetInfo(fileObj As File) As Variant
    Dim info As Variant
    If InStr(fileObj.name, "!") > 0 Then
        info = InfoNew(fileObj.name)
    Else
        info = InfoOld(fileObj.name)
    End If
    GetInfo = info
End Function

Private Function InfoNew(fileName As String) As Variant
    Dim name As String, volt As String, filter As String
    Dim fileStrArr() As String
    Dim info() As Variant
    
    fileStrArr = Split(fileName, "!")
    name = fileStrArr(0)
    volt = (Replace(fileStrArr(7), " ", "") & "kV")
    filter = fileStrArr(11)
    
    ReDim info(2)
    info(0) = name: info(1) = volt: info(2) = filter
    InfoNew = info
End Function

Function InfoOld(fileName As String) As Variant
    Dim name As String, volt As String, filter As String
    Dim fileStrArr() As String
    Dim info() As Variant
    Dim arrN As Integer
    
    fileStrArr = Split(fileName, " ")
    arrN = UBound(fileStrArr) - LBound(fileStrArr) + 1
    name = fileStrArr(0)
    For i = 1 To arrN - 1
        If InStr(fileStrArr(i), "kV") <> 0 Then
            volt = Replace(fileStrArr(i), " ", "")
        End If
        If InStr(fileStrArr(i), "uA") <> 0 Then
            filter = fileStrArr(i + 1)
        End If
    Next
    
    ReDim info(2)
    info(0) = name: info(1) = volt: info(2) = filter
    InfoOld = info
End Function

Private Sub CleanCopy(fileObj As File, newFileName, folderName)
    Dim FSO As New FileSystemObject
    Dim textStream As textStream
    Dim fileString As String
    Dim newPath As String
    
    newFileName = Replace(newFileName, ",", ".")
    Set fileObj = FSO.GetFile(fileObj.Path)
    Set textStream = fileObj.OpenAsTextStream(1)
    fileString = textStream.ReadAll
    textStream.Close
                
    fileString = Replace(fileString, ",", ".")
    newPath = outputDir & "\" & folderName & "\" & newFileName
    Set textStream = FSO.CreateTextFile(newPath, True, False)
    textStream.Write fileString
    textStream.Close
    
    Set textStream = Nothing: Set fileObj = Nothing: Set FSO = Nothing
End Sub

Public Sub SimpleCopy(fileObj As File, newFileName, folderName)
    Dim FSO As New FileSystemObject
    Dim newPath As String
    
    newPath = outputDir & "\" & folderName & "\" & newFileName
    FSO.CopyFile fileObj.Path, newPath
    
    Set FSO = Nothing
End Sub

Public Sub EmptyData()
    Set fileNames = Nothing
End Sub
