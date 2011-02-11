#include <GUIConstants.au3>
#include <Misc.au3>


#include "jintutil.au3"

#include "myApp_Control_IE.au3"
#include "myApp_Process_Data.au3"

; �����ظ�����
_Singleton("SingleAutoTest")

prt(@ScriptName & " start.")

; �������Ա����û������������֮
checkManager()

; ����ĸ�Server�ǿ���ʹ�õ�
checkServer()

; ����Ƿ�Ϸ��Ŀͻ���
If Not checkAuth() Then
	MsgBox(0, "Error", "Err00001:Network Error", 10 )
	Exit
EndIf



$info = ""
$autoStartFlag = False

; ���������� ����Ŀ¼���û��������Ե�����
$WORKPATH = @ScriptDir & "\data"
$USERNAME = "jint.qianxiang"
$TESTPLACE = "testPlace"
$AUTOSTART = ""
$version = 30


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

; ����Ƿ��� 7zip ��console�������û�У���Server������
If Not FileExists("7za.exe") Then
	downloadFile( $SERVER_URL & "/img/7za.bin", @ScriptDir & "\7za.exe" )
EndIf

; ���AutoTest.exe�ĸ���
$filelist = getFileList(@ScriptDir)
$reqUrl = $SERVER_URL & "/ver?clientver=" & $version & "&diskid=" & $UID_DISKID & "&mem=" & $TESTPLACE & "_" & $USERNAME & "&filelist=" & $filelist
prt($reqUrl)
$ret = sendReq($reqUrl)
$newVersion = Int($ret)
prt("$newVersion=" & $ret)
If $newVersion > $version Then
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

