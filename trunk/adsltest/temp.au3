#include "jintutil.au3"
#include "myapp_Process_Data.au3"

;$b = ReadCSV( "C:\temp\2010113012���ŶԱ�ŷ�Ǵ���\www.baidu.com.csv" )
;prt( $b )

$ret = "cmd ping 211.137.130.3"
$index = StringInStr($ret, " ")
$taskType = StringLeft($ret, $index-1)
$task = StringRight($ret, StringLen($ret)-$index)

prt($taskType)
prt($task)

$ret = RunWait(@ComSpec & " /c " & $task,"")