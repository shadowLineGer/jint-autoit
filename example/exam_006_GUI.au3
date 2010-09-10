#include <GUIConstants.au3>

$mainwindow = GUICreate("您好", 200, 100)
GUICtrlCreateLabel("最近过得怎样？", 30, 10)
$okbutton = GUICtrlCreateButton("还OK吧", 70, 50, 60)

$dummywindow = GUICreate(" 这只是测试用的虚设窗口，并不会被显示 ", 300, 200)

GUISetState(@SW_SHOW)
GUISwitch($mainwindow)
GUISetState(@SW_SHOW)

While 1
  $msg = GUIGetMsg(1)

  Select
    Case $msg[0] = $okbutton ;	注意这里的$msg[0]和后面的$msg[1]
      MsgBox(0, "GUI 事件", "您按下了“还OK吧”按钮！")

    Case $msg[0] = $GUI_EVENT_CLOSE And $msg[1] = $mainwindow
      MsgBox(0, "GUI 事件", "您选择了关闭主窗口！正在退出...")
      ExitLoop
  EndSelect
WEnd