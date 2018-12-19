Attribute VB_Name = "Func_Standards_Summaries"
Function Standards_Summaries(rootPath As String) As Boolean
    Dim voltMatch As Double, currMatch As Double, dcMatch As Double, ccMatch As Double
    Dim funcName As String
    Dim accum As StandardsAccum
    Set accum = New StandardsAccum
    
    voltMatch = 9#
    currMatch = 0.25
    dcMatch = 10#
    ccMatch = 12#
    accum.Initialize 1000, voltMatch, currMatch, dcMatch, ccMatch
    
    funcName = "File_Summary"
    Recursive_Search rootPath, funcName, accum
    
    accum.PrintSummaries "Data"
    accum.UpdatePlot "Data", "Plot"
    accum.Destroy
    
    Set accum = Nothing
    MsgBox "Finished!"
    
    Standards_Summaries = True
End Function

