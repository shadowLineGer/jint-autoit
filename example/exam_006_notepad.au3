

Run("C:\Program Files\Internet Explorer\iexplore")
$ieHandle = WinWaitActive("Windows Internet Explorer")
MsgBox(1,"",""& $ieHandle )











#CS
Run("notepad.exe")
WinWaitActive("Untitled - Notepad")
Send("This is some text.")
Sleep(3000)
WinClose("Untitled - Notepad")
WinWaitActive("Notepad", "Do you want to save")
Sleep(3000)
Send("!n")
#CE