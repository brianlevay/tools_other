VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "SummaryAccum"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private sizeVal As Integer
Private countVal As Integer
Private dateVals() As Date
Private cpsVals() As Long

Public Property Get Counts()
    Counts = countVal
End Property

Public Property Get Dates()
    Dates = dateVals
End Property

Public Property Get CPS()
    CPS = cpsVals
End Property

Public Sub Initialize(initialSize As Integer)
    sizeVal = initialSize
    countVal = 0
    ReDim dateVals(sizeVal)
    ReDim cpsVals(sizeVal)
End Sub

Private Sub ReSize()
    sizeVal = sizeVal + 1000
    ReDim Preserve dateVals(sizeVal)
    ReDim Preserve cpsVals(sizeVal)
End Sub

Public Sub AddSummary(time As Date, CPS As Long)
    countVal = countVal + 1
    If sizeVal <= countVal Then
        ReSize
    End If
    dateVals(countVal - 1) = time
    cpsVals(countVal - 1) = CPS
End Sub

Public Sub PrintData(rgDate As Range, rgCPS As Range)
    If countVal > 0 Then
        rgDate.ReSize(countVal, 1).value = Application.Transpose(dateVals)
        rgCPS.ReSize(countVal, 1).value = Application.Transpose(cpsVals)
    End If
End Sub

