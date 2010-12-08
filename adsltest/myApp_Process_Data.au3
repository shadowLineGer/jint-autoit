#include <Date.au3>

#include "jintutil.au3"

;prt(ReadCSV( "C:\temp\2010120210西北一路社区\ie.sogou.com.csv" ))
;getFileName("C:\temp\2010120210西北一路社区\ie.sogou.com.csv" )

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
	$indexStarted = -1
	$indexTime = -1
	$indexBlocked = -1
	$indexDNSLookup = -1
	$indexConnect = -1
	$indexSend = -1
	$indexWait = -1
	$indexReceive = -1
	$indexUrl = -1

	;读csv文件的第一行，找出需要的字段的位置
	$line2 = FileReadLine($file2)
	;prt("$line2="&$line2)
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
			ElseIf $array[$i] == "URL" Then
				$indexUrl = $i
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

	$firstStartTime = 0.0  ;第一行数据的开始时间
	$thisStartTime = 0.0   ;后面某一行数据的开始时间
	$thisTime = 0.0         ;后面某一行数据的持续时间
	$thisEndTime = 0.0      ;后面某一行数据的完成时间
	$totalTime = 0.0        ;总计时间

	;循环取每一行的数据
	$i = 0
	While $i < 2000

		$line2 = FileReadLine($file2)
		If @error == -1 Then ExitLoop
		;prt( $line2 )

		$array = StringSplit( $line2, "," )

		If $i == 0 Then
			if $indexStarted > 0 Then $firstStartTime = $array[$indexStarted]
		ElseIf $array[0] > 0 Then
			if $indexStarted > 0 Then $thisStartTime = $array[$indexStarted]
			;prt( " StartTime: " & $firstStartTime & " " & $thisStartTime & @CRLF )

			if $indexTime > 0 Then $thisTime = $array[$indexTime]
			If $thisTime == "*" Then
				;prt("********************")
				$tempBlocked = 0
				$tempDNSLookup = 0
				$tempConnect = 0
				$tempSend = 0
				$tempWait = 0
				$tempReceive = 0

				If $indexBlocked > 0 Then $tempBlocked = $array[$indexBlocked]
				If $indexDNSLookup > 0 Then $tempDNSLookup = $array[$indexDNSLookup]
				If $indexConnect > 0 Then $tempConnect = $array[$indexConnect]
				If $indexSend > 0 Then $tempSend = $array[$indexSend]
				If $indexWait > 0 Then $tempWait = $array[$indexWait]
				If $indexReceive > 0 Then $tempReceive = $array[$indexReceive]

				$thisTime = $tempBlocked + $tempDNSLookup + $tempConnect + $tempSend + $tempWait + $tempReceive

			EndIf

			$thisEndTime = SecDiff( $firstStartTime, $thisStartTime ) + $thisTime
			;prt('$firstStartTime = ' & $firstStartTime & '$thisStartTime = ' & $thisStartTime & '$thisTime = ' & $thisTime  ) ;### Debug Console

			If $thisEndTime > $totalTime Then
				$totalTime = $thisEndTime
			EndIf
			;prt($totalTime)

			If $i == 1 Then
				; 检查数据文件是否正确
				$datafilename = getFileName($filename)
				;prt("$indexUrl="&$indexUrl)
				$tmpUrl = ""
				If $indexUrl > 0 Then $tmpUrl = $array[$indexUrl]
				if StringInStr($tmpUrl, $datafilename ) == 0 Then
					$totalTime = -2
					$i =2001  ; use ExitLoop better
				EndIf
			EndIf
		EndIf

		$i = $i + 1
	WEnd
	FileClose($file2)

	If $i<4 and $totalTime <> -2 Then $totalTime = -1

	return $totalTime

EndFunc

Func SecDiff( $date1, $date2 )
	$iDateCalc = _DateDiff( 's', StringTrimRight($date1,7), StringTrimRight($date2, 7) )
	$ms = StringTrimLeft($date2, 19) - StringTrimLeft($date1, 19)
	$diff = $iDateCalc + $ms

	return $diff

EndFunc

Func getFileName($path)
	$filename = ""
	$tmp = StringSplit( $path, "\" )
	if $tmp[0] > 0 Then
		$fullname = $tmp[$tmp[0]]
		if Stringlen( $fullname ) > 4 Then
			$filename = StringLeft( $fullname, StringLen($fullname)-4)
		EndIf
	EndIf
	;prt( $filename )
	return $filename
EndFunc
