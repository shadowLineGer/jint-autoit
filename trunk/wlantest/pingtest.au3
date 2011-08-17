

#include "qxutil.au3"

prt( @ScriptName & " start.")

$workpath = ""
$taskname = ""
$task = ""

If $cmdLine[0] > 0 Then
	$workpath = $cmdLine[1]
	$taskname = $cmdLine[2]
	$task = $cmdLine[3]
Else
	pop("Cmdline argv error")
	Exit
EndIf


$pingfile = $workpath & "\ping_" & $taskname & ".txt"
If FileExists($pingfile) Then
	FileDelete( $pingfile )
EndIf


$myCmdline = @ComSpec & " /c " & $task & " > " & $pingfile
prt( $myCmdline )
RunWait( $myCmdline, @ScriptDir, @SW_SHOW )
Sleep(1000)

; 读入Ping命令的输出文件
$file2 = FileOpen($pingfile, 0)
If @error = -1 Then
	prt("FileOpen @error " & @error & "  file:" & $pingfile)
EndIf

; Open Record File
$recordfile = $workpath & "\testdata_" & $taskname & ".txt"
$file3 = FileOpen($recordfile, 1)
If @error = -1 Then
	prt("FileOpen @error " & @error & "  file:" & $recordfile)
EndIf

$i=0
$flag = 0
$ip = ""
$lost = ""
$avg = ""
$yunyingshang = ""
;prt("will while" )
While 1
	;prt("start while" )
	$line2 = FileReadLine($file2)
	If @error = 1 Or @error = -1 Then
		;prt("FileReadLine @error " & @error & "  file:" & $pingfile)
		ExitLoop
	EndIf

	;prt($line2)

	If  $flag == 0 And (StringInStr($line2, "Pinging") > 0 Or StringInStr($line2, "正在 Ping") > 0 ) Then
		$flag = 1
		$ip = ""
		$lost = ""
		$avg = ""
		$yunyingshang = ""

		$temp = StringSplit($line2, " ")

		If StringInStr($line2, "[") And StringInStr($line2, "]") Then
			; 这是Ping 域名的情况
			If StringInStr($line2, "Pinging") Then
				$ip = StringLeft($temp[3], StringLen($temp[3])-1)
			Else
				$ip = StringLeft($temp[4], StringLen($temp[4])-1)
			EndIf

			$ip = StringRight($ip, StringLen($ip)-1)
		Else
			; 这是直接ping IP的情况
			If StringInStr($line2, "Pinging") Then
				$ip = $temp[2]
			Else
				$ip = $temp[3]
			EndIf
		EndIf

	EndIf

	If $flag == 1 And StringInStr($line2, "数据包") Or StringInStr($line2, "Packets") Then
		$flag = 2
		$temp = StringSplit($line2, " ")

		If StringInStr($line2, "Packets") Then
			$lost = StringRight($temp[15],StringLen($temp[15])-1)
		Else
			$lost = StringRight($temp[13],StringLen($temp[13])-1)
		EndIf

		If $lost == "100%" Then
			$flag = 3
			$avg = "Request timed out"
		EndIf
	EndIf

	If $flag == 2 And StringInStr($line2, "平均") Or StringInStr($line2, "Average") Then
		$flag = 3
		$temp = StringSplit($line2, " ")
		If StringInStr($line2, "Average") Then
			$avg = $temp[13]
		Else
			$avg = $temp[11]
		EndIf
	 EndIf

	If $flag == 3 Then
		$record = " ip=" & $ip & "&lost=" & $lost & "&pingtime=" & $avg
		prt( $record )
		FileWriteLine($file3, $avg )
		ExitLoop
	EndIf
WEnd
FileClose($file2)
FileClose($file3)

;If FileExists($pingfile) Then
;	FileDelete( $pingfile )
;EndIf

prt( @ScriptName & " Successed END.")

; -----------------------------------------  函数的分隔线  -----------------------------------------------




