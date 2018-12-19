Attribute VB_Name = "Func_UserSelect_FileFolder"
Function UserSelect_FileFolder(startingPath As String, isFile As Boolean) As String
    Dim pathStr As String
    Dim fDialog As FileDialog
    Dim sPath() As String, sPathN As Integer, sRoot As String
    
    If isFile Then
        Set fDialog = Application.FileDialog(msoFileDialogFilePicker)
        fDialog.Title = "Select a File"
    Else
        Set fDialog = Application.FileDialog(msoFileDialogFolderPicker)
        fDialog.Title = "Select a Folder"
    End If
    
    fDialog.AllowMultiSelect = False
    If startingPath = "" Then
        fDialog.InitialFileName = Application.DefaultFilePath
    Else
        sPath = Split(startingPath, "\")
        sPathN = UBound(sPath) - LBound(sPath) + 1
        ReDim Preserve sPath(0 To sPathN - 2)
        sRoot = Join(sPath, "\")
        fDialog.InitialFileName = sRoot
    End If
    If fDialog.Show = -1 Then
        pathStr = fDialog.SelectedItems(1)
    End If
    UserSelect_FileFolder = pathStr
End Function
