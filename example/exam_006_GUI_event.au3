#include <GUIConstants.au3>

Opt("GUIOnEventMode", 1)  ; �л�Ϊ OnEvent ģʽ
$mainwindow = GUICreate("����", 200, 100)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUICtrlCreateLabel("�������������", 30, 10)
$okbutton = GUICtrlCreateButton("��OK��", 70, 50, 60)

$dummywindow = GUICreate(" ��ֻ�ǲ����õ����贰�ڣ��ǹز����ġ�", 400, 120)

;�����ص�
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUICtrlSetOnEvent($okbutton, "OKButton")

GUISetState(@SW_SHOW)
GUISwitch($mainwindow)
GUISetState(@SW_SHOW)

While 1
  Sleep(1000)  ; �����κ���
WEnd

Func OKButton()
  ;ע�⣺��ʱ @GUI_CTRLID ��ֵ���ȼ��� $okbutton
  MsgBox(0, "GUI �¼�", "�������ˡ���OK�ɡ���ť��")
EndFunc

Func CLOSEClicked()
  ;ע�⣺��ʱ @GUI_CTRLID ��ֵ���ȼ��� $GUI_EVENT_CLOSE��
  ;�� @GUI_WINHANDLE ��ȼ��� $mainwindow �� $dummywindow
  If @GUI_WINHANDLE = $mainwindow Then
    MsgBox(0, "GUI �¼�", "��ѡ���˹ر������ڣ������˳�...")
    Exit
  EndIf
EndFunc