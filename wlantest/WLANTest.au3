#include <GUIConstants.au3>
#include <Misc.au3>

#include "qxutil.au3"

; �����ظ�����
_Singleton("SingleWLANTest")

prt(@ScriptName & " start.")


; ���������� ����Ŀ¼�����Ե�����
$WORKPATH = @ScriptDir & "\data"
$TESTPLACE = getINI("testplace")
$testRoundNo = getLongRoundNo()


Opt("GUIOnEventMode", 1)  ; �л�Ϊ OnEvent ģʽ
$mainwindow = GUICreate("CMCC WLAN Auto Test Tool V3.0" , 500, 300)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUICtrlCreateLabel("�й��ƶ� WLAN �Զ����Թ���  V3.0" , 30, 10)

$testPlaceLabel = GUICtrlCreateLabel("���Ե�����:", 10, 110, 300, 25 )
$testPlaceText = GUICtrlCreateInput( $TESTPLACE, 100, 110, 300, 25 )


$testRoundLabel = GUICtrlCreateLabel("�����ִ�:", 10, 140, 300, 25 )
$testRoundText = GUICtrlCreateInput( $testRoundNo, 100, 140, 300, 25 )

$buttonTest = GUICtrlCreateButton("��ʼ����", 100, 200, 160, 60 )

$infoLabel = GUICtrlCreateLabel("��ӭʹ�й��ƶ� WLAN �Զ����Թ��� ", 10, 280, 300, 20)

;�󶨴�����
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUICtrlSetOnEvent($buttonTest, "startTest")

GUISetState(@SW_SHOW)
GUISwitch($mainwindow)
GUISetState(@SW_SHOW)


While 1
  Sleep(10)  ; �����κ���
WEnd


; -----------------------------------------  �����ķָ���  -----------------------------------------------
Func startTest()
	setInfo( "������ʼ����" )

	; make work dir
	If Not FileExists($WORKPATH) Then
		DirCreate( $WORKPATH )
	EndIf

	DirCreate( $WORKPATH & "\" & $testRoundNo )

	testMain( $WORKPATH )

EndFunc

Func testMain( $datapath )
	; read task.txt

	$taskType
	$runCount
	$task

	If $taskType == "page" Then
		$ret = runPage($task)

	ElseIf $taskType == "wlanpage" Then    ; רΪ WLAN ��Ƶ�ҳ�����
		$ret = runWlanpage($task)

	ElseIf $taskType == "login" Then
		$ret = runLogin($task)

	ElseIf $taskType == "ping" Then
		$ret = runPing($task)

	ElseIf $taskType == "download" Then
		$ret = runDownload($task)

	ElseIf $taskType == "sn" Then  ;�����ź�ǿ��
		$ret = runSN($task)

	ElseIf $taskType == "dhcp" Then
		$ret = runDhcp($task)

	ElseIf $taskType == "report" Then
		$ret = runReport($task)

	ElseIf $taskType == "sleep" Then
		Sleep($task)
	EndIf

	Return 0
EndFunc


Func CLOSEClicked()
  ;ע�⣺��ʱ @GUI_CTRLID ��ֵ���ȼ��� $GUI_EVENT_CLOSE��
  ;�� @GUI_WINHANDLE ��ȼ��� $mainwindow �� $dummywindow
  If @GUI_WINHANDLE = $mainwindow Then

    Exit
  EndIf
EndFunc

Func setInfo($str)
	$info = $str
	GUICtrlSetData($infoLabel,$info)
EndFunc

