

$pingfile = "record.txt"
; 读入Ping命令的输出文件
$file = FileOpen($pingfile, 0)
$file2 = FileOpen("ip_yys.txt", 2)
$i=0
$flag = 0

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
		$yunyingshang = getYYS($ip)

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
		$outStr = "" & $i & "    " & $url & "    " & $ip & "    " & $lost & "    " & $avg & "    " & $yunyingshang & @CRLF
		TrayTip($outStr, 2, 1)
		FileWriteLine($file2, $outStr)
	EndIf


WEnd

FileClose($file)
FileClose($file2)

MsgBox(0, "Output", "已完成IP反查，请查看 ip_yys.txt。", 120)


Func getYYS($ip)
	$yysName = "移动"
	$IpCnUrl = "http://ip.cn/getip.php?action=queryip&ip_url=" & $ip

	Local $sData = InetRead($IpCnUrl, 2)
	Local $nBytesRead = @extended
	;MsgBox(4096, "", "Bytes read: " & $nBytesRead & @CRLF & @CRLF & BinaryToString($sData))

	$ret = BinaryToString($sData, 1)
	$temp = StringSplit($ret, "：")
	$yysName = $temp[3]

	sleep(1000)

	return $yysName
EndFunc



