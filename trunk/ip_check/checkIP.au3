
Global $GaeUrl = "http://kuandaiceshi.appspot.com"
Global $AwsUrl = "http://ec2-184-73-93-85.compute-1.amazonaws.com"

#include "jintutil.au3"

If Not FileExists("pingrecord.txt") Then
	RunWait( "pingtest.bat" )
EndIf

HttpSetProxy(0)

$pingfile = "pingrecord.txt"
; 读入Ping命令的输出文件
$file = FileOpen($pingfile, 0)
$file2 = FileOpen("ip_yys.txt", 2)
$i=0
$flag = 0

$place = "test"
If $cmdLine[0] > 0 Then
	$place = $cmdLine[1]
EndIf

$url = ""
$ip = ""
$lost = ""
$avg = ""
$yunyingshang = ""
While 1
	$line = FileReadLine($file)
	If @error = -1 Then ExitLoop

	If  $flag == 0 And StringInStr($line, "[") And StringInStr($line, "]") Then
		$flag = 1
		$url = ""
		$ip = ""
		$lost = ""
		$avg = ""
		$yunyingshang = ""

		$temp = StringSplit($line, " ")
		$url = $temp[3]
		$ip = StringLeft($temp[4], StringLen($temp[4])-1)
		$ip = StringRight($ip, StringLen($ip)-1)
		$yunyingshang = getYYS($ip, $url)

		$i = $i + 1
	EndIf

	If $flag == 1 And StringInStr($line, "数据包") Then
		$flag = 2
		$temp = StringSplit($line, " ")
		$lost = StringRight($temp[13],StringLen($temp[13])-1)

		If $lost == "100%" Then
			$flag = 3
		EndIf
	EndIf

	If $flag == 2 And StringInStr($line, "平均") Then
		$flag = 3
		$temp = StringSplit($line, " ")
		$avg = $temp[11]
     EndIf

	If $flag == 3 Then
		$flag = 0
		$outStr = "" & $i & @TAB & $ip & @TAB& $lost & @TAB & $avg & @TAB  & $url & @TAB & @TAB & @TAB & @TAB & $yunyingshang
		TrayTip("", $outStr, 1)
		FileWriteLine($file2, $outStr)

		$reqStr =  $GaeUrl & "/savepingtest?ip=" & $ip & "&lost=" & $lost & "&pingtime=" & $avg & "&domain="  & $url & "&testplace=" & $place
		ConsoleWrite($reqStr & @CRLF)
		Local $sData = InetRead($reqStr, 1)
		Local $nBytesRead = @extended
		$ret4 = BinaryToString($sData, 1)
		ConsoleWrite("SavePingTest: " & $ret4 & @CRLF)

	EndIf


WEnd

FileClose($file)
FileClose($file2)

MsgBox(0, "Output", "已完成IP反查，请查看 ip_yys.txt。", 120)


Func getYYS($ip, $domain)
	$yysName = "not found"
	$IpCnUrl = "http://ip.cn/getip.php?action=queryip&ip_url=" & $ip
	$myGaeUrl = $GaeUrl & "/ipinfo?ip=" & $ip

	Local $sData = InetRead($myGaeUrl, 2)
	Local $nBytesRead = @extended
	$ret = BinaryToString($sData, 4)
	;ConsoleWrite("From GAE:" & $ret & @CRLF)

	If $ret == "not found" Then
		$sData = InetRead($IpCnUrl, 2)
		$nBytesRead = @extended
		;MsgBox(4096, "", "Bytes read: " & $nBytesRead & @CRLF & @CRLF & BinaryToString($sData))
		$ret2 = BinaryToString($sData, 1)
		$temp = StringSplit($ret2, "：")
		$yysName = $temp[3]

		$gaeSaveUrl = $myGaeUrl & "/saveip?ip=" & $ip & "&local=" & "not found"& "&domain=" & $domain
		ConsoleWrite($gaeSaveUrl & @CRLF)
		Local $sData = InetRead($gaeSaveUrl, 2)
		Local $nBytesRead = @extended
		$ret3 = BinaryToString($sData, 1)
		ConsoleWrite($ret3 & @CRLF)
		sleep(1000)
	Else
		$yysName = $ret
		sleep(100)
	EndIf

	return $yysName
EndFunc



