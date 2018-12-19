Attribute VB_Name = "Func_Change_Filename"
Function Change_Filename(fileObj As file, ByRef nameObj As NameChange) As Boolean
    Dim origFileName As String, newFileName As String
    origFileName = fileObj.Name
    If (nameObj.OldName <> "") And (nameObj.NewName <> "") Then
        newFileName = Replace(origFileName, nameObj.OldName, nameObj.NewName)
    End If
    fileObj.Name = newFileName
    File_Summary = True
End Function
