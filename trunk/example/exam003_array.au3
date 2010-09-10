#include <Array.au3>

Dim $name[5]
$name[0] = "Tom"
$name[1] = "Jerry"
$name[2] = "Mike"
$name[3] = "Joey"
$name[4] = "Jane"

For $i = 0 To 4
    MsgBox(0, $i, $name[$i], 1)
Next

_ArrayDisplay($name)

_ArrayAdd($name, "Mary")

_ArrayDisplay($name)

MsgBox(0, "Info", "Now the array $name has " & UBound($name) & " elements...")

_ArraySort($name)

_ArrayDisplay($name)

_ArrayReverse($name)

_ArrayDisplay($name)