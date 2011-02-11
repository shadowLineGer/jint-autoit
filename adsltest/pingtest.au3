#include "jintutil.au3"

prt( @ScriptName & " start.")

$place = "test"
If $cmdLine[0] > 0 Then
	$place = $cmdLine[1]
EndIf

checkManager()

$pingfile = "pingrecord.txt"
If FileExists($pingfile) Then
	FileDelete( $pingfile )
EndIf

; 读入待测站点列表
$SITELISTPATH = "" & @ScriptDir & "\sitelist.txt"
$file = FileOpen($SITELISTPATH, 0)
$i=1
While 1
	$testdomain = FileReadLine($file)
	If @error = -1 Then ExitLoop
	;prt($testdomain )

	$myCmdline = @ComSpec & " /c " & "ping " & $testdomain & " > " & $pingfile
	;prt( $myCmdline )
	RunWait( $myCmdline, @ScriptDir, @SW_HIDE )

	; 读入Ping命令的输出文件
	$file2 = FileOpen($pingfile, 0)

	$i=0
	$flag = 0
	$ip = ""
	$lost = ""
	$avg = ""
	$yunyingshang = ""
	While 1
		$line2 = FileReadLine($file2)
		If @error = -1 Then ExitLoop

		If  $flag == 0 And StringInStr($line2, "[") And StringInStr($line2, "]") Then
			$flag = 1

			$ip = ""
			$lost = ""
			$avg = ""
			$yunyingshang = ""

			$temp = StringSplit($line2, " ")

			If StringInStr($line2, "Pinging") Then
				$ip = StringLeft($temp[3], StringLen($temp[3])-1)
			Else
				$ip = StringLeft($temp[4], StringLen($temp[4])-1)
			EndIf

			$ip = StringRight($ip, StringLen($ip)-1)
			$yunyingshang = getYYS($ip, $testdomain)

			$i = $i + 1
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

			$reqUrl =  $SERVER_URL & "/savepingtest?ip=" & $ip & "&lost=" & $lost & "&pingtime=" & $avg & "&domain="  & $testdomain & "&testplace=" & $place
			$ret4 = sendReq($reqUrl)
			TrayTip("pingtest", $ret4, 3, 1 )
			prt( $reqUrl )
		EndIf
	WEnd
	FileClose($file2)
WEnd
FileClose($file)

MsgBox(0, "Output", "已完成IP测试", 20)

RunWait(@ComSpec & " /c rasdial /disconnect", "", 0) ;


Func getYYS($ip, $domain)
	$yysName = "not found"
	$IpCnUrl = "http://ip.cn/getip.php?action=queryip&ip_url=" & $ip

	$reqUrl = $SERVER_URL & "/ipinfo?ip=" & $ip
	$ret = sendReq($reqUrl)
	TrayTip("info", $ret, 3, 1 )

	If $ret == "not found" Then
		If StringInStr($SERVER_URL, "appspot") Then
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
		sleep(1000)
	;Else
		;$yysName = $ret
		;sleep(100)
	EndIf

	return $yysName
EndFunc



