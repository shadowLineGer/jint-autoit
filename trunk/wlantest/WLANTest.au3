#include <GUIConstants.au3>
#include <Misc.au3>

#include "qxutil.au3"

; �����ظ�����
_Singleton("SingleWLANTest")

prt(@ScriptName & " start.")


; ���������� ����Ŀ¼�����Ե�����
$WORKPATH = @ScriptDir & "\data"
$TESTPLACE = getINI("testplace")
$testRoundNo = getLongRoundNo()
$THISTESTPATH = ""


Opt("GUIOnEventMode", 1)  ; �л�Ϊ OnEvent ģʽ
$mainwindow = GUICreate("CMCC WLAN Auto Test Tool V3.0" , 500, 200)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
$infoLabel = GUICtrlCreateLabel("��ӭʹ�й��ƶ� WLAN �Զ����Թ��� ", 10, 10, 300, 20)

$testPlaceLabel = GUICtrlCreateLabel("���Ե�����:", 10, 45, 300, 25 )
$testPlaceText = GUICtrlCreateInput( $TESTPLACE, 80, 40, 300, 25 )


$testRoundLabel = GUICtrlCreateLabel("�����ִ�:", 10, 75, 300, 25 )
$testRoundText = GUICtrlCreateInput( $testRoundNo, 80, 70, 300, 25 )

$buttonTest = GUICtrlCreateButton("��ʼ����", 80, 110, 160, 60 )



;�󶨴�����
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUICtrlSetOnEvent($buttonTest, "startTest")

GUISetState(@SW_SHOW)
GUISwitch($mainwindow)
GUISetState(@SW_SHOW)


While 1
  Sleep(10)  ; �����κ���
WEnd


; -----------------------------------------  �����ķָ���  -----------------------------------------------
Func startTest()
	setInfo( "������ʼ����" )

	; make work dir
	If Not FileExists($WORKPATH) Then
		DirCreate( $WORKPATH )
	EndIf

	$THISTESTPATH = $WORKPATH & "\" & $testRoundNo & "_" & $TESTPLACE
	DirCreate( $THISTESTPATH )

	testMain( $WORKPATH )

	setInfo( "�������" )
EndFunc

Func testMain( $datapath )
	$taskType = "page"
	$runCount = ""
	$task = "www.10086.cn"

	; read task.txt
	$taskfile = @ScriptDir & "\" & "task.txt"

	If Not FileExists($taskfile) Then
		pop($taskfile & " Not Exist! ")
	Else
		$file = FileOpen($taskfile, 0)
		If @error = -1 Then
			prt("FileOpen @error " & @error & "  file:" & $taskfile)
		EndIf

		While 1
			$taskline = FileReadLine($file)
			If @error = 1 Or @error = -1 Then
				;prt("FileReadLine @error " & @error & "  file:" & $SITELISTPATH)
				ExitLoop
			EndIf

			$taskline = StringStripWS($taskline, 3)
			If StringLen($taskline) > 0 Then
				$temp = getParam($taskline)
				If $temp[0] < 4 Then
					pop("Task file format error! ")
					prt($taskline)
				Else
					$taskType = $temp[1]
					$taskName = $temp[2]
					$runCount = $temp[3]
					$task = $temp[4]
					prt($temp[4])

					runTask($temp[1], $temp[2], $temp[3], $temp[4])
					Sleep(5000)
				EndIf
			EndIf
		WEnd
	EndIf

EndFunc


Func runTask($taskType, $taskName, $runCount, $task )
	If $taskType == "page" Then
		setInfo( "ҳ����Կ�ʼ" )
		$ret = runPage($task)

	ElseIf $taskType == "wlanpage" Then    ; רΪ WLAN ��Ƶ�ҳ�����
		setInfo( "WLAN ���Կ�ʼ" )
		$ret = runWlanpage($task)

	ElseIf $taskType == "ping" Then
		setInfo( "Ping ���Կ�ʼ" )
		$ret = runPing($taskName, $task)

	ElseIf $taskType == "download" Then
		setInfo( "���ز��Կ�ʼ" )
		$ret = runDownload($task)

	ElseIf $taskType == "up" Then
		setInfo( "�ϴ����Կ�ʼ" )
		$ret = runUpload($task)

	ElseIf $taskType == "sn" Then  ;�����ź�ǿ��
		setInfo( "�ź�ǿ�Ȳ��Կ�ʼ" )
		$ret = runSN($task)

	ElseIf $taskType == "dhcp" Then
		setInfo( "IP ��ַ������Կ�ʼ" )
		$ret = runDhcp($task)

	ElseIf $taskType == "report" Then
		setInfo( "���ɱ���" )
		$ret = runReport($task)

	ElseIf $taskType == "sleep" Then
		setInfo( "������ͣ" )
		Sleep($task)
	EndIf

	Return 0
EndFunc

Func runPage($task)
	pop("Page test start.")
	;SaveData($line, $DATAFILEPATH, $testplace, $roundNo, $pingtime )
	$cmdline2 = "cscript //nologo pagetest.js " & $THISTESTPATH & " " &  $task
	prt($cmdline2)
	RunWait( $cmdline2, "",@SW_HIDE  )
	sleep(2000)

EndFunc

Func runWlanpage($task)
EndFunc

Func runPing($taskName, $task)
	$cmdline2 = "pingtest.exe " & $THISTESTPATH & " " & $taskName & " """ & $task & """"
	runCmdNoWait($cmdline2)
EndFunc

Func runDownload($task)
EndFunc

Func runUpload($task)
EndFunc

Func runSN($task)
EndFunc

Func runDhcp($task)
EndFunc

Func runReport($task)
EndFunc

Func getParam($line)
	$temp = StringStripWS($line, 7)
	;MsgBox(0, "Search result:", "[" & $temp & "]")

	$params = StringSplit($temp, " ")
	$argc = ""

	$flag = 1
	$num = 0
	Local $argcArr[1]

	For $i = 1 to $params[0]
		$idx = StringInStr( $params[$i], """")
		If $flag == 1 Then
			If $idx > 0 Then
				$flag = 2
				$argc = StringRight( $params[$i], stringlen($params[$i])-1 ) & " "
			Else
				$flag = 1
				$argc = $params[$i]
			EndIf
		ElseIf $flag == 2 Then
			If $idx > 0 Then
				$flag = 1
				$argc = $argc & " " & StringLeft( $params[$i], stringlen($params[$i])-1 ) & " "
			Else
				$flag = 2
				$argc = $argc & " " & $params[$i]
			EndIf
		EndIf

		If $flag == 1 Then
			;MsgBox(0, "Search result:", "[" & $argc & "]")
			_ArrayAdd( $argcArr, $argc )
			;_ArrayDisplay( $argcArr )
			$argc = ""
		EndIf
	Next

	$argcArr[0] = UBound( $argcArr )

	Return $argcArr

EndFunc


Func CLOSEClicked()
  ;ע�⣺��ʱ @GUI_CTRLID ��ֵ���ȼ��� $GUI_EVENT_CLOSE��
  ;�� @GUI_WINHANDLE ��ȼ��� $mainwindow �� $dummywindow
  If @GUI_WINHANDLE = $mainwindow Then

    Exit
  EndIf
EndFunc

Func setInfo($str)
	$info = $str
	GUICtrlSetData($infoLabel,$info)
EndFunc

