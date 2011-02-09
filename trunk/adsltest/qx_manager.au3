#include "jintutil.au3"

prt( @ScriptName & " start.")

$OpenAdslFlag = False
$RunningFlag = False

$checkDelay = 60000

While 1
	; 检查是否有测试正在进行
	If ProcessExists("AutoTest.exe") Then
		$RunningFlag = True
		$checkDelay = 20000
	ElseIf ProcessExists("pingtest.exe") Then
		$RunningFlag = True
		$checkDelay = 20000
	Else
		$RunningFlag = False
		$checkDelay = 60000
	EndIf

	; 如果有测试，那么保证网络可用
	If $RunningFlag Then
		If Not NetAlive() Then
			OpenAdsl()
			$OpenAdslFlag = True
		EndIf
	Else
		; 注释起来是为了防止无法下线。
		;If $OpenAdslFlag Then
			CloseAdsl()
			$OpenAdslFlag = False
		;EndIf
	EndIf

    ; TODO 向服务器报到
	$terminal = "abc"
	InetRead ( $serverUrl & "/checkin?terminal=" & $terminal, 1)

	prt("Running: " & $RunningFlag)
	Sleep(60000)

WEnd


Func checkUpdate()
	; 从server端获得全部文件的版本和大小

	; 比较Server端版本和 ini文件中的版本，如果需要，更新之

	; 比较 Server 端大小和 当前文件大小，如果不一致，更新之

	;

	;

	;


EndFunc

