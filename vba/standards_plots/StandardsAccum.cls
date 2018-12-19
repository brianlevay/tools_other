VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "StandardsAccum"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private voltMatch As Double
Private currMatch As Double
Private dcMatch As Double
Private ccMatch As Double

Public x50 As SummaryAccum
Public x100 As SummaryAccum
Public x150 As SummaryAccum

Public Sub Initialize(initialSize As Integer, volt As Double, curr As Double, dc As Double, cc As Double)
    voltMatch = volt
    currMatch = curr
    dcMatch = dc
    ccMatch = cc
    Set x50 = New SummaryAccum
    Set x100 = New SummaryAccum
    Set x150 = New SummaryAccum
    x50.Initialize initialSize
    x100.Initialize initialSize
    x150.Initialize initialSize
End Sub

Public Sub AddFile(xStr As String, timeStr As String, cpsStr As String, voltStr As String, currStr As String, dcStr As String, ccStr As String)
    Dim x As Double, time As Date, CPS As Long, volt As Double, curr As Double, dc As Double, cc As Double
    x = CDbl(Replace(xStr, ",", "."))
    time = CDate(timeStr)
    CPS = CLng(cpsStr)
    volt = CDbl(Replace(voltStr, ",", "."))
    curr = CDbl(Replace(currStr, ",", "."))
    dc = CDbl(Replace(dcStr, ",", "."))
    cc = CDbl(Replace(ccStr, ",", "."))
    If (volt = voltMatch) And (curr = currMatch) And (dc = dcMatch) And (cc = ccMatch) Then
        If (x = 50#) Then
            x50.AddSummary time, CPS
        ElseIf (x = 100#) Then
            x100.AddSummary time, CPS
        ElseIf (x = 150#) Then
            x150.AddSummary time, CPS
        End If
    End If
End Sub

Public Sub PrintSummaries(sheetName As String)
    Dim wb As Workbook
    Dim ws As Worksheet
    Set wb = ActiveWorkbook
    Set ws = wb.Sheets(sheetName)
    ws.UsedRange.ClearContents
    
    ws.Range("A1") = "Voltage"
    ws.Range("A2") = voltMatch
    ws.Range("B1") = "Current"
    ws.Range("B2") = currMatch
    ws.Range("C1") = "DC Slit"
    ws.Range("C2") = dcMatch
    ws.Range("D1") = "CC Slit"
    ws.Range("D2") = ccMatch
    
    Dim rgDate50 As Range, rgCPS50 As Range
    ws.Range("A4") = "X"
    ws.Range("B4") = 50
    ws.Range("A5") = "Date"
    ws.Range("B5") = "CPS"
    Set rgDate50 = ws.Range("A6")
    Set rgCPS50 = ws.Range("B6")
    x50.PrintData rgDate50, rgCPS50
    
    Dim rgDate100 As Range, rgCPS100 As Range
    ws.Range("D4") = "X"
    ws.Range("E4") = 100
    ws.Range("D5") = "Date"
    ws.Range("E5") = "CPS"
    Set rgDate100 = ws.Range("D6")
    Set rgCPS100 = ws.Range("E6")
    x100.PrintData rgDate100, rgCPS100
    
    Dim rgDate150 As Range, rgCPS150 As Range
    ws.Range("G4") = "X"
    ws.Range("H4") = 150
    ws.Range("G5") = "Date"
    ws.Range("H5") = "CPS"
    Set rgDate150 = ws.Range("G6")
    Set rgCPS150 = ws.Range("H6")
    x150.PrintData rgDate150, rgCPS150
End Sub

Public Sub UpdatePlot(sheetName As String, chartName As String)
    Dim x50rows As Integer, x100rows As Integer, x150rows As Integer
    x50rows = x50.Counts
    x100rows = x100.Counts
    x150rows = x150.Counts
    
    Dim x50strX As String, x50strY As String
    Dim x100strX As String, x100strY As String
    Dim x150strX As String, x150strY As String
    x50strX = "=" & sheetName & "!$A$6:$A$" & (x50rows + 5)
    x50strY = "=" & sheetName & "!$B$6:$B$" & (x50rows + 5)
    x100strX = "=" & sheetName & "!$D$6:$D$" & (x100rows + 5)
    x100strY = "=" & sheetName & "!$E$6:$E$" & (x100rows + 5)
    x150strX = "=" & sheetName & "!$G$6:$G$" & (x150rows + 5)
    x150strY = "=" & sheetName & "!$H$6:$H$" & (x150rows + 5)
    
    Dim wb As Workbook
    Dim chrt As Chart
    Set wb = ActiveWorkbook
    Set chrt = wb.Charts(chartName)
    chrt.SeriesCollection(1).XValues = x50strX
    chrt.SeriesCollection(1).Values = x50strY
    chrt.SeriesCollection(2).XValues = x100strX
    chrt.SeriesCollection(2).Values = x100strY
    chrt.SeriesCollection(3).XValues = x150strX
    chrt.SeriesCollection(3).Values = x150strY
End Sub

Public Sub Destroy()
    Set x50 = Nothing
    Set x100 = Nothing
    Set x150 = Nothing
End Sub
