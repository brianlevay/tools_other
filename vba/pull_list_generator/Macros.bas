Attribute VB_Name = "Macros"
Sub Start_Get_Unique()
    Dim rawData() As Variant
    rawData = Source_Data("Input", "G", False)
    
    Dim sectNames() As Variant
    Dim size As Integer
    sectNames = Get_Unique(rawData)
    size = UBound(sectNames, 1) - LBound(sectNames, 1) + 1
    
    Dim wb As Workbook
    Dim wsDest As Worksheet
    Dim rgDest As Range
    Set wb = ActiveWorkbook
    Set wsDest = wb.Sheets("List")
    Dim destRows As Long
    Dim destAddress As String
    destRows = wsDest.Range("A" & wsDest.Rows.count).End(xlUp).Row
    destAddress = "A" & (destRows + 1)
    Set rgDest = wsDest.Range(destAddress)
    rgDest.Resize(size, 1).Value = sectNames
    
    MsgBox "Finished!"
End Sub

Sub Start_List_Split()
    Dim rawData() As Variant
    rawData = Source_Data("List", "A", True)
    
    Dim sectNames() As Variant
    Dim size As Integer
    sectNames = Get_List(rawData)
    size = UBound(sectNames, 1) - LBound(sectNames, 1) + 1
    
    Dim wb As Workbook
    Dim wsDest As Worksheet
    Dim rgDest As Range
    Set wb = ActiveWorkbook
    Set wsDest = wb.Sheets("Splits")
    wsDest.UsedRange.ClearContents
    
    Dim chunkN As Integer, rowN As Integer, offset As Integer, count As Integer
    chunkN = 39
    rowN = 2
    offset = 4
    count = 0
    
    Dim i As Integer
    Dim destAddress As String
    Dim A() As Variant
    ReDim A(0 To chunkN, 0 To 0)
    For i = 0 To size - 1
        A(count, 0) = sectNames(i, 0)
        If (count = chunkN) Or (i = size - 1) Then
            destAddress = "A" & rowN
            Set rgDest = wsDest.Range(destAddress)
            rgDest.Resize(chunkN + 1, 1).Value = A
            ReDim A(0 To chunkN, 0 To 0)
            rowN = rowN + chunkN + offset
            count = 0
        Else
            count = count + 1
        End If
    Next
    
    MsgBox "Finished!"
End Sub
