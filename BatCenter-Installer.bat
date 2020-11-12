@Echo off

:Win7


REM Goto :Extract





:Win10
REM Script to install BatCenter for Win 10
Echo. FETCHING FILES FROM SERVER...
curl -L "www.batch-man.com/bat/7za.exe.hex" --output "7za.exe.hex" --progress-bar
curl -L "www.batch-man.com/bat/bat.7z" --output "bat.7z" --progress-bar
Goto :Extract


:Extract
Set /p ".=EXTRACTING DOWNLOADED FILES..." <nul
md "__Temp" >nul 2>nul
Pushd "__Temp"
expand "..\7za.exe.hex" "7za.exe" >nul 2>nul
7za e "..\bat.7z" -y >nul 2>nul
Echo. [DONE]
Set /p ".=CLEANING MESS..." <nul
Del /f /q "..\7za.exe.hex" >nul 2>nul
Del /f /q "..\bat.7z" >nul 2>nul
Echo. [DONE]
Goto :FirstRun

:FirstRun
Call Bat update
Copy /y "*.*" "%SystemDrive%\system\bat\Files" >nul 2>nul
Popd
RD /S /Q "__Temp" >nul 2>nul
Goto :End

:End
Echo. INSTALLATION COMPLETE!
Echo. PLEASE RESTART CMD/TERMINAL TO ENJOY 'BAT-CENTER' BY KVC
Echo. WWW.BATCH-MAN.COM
Exit /b
