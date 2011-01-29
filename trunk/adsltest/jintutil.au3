#include-once

Global $UID_DISKID = "abc"
Global $serverUrl = ""
Global $GaeUrl = "http://kuandaiceshi.appspot.com"
Global $GaeAuthUrl = "http://qxauth.appspot.com"
Global $AwsUrl = "http://ec2-184-73-93-85.compute-1.amazonaws.com"


Func downloadFile( $url, $savePath )
	$i = 0
	$ret = InetGet( $url , $savePath, 1, 1 )
	Do
		Sleep(2000)
		$i = $i +1
		If mod($i,10) == 0 Then
			prt("time=" & ($i*2))
		EndIf
	Until InetGetInfo($ret, 2)    ; Check if the download is complete.
	Local $nBytes = InetGetInfo($ret, 0)
	InetClose($ret)   ; Close the handle to release resourcs.
	;MsgBox(0, "", "Bytes read: " & $nBytes)
EndFunc

Func checkServer($testUrl)
	$hDownload = InetRead ( $testUrl & "/status", 1)
	$ret = BinaryToString($hDownload)
	prt($testUrl & " " & $ret)

	If 'ok' == $ret Then
		$serverUrl = $testUrl
		return True
	Else
		return False
	EndIf
EndFunc

Func checkAuth()
	;获取IP和Mac
	$ip = @IPAddress1
	$mac = _GetMAC ($ip)

	;获取硬盘信息和cpu信息
	$Dll=DllOpen("Getinfo.dll")
	$diskName = DllCall($Dll,"str","GetDiskIDName","str","DiskName","byte",0)
	$diskName = StringStripWS($diskName[0],2)

	$diskId=DllCall($Dll,"str","GetDiskIDName","str","DiskId","byte",0)
	$diskId = StringStripWS($diskId[0],2)
	Global $UID_DISKID = $diskId

	$cpuId=DllCall($Dll,"str","GetCpuInfo","long",1)
	$cpuId = StringStripWS($cpuId[0],2)
	DllClose($Dll)

	;$reqUrl = "http://localhost:8080/adsl?zero=" & $ip _
	;http://qxauth.appspot.com/adsl
	$authUrl = ""
	If checkServer($GaeUrl) Then
		$authUrl = $GaeAuthUrl & "/adsl"
	ElseIf checkServer($AwsUrl) Then
		$authUrl = $AwsUrl & "/adsl"
	EndIf

	$reqUrl = $authUrl & "?zero=" & $ip _
			  & "&one=" & $mac & "&two=" & $diskName & "&three=" & $diskId & "&four=" & $cpuId
	prt($reqUrl)

	$hDownload = InetRead ( $reqUrl, 1)
	$ret = BinaryToString($hDownload)
	;prt( $ret )

	If 'yes' == $ret Then
		;prt("Auth Success")
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

Func msg( $str )
	MsgBox(0, "Debug", $str, 15 )
EndFunc

Func prt($str)
	ConsoleWrite( $str & @CRLF )
EndFunc

; todo 这个以后要改成真的写 log 文件
Func logging($str)
	prt($str)
EndFunc

Func pop($str)
	TrayTip("Debug", $str, 3, 1)
EndFunc

; 包装这个函数，主要是为了方便翻墙
Func getFileByUrl( $url, $localname, $timeout )
	$ret = 0
	$handle = InetGet( $url , $localname, 1, 0 )
	$i = 0
	Do
		Sleep(1000)
		$i = $i +1
		If $i > $timeout Then
			logging("Can't download update file! Update fail!")
			$ret = -1
			ExitLoop
		EndIf
	Until InetGetInfo($handle, 2)    ; Check if the download is complete.
	Local $nBytes = InetGetInfo($handle, 0)
	InetClose($handle)   ; Close the handle to release resourcs.
	return $ret
EndFunc


Func csvToHwl($path)
	$l = StringLen($path)
	If $l > 3  Then
		$tmp = StringLeft( $path, $l-3 )
		return $tmp & "hwl"
	Else
		Return ""
	EndIf

EndFunc

Func getFileList( $dir )
	Dim $ret = ""
	; 显示指定目录下的所有文件的文件名，注意有返回 "." 和 ".."
	$search = FileFindFirstFile($dir & "\*.*")

	; 检查搜索是否成功
	If $search = -1 Then
		MsgBox(0, "错误", "无任何文件或文件夹与指定的搜索字符串匹配")
		Exit
	EndIf

	While 1
		$file = FileFindNextFile($search)
		If @error Then ExitLoop

		$ret = $ret & $file & ", "
	WEnd

	; 关闭搜索句柄
	FileClose($search)

	return $ret

EndFunc

Func OpenAdsl()
	$adslName = "cmcc"
	;$adslUser = "290244911"
	;$adslPwd = "737420"
	$adslUser = "xa00000000000"
	$adslPwd = "cmcc123"
	$ret = RunWait(@ComSpec & " /c rasdial " & $adslName & " " & $adslUser & " " & $adslPwd,"", 0);
	;msg("RunWait Return: " & $ret)
EndFunc

Func CloseAdsl()
	$adslName = "cmcc"
	$adslUser = "290244911"
	$adslPwd = "737420"
	RunWait(@ComSpec & " /c rasdial /disconnect", "", 0);
EndFunc

Func NetAlive()
	$var = Ping ("211.137.130.19",3000)
	If $var > 0 Then
		Sleep(100)
		return True
	Else
		Return False
	EndIf
EndFunc


;prt(getFileList(@ScriptDir))
;prt( csvToHwl("abc\def\crw.csv"))
