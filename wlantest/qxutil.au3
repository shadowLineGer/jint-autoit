#include-once

#include <Array.au3>

;prt( getINI("portal_url") )

; -----------------------------------------  函数的分隔线  -----------------------------------------------
Global $logpath = ""

Func getINI( $name )
	$val = IniRead( @ScriptDir & "\cfg.ini", "basic", $name, "")
	If $val == '' Then
		msg("INI File Error.")
	EndIf

	return $val
EndFunc



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
	prt($str)
	MsgBox(0, "Message:", $str, 10 )
EndFunc

Func prt($str)
	if @compiled == 1 Then
		If StringLen($logpath) < 1 Then
			$logpath = @ScriptDir & "\log\" & getSec() & ".log"
		EndIf
		FileWriteLine( $logpath , getCurrTime() & " " & $str)
	else
		ConsoleWrite( getCurrTime() & " " & $str & @CRLF )
	EndIf
EndFunc

Func pop($str)
	TrayTip("Debug", $str, 3, 1)
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


EndFunc



Func getCurrTime()
	$time = @YEAR & @MON & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC
	return $time
EndFunc

Func getSec()
	$time = @YEAR & @MON & @MDAY & @HOUR  & @MIN & @SEC
	return $time
EndFunc

Func getHour()
	$hour = @YEAR & @MON & @MDAY & @HOUR
	Return $hour
EndFunc

Func getRoundNo()
	return @YEAR & @MON & @MDAY & @HOUR ;& @MIN & @SEC
EndFunc

Func getLongRoundNo()
	return @YEAR & @MON & @MDAY & @HOUR & @MIN ;& @SEC
EndFunc


Func sendReq($req)
	$response = InetRead ( $req, 1)
	$ret = BinaryToString($response)
	Return $ret
EndFunc

Func runDos($cmd)
	$fullcmd = @ComSpec & " /c " & $cmd
	return RunWait( $fullcmd, @ScriptDir) ;, @SW_HIDE )
EndFunc

Func runCmdNoWait($cmd)
	$fullcmd = @ComSpec & " /c " & $cmd
	return Run( $fullcmd, @ScriptDir, @SW_SHOW )
EndFunc


Func map_init($str)
	$strArray = StringSplit( $str, "," )
	Dim $mapArray[$strArray[0]][2]
	$i=1
	while $i < $strArray[0]+1

		$index = StringInStr($strArray[$i], "=")
		If $index > 0 Then
			$key = StringLeft($strArray[$i],$index-1)
			$key = StringStripWS($key, 3)
			$value = StringRight($strArray[$i], StringLen( $strArray[$i]) - $index)
			$value = StringStripWS($value, 3)

			$mapArray[$i-1][0] = $key
			$mapArray[$i-1][1] = $value
		EndIf
		$i = $i + 1
	WEnd
	;prt( "MAP:" & map_toString($mapArray))
	Return $mapArray
EndFunc

Func map_toString( $map )
	$i = 0
	$str = ""
	While $i < UBound($map)
		$str = $str & $map[$i][0] & "=" & $map[$i][1] & ","
		$i=$i+1
	WEnd
	return $str
EndFunc

Func map_get( $map , $key )
	$i = 0
	$str = ""
	While $i < UBound($map)
		if $map[$i][0] == $key Then
			$str = $map[$i][1]
		EndIf
		$i=$i+1
	WEnd

	return $str
EndFunc