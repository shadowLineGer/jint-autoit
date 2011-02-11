#include "jintutil.au3"
#include "myapp_Process_Data.au3"

;$b = ReadCSV( "C:\temp\2010113012电信对比欧亚大厦\www.baidu.com.csv" )
;prt( $b )

;$ret = "cmd ping 211.137.130.3"
;$index = StringInStr($ret, " ")
;$taskType = StringLeft($ret, $index-1)
;$task = StringRight($ret, StringLen($ret)-$index)

;prt($taskType)
;prt($task)

;$ret = RunWait(@ComSpec & " /c " & $task,"")

$i=0
;While $i<100
;	prt( "WinActivate:" & WinActive( "Auto Test Tool" ) )
;	sleep(300)
;	$i=$i+1
;WEnd


$cmdtext = @ComSpec & " /c RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 255"
RunWait( $cmdtext, "",@SW_HIDE  )

