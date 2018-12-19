Attribute VB_Name = "Func_Left_Pad"
Function Left_Pad(val As Variant) As Variant
    If val < 10 Then
        Left_Pad = "0" & val
    Else
        Left_Pad = val
    End If
End Function
