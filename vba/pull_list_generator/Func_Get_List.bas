Attribute VB_Name = "Func_Get_List"
Function Get_List(rawData() As Variant) As Variant()
    Dim sectAccum As SectionAccumulator
    Set sectAccum = New SectionAccumulator
    sectAccum.Initialize
    
    Dim i As Integer, n As Integer
    n = UBound(rawData, 1) - LBound(rawData, 1) + 1
    
    For i = 1 To n
        sectAccum.AddSection CStr(rawData(i, 1))
    Next
    
    Get_List = sectAccum.GetNames()
End Function

