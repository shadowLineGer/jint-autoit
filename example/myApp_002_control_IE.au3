
If Not ProcessExists("iexplore.exe") Then Run("C:\Program Files\Internet Explorer\iexplore")

Sleep(2000)
$title = "[CLASS:IEFrame]"
If Not WinActive($title,"") Then WinActivate($title,"")
WinActivate($title,"")

$ret = ControlFocus("[CLASS:IEFrame]", "", "[CLASS:Edit;INSTANCE:1]")
$sURL = "www.google.com"
Send("http://" & $sURL)
Send("{ENTER}")
ConsoleWrite("sURL=" & $sURL & @CRLF)

WinMove ( $title,"", 45, 0 )
Sleep(1000)
MouseClick("",200,200)

$clsList = WinGetClassList($title,"")
ConsoleWrite("list:" & $clsList & @CRLF)

$pos = WinGetCaretPos ( )
ConsoleWrite("pos:" & $pos[0] & " " & $pos[1] & @CRLF)


