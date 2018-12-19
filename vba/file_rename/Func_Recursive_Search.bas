Attribute VB_Name = "Func_Recursive_Search"
Function Recursive_Search(rootPath As String, funcName As String, ByRef nameObj As NameChange) As Boolean
    Dim FSO As New FileSystemObject
    Dim mainFolder As Folder
    Dim subFolder As Folder
    Dim fileObj As file
    Dim result As String
    
    Set mainFolder = FSO.GetFolder(rootPath)
    For Each fileObj In mainFolder.Files
        If InStr(fileObj.Name, ".spe") > 0 Then
            result = Application.Run(funcName, fileObj, nameObj)
        End If
    Next
    For Each subFolder In mainFolder.SubFolders
        Recursive_Search subFolder.path, funcName, nameObj
    Next
    Set FSO = Nothing
    
    Recursive_Search = True
End Function
