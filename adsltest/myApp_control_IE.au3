



Func testMain( $workpath )

	;��ʼ������·��
	$SITELISTPATH = "" & @ScriptDir & "\sitelist.txt"


	$now = @YEAR & @MON & @MDAY & @HOUR ;& @MIN & @SEC
    if FileExists( $workpath ) Then
		$DATAFILEPATH = $workpath & "\" & $now
	else
		$DATAFILEPATH = @ScriptDir & "\" & $now
	EndIf
	$ret = DirCreate($DATAFILEPATH)

    ; ��Ϊ������ʱ������޷��õ����ݣ��ʶ������Σ������Ĳ����ظ�ִ��
	For $i=0 To 2
		; ��IE
		OpenIE()

		; ���IE����
		ClearCache()

		;�� httpwatch ���
		OpenHttpWatch()

		If Not checkAuth() Then
			MsgBox(0, "Error", "Err00001:Network Error", 10 )
			Exit
		EndIf


		; �������վ���б�
		$file = FileOpen($SITELISTPATH, 0)
		While 1
			$line = FileReadLine($file)
			If @error = -1 Then ExitLoop
			ConsoleWrite("" & $line & @CRLF)

			; ���URL����ȷ�ģ������ٶȲ���
			If checkUrl($line) Then
				If Not FileExists($DATAFILEPATH & "\" & $line & ".csv") Then
					TestSpeed($line, $DATAFILEPATH)
				Else
					ConsoleWrite($line & ".csv is Exist. Skip! " & @CRLF)
				EndIf

			EndIf
		WEnd
		FileClose($file)

		CloseIE()
	Next

	; ������ɣ��޸��ļ�������


	MsgBox(0, "Output", "Finished")

EndFunc


Func checkUrl($url)
	If StringLen($url) > 0 Then
		Return True
	Else
		Return False
	EndIf

EndFunc   ;==>checkUrl



Func TestSpeed($url, $dataFilePath )

	;��ʼ httpwatch ��¼
	Sleep(500)
	Send("^{F2}")

	$ret = ControlFocus("[CLASS:IEFrame]", "", "[CLASS:Edit;INSTANCE:1]")
	Sleep(200)
	Send("{BACKSPACE}")
	Sleep(200)
	Send("http://" & $url)
	Sleep(500)
	Send("{ENTER}")

	;ֹͣ httpwatch ��¼
	Sleep(5000)
	$count = 0
	$Totalcount = 0
	While 1
		$Totalcount = $Totalcount + 1

		$statusText = ControlGetText("[CLASS:IEFrame]", "", "[CLASS:msctls_statusbar32;INSTANCE:1]")

		If StringLen($statusText) == 0 And StringIsSpace($statusText) == 1 Or StringInStr($statusText, "Done") Or StringInStr($statusText, "���") Then
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


	; ���� httpwatch ��¼����
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
	Sleep(1000)
	MouseClick("", 60, 200)
	Sleep(500)
	Send("+{F2}")
EndFunc   ;==>OpenHttpWatch



Func checkAuth()
	;��ȡIP��Mac
	$ip = @IPAddress1
	$mac = _GetMAC ($ip)

	;��ȡӲ����Ϣ��cpu��Ϣ
	$Dll=DllOpen("Getinfo.dll")
	$diskName = DllCall($Dll,"str","GetDiskIDName","str","DiskName","byte",0)
	$diskName = StringStripWS($diskName[0],2)

	$diskId=DllCall($Dll,"str","GetDiskIDName","str","DiskId","byte",0)
	$diskId = StringStripWS($diskId[0],2)

	$cpuId=DllCall($Dll,"str","GetCpuInfo","long",1)
	$cpuId = StringStripWS($cpuId[0],2)
	DllClose($Dll)

    ;$reqUrl = "http://localhost:8080/adsl?zero=" & $ip _
	$reqUrl = "http://qxauth.appspot.com/adsl?zero=" & $ip _
			  & "&one=" & $mac & "&two=" & $diskName & "&three=" & $diskId & "&four=" & $cpuId
	prt($reqUrl)

	$hDownload = InetRead ( $reqUrl, 1)
	$ret = BinaryToString($hDownload)
	prt( $ret )

	If 'yes' == $ret Then
		return True
	Else
		return False
	EndIf

EndFunc



Func _GetMAC ($sIP)
  Local $MAC,$MACSize
  Local $i,$s,$r,$iIP

  $MAC = DllStructCreate("byte[6]")
  $MACSize = DllStructCreate("int")

  DllStructSetData($MACSize,1,6)
  $r = DllCall ("Ws2_32.dll", "int", "inet_addr", "str", $sIP)
  $iIP = $r[0]
  $r = DllCall ("iphlpapi.dll", "int", "SendARP","int", $iIP,"int", 0,"ptr", DllStructGetPtr($MAC),"ptr", DllStructGetPtr($MACSize))
  $s    = ""
  For $i = 0 To 5
      If $i Then $s = $s & ":"
      $s = $s & Hex(DllStructGetData($MAC,1,$i+1),2)
  Next
  Return $s
EndFunc

Func prt($str)
	ConsoleWrite( $str & @CRLF )
EndFunc




