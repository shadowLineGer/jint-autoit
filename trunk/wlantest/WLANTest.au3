#include <GUIConstants.au3>
#include <Misc.au3>

#include "qxutil.au3"

; 避免重复运行
_Singleton("SingleWLANTest")

prt(@ScriptName & " start.")


; 参数包括： 工作目录，测试点名称
$WORKPATH = @ScriptDir & "\data"
$TESTPLACE = getINI("testplace")
$testRoundNo = getLongRoundNo()


Opt("GUIOnEventMode", 1)  ; 切换为 OnEvent 模式
$mainwindow = GUICreate("CMCC WLAN Auto Test Tool V3.0" , 500, 300)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUICtrlCreateLabel("中国移动 WLAN 自动测试工具  V3.0" , 30, 10)

$testPlaceLabel = GUICtrlCreateLabel("测试点名称:", 10, 110, 300, 25 )
$testPlaceText = GUICtrlCreateInput( $TESTPLACE, 100, 110, 300, 25 )


$testRoundLabel = GUICtrlCreateLabel("测试轮次:", 10, 140, 300, 25 )
$testRoundText = GUICtrlCreateInput( $testRoundNo, 100, 140, 300, 25 )

$buttonTest = GUICtrlCreateButton("开始测试", 100, 200, 160, 60 )

$infoLabel = GUICtrlCreateLabel("欢迎使中国移动 WLAN 自动测试工具 ", 10, 280, 300, 20)

;绑定处理函数
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUICtrlSetOnEvent($buttonTest, "startTest")

GUISetState(@SW_SHOW)
GUISwitch($mainwindow)
GUISetState(@SW_SHOW)


While 1
  Sleep(10)  ; 不做任何事
WEnd


; -----------------------------------------  函数的分隔线  -----------------------------------------------
Func startTest()
	setInfo( "即将开始测试" )

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

	ElseIf $taskType == "wlanpage" Then    ; 专为 WLAN 设计的页面测试
		$ret = runWlanpage($task)

	ElseIf $taskType == "login" Then
		$ret = runLogin($task)

	ElseIf $taskType == "ping" Then
		$ret = runPing($task)

	ElseIf $taskType == "download" Then
		$ret = runDownload($task)

	ElseIf $taskType == "sn" Then  ;测试信号强度
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
  ;注意：此时 @GUI_CTRLID 的值将等价于 $GUI_EVENT_CLOSE，
  ;而 @GUI_WINHANDLE 则等价于 $mainwindow 或 $dummywindow
  If @GUI_WINHANDLE = $mainwindow Then

    Exit
  EndIf
EndFunc

Func setInfo($str)
	$info = $str
	GUICtrlSetData($infoLabel,$info)
EndFunc

