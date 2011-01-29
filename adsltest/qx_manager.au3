
#include "jintutil.au3"
$OpenAdslFlag = False
$RunningFlag = False

While 1
	If ProcessExists("AutoTest.exe") Then
		$RunningFlag = True
	ElseIf ProcessExists("pingtest.exe") Then
		$RunningFlag = True
	Else
		$RunningFlag = False
	EndIf

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

	TrayTip('',"Running: " & $RunningFlag, 2, 1)
	Sleep(20000)

WEnd





