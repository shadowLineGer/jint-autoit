#include <GUIConstants.au3>

$mainwindow = GUICreate("您好", 200, 700)
GUICtrlCreateLabel("生成随机数", 30, 10)
$resultEdit = GUICtrlCreateEdit("",0,0,200,600)
$okbutton = GUICtrlCreateButton("Run", 70, 620, 60)

GUISwitch($mainwindow)
GUISetState(@SW_SHOW)

Dim $strTemp = ""

While 1
  $msg = GUIGetMsg(1)

  Select
    Case $msg[0] = $okbutton ;	注意这里的$msg[0]和后面的$msg[1]
      ;MsgBox(0, "GUI 事件", Random(0,1))
	  $strTemp = ""
	  For $i=1 to 81 Step 1
		;$strTemp = $strTemp & StringRight(StringLeft( Random(0, 1), 5),4) & @CRLF
		;$strTemp = $strTemp & StringLeft(  Random(0.85, 1.15), 5) & @CRLF
		;$strTemp = $strTemp &  Random(-1, 1, 1) & @CRLF
	  Next

      $i=0
	  While $i < 81
		  $fuhao = Random(-1,1,1)
		  if( $fuhao <> 0 ) Then
			$strTemp = $strTemp & StringLeft(  1+Random(0.05, 0.15)*$fuhao, 5) & @CRLF
			$i=$i+1
		  EndIf
	  WEnd

	  GUICtrlSetData($resultEdit, $strTemp)
	  ClipPut($strTemp)



    Case $msg[0] = $GUI_EVENT_CLOSE And $msg[1] = $mainwindow
      ;MsgBox(0, "GUI 事件", "您选择了关闭主窗口！正在退出...")
      ExitLoop
  EndSelect
WEnd


#CS  VBA 版本
Sub randomData()
' Macro1 Macro
' óé jint ±àD′￡?ê±??: 2010-10-14
    Dim flagNum, flag
    Dim newValue, oldValue As Single
    Dim strValue As String
    Dim i, j As Integer

    i = 3
    While i < 60
        j = 3
        While j < 60
            flagNum = Rnd()
            If flagNum < 0.5 Then
                flag = -1
            Else
                flag = 1
            End If

            If IsNumeric(Cells(i, j).Value) Then
                oldValue = Cells(i, j).Value
                newValue = (1 + (Rnd() / 10 + 0.03) * flag) * oldValue

                If newValue > 0 Then
                    strValue = Format(newValue, "0.000")
                    Cells(i, j).Value = strValue
                Else
                    Cells(i, j).Value = ""
                End If
            End If

            j = j + 1
        Wend
        i = i + 1
    Wend

End Sub
 #CE



