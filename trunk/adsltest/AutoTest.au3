#include <GUIConstants.au3>
#include <Misc.au3>


#include "jintutil.au3"

#include "myApp_Control_IE.au3"
#include "myApp_Process_Data.au3"

; 避免重复运行
_Singleton("SingleAutoTest")

prt(@ScriptName & " start.")

; 如果管理员进程没有启动，启动之
checkManager()

; 检查哪个Server是可以使用的
checkServer()

; 检查是否合法的客户端
If Not checkAuth() Then
	MsgBox(0, "Error", "Err00001:Network Error", 10 )
	Exit
EndIf



$info = ""
$autoStartFlag = False

; 参数包括： 工作目录，用户名，测试点名称
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
	$info = "您可以使用bat文件指定相关参数。"
EndIf

; 检查是否有 7zip 的console程序，如果没有，从Server端下载
If Not FileExists("7za.exe") Then
	downloadFile( $SERVER_URL & "/img/7za.bin", @ScriptDir & "\7za.exe" )
EndIf

; 检查AutoTest.exe的更新
$filelist = getFileList(@ScriptDir)
$reqUrl = $SERVER_URL & "/ver?clientver=" & $version & "&diskid=" & $UID_DISKID & "&mem=" & $TESTPLACE & "_" & $USERNAME & "&filelist=" & $filelist
prt($reqUrl)
$ret = sendReq($reqUrl)
$newVersion = Int($ret)
prt("$newVersion=" & $ret)
If $newVersion > $version Then
	; 首先更新主程序之外的其他文件
	downloadFile( $SERVER_URL & "/img/update.7z", @ScriptDir & "\update.7z" )
	prt("7za.exe x -y update.7z")
	RunWait("7za.exe x -y update.7z")
	Sleep(5000)
	FileDelete( "update.7z" )

	; 更新主程序
	If fileexists(@ScriptDir & "\update.exe ") Then
		msg("Have a new version, will update.")
		$ret = Run(@ScriptDir & "\update.exe " & $SERVER_URL & "/img/update.zip")
		sleep(1000)
		Exit
	Else
		msg("Have a new version, but update fail.")
	EndIf
EndIf

Opt("GUIOnEventMode", 1)  ; 切换为 OnEvent 模式
$mainwindow = GUICreate("Auto Test Tool  V" & $version , 500, 300)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUICtrlCreateLabel("小区宽带自动测试工具  V" & $version, 30, 10)

$testDataLabel = GUICtrlCreateLabel("工作目录:", 10, 50, 300, 25)
$testDataPath = GUICtrlCreateInput($WORKPATH, 100, 50, 300, 25 )
$buttonTestDataPath = GUICtrlCreateButton("选择", 410, 50, 50, 25 )

$userNameLabel = GUICtrlCreateLabel("用户名:", 10, 80, 300, 25 )
$userNameText = GUICtrlCreateInput( $USERNAME, 100, 80, 300, 25 )

$testPlaceLabel = GUICtrlCreateLabel("测试点名称:", 10, 110, 300, 25 )
$testPlaceText = GUICtrlCreateInput( $TESTPLACE, 100, 110, 300, 25 )

$testRoundNo = @YEAR & @MON & @MDAY & @HOUR ;& @MIN & @SEC
$testRoundLabel = GUICtrlCreateLabel("测试轮次:", 10, 140, 300, 25 )
$testRoundText = GUICtrlCreateInput( $testRoundNo, 100, 140, 300, 25 )

$testPlaceLabel = GUICtrlCreateLabel("其他参数:", 10, 170, 300, 25 )
$autoStartLabel = GUICtrlCreateLabel($AUTOSTART, 100, 170, 300, 25 )

$buttonTest = GUICtrlCreateButton("开始测试", 100, 200, 160, 60 )

$infoLabel = GUICtrlCreateLabel("欢迎使用小区宽带自动测试工具", 10, 280, 300, 20)

;绑定处理函数
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
  Sleep(10)  ; 不做任何事
WEnd

Func startTest()

	setInfo( "即将开始网站访问测试" )

	$WORKPATH = GUICtrlRead($testDataPath)
	$USERNAME = GUICtrlRead($userNameText)
	$TESTPLACE = GUICtrlRead($testPlaceText)
	$ROUNDNO = GUICtrlRead($testRoundText)

	testMain($WORKPATH, $USERNAME, $TESTPLACE, $ROUNDNO )

	If $autoStartFlag Then Exit
EndFunc

Func CLOSEClicked()
  ;注意：此时 @GUI_CTRLID 的值将等价于 $GUI_EVENT_CLOSE，
  ;而 @GUI_WINHANDLE 则等价于 $mainwindow 或 $dummywindow
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

