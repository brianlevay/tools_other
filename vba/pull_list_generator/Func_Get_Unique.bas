Attribute VB_Name = "Func_Get_Unique"
Function Get_Unique(rawData() As Variant) As Variant()
    Dim sectAccum As SectionAccumulator
    Set sectAccum = New SectionAccumulator
    sectAccum.Initialize
    
    Dim sectStr As String
    Dim goodRow As Boolean
    Dim i As Integer, j As Integer, n As Integer
    n = UBound(rawData, 1) - LBound(rawData, 1) + 1
    
    For i = 1 To n
        goodRow = True
        For j = 1 To 7
            If rawData(i, j) = "" Then
                goodRow = False
                Exit For
            End If
        Next
        sectStr = rawData(i, 1) & "-" & rawData(i, 2) & rawData(i, 3) & "-"
        sectStr = sectStr & Left_Pad(rawData(i, 4)) & rawData(i, 5) & "-"
        sectStr = sectStr & rawData(i, 6) & rawData(i, 7)
        If goodRow = True Then
            sectAccum.AddSection sectStr
        End If
    Next
    
    Get_Unique = sectAccum.GetNames()
End Function
