#include <Date.au3>

#include "jintutil.au3"

Func ProcessPageTestData( $sitelistfilename, $datapath )
	$calcValue = ""
	; 读入站点列表
	;$sitelistPath =  @ScriptDir & "\" & $sitelistfilename
	If FileExists( $sitelistfilename ) Then
		$file = FileOpen( $sitelistfilename, 0)
		While 1
			$line = FileReadLine($file)
			If @error = -1 Then ExitLoop
			;prt( $line & @CRLF )

			If StringIsSpace($line) Then ContinueLoop

			$ret = ""
			If FileExists( $datapath & "\" & $line & ".csv") Then
				$ret = ReadCSV( $datapath & "\" & $line & ".csv" )
			Else
				prt( "Error ! " & $line & ".csv is Not Exist. " )
				$ret = "x"
			EndIf
			prt( $ret & "  " &  $line )
			$calcValue = $calcValue & $ret & @CRLF
		WEnd
		FileClose($file)

	Else
		MsgBox(0, "Output", "sitelist.txt not exist!")
	EndIf
	return $calcValue

EndFunc


Func ReadCSV( $filename )

	$file2 = FileOpen( $filename , 0)

	$i = 0
	$line2 = ""
	$indexStarted = 0
	$indexTime = 0
	$indexBlocked = 0
	$indexDNSLookup = 0
	$indexConnect = 0
	$indexSend = 0
	$indexWait = 0
	$indexReceive = 0

	;读csv文件的第一行，找出需要的字段的位置
	$line2 = FileReadLine($file2)
	If @error == -1 Then
		MsgBox(0,"Error","Data file is invalid !",3)
		Exit
	Else
		$array = StringSplit( $line2, "," )
		For $i=1 To $array[0]
			If $array[$i] == "Started" Then
				$indexStarted = $i
			ElseIf $array[$i] == "Time" Then
				$indexTime = $i
			ElseIf $array[$i] == "Blocked" Then
				$indexBlocked = $i
			ElseIf $array[$i] == "DNS Lookup" Then
				$indexDNSLookup = $i
			ElseIf $array[$i] == "Connect" Then
				$indexConnect = $i
			ElseIf $array[$i] == "Send" Then
				$indexSend = $i
			ElseIf $array[$i] == "Wait" Then
				$indexWait = $i
			ElseIf $array[$i] == "Receive" Then
				$indexReceive = $i
			EndIf
		Next
	EndIf

;~ 	prt( "$indexStarted = " &      $indexStarted )
;~ 	prt( "$indexTime = " &         $indexTime )
;~ 	prt( "$indexBlocked = " &      $indexBlocked )
;~ 	prt( "$indexDNSLookup = " &    $indexDNSLookup )
;~ 	prt( "$indexConnect = " &      $indexConnect )
;~ 	prt( "$indexSend = " &         $indexSend )
;~ 	prt( "$indexWait = " &         $indexWait )
;~ 	prt( "$indexReceive = " &      $indexReceive )
	;FileClose($file2)
	;Exit

	$firstStartTime = ""  ;第一行数据的开始时间
	$thisStartTime = ""   ;后面某一行数据的开始时间
	$thisTime = 0.0         ;后面某一行数据的持续时间
	$thisEndTime = 0.0      ;后面某一行数据的完成时间
	$totalTime = 0.0        ;总计时间

	;循环取每一行的数据
	$i = 0
	While 1

		$line2 = FileReadLine($file2)
		If @error == -1 Then ExitLoop
		;prt("" & $line & @CRLF )

		$array = StringSplit( $line2, "," )

		If $i == 0 Then
			$firstStartTime = $array[$indexStarted]
		ElseIf $array[0] > 0 Then
			$thisStartTime = $array[$indexStarted]
			;prt( " StartTime: " & $firstStartTime & " " & $thisStartTime & @CRLF )

			$thisTime = $array[$indexTime]
			If $thisTime == "*" Then
				;prt("********************")
				$thisTime = $array[$indexBlocked] + $array[$indexDNSLookup] + $array[$indexConnect] + $array[$indexSend] + $array[$indexWait] + $array[$indexReceive]
				;prt("$array[$indexWait]: " & $array[$indexWait] )
			EndIf

			$thisEndTime = SecDiff( $firstStartTime, $thisStartTime ) + $thisTime
			;prt('@@ Debug(' & @ScriptLineNumber & ') : $thisEndTime = ' & $thisEndTime & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

			If $thisEndTime > $totalTime Then
				$totalTime = $thisEndTime
			EndIf

		EndIf

		$i = $i + 1
	WEnd
	FileClose($file2)

	;prt( $filename & " Time: " & $firstStartTime & " " & $thisStartTime & " " & $totalTime & @CRLF )
	If $i<2 Then $totalTime = -1

	return $totalTime

EndFunc

Func SecDiff( $date1, $date2 )
	$iDateCalc = _DateDiff( 's', StringTrimRight($date1,7), StringTrimRight($date2, 7) )
	$ms = StringTrimLeft($date2, 19) - StringTrimLeft($date1, 19)
	$diff = $iDateCalc + $ms

	return $diff

EndFunc



