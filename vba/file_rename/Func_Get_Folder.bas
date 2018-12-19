Attribute VB_Name = "Func_Get_Folder"
'' This is copied from the following StackOverflow page: ''
'' https://stackoverflow.com/questions/26392482/vba-excel-to-prompt-user-response-to-select-folder-and-return-the-path-as-string ''

Function Get_Folder() As String
    Dim fldr As FileDialog
    Dim sItem As String
    Set fldr = Application.FileDialog(msoFileDialogFolderPicker)
    With fldr
        .Title = "Select a Folder"
        .AllowMultiSelect = False
        .InitialFileName = Application.DefaultFilePath
        If .Show <> -1 Then GoTo NextCode
        sItem = .SelectedItems(1)
    End With
NextCode:
    Get_Folder = sItem
    Set fldr = Nothing
End Function
