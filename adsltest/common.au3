#include-once
#include "jintutil.au3"

$VERSION = 38

Global $UID_DISKID = "abcdefg"

; ��һ������Ϣ��Ϊ�˱��ܷ��ƽ⣬���Բ����� INI �ļ�����
Global $SERVER_URL = ""
Global $AUTH_Url = "http://qxauth.appspot.com"

; ����������
OpenAdsl()
; ����ĸ�Server�ǿ���ʹ�õ�
checkServer()
; ����Ƿ�Ϸ��Ŀͻ���
If Not checkAuth() Then
	MsgBox(0, "Error", "Err00001:Network Error", 10 )
	Exit
EndIf

; �������Ա����û������������֮
checkManager()

; -----------------------------------------  �����ķָ���  -----------------------------------------------
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

	; FUCK GFW
	If Not StringInStr($SERVER_URL, "appspot.com" ) Then
		Return True
	EndIf

	$reqUrl = $AUTH_Url & "/adsl?zero=" & $ip _
			  & "&one=" & $mac & "&two=" & $diskName & "&three=" & $diskId & "&four=" & $cpuId
	$ret = sendReq($reqUrl)
	prt( $reqUrl & " Response:" & $ret )

	If 'yes' == $ret Then
		;prt("Auth Success")
		return True
	Else
		return False
	EndIf

EndFunc