

$n = InputBox("Input", "To what number do you want to add up to?")
If Not StringIsDigit($n) Then
     MsgBox(0, "Warning!", "You didn't input a valid number. Press OK to quit...")
     Exit
EndIf
$r = 0
For $i = 1 To $n
     $r = $r + $i
Next
MsgBox(0, "Output", "The sum from 1 to " & $n & " is " & $r)


;MsgBox(1, "Output", "The sum from 1 to " & $n & " is " & $r)
;MsgBox(2, "Output", "The sum from 1 to " & $n & " is " & $r)
;MsgBox(3, "Output", "The sum from 1 to " & $n & " is " & $r)
;MsgBox(4, "Output", "The sum from 1 to " & $n & " is " & $r)