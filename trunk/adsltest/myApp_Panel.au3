



#include <GUIConstants.au3>
#include "myApp_Process_Data.au3"

Opt("GUIOnEventMode", 1)  ; 切换为 OnEvent 模式
$mainwindow = GUICreate("ADSL Test Control Panel", 500, 400)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUICtrlCreateLabel("小区宽带测试工具 V1.0 ", 30, 10)
$buttonTest1 = GUICtrlCreateButton("网站访问测试", 10, 50, 100, 60 )
$buttonTest2 = GUICtrlCreateButton("Trace测试", 10, 120, 100, 60)
$buttonTest3 = GUICtrlCreateButton("视频测试", 10, 190, 100, 60 )

$testDataLabel = GUICtrlCreateLabel("数据文件路径", 10, 260, 300, 25)
$testDataPath = GUICtrlCreateInput("", 100, 260, 300, 25 )
$buttonTestDataPath = GUICtrlCreateButton("选择", 410, 260, 50, 25 )

$sitelistLabel = GUICtrlCreateLabel("站点列表文件", 10, 290, 300, 25 )
$sitelistPath = GUICtrlCreateInput( @ScriptDir & "\report_topN.txt", 100, 290, 300, 25 )
$buttonSitelistPath = GUICtrlCreateButton("选择", 410, 290, 50, 25 )

$buttonTest4 = GUICtrlCreateButton("整理网站访问测试数据", 10, 330, 160, 60 )

;绑定处理函数
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
  Sleep(10)  ; 不做任何事
WEnd

Func testPage()
  ;注意：此时 @GUI_CTRLID 的值将等价于 $okbutton
  MsgBox(0, "GUI 事件", "即将开始网站访问测试", 3 )
EndFunc

Func testTrace()
  ;注意：此时 @GUI_CTRLID 的值将等价于 $okbutton
  MsgBox(0, "GUI 事件", "即将开始Trace测试", 3 )
EndFunc

Func testVideo()
  ;注意：此时 @GUI_CTRLID 的值将等价于 $okbutton
  MsgBox(0, "GUI 事件", "即将开始视频测试", 3 )
EndFunc

Func processData1()
  ;MsgBox(0, "GUI 事件", "即将开始处理测试数据", 2 )
  $ret = ProcessPageTestData( GUICtrlRead( $sitelistPath ), GUICtrlRead( $testDataPath ) )
  ClipPut($ret)
  MsgBox(0, "Ret Value", $ret, 10 )

EndFunc

Func CLOSEClicked()
  ;注意：此时 @GUI_CTRLID 的值将等价于 $GUI_EVENT_CLOSE，
  ;而 @GUI_WINHANDLE 则等价于 $mainwindow 或 $dummywindow
  If @GUI_WINHANDLE = $mainwindow Then

    Exit
  EndIf
EndFunc

Func pickTestDataPath()
	$path = FileSelectFolder ("pick path", "", 4, "c:\temp")
	GUICtrlSetData($testDataPath, $path )
EndFunc

Func pickSitelistPath()
	$path = FileOpenDialog("pick path", @ScriptDir, "所有文件(*.*)")
	GUICtrlSetData($sitelistPath, $path )
EndFunc



