
If Not ProcessExists("iexplore.exe") Then Run("C:\Program Files\Internet Explorer\iexplore")

Sleep(2000)
$title = "[CLASS:IEFrame]"
If Not WinActive($title,"") Then WinActivate($title,"")
WinActivate($title,"")
Sleep(1000)
Send("^+{DEL}")
Sleep(1000)

$title2 = "Delete Browsing History"
WinActivate($title2,"")
Send("{d 1}")
ControlClick($title2, "", "Button8")


Sleep(1000)
MouseClick("",200,200)
Sleep(1000)
Send("+{F2}")
Sleep(1000)
Send("^{F2}")


$ret = ControlFocus("[CLASS:IEFrame]", "", "[CLASS:Edit;INSTANCE:1]")
$sURL = "www.google.com"
Send("http://" & $sURL)
Send("{ENTER}")

Sleep(5000)
Send("^{F3}")

Send("^+{s}")

Send($sURL)
Send("{ENTER}")

ConsoleWrite("sURL=" & $sURL & @CRLF)

