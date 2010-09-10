;Once I read in an article:
;
; Take a piece of paper, right now, and write out the word ATTITUDE.
; Now assign each letter the number that letter corresponds to and
; add those numbers up. Guess what, they add up to 100%. A=1, T=20,
; T=20, I=9, T=20, U=21, D=4, E=5 = 100%. Attitude is everything folks.
; You can¡¯t hide it; you can¡¯t even deny it.;
; It¡¯s who you are. It¡¯s the outside of your inside.
;
;I thought, Oh! Really?
;Seconds later, I became suspicious of this claim...
;OK, let's find out the truth, since we have tools to utilize...

InetGet("http://www.kilgarriff.co.uk/BNClists/lemma.al", "lemma.al", 0)

$file = FileOpen("lemma.al", 0)
While 1
	$line = FileReadLine($file)
	If @error = -1 Then ExitLoop
	$lineElements = StringSplit($line, " ")
	If AddUpCharactersInWordAsNumber($lineElements[3]) == 100 Then
		ConsoleWrite($lineElements[3] & @CRLF)
	EndIf
WEnd
FileClose($file)

MsgBox(0, "", "Finished!")

Func AddUpCharactersInWordAsNumber($word)
	$wordLowerCase = StringLower($word)
	$Characters = StringSplit($wordLowerCase, "")
	$count = 0
	For $i = 1 To $Characters[0]
		$count = $count + Asc($Characters[$i]) - 96
	Next
	Return $count
EndFunc