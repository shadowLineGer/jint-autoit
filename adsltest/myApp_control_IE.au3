



Func testMain( $workpath, $username, $testplace )

	;��ʼ������·��
	$SITELISTPATH = "" & @ScriptDir & "\sitelist.txt"


	$now = @YEAR & @MON & @MDAY & @HOUR ;& @MIN & @SEC
    if FileExists( $workpath ) Then
		$DATAFILEPATH = $workpath & "\" & $now & $testplace
	else
		$DATAFILEPATH = @ScriptDir & "\" & $now & $testplace
	EndIf
	$ret = DirCreate($DATAFILEPATH)

    ; ����Server�ˣ����Կ�ʼ
	$reqUrl = "http://kuandaiceshi.appspot.com/starttest?username=" & $username _
			  & "&place=" & $testplace & "&roundno=" & $now
	prt($reqUrl)
	;pop($reqUrl)
	$response = InetRead ( $reqUrl, 1)
	$ret = BinaryToString($response)
	prt( $ret )

	; ��IE
	OpenIE()

	;�� httpwatch ���
	OpenHttpWatch()

    ; ��Ϊ������ʱ������޷��õ����ݣ��ʶ������Σ������Ĳ����ظ�ִ��
	For $loopNum=0 To 2

		; ���IE����
		ClearCache()

		; �������վ���б�
		$file = FileOpen($SITELISTPATH, 0)
		$i=1
		While 1
			$line = FileReadLine($file)
			If @error = -1 Then ExitLoop
			ConsoleWrite("" & $line & @CRLF)

			; ���URL����ȷ�ģ����Ҳ���ע�ͣ��ͽ����ٶȲ���
			If checkUrl($line) Then
				If Not FileExists($DATAFILEPATH & "\" & $line & ".csv") Then
					TestSpeed($line, $DATAFILEPATH)
					TrayTip("TEST IN PROCESS", "Site: " & $line & " test finished!" & @CRLF & "It's " & $i & ".", 2, 1)
					SaveData($line, $DATAFILEPATH, $testplace, $now )
				Else
					ConsoleWrite($line & ".csv is Exist. Skip! " & @CRLF)
				EndIf
			EndIf
			$i=$i+1
		WEnd
		FileClose($file)
	Next

	CloseIE()

    ; ����Server�ˣ��������
	$reqUrl = "http://kuandaiceshi.appspot.com/endtest"
	prt($reqUrl)
	$response = InetRead ( $reqUrl, 1)
	$ret = BinaryToString($response)
	prt( $ret )


	MsgBox(0, "Output", "Finished", 10)

EndFunc

Func SaveData($url, $dataFilePath, $testplace, $roundNo)
	;����ҳ��װ��ʱ�䣬���������ͷ�������
	$recordFilePath = $dataFilePath & "\" & $url & ".csv"
	prt( "$recordFilePath: " & $recordFilePath )


	If 1 == FileExists( $recordFilePath ) Then

		$filetime = FileGetTime($recordFilePath, 0, 1);
		prt( $filetime )
		$testtime = $filetime

		$ret = ReadCSV( $recordFilePath )
		prt( $ret )

		$reqUrl = "http://kuandaiceshi.appspot.com/savedata?place=" & $testplace _
				  & "&roundno=" & $roundNo & "&url=" & $url & "&testtime=" & $testtime _
				  & "&loadtime=" & $ret
		prt($reqUrl)
		$response = InetRead ( $reqUrl, 1)
		$ret2 = BinaryToString($response)
		prt( $ret2 )
	Else
		prt($recordFilePath & " Not Exist!")
	EndIf

EndFunc


Func checkUrl($url)
	If StringLen($url) > 0 And StringInStr($url, "#")<>1 Then
		Return True
	Else
		Return False
	EndIf

EndFunc   ;==>checkUrl



Func TestSpeed($url, $dataFilePath )

	;��ʼ httpwatch ��¼
	Sleep(500)
	Send("^{F2}")

	;$ret = ControlFocus("[CLASS:IEFrame]", "", "[CLASS:Edit;INSTANCE:1]")
	Send("{F4}")
	Sleep(200)
	Send("{BACKSPACE}")
	Sleep(200)
	Send("http://" & $url)
	Sleep(500)
	Send("{ENTER}")


	Sleep(5000)
	$count = 0
	$Totalcount = 0
	While 1
		$Totalcount = $Totalcount + 1

		$statusText = ControlGetText("[CLASS:IEFrame]", "", "[CLASS:msctls_statusbar32;INSTANCE:1]")

		If StringLen($statusText) == 0 Or StringIsSpace($statusText) == 1 _
			Or StringInStr($statusText, "Done") Or StringInStr($statusText, "���") _
			Or StringInStr($statusText, "���") _
			Then
				;ConsoleWrite("Status: >>>" & $statusText & "<<<" & @CRLF)
				$count = $count + 1
		Else
				$count = 0
		EndIf

		If $count > 10 Or $Totalcount > 1050 Then
			ExitLoop
		Else
			Sleep(100)
		EndIf

	WEnd
	;ֹͣ httpwatch ��¼
	Send("^{F3}")
	Sleep(1000)


	; ���� httpwatch ��¼����
	$recordFilePath = $dataFilePath & "\" & $url
	Send("^+{c}")
	Sleep(200)
	Send("{BACKSPACE}")
	ConsoleWrite("" & $url & @CRLF)
	Sleep(200)
	Send($recordFilePath)
	Sleep(1000)
	; ֮����Ҫ�����������س�����Ϊ�����ڷ�������ʱ������Ǹ�alert���OK��ť
	; ������������һ�����⣬���ҳ���Զ����������õ�ĳ������򣬰��»س��ͻ��Զ�����submit�¼���
	; ��û�н�����������ǰ��ֻ�ò���ô�����ˡ�
	Send("{ENTER}")
	Sleep(2000)
	;Send("{ENTER}")
	;Sleep(100)

	Send("^+{s}")
	Sleep(200)
	Send("{BACKSPACE}")
	ConsoleWrite("" & $url & @CRLF)
	Sleep(200)
	Send($recordFilePath)
	Sleep(1000)
	Send("{ENTER}")
	Sleep(3000)
	;Send("{ENTER}")
	;Sleep(100)

	Send("^{DELETE}")

	Sleep(200)
	;$ret = ControlFocus("[CLASS:IEFrame]", "", "[CLASS:Edit;INSTANCE:1]")
	Send("{F4}")
	Sleep(200)
	Send("{BACKSPACE}")
	Sleep(200)
	Send(@ScriptDir & "\wait.htm")
	Sleep(200)
	Send("{ENTER}")
	;Sleep(100)
	;Send("{ENTER}")

	Sleep(1000)

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
		Send("{TAB}")
		sleep(200)
		Send("{ENTER}")
		Sleep(200)
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







