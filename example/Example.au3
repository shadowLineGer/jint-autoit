

$sURL = "Hello World !"
ConsoleWrite("sURL=" & $sURL & @CRLF)

Run(@ComSpec & ' /c dir>c:\dir.txt',"", @SW_HIDE)

#include <Process.au3>
$rc = _RunDos("start Http://www.autoit.net.cn")