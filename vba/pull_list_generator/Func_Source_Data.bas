Attribute VB_Name = "Func_Source_Data"
Function Source_Data(srcSheet As String, maxCol As String, sorted As Boolean) As Variant()
    Dim wb As Workbook
    Dim wsSrc As Worksheet
    Dim rgSrc As Range
    Set wb = ActiveWorkbook
    Set wsSrc = wb.Sheets(srcSheet)
    
    Dim srcRows As Long
    Dim srcAddress As String
    srcRows = wsSrc.Range("A" & wsSrc.Rows.count).End(xlUp).Row
    srcAddress = "A2:" & maxCol & srcRows
    Set rgSrc = wsSrc.Range(srcAddress)
    If sorted = True Then
        rgSrc.CurrentRegion.Sort Key1:=wsSrc.Range("A2"), Order1:=xlAscending, Header:=xlNo
    End If
    Source_Data = rgSrc.Value
End Function
