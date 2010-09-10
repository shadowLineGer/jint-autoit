

$file = FileOpen("sitelist.txt", 0)
While 1
	$line = FileReadLine($file)
	If @error = -1 Then ExitLoop
	ConsoleWrite("" & $line & @CRLF )

WEnd
FileClose($file)

MsgBox(0, "", "Finished!")
