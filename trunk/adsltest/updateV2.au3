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


;�ȴ��������˳�
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

; �����ϴε��ļ��������ؽ�Ŀ¼
If FileExists( $updatePath ) Then
	;FileDelete( $updatePath & "*.*" )
Else
	DirCreate( $updatePath )
EndIf


; ��ȡ��Ҫ���µ��ļ����б�
$ret = getFileByUrl( $updateUrl & "filelist.txt", $filelistPath, 10 )
prt("--------->  $ret=" & $ret)

; ���ظ����ļ�
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

; ��������ļ�


$file = FileOpen($filelistPath, 0)
While 1
	$line = FileReadLine($file)
	If @error == -1 Then
		logging("50 EOF.")
		$runFlag = False
		ExitLoop
	Else
		; ���� *.*.new �ļ�������Ϊ *.*  �ļ�
		FileMove($updatePath & $line, $updatePath & StringLeft($line, StringLen($line)-4 ) )
		logging("40 rename :" & $updatePath & StringLeft($line, StringLen($line)-4 ))
		; ���� *.*.zip �ļ�����ѹ


	EndIf
WEnd
FileClose($file)
; �ƶ��ļ�������Ŀ¼
FileMove($updatePath & "*.exe", @ScriptDir & "\temp" )










;~ If FileExists(@ScriptDir & "\update.zip") Then
;~ 	; ɾ���ɱ���
;~ 	FileDelete(@ScriptDir & "\AutoTest.bak")
;~ 	; �ɳ������
;~ 	FileMove(@ScriptDir & "\AutoTest.exe", @ScriptDir & "\AutoTest.bak", 1)
;~ 	; �³������
;~ 	FileMove(@ScriptDir & "\update.zip", @ScriptDir & "\AutoTest.exe", 1)
;~ EndIf

;~ sleep(1000)
;~ If fileexists(@ScriptDir & "\update.exe ") Then Run(@ScriptDir & "\run_test.bat ")






; ���ִ���г�����ô�ϴ���־�ļ����Ա�debug
If $runFlag Then
	InetRead ( $logUrl & "?type=info&log=update success.", 1)
Else
	InetRead ( $logUrl & "?type=error&log=bulabulabula", 1)
EndIf

