#include "jintutil.au3"

prt( @ScriptName & " start.")

$OpenAdslFlag = False
$RunningFlag = False

$checkDelay = 60000

While 1
	; ����Ƿ��в������ڽ���
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

	; ����в��ԣ���ô��֤�������
	If $RunningFlag Then
		If Not NetAlive() Then
			OpenAdsl()
			$OpenAdslFlag = True
		EndIf
	Else
		; ע��������Ϊ�˷�ֹ�޷����ߡ�
		;If $OpenAdslFlag Then
			CloseAdsl()
			$OpenAdslFlag = False
		;EndIf
	EndIf

    ; TODO �����������
	$terminal = "abc"
	InetRead ( $serverUrl & "/checkin?terminal=" & $terminal, 1)

	prt("Running: " & $RunningFlag)
	Sleep(60000)

WEnd


Func checkUpdate()
	; ��server�˻��ȫ���ļ��İ汾�ʹ�С

	; �Ƚ�Server�˰汾�� ini�ļ��еİ汾�������Ҫ������֮

	; �Ƚ� Server �˴�С�� ��ǰ�ļ���С�������һ�£�����֮

	;

	;

	;


EndFunc

