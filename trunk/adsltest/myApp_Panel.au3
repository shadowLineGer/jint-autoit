



#include <GUIConstants.au3>
#include "myApp_Process_Data.au3"

Opt("GUIOnEventMode", 1)  ; �л�Ϊ OnEvent ģʽ
$mainwindow = GUICreate("ADSL Test Control Panel", 500, 400)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUICtrlCreateLabel("С��������Թ��� V1.0 ", 30, 10)
$buttonTest1 = GUICtrlCreateButton("��վ���ʲ���", 10, 50, 100, 60 )
$buttonTest2 = GUICtrlCreateButton("Trace����", 10, 120, 100, 60)
$buttonTest3 = GUICtrlCreateButton("��Ƶ����", 10, 190, 100, 60 )

$testDataLabel = GUICtrlCreateLabel("�����ļ�·��", 10, 260, 300, 25)
$testDataPath = GUICtrlCreateInput("", 100, 260, 300, 25 )
$buttonTestDataPath = GUICtrlCreateButton("ѡ��", 410, 260, 50, 25 )

$sitelistLabel = GUICtrlCreateLabel("վ���б��ļ�", 10, 290, 300, 25 )
$sitelistPath = GUICtrlCreateInput( @ScriptDir & "\report_topN.txt", 100, 290, 300, 25 )
$buttonSitelistPath = GUICtrlCreateButton("ѡ��", 410, 290, 50, 25 )

$buttonTest4 = GUICtrlCreateButton("������վ���ʲ�������", 10, 330, 160, 60 )

;�󶨴�����
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUICtrlSetOnEvent($buttonTest1, "testPage")
GUICtrlSetOnEvent($buttonTest2, "testTrace")
GUICtrlSetOnEvent($buttonTest3, "testVideo")
GUICtrlSetOnEvent($buttonTest4, "processData1")
GUICtrlSetOnEvent($buttonTestDataPath, "pickTestDataPath")
GUICtrlSetOnEvent($buttonSitelistPath, "pickSitelistPath")


GUISetState(@SW_SHOW)
GUISwitch($mainwindow)
GUISetState(@SW_SHOW)

While 1
  Sleep(10)  ; �����κ���
WEnd

Func testPage()
  ;ע�⣺��ʱ @GUI_CTRLID ��ֵ���ȼ��� $okbutton
  MsgBox(0, "GUI �¼�", "������ʼ��վ���ʲ���", 3 )
EndFunc

Func testTrace()
  ;ע�⣺��ʱ @GUI_CTRLID ��ֵ���ȼ��� $okbutton
  MsgBox(0, "GUI �¼�", "������ʼTrace����", 3 )
EndFunc

Func testVideo()
  ;ע�⣺��ʱ @GUI_CTRLID ��ֵ���ȼ��� $okbutton
  MsgBox(0, "GUI �¼�", "������ʼ��Ƶ����", 3 )
EndFunc

Func processData1()
  ;MsgBox(0, "GUI �¼�", "������ʼ�����������", 2 )
  $ret = ProcessPageTestData( GUICtrlRead( $sitelistPath ), GUICtrlRead( $testDataPath ) )
  ClipPut($ret)
  MsgBox(0, "Ret Value", $ret, 10 )

EndFunc

Func CLOSEClicked()
  ;ע�⣺��ʱ @GUI_CTRLID ��ֵ���ȼ��� $GUI_EVENT_CLOSE��
  ;�� @GUI_WINHANDLE ��ȼ��� $mainwindow �� $dummywindow
  If @GUI_WINHANDLE = $mainwindow Then

    Exit
  EndIf
EndFunc

Func pickTestDataPath()
	$path = FileSelectFolder ("pick path", "", 4, "c:\temp")
	GUICtrlSetData($testDataPath, $path )
EndFunc

Func pickSitelistPath()
	$path = FileOpenDialog("pick path", @ScriptDir, "�����ļ�(*.*)")
	GUICtrlSetData($sitelistPath, $path )
EndFunc



