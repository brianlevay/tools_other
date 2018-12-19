VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "SectionAccumulator"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Requires Microsoft Scripting Runtime (Tools > References) '

Private sectionNames As Dictionary

Public Sub Initialize()
    Set sectionNames = New Dictionary
End Sub

Public Sub AddSection(sectStr As String)
    If Not sectionNames.Exists(sectStr) Then
        sectionNames.Add sectStr, True
    End If
End Sub

Private Function DictionaryToArray(dict As Dictionary) As Variant()
    Dim A() As Variant
    Dim dictKeys() As Variant, dictItems() As Variant
    Dim i As Integer, j As Integer, n As Integer
    Dim namePts() As String
    
    ReDim A(0 To dict.count - 1, 0 To 0)
    dictKeys = dict.Keys
    dictItems = dict.Items
    n = dict.count
    
    For i = 0 To n - 1
        A(i, 0) = dictKeys(i)
    Next
    DictionaryToArray = A
End Function

Public Function GetNames() As Variant()
    Dim listOfNames() As Variant
    listOfNames = DictionaryToArray(sectionNames)
    Set sectionNames = Nothing
    GetNames = listOfNames
End Function
