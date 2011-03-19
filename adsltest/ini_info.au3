#include-once

Global $INI_clientId = "jint"
Global $INI_place    = "testplace"
Global $INI_runMode  = "auto"

Global $INI_minDelay = "20000"
Global $INI_workDelay = "20000"
Global $INI_maxDelay = "1200000"
Global $INI_exelist = "AutoTest.exe,pingtest.exe,update.exe"

readIni()

; -----------------------------------------  函数的分隔线  -----------------------------------------------
Func readIni()
	; 取配置信息  客户端部分  这个部分，每个客户端都不一样
	Global $INI_clientId = IniRead( @ScriptDir & "\client.ini", "basic", "clientId", "jint")
	Global $INI_place    = IniRead( @ScriptDir & "\client.ini", "basic", "place", "testplace")
	Global $INI_runMode    = IniRead( @ScriptDir & "\client.ini", "basic", "runMode", "auto")

	; 取配置信息  服务端部分  这个部分，全局统一
	Global $INI_minDelay = IniRead( @ScriptDir & "\server.ini", "task", "minDelay", "2000")
	Global $INI_workDelay = IniRead( @ScriptDir & "\server.ini", "task", "workDelay", "20000")
	Global $INI_maxDelay = IniRead( @ScriptDir & "\server.ini", "task", "maxDelay", "1200000")

	Global $INI_exelist = IniRead( @ScriptDir & "\server.ini", "update", "exelist", "AutoTest.exe,pingtest.exe,update.exe")
EndFunc

