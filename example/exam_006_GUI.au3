#include <GUIConstants.au3>

$mainwindow = GUICreate("����", 200, 100)
GUICtrlCreateLabel("�������������", 30, 10)
$okbutton = GUICtrlCreateButton("��OK��", 70, 50, 60)

$dummywindow = GUICreate(" ��ֻ�ǲ����õ����贰�ڣ������ᱻ��ʾ ", 300, 200)

GUISetState(@SW_SHOW)
GUISwitch($mainwindow)
GUISetState(@SW_SHOW)

While 1
  $msg = GUIGetMsg(1)

  Select
    Case $msg[0] = $okbutton ;	ע�������$msg[0]�ͺ����$msg[1]
      MsgBox(0, "GUI �¼�", "�������ˡ���OK�ɡ���ť��")

    Case $msg[0] = $GUI_EVENT_CLOSE And $msg[1] = $mainwindow
      MsgBox(0, "GUI �¼�", "��ѡ���˹ر������ڣ������˳�...")
      ExitLoop
  EndSelect
WEnd