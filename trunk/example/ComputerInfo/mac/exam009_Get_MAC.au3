$sIP = InputBox("MAC地址获取", "请输入IP地址", @IPAddress1, "", 150, 100, -1, -1)
$MAC = _GetMAC ($sIP)
If $MAC <> "00:00:00:00:00:00" Then
 MsgBox (0, "MAC地址", '"' &$sIP& '" 的MAC地址是:'&$MAC)
Else
 MsgBox (0, "MAC地址", '无法获取:"' &$sIP& '" 的MAC地址')
EndIf

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