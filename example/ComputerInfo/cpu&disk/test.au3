#cs
Private Declare Function GetDiskIDName Lib "Getinfo.dll" (ByVal Parameters asciiz ptr,ByVal Parameters1 As BYTE) As String
;注意：asciiz ptr为PB中的指针类型，转为VB的就自己想办法。不懂VB，不大清楚了。哈。
'函数入口，GetDiskIDName(Parameters,Parameters1)
'返回硬盘的型号和ID
'参数 Parameters 为DiskName时，Parameters1为0时，返回系统系统第一个硬盘的型号
'参数 Parameters 为DiskId时，Parameters1为0时，返回系统系统第一个硬盘的ID

Parameters1 说明：
0是第一个硬盘
1是第二个硬盘
依次类推。。。

Private Declare Function GetCpuInfo Lib "Getinfo.dll" (ByVal Parameters As Long) As String
'函数入口 GetCpuInfo(Parameters)
'返回CPU的序列号
'参数 Parameters 为0时，返回CPU序列号为8位
'参数 Parameters 为1时，返回CPU序列号为16位

#ce


$Dll=DllOpen("Getinfo.dll")
$sReturn1=DllCall($Dll,"str","GetDiskIDName","str","DiskName","byte",0)
ConsoleWrite( "硬盘名称" & StringStripWS($sReturn1[0],2) & @CRLF )

$sReturn2=DllCall($Dll,"str","GetDiskIDName","str","DiskId","byte",0)
ConsoleWrite( "硬盘ID" & $sReturn2[0] & @CRLF )

$sReturn3=DllCall($Dll,"str","GetCpuInfo","long",0)
ConsoleWrite( "CPU序列号的前8位" & $sReturn3[0] & @CRLF )

$sReturn4=DllCall($Dll,"str","GetCpuInfo","long",1)
ConsoleWrite( "CPU序列号16位" & $sReturn4[0] & @CRLF & "=====" & $sReturn4[1] & "=====" )

DllClose($Dll)

MsgBox(64,"硬盘名称",StringStripWS($sReturn1[0],2))
MsgBox(64,"硬盘ID",$sReturn2[0])
;MsgBox(64,"CPU序列号的前8位",$sReturn3[0])
MsgBox(64,"CPU序列号16位",$sReturn4[0])


