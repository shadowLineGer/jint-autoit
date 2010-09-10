
; 打开IE
OpenIE()

; 清除IE缓存
ClearCache()

;打开 httpwatch 软件
OpenHttpWatch()

; 读入待测站点列表
$file = FileOpen("C:\temp\sitelist.txt", 0)
While 1
	$line = FileReadLine($file)
	If @error = -1 Then ExitLoop
	ConsoleWrite("" & $line & @CRLF )


    ; 如果URL是正确的，进行速度测试
	If checkUrl( $line )  Then
		If Not FileExists("C:\temp\" & $line & ".csv") Then
			TestSpeed( $line )
		Else
			ConsoleWrite( $line & ".csv is Exist. Skip! " & @CRLF )
		EndIf

	EndIf
WEnd
FileClose($file)
MsgBox(0, "Output", "Finished")

Func checkUrl( $url )
	If StringLen($url) > 0 then
		return True
	Else
		return False
	EndIf

EndFunc



Func TestSpeed( $url )

	;开始 httpwatch 记录
	Sleep(500)
	Send("^{F2}")

	$ret = ControlFocus("[CLASS:IEFrame]", "", "[CLASS:Edit;INSTANCE:1]")
	Sleep(200)
	Send("{BACKSPACE}")
	Sleep(200)
	Send("http://" & $url)
	Sleep(500)
	Send("{ENTER}")

	;停止 httpwatch 记录
	Sleep(5000)
	$count = 0
	$Totalcount = 0
	While 1
		$Totalcount = $Totalcount + 1

		$statusText = ControlGetText("[CLASS:IEFrame]", "", "[CLASS:msctls_statusbar32;INSTANCE:1]")

		If StringLen($statusText)==0 And StringIsSpace ($statusText)==1 Or StringInStr($statusText,"Done") Or StringInStr($statusText,"完成") Then
				ConsoleWrite("Status: >>>" & $statusText & "<<<" & @CRLF )
				$count = $count + 1
		Else
				$count = 0
		EndIf

		If $count > 10 Or $Totalcount > 1150 Then

			ExitLoop
		Else
			Sleep(100)
		EndIf

	WEnd

	Send("^{F3}")
	Sleep(1000)


	; 保存 httpwatch 记录数据
	Send("^+{c}")
	Sleep(200)
	Send("{BACKSPACE}")
	ConsoleWrite("C:\temp\" & $url & @CRLF)
	Sleep(200)
	Send("C:\temp\" & $url)
	Sleep(2000)
	Send("{ENTER}")
    Sleep(2000)

	Send("^+{s}")
	Sleep(200)
	Send("{BACKSPACE}")
	ConsoleWrite("C:\temp\" & $url & @CRLF)
	Sleep(200)
	Send("C:\temp\" & $url)
	Sleep(2000)
	Send("{ENTER}")
    Sleep(3000)

	Send("^{DELETE}")

	Sleep(200)
	$ret = ControlFocus("[CLASS:IEFrame]", "", "[CLASS:Edit;INSTANCE:1]")
	Sleep(200)
	Send("{BACKSPACE}")
	Sleep(200)
	Send("C:\temp\wait.htm")
	Sleep(200)
	Send("{ENTER}")
	Sleep(3000)

;	$clsList = WinGetClassList($title,"")
;	ConsoleWrite("list:" & $clsList & @CRLF)

EndFunc

Func ClearCache()
	Sleep(1000)
	$title = "[CLASS:IEFrame]"
	If Not WinActive($title,"") Then WinActivate($title,"")
	Sleep(1000)
	Send("^+{DEL}")
	Sleep(1000)

	$title2 = "Delete Browsing History"
	WinActivate($title2,"")
	Send("{d 1}")
	Sleep(2000)
EndFunc

Func OpenIE()
	If Not ProcessExists("iexplore.exe") Then
		Run("C:\Program Files\Internet Explorer\iexplore")
		Sleep(2000)
	EndIf
EndFunc

Func OpenHttpWatch()
	$title = "[CLASS:IEFrame]"
	WinMove ( $title,"", 45, 0 )
	Sleep(1000)
	MouseClick("",60,200)
	Sleep(1000)
	Send("+{F2}")
EndFunc