#cs
Private Declare Function GetDiskIDName Lib "Getinfo.dll" (ByVal Parameters asciiz ptr,ByVal Parameters1 As BYTE) As String
;ע�⣺asciiz ptrΪPB�е�ָ�����ͣ�תΪVB�ľ��Լ���취������VB����������ˡ�����
'������ڣ�GetDiskIDName(Parameters,Parameters1)
'����Ӳ�̵��ͺź�ID
'���� Parameters ΪDiskNameʱ��Parameters1Ϊ0ʱ������ϵͳϵͳ��һ��Ӳ�̵��ͺ�
'���� Parameters ΪDiskIdʱ��Parameters1Ϊ0ʱ������ϵͳϵͳ��һ��Ӳ�̵�ID

Parameters1 ˵����
0�ǵ�һ��Ӳ��
1�ǵڶ���Ӳ��
�������ơ�����

Private Declare Function GetCpuInfo Lib "Getinfo.dll" (ByVal Parameters As Long) As String
'������� GetCpuInfo(Parameters)
'����CPU�����к�
'���� Parameters Ϊ0ʱ������CPU���к�Ϊ8λ
'���� Parameters Ϊ1ʱ������CPU���к�Ϊ16λ

#ce


$Dll=DllOpen("Getinfo.dll")
$sReturn1=DllCall($Dll,"str","GetDiskIDName","str","DiskName","byte",0)
ConsoleWrite( "Ӳ������" & StringStripWS($sReturn1[0],2) & @CRLF )

$sReturn2=DllCall($Dll,"str","GetDiskIDName","str","DiskId","byte",0)
ConsoleWrite( "Ӳ��ID" & $sReturn2[0] & @CRLF )

$sReturn3=DllCall($Dll,"str","GetCpuInfo","long",0)
ConsoleWrite( "CPU���кŵ�ǰ8λ" & $sReturn3[0] & @CRLF )

$sReturn4=DllCall($Dll,"str","GetCpuInfo","long",1)
ConsoleWrite( "CPU���к�16λ" & $sReturn4[0] & @CRLF & "=====" & $sReturn4[1] & "=====" )

DllClose($Dll)

MsgBox(64,"Ӳ������",StringStripWS($sReturn1[0],2))
MsgBox(64,"Ӳ��ID",$sReturn2[0])
;MsgBox(64,"CPU���кŵ�ǰ8λ",$sReturn3[0])
MsgBox(64,"CPU���к�16λ",$sReturn4[0])


