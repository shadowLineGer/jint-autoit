#include-once

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

Func msg( $str )
	MsgBox(0, "Debug", $str, 5 )
EndFunc

Func prt($str)
	ConsoleWrite( $str & @CRLF )
EndFunc

; todo ����Ժ�Ҫ�ĳ����д log �ļ�
Func logging($str)
	prt($str)
EndFunc

Func pop($str)
	TrayTip("Debug", $str, 3, 1)
EndFunc

; ��װ�����������Ҫ��Ϊ�˷��㷭ǽ
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






