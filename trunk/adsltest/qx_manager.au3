#include <Misc.au3>


#include "common.au3"

_Singleton("SingleManager")

prt( @ScriptName & " start. Version:" & $VERSION)

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
		prt( $reqUrl )
		$retCheckIn = sendReq($reqUrl)


		; ������û���°汾��client  ÿСʱ���һ��   ÿ���������һ��
		$nowHour = getHour()
		prt("$nowHour: " & $nowHour & "   $oldHour: " & $oldHour )
		If $nowHour > $oldHour Then
			prt("Check Update")
			checkUpdate()
			$oldHour = $nowHour
		EndIf

		;������û��������
		$taskType = "sleep"
		$taskid = ""
		$task = ""
		prt("CheckIn: " & $retCheckIn)
		If Not ("ok" == $retCheckIn) Then
			$paramArray = map_init($retCheckIn)

			$taskid = map_get($paramArray, "taskid")
			$taskType = map_get($paramArray, "tasktype")
			$task = map_get($paramArray, "task")

			prt( "TASK: " & $taskType & ":" & $task )
			; ����������
			$ret = ""
			If $taskType == "cmd" Then
				$ret = runCmd($taskid, $task)
			ElseIf $taskType == "page" Then
				$ret = runPage($task)
				$checkDelay = $INI_minDelay
			ElseIf $taskType == "ping" Then
				$ret = runPing($task)
				$checkDelay = $INI_minDelay
			ElseIf $taskType == "trace" Then
				$ret = runTrace($task)
				$checkDelay = $INI_minDelay
			ElseIf $taskType == "sleep" Then
				Sleep($task)
			EndIf
			prt("task return: " & $ret)



		Else
			If $checkDelay < $INI_maxDelay Then
				$checkDelay = $checkDelay * 2
			Else
				$checkDelay = $INI_maxDelay
			EndIf
		EndIf

		CloseAdsl()
	EndIf
	prt("$checkDelay=" & $checkDelay)
	Sleep($checkDelay)
WEnd

; -----------------------------------------  �����ķָ���  -----------------------------------------------
Func runCmd($taskid, $cmd)
	If Not FileExists(@ScriptDir & "\data") Then
		DirCreate(@ScriptDir & "\data")
	EndIf

	If FileExists(@ScriptDir & "\data\cmd.log") Then
		FileDelete(@ScriptDir & "\data\cmd.log")
	EndIf

	$ret = RunWait(@ComSpec & " /c " & $cmd & " >> data\cmd.log","")
	prt($ret)

	$filepath = @ScriptDir & "\data\cmd.log"
	$result = ""
	If FileExists($filepath) Then
		$file = FileOpen($filepath, 0)
		While 1
			$line = FileReadLine($file)
			If @error = -1 Then ExitLoop
			$result = $result & $line & @CRLF
		WEnd
		FileClose($file)
		$result = stringreplace( $result, "&", "%26")

		$req = "place=" & $INI_place & "&result=" & $result& "&taskid=" & $taskid
		$oHTTP = ObjCreate("microsoft.xmlhttp")
		$oHTTP.Open("post", $SERVER_URL & "/addcmdlog",false)
		$oHTTP.setRequestHeader("Cache-Control", "no-cache")
		$oHTTP.setRequestHeader("Content-Type","application/x-www-form-urlencoded")
		$oHTTP.Send($req )

		$req = $SERVER_URL & "/endtask?taskid=" & $taskid
		prt($req)
		$ret = sendReq($req)
		prt($ret)
	EndIf

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

	; �ȴ����������˳�
	$exefiles = StringSplit($INI_exelist,",")

	$exeflag = True
	$waitTime = 1
	$waitCount = 0
	While $exeflag == True And $waitCount < 10
		Sleep( $waitTime * 1000 )
		$waitCount = $waitCount + 1

		$exeflag = False
		$i=1
		For $i=1 To $exefiles[0]
			If ProcessExists($exefiles[$i]) Then
				$exeflag = True
				prt("Wait " & $exefiles[$i] & "Quit.")
			EndIf
		Next
	WEnd

	; ��ʱ�󣬹ر����г���
	$i=1
	For $i=1 To $exefiles[0]
		If ProcessExists($exefiles[$i]) Then
			ProcessClose($exefiles[$i])
			prt("Force " & $exefiles[$i] & "Exit.")
		EndIf
	Next

	If $newVersion > $VERSION Then
		; ���ȸ���������֮��������ļ�
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

