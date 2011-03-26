
#include "ini_info.au3"
#include "common.au3"


prt( @ScriptName & " start.")

$roundno = getLongRoundNo()

If $cmdLine[0] > 0 Then
	$sitelistfile = $cmdLine[1]
Else
	$sitelistfile = "sitelist.txt"
EndIf


$pingfile = "pingrecord" & $roundno & ".txt"
If FileExists($pingfile) Then
	FileDelete( $pingfile )
EndIf

; 读入待测站点列表
$SITELISTPATH = @ScriptDir & "\" & $sitelistfile

If Not FileExists($SITELISTPATH) Then
	$cmd = "echo " & $sitelistfile & " > " & $sitelistfile & ".txt"
	runDos($cmd)
	$SITELISTPATH = $SITELISTPATH & ".txt"
EndIf

$file = FileOpen($SITELISTPATH, 0)
If @error = -1 Then
	prt("FileOpen @error " & @error & "  file:" & $SITELISTPATH)
EndIf

$i=1
While 1
	$testdomain = FileReadLine($file)
	If @error = 1 Or @error = -1 Then
		;prt("FileReadLine @error " & @error & "  file:" & $SITELISTPATH)
		ExitLoop
	EndIf

	$myCmdline = @ComSpec & " /c " & "ping -n 10 " & $testdomain & " > " & $pingfile
	;prt( $myCmdline )
	RunWait( $myCmdline, @ScriptDir, @SW_HIDE )
	Sleep(1000)

	; 读入Ping命令的输出文件
	$file2 = FileOpen($pingfile, 0)
	If @error = -1 Then
		prt("FileOpen @error " & @error & "  file:" & $pingfile)
	EndIf

	$i=0
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

		If  $flag == 0 And (StringInStr($line2, "Pinging") > 0 Or StringInStr($line2, "正在 Ping") > 0 ) Then
			$flag = 1
			$ip = ""
			$lost = ""
			$avg = ""
			$yunyingshang = ""

			$temp = StringSplit($line2, " ")

			If StringInStr($line2, "[") And StringInStr($line2, "]") Then
				; 这是Ping 域名的情况
				If StringInStr($line2, "Pinging") Then
					$ip = StringLeft($temp[3], StringLen($temp[3])-1)
				Else
					$ip = StringLeft($temp[4], StringLen($temp[4])-1)
				EndIf

				$ip = StringRight($ip, StringLen($ip)-1)
			Else
				; 这是直接ping IP的情况
				If StringInStr($line2, "Pinging") Then
					$ip = $temp[2]
				Else
					$ip = $temp[3]
				EndIf
			EndIf

			$yunyingshang = getYYS($ip, $testdomain)

		EndIf

		If $flag == 1 And StringInStr($line2, "数据包") Or StringInStr($line2, "Packets") Then
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

		If $flag == 2 And StringInStr($line2, "平均") Or StringInStr($line2, "Average") Then
			$flag = 3
			$temp = StringSplit($line2, " ")
			If StringInStr($line2, "Average") Then
				$avg = $temp[13]
			Else
				$avg = $temp[11]
			EndIf
		 EndIf

		If $flag == 3 Then

			$reqUrl =  $SERVER_URL & "/savepingtest?ip=" & $ip & "&lost=" & $lost & "&pingtime=" & $avg & "&domain="  & $testdomain & "&testplace=" & $INI_place & "&roundno=" & $roundno
			$ret4 = sendReq($reqUrl)
			TrayTip("pingtest", $testdomain & " " & $ip & " " & $lost & " " & $avg & " " & $ret4, 3, 1 )
			prt( $reqUrl )
		EndIf
	WEnd
	FileClose($file2)
WEnd
FileClose($file)

If FileExists($pingfile) Then
	FileDelete( $pingfile )
EndIf
MsgBox(0, "Output", "已完成IP测试", 20)
prt( @ScriptName & " END.")

; -----------------------------------------  函数的分隔线  -----------------------------------------------
Func getYYS($ip, $domain)
	$yysName = "not found"
	$IpCnUrl = "http://ip.cn/getip.php?action=queryip&ip_url=" & $ip

	$reqUrl = $SERVER_URL & "/ipinfo?ip=" & $ip
	$ret = sendReq($reqUrl)
	;TrayTip("info", $ret, 3, 1 )
	;prt($ret)

	If $ret == "not found" Then
		If StringInStr($SERVER_URL, "appspot") Or StringInStr($SERVER_URL, "jint.org") Then
			$ret2 = sendReq($IpCnUrl)
			$temp = StringSplit($ret2, "：")
			$yysName = $temp[3]
		Else
			$yysName = "not found"
		EndIf

		$gaeSaveUrl = $SERVER_URL & "/saveip?ip=" & $ip & "&local=" & $yysName & "&domain=" & $domain
		ConsoleWrite($gaeSaveUrl & @CRLF)
		$ret3 = sendReq($gaeSaveUrl)
		ConsoleWrite($ret3 & @CRLF)
		TrayTip("save", $ret3, 3, 1 )
		sleep(100)
	;Else
		;$yysName = $ret
		;sleep(100)
	EndIf

	return $yysName
EndFunc



