#include <GUIConstants.au3>
#include <Misc.au3>

#include "jintutil.au3"

; 避免重复运行
;_Singleton("SingleUpdate")

$url = ""
$appName = "AutoTest.exe"


;等待主程序退出
$i = 0
While ProcessExists($appName)
	sleep(500)
	$i = $i +1
	If $i > 120 Then
		msg("Please close " & $appName & "!")
	EndIf
	If $i > 360 Then
		msg("Update fail!")
		Exit
	EndIf
WEnd

If $cmdLine[0] > 0 Then
	$url = $cmdLine[1]
Else
	msg("This update program. Please don't manual run it ")
	sleep(5000)
	Exit
EndIf

; 获取更新
$i = 0
$ret = InetGet( $url ,@ScriptDir & "\update.zip", 1, 1 )
Do
    Sleep(5000)
	$i = $i +1
	If $i > 10 Then
		msg("time=" & ($i*2))
	EndIf
Until InetGetInfo($ret, 2)    ; Check if the download is complete.
Local $nBytes = InetGetInfo($ret, 0)
InetClose($ret)   ; Close the handle to release resourcs.
;MsgBox(0, "", "Bytes read: " & $nBytes)

If FileExists(@ScriptDir & "\update.zip") Then
	; 删除旧备份
	FileDelete(@ScriptDir & "\AutoTest.bak")
	; 旧程序改名
	FileMove(@ScriptDir & "\AutoTest.exe", @ScriptDir & "\AutoTest.bak", 1)
	; 新程序改名
	FileMove(@ScriptDir & "\update.zip", @ScriptDir & "\AutoTest.exe", 1)
EndIf

sleep(1000)
If fileexists(@ScriptDir & "\update.exe ") Then Run(@ScriptDir & "\run_test.bat ")








