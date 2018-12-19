Attribute VB_Name = "Func_File_Summary"
Function File_Summary(fileObj As file, ByRef accum As StandardsAccum) As Boolean
    Dim textStream
    Dim fileContents As String
    Dim fileValues() As String
    Dim fileRows As Integer
    Dim i As Integer
    Dim x As String, time As String, CPS As String
    Dim volt As String, curr As String, dc As String, cc As String
    
    Set textStream = fileObj.OpenAsTextStream(1)
    fileContents = textStream.ReadAll
    textStream.Close
    Set textStream = Nothing
    
    fileValues = Split(fileContents, vbCrLf)
    fileRows = UBound(fileValues) - LBound(fileValues) + 1
    For i = 1 To fileRows - 1 Step 1
        If StrComp(fileValues(i), "$X_Position:") = 0 Then
            x = fileValues(i + 1)
        ElseIf StrComp(fileValues(i), "$Slit_DC:") = 0 Then
            dc = fileValues(i + 1)
        ElseIf StrComp(fileValues(i), "$Slit_CC:") = 0 Then
            cc = fileValues(i + 1)
        ElseIf StrComp(fileValues(i), "$TotalCPS:") = 0 Then
            CPS = fileValues(i + 1)
        ElseIf StrComp(fileValues(i), "$ACC_VOLT:") = 0 Then
            volt = fileValues(i + 1)
        ElseIf StrComp(fileValues(i), "$TUBE_CUR:") = 0 Then
            curr = fileValues(i + 1)
        ElseIf StrComp(fileValues(i), "$DATE_MEA:") = 0 Then
            time = fileValues(i + 1)
        End If
    Next i
    accum.AddFile x, time, CPS, volt, curr, dc, cc
    
    File_Summary = True
End Function
