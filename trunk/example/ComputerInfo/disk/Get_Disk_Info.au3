
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

FileInstall("xuanfeng.dll",@TempDir&"\xuanfeng.dll",1)
GUICreate("��ȡӲ����Ϣ", 234, 266, @DesktopWidth/2-(234/2), @DesktopHeight/2-(266/2))

$Input1 = GUICtrlCreateInput("", 95, 7, 129, 21,$ES_READONLY)
$Input2 = GUICtrlCreateInput("", 95, 39, 129, 21,$ES_READONLY)
$Input3 = GUICtrlCreateInput("", 95, 71, 129, 21,$ES_READONLY)
$Input4 = GUICtrlCreateInput("", 95, 103, 129, 21,$ES_READONLY)
$Input5 = GUICtrlCreateInput("", 95, 135, 129, 21,$ES_READONLY)
$Input6 = GUICtrlCreateInput("", 95, 167, 129, 21,$ES_READONLY)
$Input7 = GUICtrlCreateInput("", 95, 199, 129, 21,$ES_READONLY)

GUICtrlCreateLabel("Ӳ �����к� :", 9, 10, 79, 17)
GUICtrlCreateLabel("Ʒ �� �� �� :", 9, 42, 79, 17)
GUICtrlCreateLabel("�� �� �� �� :", 9, 74, 79, 17)
GUICtrlCreateLabel("�� �� �� С :", 9, 106, 79, 17)
GUICtrlCreateLabel("�� �� �� �� :", 9, 138, 79, 17)
GUICtrlCreateLabel("�� ͷ �� С :", 9, 170, 79, 17)
GUICtrlCreateLabel("ÿ�ŵ�������:", 9, 202, 79, 17)

$quit=GUICtrlCreateButton("�˳�", 144, 232, 73, 25, 0)
$read=GUICtrlCreateButton("��ȡ", 15, 232, 73, 25, 0)

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


	$sn = dllcall(@TempDir&"\xuanfeng.dll","int","GetSerialNumber","int","nDrive","str","lpBuffer")     ;���к�
	If @error Then
	MsgBox(0,"����","DLL�ļ����ô���,"&@LF&"�������:"&@error)
	Exit
	EndIf

	$mn = dllcall(@TempDir&"\xuanfeng.dll","int","GetModelNumber","int","nDrive","str","lpBuffer")      ;Ʒ��
	$rn = dllcall(@TempDir&"\xuanfeng.dll","int","GetRevisionNumber","int","nDrive","str","lpBuffer")   ;�汾��
	$bs = dllcall(@TempDir&"\xuanfeng.dll","int","GetBufferSize","int","nDrive")                        ;�����С
	$dc = dllcall(@TempDir&"\xuanfeng.dll","int","GetDiskCylinders","int","nDrive")                     ;��������
	$dh = dllcall(@TempDir&"\xuanfeng.dll","int","GetDiskHeads","int","nDrive")                         ;��ͷ��С
	$st = dllcall(@TempDir&"\xuanfeng.dll","int","GetSectorsOfTrack","int","nDrive")                    ;ÿ�ŵ�������

	GUICtrlSetData($Input1,$sn[2])
	GUICtrlSetData($Input2,$mn[2])
	GUICtrlSetData($Input3,$rn[2])
	GUICtrlSetData($Input4,$bs[0])
	GUICtrlSetData($Input5,$dc[0])
	GUICtrlSetData($Input6,$dh[0])
	GUICtrlSetData($Input7,$st[0])
EndFunc