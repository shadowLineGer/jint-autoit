#include <IE.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>


Local $url[3], $n = 1
$url[0] = "http://www.baidu.cn/"
$url[1] = "http://www.google.com/"
$url[2] = "http://www.hao123.com/"
#Region ### START Koda GUI section ###
$Form1 = GUICreate("´°Ìå1", 800, 600)
$oIE = ObjCreate("Shell.Explorer.2")
GUICtrlCreateObj($oIE, 1, 1, 800, 600)
$oIE.navigate("http://www.baidu.cn/")
GUISetState(@SW_SHOW)


AdlibRegister("IE", 5000)
While 1
        $msg = GUIGetMsg()
        If $msg = $GUI_EVENT_CLOSE Then ExitLoop
WEnd


Func IE()
        If $n = 3 Then $n = 0
        $oIE.navigate($url[$n])
        $n += 1
EndFunc   ;==>IE
$oIE = 0 ; Çå³ıÄÚ´æ
GUIDelete()