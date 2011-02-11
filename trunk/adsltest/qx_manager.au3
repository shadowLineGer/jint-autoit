#include <Misc.au3>

#include "jintutil.au3"

_Singleton("SingleManager")

prt( @ScriptName & " start.")

$OpenAdslFlag = False
$RunningFlag = False

$checkDelay = 60000

; ����������
If Not NetAlive() Then
	OpenAdsl()
	$OpenAdslFlag = True
EndIf
; ����ĸ�Server�ǿ���ʹ�õ�
checkServer()

While 1
	OpenAdsl()

    ; TODO �����������
	$clientId = IniRead( @ScriptDir & "\client.ini", "basic", "clientId", "jint")
	$reqUrl = $SERVER_URL & "/checkin?terminal=" & $clientId
	prt( $reqUrl )
	$ret = sendReq($reqUrl)
	prt("CheckIn: " & $ret)

	;������û��������
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
	; ��server�˻��ȫ���ļ��İ汾�ʹ�С

	; �Ƚ�Server�˰汾�� ini�ļ��еİ汾�������Ҫ������֮

	; �Ƚ� Server �˴�С�� ��ǰ�ļ���С�������һ�£�����֮

	;

	;

	;


EndFunc

