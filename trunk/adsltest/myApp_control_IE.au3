
$TITLE = "[CLASS:IEFrame]"



Func testMain( $workpath, $username, $testplace, $roundNo )

	;��ʼ������·��
	$SITELISTPATH = "" & @ScriptDir & "\sitelist.txt"

    if FileExists( $workpath ) Then
		$DATAFILEPATH = $workpath & "\" & $roundNo & $testplace
	else
		$DATAFILEPATH = @ScriptDir & "\" & $roundNo & $testplace
	EndIf
	$ret = DirCreate($DATAFILEPATH)

    ; ����Server�ˣ����Կ�ʼ
	$reqUrl = $serverUrl & "/starttest?username=" & $username _
			  & "&place=" & $testplace & "&roundno=" & $roundNo
	prt($reqUrl)
	;pop($reqUrl)
	$response = InetRead ( $reqUrl, 1)
	$ret = BinaryToString($response)
	prt( $ret )

	; ��IE
	;OpenIE()

	;�� httpwatch ���
	;OpenHttpWatch()

    ; ��Ϊ������ʱ������޷��õ����ݣ��ʶ������Σ������Ĳ����ظ�ִ��
	For $loopNum=0 To 3

		; ���IE����
		OpenIE()
		ClearCache()
		sleep(5000)
		CloseIE()

		; �������վ���б�
		$file = FileOpen($SITELISTPATH, 0)
		$i=1
		While 1
			$line = FileReadLine($file)
			If @error = -1 Then ExitLoop
			ConsoleWrite("" & $line & @CRLF)

			; ���URL����ȷ�ģ����Ҳ���ע�ͣ��ͽ����ٶȲ���
			If checkUrl($line) Then
				If Not FileExists($DATAFILEPATH & "\" & $line & ".hwl") Then
					;$pingtime = Ping($line,1000)

					;TestSpeed($line, $DATAFILEPATH)
					TrayTip("TEST IN PROCESS", "Site: " & $line & " test Start!" & @CRLF & "It's " & $i & ".", 2, 1)
					;SaveData($line, $DATAFILEPATH, $testplace, $roundNo, $pingtime )
					$cmdline2 = "cscript //nologo page_check.js " & $DATAFILEPATH & " " &  $line & " " &  $serverUrl & _
					            ' "/savedata?place='& $testplace & '&roundno=' & $roundNo & '&testtime=100"'
					;prt($cmdline2)
					RunWait( $cmdline2, "",@SW_HIDE  )
					CloseIE()
				Else
					ConsoleWrite($line & ".csv is Exist. Skip! " & @CRLF)
				EndIf
			EndIf
			$i=$i+1
		WEnd
		FileClose($file)
	Next

    ; ����Server�ˣ��������
	$reqUrl = $serverUrl & "/endtest?place=" & $testplace & "&roundno=" & $roundNo
	prt($reqUrl)
	$response = InetRead ( $reqUrl, 1)
	$ret = BinaryToString($response)
	prt( $ret )


	MsgBox(0, "Output", "Finished", 10)

EndFunc

Func SaveData($url, $dataFilePath, $testplace, $roundNo, $pingtime )
	;����ҳ��װ��ʱ�䣬���������ͷ�������
	$recordFilePath = $dataFilePath & "\" & $url & ".csv"
	prt( "$recordFilePath: " & $recordFilePath )


	If 1 == FileExists( $recordFilePath ) Then

		$testtime = FileGetTime($recordFilePath, 0, 1);

		$ret = ReadCSV( $recordFilePath )
		prt( $ret )
		If -2 == $ret Then
			; �������ݳ���ɾ�������ļ�
			TrayTip("Warning", "Invalid data file, delete it! " & $recordFilePath, 5, 2 )
			FileDelete($recordFilePath)
			FileDelete(csvToHwl($recordFilePath))
		Else
			$reqUrl = $serverUrl & "/savedata?place=" & $testplace _
					  & "&roundno=" & $roundNo & "&url=" & $url & "&testtime=" & $testtime _
					  & "&loadtime=" & $ret & "&pingtime=" & $pingtime
			prt($reqUrl)
			$response = InetRead ( $reqUrl, 1)
			$ret2 = BinaryToString($response)
			prt( $ret2 )
		EndIf
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
	Sleep(100)
	Send("^{DEL}")
	Sleep(200)
	Send("^{F2}")
	Sleep(100)

	;$ret = ControlFocus("[CLASS:IEFrame]", "", "[CLASS:Edit;INSTANCE:1]")
	Send("{F4}")
	Sleep(300)
	Send("{BACKSPACE}")
	Sleep(300)
	Send("http://" & $url)
	Sleep(900)
	Send("{ENTER}")

	;�ȴ�ҳ��װ��
	Sleep(5000)
	;MouseClick("")


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

		If $count > 10 Or $Totalcount > 1000 Then
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
	Sleep(500)
	Send("{BACKSPACE}")
	prt("" & $recordFilePath & @CRLF)
	Sleep(500)
	Send($recordFilePath)
	Sleep(1500)

	; �����ܷ�ͨ������Ƿ��С�ȷ�����Ϊ�������
	Send("{ENTER}")
	Sleep(2000)
	$alertTitle = "ȷ�����Ϊ"
	If WinActive($alertTitle) Then
		;msg("OK send Y")
		send("{y}");
		Sleep(2000)
	EndIf

	;Send("{ENTER}")
	;Sleep(100)

	Send("^+{s}")
	Sleep(500)
	Send("{BACKSPACE}")
	ConsoleWrite("" & $url & @CRLF)
	Sleep(500)
	Send($recordFilePath)
	Sleep(1500)
	Send("{ENTER}")
	Sleep(2000)
	;Send("{ENTER}")
	;Sleep(100)
	If WinActive($alertTitle) Then
		;msg("OK send Y")
		send("{y}");
		Sleep(2000)
	EndIf

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

	;	$clsList = WinGetClassList($TITLE,"")
	;	ConsoleWrite("list:" & $clsList & @CRLF)

EndFunc   ;==>TestSpeed

Func ClearCache()
	Sleep(500)

	If Not WinActive($TITLE, "") Then WinActivate($TITLE, "")
	Sleep(500)
	Send("^+{DEL}")
	Sleep(500)

	$title2 = "Delete Browsing History"
	WinActivate($title2, "")
	Send("{d 1}")
	Sleep(1000)
	WinWaitClose("����ɾ��")
	Sleep(500)
	MouseClick("left")
	Sleep(500)

EndFunc   ;==>ClearCache

Func OpenIE()
	If ProcessExists("iexplore.exe") Then
		ProcessClose("iexplore.exe")
		Sleep(1000)
	EndIf

	If Not ProcessExists("iexplore.exe") Then
		Run("C:\Program Files\Internet Explorer\iexplore.exe")
		$ieHandle = WinWaitActive("Windows Internet Explorer")

		Sleep(1000)
		Send("{TAB}")
		sleep(300)
		Send("{ENTER}")
		Sleep(200)
	EndIf


	;WinMove($TITLE, "", 45, 0)
	WinSetState( $TITLE , "",@SW_MAXIMIZE )

EndFunc   ;==>OpenIE

Func CloseIE()
	If ProcessExists("iexplore.exe") Then
		ProcessClose("iexplore.exe")
		Sleep(1000)
	EndIf
EndFunc   ;==>OpenIE

Func OpenHttpWatch()

	$x = 20
	$y = 600

	Sleep(400)
	$pos = WinGetPos($TITLE);
	If $pos==0 Then
		msg("IE not running.")
	Else
		$x = $pos[0]+20
		$y = $pos[1]+$pos[3]-80
	EndIf

	Sleep(100)

	MouseClick("left", $x, $y )
	Sleep(300)
	Send("+{F2}")
	Sleep(500)
	MouseClick("left", $x, $y)
	Sleep(100)
EndFunc   ;==>OpenHttpWatch







