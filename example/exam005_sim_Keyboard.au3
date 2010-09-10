



Func InsertToText($str)
	$title = "Untitled - Notepad"
	WinWait($title,"")
	If Not WinActive($title,"") Then WinActivate($title,"")
	WinWaitActive($title,"")
	Send($str)

EndFunc


; Finished!
If Not ProcessExists("iexplore.exe") Then Run("C:\Program Files\Internet Explorer\iexplore")
;InsertToText("abcdefg111111111")
;MsgBox(0, "AutoIt Message", "Finished!", 3)
Sleep(6)
$title = "Blank Page - Windows Internet Explorer"
If Not WinActive($title,"") Then WinActivate($title,"")

Sleep(3)
Send("^+{DEL}")


$title2 = "Delete Browsing History"
WinActivate($title2,"")
Sleep(3)
;Send("{d 1}")
ControlClick($title2, "", "Button8")

