#include <Misc.au3>

#include "ini_info.au3"
#include "jintutil.au3"

_Singleton("SingleManager")

prt( @ScriptName & " start.")

$OpenAdslFlag = False
$RunningFlag = False

$checkDelay = 20000

$oldHour = 0

; ����������
If Not NetAlive() Then
	OpenAdsl()
	$OpenAdslFlag = True
EndIf


While 1
	OpenAdsl()

	If inWorking() Then
		$checkDelay = $INI_workDelay
	Else
		; �����������
		$reqUrl = $SERVER_URL & "/checkin?terminal=" & $INI_clientId & "&place=" & $INI_place
		;prt( $reqUrl )
		$ret = sendReq($reqUrl)
		prt("CheckIn: " & $ret)

		; ������û���°汾��client
		$nowHour = getHour()
		If $nowHour > $oldHour Then
			prt("Check Update")
			checkUpdate()
			$oldHour = $nowHour
		EndIf

		;������û��������
		$index = StringInStr($ret, " ")
		$taskType = StringLeft($ret, $index-1)
		$task = StringRight($ret, StringLen($ret)-$index)

		$ret = "no run"

		If $taskType == "cmd" Then
			$ret = runCmd($task)
		ElseIf $taskType == "page" Then
			$ret = runPage($task)
			$checkDelay = $INI_minDelay
		ElseIf $taskType == "ping" Then
			$ret = runPing($task)
			$checkDelay = $INI_minDelay
		ElseIf $taskType == "trace" Then
			$ret = runTrace($task)
			$checkDelay = $INI_minDelay
		Else
			If $checkDelay < $INI_maxDelay Then
				$checkDelay = $checkDelay * 2
			Else
				$checkDelay = $INI_maxDelay
			EndIf
		EndIf
		prt("task return: " & $ret)

		CloseAdsl()
	EndIf
	Sleep($checkDelay)
WEnd

Func runCmd($cmd)
	$ret = RunWait(@ComSpec & " /c " & $cmd & " >> data\cmd.log","")
	$file = FileOpen(@ScriptDir & "\data\cmd.log", 0)
	FileRead($file)


	Return $ret
EndFunc

Func runPage($cmd)
	$ret = "will coding"
	Return $ret
EndFunc

Func runPing($cmd)
	$ret = "will coding"
	Return $ret
EndFunc

Func runTrace($cmd)
	$ret = "will coding"
	Return $ret
EndFunc



Func checkUpdate()
	; ���AutoTest.exe�ĸ���
	$filelist = getFileList(@ScriptDir)
	$reqUrl = $SERVER_URL & "/ver?clientver=" & $VERSION & "&diskid=" & $UID_DISKID & "&mem=" & $INI_place & "_" & $INI_clientId & "&filelist=" & $filelist
	prt($reqUrl)
	$ret = sendReq($reqUrl)
	$newVersion = Int($ret)
	prt("$newVersion=" & $ret)
	If $newVersion > $VERSION Then
		; ���ȸ���������֮��������ļ�
		; �رչ������
		ProcessClose("qx_manager.exe")

		downloadFile( $SERVER_URL & "/img/update.7z", @ScriptDir & "\update.7z" )
		prt("7za.exe x -y update.7z")
		RunWait("7za.exe x -y update.7z")
		Sleep(5000)
		FileDelete( "update.7z" )

		; ����������
		If fileexists(@ScriptDir & "\update.exe ") Then
			msg("Have a new version, will update.")
			$ret = Run(@ScriptDir & "\update.exe " & $SERVER_URL & "/img/update.zip")
			sleep(1000)
			Exit
		Else
			msg("Have a new version, but update fail.")
		EndIf
	EndIf

EndFunc

