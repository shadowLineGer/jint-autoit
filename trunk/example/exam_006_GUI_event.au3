#include <GUIConstants.au3>

Opt("GUIOnEventMode", 1)  ; 切换为 OnEvent 模式
$mainwindow = GUICreate("您好", 200, 100)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUICtrlCreateLabel("最近过得怎样？", 30, 10)
$okbutton = GUICtrlCreateButton("还OK吧", 70, 50, 60)

$dummywindow = GUICreate(" 这只是测试用的虚设窗口，是关不掉的。", 400, 120)

;这是重点
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUICtrlSetOnEvent($okbutton, "OKButton")

GUISetState(@SW_SHOW)
GUISwitch($mainwindow)
GUISetState(@SW_SHOW)

While 1
  Sleep(1000)  ; 不做任何事
WEnd

Func OKButton()
  ;注意：此时 @GUI_CTRLID 的值将等价于 $okbutton
  MsgBox(0, "GUI 事件", "您按下了“还OK吧”按钮！")
EndFunc

Func CLOSEClicked()
  ;注意：此时 @GUI_CTRLID 的值将等价于 $GUI_EVENT_CLOSE，
  ;而 @GUI_WINHANDLE 则等价于 $mainwindow 或 $dummywindow
  If @GUI_WINHANDLE = $mainwindow Then
    MsgBox(0, "GUI 事件", "您选择了关闭主窗口！正在退出...")
    Exit
  EndIf
EndFunc