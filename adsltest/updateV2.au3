#include <GUIConstants.au3>
#include <Misc.au3>

#include "jintutil.au3"

$runFlag = True
$baseUrl = "http://kuandaiceshi.appspot.com/"
$logUrl = $baseUrl + "log"
$updateUrl = $baseUrl & "/update/"
$updatePath = @ScriptDir & "\update\"
$filelistPath = @ScriptDir & "\update\filelist.txt"
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

; 清理上次的文件，或者重建目录
If FileExists( $updatePath ) Then
	;FileDelete( $updatePath & "*.*" )
Else
	DirCreate( $updatePath )
EndIf


; 获取需要更新的文件的列表
$ret = getFileByUrl( $updateUrl & "filelist.txt", $filelistPath, 10 )
prt("--------->  $ret=" & $ret)

; 下载更新文件
$file = FileOpen($filelistPath, 0)
While 1
	$line = FileReadLine($file)
	logging("10 ReadLine :" & $line)
	If @error == -1 Then
		logging("20 ReadLine fail.")
		$runFlag = False
		ExitLoop
	Else
		$ret = getFileByUrl( $updateUrl & $line ,$updatePath & $line, 10 )
		If $ret == -1 Then
			logging("30 get File " & $line & " fail.")
			$runFlag = False
			ExitLoop
		EndIf
	EndIf
WEnd
FileClose($file)

; 处理更新文件


$file = FileOpen($filelistPath, 0)
While 1
	$line = FileReadLine($file)
	If @error == -1 Then
		logging("50 EOF.")
		$runFlag = False
		ExitLoop
	Else
		; 对于 *.*.new 文件，改名为 *.*  文件
		FileMove($updatePath & $line, $updatePath & StringLeft($line, StringLen($line)-4 ) )
		logging("40 rename :" & $updatePath & StringLeft($line, StringLen($line)-4 ))
		; 对于 *.*.zip 文件，解压


	EndIf
WEnd
FileClose($file)
; 移动文件到工作目录
FileMove($updatePath & "*.exe", @ScriptDir & "\temp" )










;~ If FileExists(@ScriptDir & "\update.zip") Then
;~ 	; 删除旧备份
;~ 	FileDelete(@ScriptDir & "\AutoTest.bak")
;~ 	; 旧程序改名
;~ 	FileMove(@ScriptDir & "\AutoTest.exe", @ScriptDir & "\AutoTest.bak", 1)
;~ 	; 新程序改名
;~ 	FileMove(@ScriptDir & "\update.zip", @ScriptDir & "\AutoTest.exe", 1)
;~ EndIf

;~ sleep(1000)
;~ If fileexists(@ScriptDir & "\update.exe ") Then Run(@ScriptDir & "\run_test.bat ")






; 如果执行中出错，那么上传日志文件，以便debug
If $runFlag Then
	InetRead ( $logUrl & "?type=info&log=update success.", 1)
Else
	InetRead ( $logUrl & "?type=error&log=bulabulabula", 1)
EndIf

