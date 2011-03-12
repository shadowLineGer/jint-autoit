#include-once

#include <Array.au3>

$VERSION = 33

Global $UID_DISKID = "abcdefg"

; 这一部分信息，为了保密防破解，所以不放在 INI 文件里面
Global $SERVER_URL = ""
Global $AUTH_Url = "http://qxauth.appspot.com"

; 打开网络连接
OpenAdsl()
; 检查哪个Server是可以使用的
checkServer()
; 检查是否合法的客户端
If Not checkAuth() Then
	MsgBox(0, "Error", "Err00001:Network Error", 10 )
	Exit
EndIf


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

Func checkServer()
	$JintUrl = "http://kuandaiceshi.jint.org"
	$GaeUrl = "http://kuandaiceshi.appspot.com"
	$AwsUrl = "http://ec2-184-73-93-85.compute-1.amazonaws.com"

	If checkServerStatus($GaeUrl) Then
		$SERVER_URL = $GaeUrl
		sleep(10)
	ElseIf checkServerStatus($AwsUrl) Then
		$SERVER_URL = $AwsUrl
		sleep(10)
	ElseIf checkServerStatus($JintUrl) Then
		$SERVER_URL = $JintUrl
		sleep(10)
	EndIf
EndFunc

Func checkServerStatus($testUrl)
	$reqUrl =  $testUrl & "/status"
	$ret = sendReq($reqUrl)

	If 'ok' == $ret Then
		prt($reqUrl & " is accessible.")
		return True
	Else
		prt($reqUrl & " is NOT accessible.")
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

	; FUCK GFW
	If Not StringInStr($SERVER_URL, "appspot.com" ) Then
		Return True
	EndIf

	$reqUrl = $AUTH_Url & "/adsl?zero=" & $ip _
			  & "&one=" & $mac & "&two=" & $diskName & "&three=" & $diskId & "&four=" & $cpuId
	$ret = sendReq($reqUrl)
	prt( $reqUrl & " " & $ret )

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
	if @compiled == 1 Then
		FileWriteLine(@ScriptDir & "\log.log", getCurrTime() & " " & $str)
	else
		ConsoleWrite( getCurrTime() & " " & $str & @CRLF )
	EndIf
EndFunc

Func pop($str)
	TrayTip("Debug", $str, 3, 1)
EndFunc

; 包装这个函数，主要是为了方便翻墙  现在看来这个也没什么用了
;Func getFileByUrl( $url, $localname, $timeout )
;	$ret = 0
;	$handle = InetGet( $url , $localname, 1, 0 )
;	$i = 0
;	Do
;		Sleep(1000)
;		$i = $i +1
;		If $i > $timeout Then
;			logging("Can't download update file! Update fail!")
;			$ret = -1
;			ExitLoop
;		EndIf
;	Until InetGetInfo($handle, 2)    ; Check if the download is complete.
;	Local $nBytes = InetGetInfo($handle, 0)
;	InetClose($handle)   ; Close the handle to release resourcs.
;	return $ret
;EndFunc


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



Func NetAlive()
	If Ping ("www.qq.com",3000) > 0 Then     ; ping这一个应该就够了。
		Sleep(100)
		return True
	Else
		prt("NetAlive: False")
		Return False
	EndIf

;~ 	If Ping ("211.137.130.19",3000) > 0 Then     ; 移动的DNS
;~ 		Sleep(100)
;~ 		return True
;~ 	ElseIf Ping ("218.30.19.40",3000) > 0 Then    ; 电信的DNS
;~ 		Sleep(100)
;~ 		return True
;~ 	ElseIf Ping ("211.98.2.4",3000) > 0 Then    ; 铁通的DNS
;~ 		Sleep(100)
;~ 		return True
;~ 	Else
;~ 		prt("NetAlive: False")
;~ 		Return False
;~ 	EndIf
EndFunc

Func checkManager()
	If Not ProcessExists("qx_manager.exe") Then
		If FileExists( @ScriptDir & "\qx_manager.exe" ) Then
			Run( @ScriptDir & "\qx_manager.exe")
			sleep(5000)
		Else
			prt("Not found qx_manager.exe.")
		EndIf
	EndIf
EndFunc

Func getCurrTime()
	$time = @YEAR & @MON & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC
	return $time
EndFunc

Func sendReq($req)
	$response = InetRead ( $req, 1)
	$ret = BinaryToString($response)
	Return $ret
EndFunc

Func getHour()
	$hour = @YEAR & @MON & @MDAY & @HOUR
	Return $hour
EndFunc


;prt(Ping ("211.137.130.19",3000))
;prt( @error)



Func OpenAdsl()
	$adslName = "cmcc"
	;$adslUser = "290244911"
	;$adslPwd = "737420"
	$adslUser = _ArrayCreate("xa13772543671", "xa13572927742", "xa15829279996", "xa13991283183", "xa15102932623")
	$adslPwd = _ArrayCreate("cmcc123", "cmcc123", "cmcc123", "cmcc123", "cmcc123" )

	$ret = False
	If NetAlive() Then
		$ret = True
	Else
		$i = 0
		$ret = False
		; 为了应对多拨情况下的帐号使用不均衡，只需要简单的随机就可以了，不必考虑完备。
		$arraySize = UBound($adslUser)
		While $i < $arraySize
			If Not NetAlive() Then
				$idx = Random(0,$arraySize-1,1)

				$dialRet = RunWait(@ComSpec & " /c rasdial " & $adslName & " " & $adslUser[$i] & " " & $adslPwd[$i],"", 0)
				prt("RunWait Return: " & $dialRet)
				If $dialRet == 0 Then
					prt("Dial " & $adslUser[$i] & " Success.")
					$ret = True
					ExitLoop
				EndIf
			Else
				prt("Net Alive.")
				$ret = True
				ExitLoop
			EndIf
			$i = $i+1
		WEnd
	EndIf
	return $ret
EndFunc

Func CloseAdsl()
	$ret = False
	If inWorking() Then
		prt("Have test runniing, keep connect.")
		$ret = False
	Else
		RunWait(@ComSpec & " /c rasdial /disconnect", "", 0)
		$ret = True
	EndIf
	Return $ret
EndFunc

Func inWorking()
	If ProcessExists("AutoTest.exe") Or ProcessExists("pingtest.exe") Then
		Return True
	Else
		Return False
	EndIf
EndFunc



