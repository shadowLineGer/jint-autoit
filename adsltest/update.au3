
; 这个程序只负责更新 qx_manager.exe 程序。


#include <GUIConstants.au3>
#include <Misc.au3>

#include "ini_info.au3"
#include "jintutil.au3"

; 避免重复运行
_Singleton("SingleUpdate")

$url = ""
$appName = "qx_manager.exe"

; 检查参数
;If $cmdLine[0] > 0 Then
;	$url = $cmdLine[1]
;Else
;	msg("This update program. Please don't manual run it ")
;	sleep(5000)
;	Exit
;EndIf

; 检查是否有 7zip 的console程序，如果没有，从Server端下载
;If Not FileExists("7za.exe") Then
;	downloadFile( $SERVER_URL & "/img/7za.bin", @ScriptDir & "\7za.exe" )
;EndIf

;等待主程序退出
$i = 0
While ProcessExists($appName)
	sleep(500)
	$i = $i +1
	If $i > 120 Then
		msg("Please close " & $appName & "!")
	EndIf
	If $i > 360 Then
		msg("Will force exit " & $appName & "!")
		ProcessClose($appName)
	EndIf
WEnd

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
	; 删除旧文件
	FileDelete(@ScriptDir & "\" & $appName)

	; 新程序改名
	FileMove(@ScriptDir & "\update.zip", @ScriptDir & "\" & $appName, 1)
EndIf

sleep(1000)
If fileexists(@ScriptDir & "\" & $appName) Then Run(@ScriptDir & "\" & $appName)








