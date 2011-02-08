#include-once

#include <Array.au3>


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

Func checkServer()
	;$reqUrl = "http://localhost:8080/adsl?zero=" & $ip _
	;http://qxauth.appspot.com/adsl
	If checkServerStatus($GaeUrl) Then
		prt($GaeUrl & " is accessible.")
	ElseIf checkServerStatus($AwsUrl) Then
		prt($AwsUrl & " is accessible.")
	EndIf
EndFunc

Func checkServerStatus($testUrl)
	$hDownload = InetRead ( $testUrl & "/status", 1)
	$ret = BinaryToString($hDownload)
	;prt($testUrl & " " & $ret)

	If 'ok' == $ret Then
		$serverUrl = $testUrl
		return True
	Else
		return False
	EndIf
EndFunc

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
	Global $UID_DISKID = $diskId

	$cpuId=DllCall($Dll,"str","GetCpuInfo","long",1)
	$cpuId = StringStripWS($cpuId[0],2)
	DllClose($Dll)


	$authUrl = $ServerUrl & "/adsl"

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
	if @compiled == 1 Then
		logging($str)
	else
		ConsoleWrite( $str & @CRLF )
	EndIf
EndFunc

; д log �ļ�
Func logging($str)
	FileWriteLine(@ScriptDir & "\log.log", getCurrTime() & " " & $str)
EndFunc

Func pop($str)
	TrayTip("Debug", $str, 3, 1)
EndFunc

; ��װ�����������Ҫ��Ϊ�˷��㷭ǽ  ���ڿ������Ҳûʲô����
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
	; ��ʾָ��Ŀ¼�µ������ļ����ļ�����ע���з��� "." �� ".."
	$search = FileFindFirstFile($dir & "\*.*")

	; ��������Ƿ�ɹ�
	If $search = -1 Then
		MsgBox(0, "����", "���κ��ļ����ļ�����ָ���������ַ���ƥ��")
		Exit
	EndIf

	While 1
		$file = FileFindNextFile($search)
		If @error Then ExitLoop

		$ret = $ret & $file & ", "
	WEnd

	; �ر��������
	FileClose($search)

	return $ret

EndFunc

Func OpenAdsl()
	$adslName = "cmcc"
	;$adslUser = "290244911"
	;$adslPwd = "737420"
	$adslUser = _ArrayCreate("yxal886677", "yxal765645", "xa00000000000", "yxal881430", "290244911")
	$adslPwd = _ArrayCreate("cmcc123", "cmcc123", "780523", "cmcc123", "737420" )

	$i = 0
	$ret = False
	While $i < UBound($adslUser)
		If Not NetAlive() Then
			$dialRet = RunWait(@ComSpec & " /c rasdial " & $adslName & " " & $adslUser[$i] & " " & $adslPwd[$i],"", 0)
			prt("RunWait Return: " & $dialRet)
			If $dialRet == 0 Then
				prt("Dial " & $adslUser[$i] & "Success.")
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

	return $ret


EndFunc

Func CloseAdsl()
	$adslName = "cmcc"
	$adslUser = "290244911"
	$adslPwd = "737420"
	RunWait(@ComSpec & " /c rasdial /disconnect", "", 0);
EndFunc

Func NetAlive()
	If Ping ("www.qq.com",3000) > 0 Then     ; ping��һ��Ӧ�þ͹��ˡ�
		Sleep(100)
		return True
	Else
		prt("NetAlive: False")
		Return False
	EndIf

;~ 	If Ping ("211.137.130.19",3000) > 0 Then     ; �ƶ���DNS
;~ 		Sleep(100)
;~ 		return True
;~ 	ElseIf Ping ("218.30.19.40",3000) > 0 Then    ; ���ŵ�DNS
;~ 		Sleep(100)
;~ 		return True
;~ 	ElseIf Ping ("211.98.2.4",3000) > 0 Then    ; ��ͨ��DNS
;~ 		Sleep(100)
;~ 		return True
;~ 	Else
;~ 		prt("NetAlive: False")
;~ 		Return False
;~ 	EndIf
EndFunc

Func checkManager()
	If Not ProcessExists("qx_manager.exe") Then
		Run( @ScriptDir & "\qx_manager.exe")
		sleep(5000)
	EndIf
EndFunc

Func getCurrTime()
	$time = @YEAR & @MON & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC
	return $time
EndFunc


prt(Ping ("211.137.130.19",3000))
prt( @error)




