
$title = "[CLASS:IEFrame]"
If Not WinActive($title,"") Then WinActivate($title,"")
$ret = ControlGetText("[CLASS:IEFrame]", "", "[CLASS:msctls_statusbar32;INSTANCE:1]")
ConsoleWrite("Status:"&$ret)