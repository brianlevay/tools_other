Attribute VB_Name = "Func_Filename_Search"
Function Filename_Search(rootPath As String, ByRef fileAccum As FileAccumulator) As Boolean
    Dim FSO As New FileSystemObject
    Dim mainFolder As folder
    Dim subFolder As folder
    Dim fileObj As file
    
    Set mainFolder = FSO.GetFolder(rootPath)
    For Each fileObj In mainFolder.Files
        If InStr(fileObj.name, ".spe") > 0 Then
            fileAccum.AddFilename fileObj
        End If
    Next
    For Each subFolder In mainFolder.SubFolders
        Filename_Search subFolder.path, fileAccum
    Next
    Set FSO = Nothing
    
    Filename_Search = True
End Function
