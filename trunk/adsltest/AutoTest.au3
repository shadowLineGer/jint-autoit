#include <GUIConstants.au3>
#include <Misc.au3>

#include "jintutil.au3"

$serverUrl = "http://kuandaiceshi.appspot.com"

#include "myApp_Control_IE.au3"
#include "myApp_Process_Data.au3"

; �����ظ�����
_Singleton("SingleAutoTest")

$info = ""
$autoStartFlag = False

; ���������� ����Ŀ¼���û��������Ե�����
$WORKPATH = "C:\temp"
$USERNAME = "Unspecified"
$TESTPLACE = "Unspecified"
$AUTOSTART = ""
$version = 7


If $cmdLine[0] > 0 Then
	$WORKPATH = $cmdLine[1]
	If $cmdLine[0] > 1 Then
		$USERNAME = $cmdLine[2]
		If $cmdLine[0] > 2 Then
			$TESTPLACE = $cmdLine[3]
			If $cmdLine[0] > 3 Then
				$AUTOSTART = $cmdLine[4]
			EndIf
		EndIf
	EndIf
Else
	$info = "������ʹ��bat�ļ�ָ����ز�����"
EndIf

; ������
$reqUrl = $serverUrl & "/ver?clientver=" & $version & "&mem=" & $TESTPLACE & "_" & $USERNAME
$response = InetRead ( $reqUrl, 1)
$ret = BinaryToString($response)
$newVersion = Int($ret)
If $newVersion > $version Then
	If fileexists(@ScriptDir & "\update.exe ") Then
		msg("Have a new version, will update.")
		$ret = Run(@ScriptDir & "\update.exe " & $serverUrl & "/img/update.zip")
		sleep(1000)
		Exit
	Else
		msg("Have a new version, but update fail.")
	EndIf
EndIf

Opt("GUIOnEventMode", 1)  ; �л�Ϊ OnEvent ģʽ
$mainwindow = GUICreate("Auto Test Tool  V" & $version , 500, 300)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUICtrlCreateLabel("С������Զ����Թ���  V" & $version, 30, 10)

$testDataLabel = GUICtrlCreateLabel("����Ŀ¼:", 10, 50, 300, 25)
$testDataPath = GUICtrlCreateInput($WORKPATH, 100, 50, 300, 25 )
$buttonTestDataPath = GUICtrlCreateButton("ѡ��", 410, 50, 50, 25 )

$userNameLabel = GUICtrlCreateLabel("�û���:", 10, 80, 300, 25 )
$userNameText = GUICtrlCreateInput( $USERNAME, 100, 80, 300, 25 )

$testPlaceLabel = GUICtrlCreateLabel("���Ե�����:", 10, 110, 300, 25 )
$testPlaceText = GUICtrlCreateInput( $TESTPLACE, 100, 110, 300, 25 )

$testRoundNo = @YEAR & @MON & @MDAY & @HOUR ;& @MIN & @SEC
$testRoundLabel = GUICtrlCreateLabel("�����ִ�:", 10, 140, 300, 25 )
$testRoundText = GUICtrlCreateInput( $testRoundNo, 100, 140, 300, 25 )

$testPlaceLabel = GUICtrlCreateLabel("��������:", 10, 170, 300, 25 )
$autoStartLabel = GUICtrlCreateLabel($AUTOSTART, 100, 170, 300, 25 )

$buttonTest = GUICtrlCreateButton("��ʼ����", 100, 200, 160, 60 )

$infoLabel = GUICtrlCreateLabel("��ӭʹ��С������Զ����Թ���", 10, 280, 300, 20)

;�󶨴�����
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUICtrlSetOnEvent($buttonTest, "startTest")
GUICtrlSetOnEvent($buttonTestDataPath, "pickTestDataPath")
;GUICtrlSetOnEvent($userNameText, "inputUserName")
;GUICtrlSetOnEvent($testPlaceText, "inputPlace")


GUISetState(@SW_SHOW)
GUISwitch($mainwindow)
GUISetState(@SW_SHOW)

if StringLen($info)>0  Then
	Sleep(2000)
	setInfo( $info )
EndIf

If "autostart" == $AUTOSTART Then $autoStartFlag=True
If $autoStartFlag Then
	;msg($autoStartFlag)
	Sleep(4000)
	startTest()
EndIf

While 1
  Sleep(10)  ; �����κ���
WEnd

Func startTest()
	If Not checkAuth() Then
		MsgBox(0, "Error", "Err00001:Network Error", 10 )
		Exit
	EndIf

	setInfo( "������ʼ��վ���ʲ���" )

	$WORKPATH = GUICtrlRead($testDataPath)
	$USERNAME = GUICtrlRead($userNameText)
	$TESTPLACE = GUICtrlRead($testPlaceText)
	$ROUNDNO = GUICtrlRead($testRoundText)

	testMain($WORKPATH, $USERNAME, $TESTPLACE, $ROUNDNO )

	If $autoStartFlag Then Exit
EndFunc

Func CLOSEClicked()
  ;ע�⣺��ʱ @GUI_CTRLID ��ֵ���ȼ��� $GUI_EVENT_CLOSE��
  ;�� @GUI_WINHANDLE ��ȼ��� $mainwindow �� $dummywindow
  If @GUI_WINHANDLE = $mainwindow Then

    Exit
  EndIf
EndFunc

Func pickTestDataPath()
	$path = FileSelectFolder ("pick path", "", 4, @ScriptDir)
	GUICtrlSetData($testDataPath, $path )
EndFunc

Func inputUserName()
	MsgBox(0,"abc","")
	GUICtrlSetData($testDataPath, "" )
EndFunc

Func inputPlace()
	MsgBox(0,"def","")
	GUICtrlSetData($testDataPath, "" )
EndFunc

Func setInfo($str)
	$info = $str
	GUICtrlSetData($infoLabel,$info)
EndFunc

