



Func testMain( $workpath, $username, $testplace )

	;初始化各种路径
	$SITELISTPATH = "" & @ScriptDir & "\sitelist.txt"


	$now = @YEAR & @MON & @MDAY & @HOUR ;& @MIN & @SEC
    if FileExists( $workpath ) Then
		$DATAFILEPATH = $workpath & "\" & $now & $testplace
	else
		$DATAFILEPATH = @ScriptDir & "\" & $now & $testplace
	EndIf
	$ret = DirCreate($DATAFILEPATH)

    ; 告诉Server端，测试开始
	$reqUrl = "http://kuandaiceshi.appspot.com/starttest?username=" & $username _
			  & "&place=" & $testplace & "&roundno=" & $now
	prt($reqUrl)
	;pop($reqUrl)
	$response = InetRead ( $reqUrl, 1)
	$ret = BinaryToString($response)
	prt( $ret )


    ; 因为测试有时会出错，无法得到数据，故多做几次，做过的不会重复执行
	For $loopNum=0 To 2
		; 打开IE
		OpenIE()

		; 清除IE缓存
		ClearCache()

		;打开 httpwatch 软件
		OpenHttpWatch()

		; 读入待测站点列表
		$file = FileOpen($SITELISTPATH, 0)
		$i=1
		While 1
			$line = FileReadLine($file)
			If @error = -1 Then ExitLoop
			ConsoleWrite("" & $line & @CRLF)

			; 如果URL是正确的，进行速度测试
			If checkUrl($line) Then
				If Not FileExists($DATAFILEPATH & "\" & $line & ".csv") Then
					TestSpeed($line, $DATAFILEPATH)
					TrayTip("TEST IN PROCESS", "Site: " & $line & " test finished!" & @CRLF & "It's " & $i & ".", 2, 1)
				Else
					ConsoleWrite($line & ".csv is Exist. Skip! " & @CRLF)
				EndIf
			EndIf
			$i=$i+1
		WEnd
		FileClose($file)

		CloseIE()


	Next

    ; 告诉Server端，测试完成
	$reqUrl = "http://kuandaiceshi.appspot.com/endtest"
	prt($reqUrl)
	$response = InetRead ( $reqUrl, 1)
	$ret = BinaryToString($response)
	prt( $ret )


	MsgBox(0, "Output", "Finished", 10)

EndFunc


Func checkUrl($url)
	If StringLen($url) > 0 Then
		Return True
	Else
		Return False
	EndIf

EndFunc   ;==>checkUrl



Func TestSpeed($url, $dataFilePath )

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

		If StringLen($statusText) == 0 Or StringIsSpace($statusText) == 1 _
			Or StringInStr($statusText, "Done") Or StringInStr($statusText, "完成") _
			Or StringInStr($statusText, "完毕") _
			Then

			ConsoleWrite("Status: >>>" & $statusText & "<<<" & @CRLF)
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
	ConsoleWrite("" & $url & @CRLF)
	Sleep(200)
	Send($dataFilePath & "\" & $url)
	Sleep(2000)
	Send("{ENTER}")
	Sleep(2000)

	Send("^+{s}")
	Sleep(200)
	Send("{BACKSPACE}")
	ConsoleWrite("" & $url & @CRLF)
	Sleep(200)
	Send($dataFilePath & "\" & $url)
	Sleep(2000)
	Send("{ENTER}")
	Sleep(3000)

	Send("^{DELETE}")

	Sleep(200)
	$ret = ControlFocus("[CLASS:IEFrame]", "", "[CLASS:Edit;INSTANCE:1]")
	Sleep(200)
	Send("{BACKSPACE}")
	Sleep(200)
	Send(@ScriptDir & "\wait.htm")
	Sleep(200)
	Send("{ENTER}")
	Sleep(3000)

	;	$clsList = WinGetClassList($title,"")
	;	ConsoleWrite("list:" & $clsList & @CRLF)

EndFunc   ;==>TestSpeed

Func ClearCache()
	Sleep(500)
	$title = "[CLASS:IEFrame]"
	If Not WinActive($title, "") Then WinActivate($title, "")
	Sleep(500)
	Send("^+{DEL}")
	Sleep(500)

	$title2 = "Delete Browsing History"
	WinActivate($title2, "")
	Send("{d 1}")
	Sleep(2000)
EndFunc   ;==>ClearCache

Func OpenIE()
	If Not ProcessExists("iexplore.exe") Then
		Run("C:\Program Files\Internet Explorer\iexplore")
		Sleep(2000)
	EndIf
EndFunc   ;==>OpenIE

Func CloseIE()
	If ProcessExists("iexplore.exe") Then
		ProcessClose("iexplore.exe")
		Sleep(1000)
	EndIf
EndFunc   ;==>OpenIE

Func OpenHttpWatch()
	$title = "[CLASS:IEFrame]"
	WinMove($title, "", 45, 0)
	Sleep(500)
	MouseClick("", 60, 200)
	Sleep(500)
	Send("+{F2}")
	Sleep(500)
	MouseMove(60,10)

EndFunc   ;==>OpenHttpWatch







