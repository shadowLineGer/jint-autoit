#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Jint

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

ConsoleWrite("Hello")


$a = 100
$b = 100
$c = $a + $b
ConsoleWrite($c)

$s1 = "AutoIt"
$s2 = "Script"
$s3 = $s1 & $s2
ConsoleWrite($s3)

$b1 = True
$b2 = False
$b3 = $b1 And $b2
ConsoleWrite($b3)
$b4 = $b1 Or $b2
ConsoleWrite($b4)

$r = 0
For $i = 1 To 256
     $r = $r + $i
Next
ConsoleWrite($r)