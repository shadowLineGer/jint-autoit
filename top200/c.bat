@echo [Clear]
@del top200_ping.exe

@echo [Compile Script to .exe]
"C:\AutoIt3\Aut2Exe\Aut2exe.exe" /in top200_ping.au3 /out top200_ping.exe /icon .\favicon.ico /nodecompile /comp 4
