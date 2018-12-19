Attribute VB_Name = "Func_Copy_Search"
Function Copy_Search(rootPath As String, ByRef wantedList As WantedFiles) As Boolean
    Dim FSO As New FileSystemObject
    Dim mainFolder As folder
    Dim subFolder As folder
    Dim fileObj As file
    
    Set mainFolder = FSO.GetFolder(rootPath)
    For Each fileObj In mainFolder.Files
        If InStr(fileObj.name, ".spe") > 0 Then
            wantedList.CopyFile fileObj
        End If
    Next
    For Each subFolder In mainFolder.SubFolders
        Copy_Search subFolder.path, wantedList
    Next
    Set FSO = Nothing
    
    Copy_Search = True
End Function

