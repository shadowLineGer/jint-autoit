@echo [Clear]
@del AutoTest.exe pingtest.exe qx_manager.exe update.exe log.log

@echo [Compile Script to .exe]
"C:\Program Files\AutoIt3\Aut2Exe\Aut2exe.exe" /in ..\AutoTest.au3 /out .\AutoTest.exe /icon ..\favicon.ico /nodecompile /comp 4
"C:\Program Files\AutoIt3\Aut2Exe\Aut2exe.exe" /in ..\pingtest.au3 /out .\pingtest.exe /icon ..\favicon.ico /nodecompile /comp 4
"C:\Program Files\AutoIt3\Aut2Exe\Aut2exe.exe" /in ..\qx_manager.au3 /out .\qx_manager.exe /icon ..\favicon.ico /nodecompile /comp 4
"C:\Program Files\AutoIt3\Aut2Exe\Aut2exe.exe" /in ..\update.au3 /out .\update.exe /icon ..\favicon.ico /nodecompile /comp 4

@echo [compress files]
@7za a -y update.7z ..\page_check.js AutoTest.exe server.ini

@echo [Deploy]
@copy qx_manager.exe update.zip
@move update.zip ..\..\..\jint-gae\kuandaiceshi\img\
@move update.7z ..\..\..\jint-gae\kuandaiceshi\img\
