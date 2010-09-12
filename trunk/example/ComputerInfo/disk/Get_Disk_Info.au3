
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

FileInstall("xuanfeng.dll",@TempDir&"\xuanfeng.dll",1)
GUICreate("读取硬盘信息", 234, 266, @DesktopWidth/2-(234/2), @DesktopHeight/2-(266/2))

$Input1 = GUICtrlCreateInput("", 95, 7, 129, 21,$ES_READONLY)
$Input2 = GUICtrlCreateInput("", 95, 39, 129, 21,$ES_READONLY)
$Input3 = GUICtrlCreateInput("", 95, 71, 129, 21,$ES_READONLY)
$Input4 = GUICtrlCreateInput("", 95, 103, 129, 21,$ES_READONLY)
$Input5 = GUICtrlCreateInput("", 95, 135, 129, 21,$ES_READONLY)
$Input6 = GUICtrlCreateInput("", 95, 167, 129, 21,$ES_READONLY)
$Input7 = GUICtrlCreateInput("", 95, 199, 129, 21,$ES_READONLY)

GUICtrlCreateLabel("硬 盘序列号 :", 9, 10, 79, 17)
GUICtrlCreateLabel("品 牌 型 号 :", 9, 42, 79, 17)
GUICtrlCreateLabel("修 正 版 本 :", 9, 74, 79, 17)
GUICtrlCreateLabel("缓 冲 大 小 :", 9, 106, 79, 17)
GUICtrlCreateLabel("柱 面 数 量 :", 9, 138, 79, 17)
GUICtrlCreateLabel("盘 头 大 小 :", 9, 170, 79, 17)
GUICtrlCreateLabel("每磁道扇区数:", 9, 202, 79, 17)

$quit=GUICtrlCreateButton("退出", 144, 232, 73, 25, 0)
$read=GUICtrlCreateButton("读取", 15, 232, 73, 25, 0)

GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()

	Switch $nMsg
	    Case $GUI_EVENT_CLOSE
		    FileDelete(@TempDir&"\xuanfeng.dll")
	        Exit
		Case $quit
			FileDelete(@TempDir&"\xuanfeng.dll")
			Exit
		Case $read
			dll()
	EndSwitch
	Sleep(1)
WEnd


Func dll()


	$sn = dllcall(@TempDir&"\xuanfeng.dll","int","GetSerialNumber","int","nDrive","str","lpBuffer")     ;序列号
	If @error Then
	MsgBox(0,"错误","DLL文件调用错误,"&@LF&"错误代码:"&@error)
	Exit
	EndIf

	$mn = dllcall(@TempDir&"\xuanfeng.dll","int","GetModelNumber","int","nDrive","str","lpBuffer")      ;品牌
	$rn = dllcall(@TempDir&"\xuanfeng.dll","int","GetRevisionNumber","int","nDrive","str","lpBuffer")   ;版本号
	$bs = dllcall(@TempDir&"\xuanfeng.dll","int","GetBufferSize","int","nDrive")                        ;缓冲大小
	$dc = dllcall(@TempDir&"\xuanfeng.dll","int","GetDiskCylinders","int","nDrive")                     ;柱面数量
	$dh = dllcall(@TempDir&"\xuanfeng.dll","int","GetDiskHeads","int","nDrive")                         ;盘头大小
	$st = dllcall(@TempDir&"\xuanfeng.dll","int","GetSectorsOfTrack","int","nDrive")                    ;每磁道扇区数

	GUICtrlSetData($Input1,$sn[2])
	GUICtrlSetData($Input2,$mn[2])
	GUICtrlSetData($Input3,$rn[2])
	GUICtrlSetData($Input4,$bs[0])
	GUICtrlSetData($Input5,$dc[0])
	GUICtrlSetData($Input6,$dh[0])
	GUICtrlSetData($Input7,$st[0])
EndFunc