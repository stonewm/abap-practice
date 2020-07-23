Option Explicit

Dim logonControl As SAPLogonCtrl.SAPLogonControl
Dim connection As SAPLogonCtrl.connection

Public Sub LogonSAP()
    Set logonControl = New SAPLogonControl
    Set connection = logonControl.NewConnection()
    
    With connection
        .System = "D01"                    '系统标识
        .ApplicationServer = "sapecc6"     '应用服务器，一般为IP地址
        .SystemNumber = "00"               '实例编号
        .Client = "001"
        .User = "STONE"
        .Password = "123456"
    End With

    Call connection.Logon(0, True)
End Sub

Public Sub LogoffSAP()
    If Not connection Is Nothing And connection.IsConnected = tloRfcConnected Then
        connection.Logoff
    End If
End Sub

Public Sub Read_SKA1()
    Dim fms As SAPFunctionsOCX.SAPFunctions
    Dim fm As SAPFunctionsOCX.Function
    Dim content As SAPTableFactoryCtrl.Table

    Call LogonSAP
    
    If connection.IsConnected <> tloRfcConnected Then
        MsgBox "连接失败"
        Exit Sub
    End If
    
    Set fms = New SAPFunctions
    Set fms.connection = connection
    Set fm = fms.Add("Z_SKA1_READ")
    
    fm.Exports("KTOPL").Value = "Z900"
    fm.Call
    
    If fm.Exception <> "" Then
        Exit Sub
    End If
    
    Set content = fm.Tables("CONTENT")
    
    Call WriteTable(content, Sheet1)
    
    Call LogoffSAP
End Sub

Public Sub WriteTable(itab As SAPTableFactoryCtrl.Table, sht As Worksheet)
    Dim col As Long             'column index
    Dim row As Long             'row index
    Dim headerRange As Variant  '在Excel中根据itab的header大小，类型为Variant数组
    Dim itemsRange As Variant   '在Excel中根据itab的行数和列数，类型为Variant数组
    
    If itab.RowCount = 0 Then Exit Sub
    
    '-------------------------------------------------
    ' 取消Excel的屏幕刷新和计算功能以加快速度
    '-------------------------------------------------
    Application.ScreenUpdating = False
    Application.Calculation = xlCalculationManual
    
    ' 清除cells的内容
    sht.Cells.ClearContents

    '------------------------------
    ' 将Table的Header写入Worksheet
    '------------------------------
    
    ' 根据内表的列数，使用Range创建一个数组
    Dim headerstarts As Range
    Dim headerends As Range
    Set headerstarts = sht.Cells(1, 1)
    Set headerends = sht.Cells(1, itab.ColumnCount)
    
    headerRange = sht.Range(headerstarts, headerends).Value
    
    ' 将内表列名写入数组
    For col = 1 To itab.ColumnCount
        headerRange(1, col) = itab.Columns(col).Name
    Next
    
    ' 从数组一次性写入Excel，这样效率较高
    sht.Range(headerstarts, headerends).Value = headerRange
    
    '-------------------------------
    ' 将Table的行项目写入Worksheet
    '-------------------------------
    
    ' 根据内表的大小,使用Range创建数组
    Dim itemStarts As Range
    Dim itemEnds As Range
    
    Set itemStarts = sht.Cells(2, 1)
    Set itemEnds = sht.Cells(itab.RowCount + 1, itab.ColumnCount)

    Dim rowidx As Integer
    Dim colidx As Integer
    itemsRange = sht.Range(itemStarts, itemEnds).Value
    For rowidx = 1 To itab.RowCount
        For colidx = 1 To itab.ColumnCount
            itemsRange(rowidx, colidx) = itab.Value(rowidx, colidx)
        Next
    Next
    
    ' 一次性将数组写入Worksheet
    sht.Range(itemStarts, itemEnds).Value = itemsRange
    
    '---------------------------------
    ' 恢复Excel的屏幕刷新和计算
    '---------------------------------
    Application.ScreenUpdating = True
    Application.Calculation = xlCalculationAutomatic
End Sub
