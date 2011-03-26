
prt( @ScriptName & " start.")

$sitelistfile = "subDomain.txt"
$roundno = @YEAR & @MON & @MDAY & @HOUR & @MIN

$pingfile = "pingrecord" & $roundno & ".txt"
If FileExists($pingfile) Then
	FileDelete( $pingfile )
EndIf

; �������վ���б�
$SITELISTPATH = @ScriptDir & "\" & $sitelistfile
$file = FileOpen($SITELISTPATH, 0)
If @error = -1 Then
	prt("FileOpen @error " & @error & "  file:" & $SITELISTPATH)
EndIf

$pingResultFile = FileOpen(@ScriptDir & "\pingResult" & $roundno & "_1.txt", 2)
If @error = -1 Then
	prt("FileOpen @error " & @error & "  file: pingResult.txt" )
EndIf

$xCount=1
$yCount=1
While 1
	$testdomain = FileReadLine($file)
	If @error = 1 Or @error = -1 Then
		;prt("FileReadLine @error " & @error & "  file:" & $SITELISTPATH)
		ExitLoop
	EndIf

	$myCmdline = @ComSpec & " /c " & "ping " & $testdomain & " > " & $pingfile
	;prt( $myCmdline )
	RunWait( $myCmdline, @ScriptDir, @SW_HIDE )
	Sleep(100)

	; ����Ping���������ļ�
	$file2 = FileOpen($pingfile, 0)
	If @error = -1 Then
		prt("FileOpen @error " & @error & "  file:" & $pingfile)
	EndIf

	$flag = 0
	$ip = ""
	$lost = ""
	$avg = ""
	$yunyingshang = ""
	;prt("will while" )
	While 1
		;prt("start while" )
		$line2 = FileReadLine($file2)
		If @error = 1 Or @error = -1 Then
			;prt("FileReadLine @error " & @error & "  file:" & $pingfile)
			ExitLoop
		EndIf

		;prt($line2)

		If  $flag == 0 And (StringInStr($line2, "Pinging") > 0 Or StringInStr($line2, "���� Ping") > 0 ) Then
			$flag = 1
			$ip = ""
			$lost = ""
			$avg = ""
			$yunyingshang = ""

			$temp = StringSplit($line2, " ")

			If StringInStr($line2, "[") And StringInStr($line2, "]") Then
				; ����Ping ���������
				If StringInStr($line2, "Pinging") Then
					$ip = StringLeft($temp[3], StringLen($temp[3])-1)
				Else
					$ip = StringLeft($temp[4], StringLen($temp[4])-1)
				EndIf

				$ip = StringRight($ip, StringLen($ip)-1)
			Else
				; ����ֱ��ping IP�����
				If StringInStr($line2, "Pinging") Then
					$ip = $temp[2]
				Else
					$ip = $temp[3]
				EndIf
			EndIf

			$yunyingshang = getYYS($ip, $testdomain)

		EndIf

		If $flag == 1 And StringInStr($line2, "���ݰ�") Or StringInStr($line2, "Packets") Then
			$flag = 2
			$temp = StringSplit($line2, " ")

			If StringInStr($line2, "Packets") Then
				$lost = StringRight($temp[15],StringLen($temp[15])-1)
			Else
				$lost = StringRight($temp[13],StringLen($temp[13])-1)
			EndIf

			If $lost == "100%" Then
				$flag = 3
				$avg = "Request timed out"
			EndIf
		EndIf

		If $flag == 2 And StringInStr($line2, "ƽ��") Or StringInStr($line2, "Average") Then
			$flag = 3
			$temp = StringSplit($line2, " ")
			If StringInStr($line2, "Average") Then
				$avgPingtime = $temp[13]
			Else
				$avgPingtime = $temp[11]
			EndIf
		 EndIf

		If $flag == 3 Then
			$flag = 4

			$aResult =  $testdomain & @TAB & $ip & @TAB & $yunyingshang & @TAB & $avgPingtime  & @TAB & $lost
			FileWrite( $pingResultFile, $aResult & @CRLF )
			TrayTip("pingtest", $testdomain & " " & $ip & " " & $lost & " " & $avgPingtime , 3, 1 )
			;prt( $aResult )

			If $xCount >= 400 Then
				$xCount = 0
				$yCount = $yCount + 1
				FileClose( $pingResultFile )
				$pingResultFile = FileOpen(@ScriptDir & "\pingResult" & $roundno & "_" & $yCount & ".txt", 2)
			Else
				$xCount = $xCount + 1
			EndIf
		EndIf
	WEnd

	; ���ڴ�������������һ��ֻ������û�н������
	If $flag == 0 Then FileWrite( $pingResultFile, $testdomain & @CRLF )

	FileClose($file2)
WEnd
FileClose($file)
FileClose($pingResultFile)

If FileExists($pingfile) Then
	FileDelete( $pingfile )
EndIf
MsgBox(0, "Output", "�����IP����", 20)
prt( @ScriptName & " END.")

; -----------------------------------------  �����ķָ���  -----------------------------------------------
Func getYYS($ip, $domain)
	$yysName = "not found"
	$IpCnUrl = "http://ip.cn/getip.php?action=queryip&ip_url=" & $ip

	$reqUrl = "http://kuandaiceshi.jint.org/ipinfo?ip=" & $ip
	;prt($reqUrl)
	$retByte = sendReq($reqUrl)
	$ret = BinaryToString($retByte, 4 )
	If @error Then prt("Decode error about kuandaiceshi.jint.org")

	TrayTip("info", $ret, 3, 1 )
	;prt(">>>>>" & $ret & "<<<<<")

	If $ret == "not found" Or $ret == "" Then

		$retByte = sendReq($IpCnUrl)
		$ret2 = BinaryToString($retByte, 0 )
		If @error Then prt("Decode error about ip.cn")
		;prt($ret2)
		$temp = StringSplit($ret2, "��")
		$yysName = $temp[3]
	Else
		$yysName = $ret
	EndIf
	sleep(100)

	return $yysName
EndFunc

Func prt($str)
	if @compiled == 1 Then
		FileWriteLine(@ScriptDir & "\log.log", getCurrTime() & " " & $str)
	else
		ConsoleWrite( getCurrTime() & " " & $str & @CRLF )
	EndIf
EndFunc

Func sendReq($req)
	$response = InetRead ( $req, 1)
	Return $response
EndFunc

Func getCurrTime()
	$time = @YEAR & @MON & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC
	return $time
EndFunc