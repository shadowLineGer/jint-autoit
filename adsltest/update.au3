; �������ֻ������� �� ����
#include <GUIConstants.au3>
#include <Misc.au3>

;#include "common.au3"
#include "jintutil.au3"

; �����ظ�����
_Singleton("SingleUpdate")

$url = ""
$appName = "qx_manager.exe"

; ������
; msg("$cmdLine[0]=" & $cmdLine[0])
If $cmdLine[0] > 0 Then
	$url = $cmdLine[1]
Else
	msg("This update program. Please don't manual run it ")
	sleep(5000)
	Exit
EndIf
prt($url)

; ����Ƿ��� 7zip ��console�������û�У���Server������
;If Not FileExists("7za.exe") Then
;	downloadFile( $SERVER_URL & "/img/7za.bin", @ScriptDir & "\7za.exe" )
;EndIf

;�ȴ��������˳�
$i = 0
While ProcessExists($appName)
	sleep(500)
	$i = $i +1
	If $i > 120 Then
		;msg("Please close " & $appName & "!")
	EndIf
	If $i > 360 Then
		prt("Will force exit " & $appName & "!")
		ProcessClose($appName)
	EndIf
WEnd

; ��ȡ����
$i = 0
$ret = InetGet( $url ,@ScriptDir & "\update.zip", 1, 1 )
Do
    Sleep(5000)
	$i = $i +1
	If $i > 10 Then
		prt("time=" & ($i*2))
	EndIf
Until InetGetInfo($ret, 2)    ; Check if the download is complete.
Local $nBytes = InetGetInfo($ret, 0)
InetClose($ret)   ; Close the handle to release resourcs.
; MsgBox(0, "", "Bytes read: " & $nBytes)

If FileExists(@ScriptDir & "\update.zip") Then
	; ɾ�����ļ�
	FileDelete(@ScriptDir & "\" & $appName)

	; �³������
	FileMove(@ScriptDir & "\update.zip", @ScriptDir & "\" & $appName, 1)
EndIf

sleep(1000)
If fileexists(@ScriptDir & "\" & $appName) Then Run(@ScriptDir & "\" & $appName)

prt("Update Finished!")







