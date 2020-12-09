@Echo off
Setlocal EnableDelayedExpansion
Set "_Old_Path=%systemDrive%\system\Bat"
Set "_New_Path=%LocalAppData%\BatCenter"
If Exist "%_Old_Path%\hosts.txt" (
	If Not Exist "%_New_Path%" (MD "%_New_Path%")
	REM Copying all files to new path...
	Echo. Transferring Files from "OLD-Path" to "New-Path"...
	Robocopy "%_Old_Path%" "%_New_Path%" /MIR /E /S /w:3 /R:5

	REM Removing older path from PATH variable...
	Set "_path=%_Old_Path%"
	Call Getlen "!_path!"
	Set _len=!Errorlevel!
	Set _NewPath=
	REM Reading Path of Current User...
	for /f "skip=2 tokens=1,2,*" %%a in ('reg query HKCU\Environment /v path') do (Set "_UserPath=%%c")

	REM Checking, if the Path already has path to Bat
	for /f "tokens=*" %%A in ('StrSplit ^; "!_UserPath!"') do (
		REM Echo.%%A
		FOR %%a in (!_len!) do (
			Set "_Temp=%%~A"
			if /i "!_Temp:~0,%%~a!" NEQ "!_path!" (Set "_NewPath=!_NewPath!!_Temp!;")
			)
		)
	Set /p ".=Removing Batcenter From PATH... " <nul
	REM Removing BatCenter path from Environment variable...
	reg add HKCU\Environment /v Path /d "!_NewPath!" /f 2>nul >nul
	Cd / 2>nul >nul 2>&1
	RD /S /Q "!_path!" 2>nul >nul 2>&1
	Echo.[Done]
	Set "_path=%_New_Path%"
	Set "Path=%Path%;%_path%;"

	REM Adding New Path to PATH variable...
	Echo. Triggering BatCenter to Update Path as per the new Location > "%_New_Path%\FirstLaunch.txt"
	reg add HKCU\Environment /v Path /d "!Path!;!_path!;!_path!\Files;!_path!\plugins" /f
	Echo.
	Echo. RECOMMENDED:
	Echo. Please LOG-OFF/LOG-IN to make new Changes effective.
	Echo.
	)
exit /b