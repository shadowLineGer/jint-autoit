#include <Date.au3>

#include "jintutil.au3"

;prt(ReadCSV( "C:\temp\2010120210����һ·����\ie.sogou.com.csv" ))
;getFileName("C:\temp\2010120210����һ·����\ie.sogou.com.csv" )

Func ProcessPageTestData( $sitelistfilename, $datapath )
	$calcValue = ""
	; ����վ���б�
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
	$indexUrl = 0

	;��csv�ļ��ĵ�һ�У��ҳ���Ҫ���ֶε�λ��
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

	$firstStartTime = ""  ;��һ�����ݵĿ�ʼʱ��
	$thisStartTime = ""   ;����ĳһ�����ݵĿ�ʼʱ��
	$thisTime = 0.0         ;����ĳһ�����ݵĳ���ʱ��
	$thisEndTime = 0.0      ;����ĳһ�����ݵ����ʱ��
	$totalTime = 0.0        ;�ܼ�ʱ��

	;ѭ��ȡÿһ�е�����
	$i = 0
	While $i < 2000

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

			If $i == 1 Then
				; ��������ļ��Ƿ���ȷ
				$datafilename = getFileName($filename)
				$tmpUrl = $array[$indexUrl]
				if StringInStr($tmpUrl, $datafilename ) == 0 Then
					$totalTime = -2
					$i =2001
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
