VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "NameChange"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private oldNamePart As String
Private newNamePart As String

Property Get OldName() As String
    OldName = oldNamePart
End Property

Property Get NewName() As String
    NewName = newNamePart
End Property

Property Let OldName(oldNameStr As String)
    oldNamePart = oldNameStr
End Property

Property Let NewName(newNameStr As String)
    newNamePart = newNameStr
End Property
