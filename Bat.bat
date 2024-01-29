@echo off
setlocal EnableDelayedExpansion

set "_BatCenter=!LocalAppData!\BatCenter"
set "Original_Path=!path!"
if not exist "!_BatCenter!" (md "!_BatCenter!")
set _FolderStructure="Json" "plugins" "Files" "Index" "Zips" "Temp"
set _IndexFiles="name" "full_name" "default_branch" "license.name" "size" "description" "owner.login" "owner.avatar_url" "svn_url" "created_at" "updated_at" "id"
set _commands="update" "ilist" "list" "search" "install" "uninstall" "detail"

REM THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY
REM KIND, EXPRESS OR IMPLIED, INCLUDING BUT not LIMITED TO THE
REM WARRANTIES OF MERCHANTABILITY, FITNESS for A PARTICULAR PURPOSE
REM AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR copyRIGHT
REM HOLDERS BE LIABLE for ANY CLAIM, DAMAGES OR OTHER LIABILITY,
REM WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
REM OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
REM DEALINGS IN THE SOFTWARE.

REM This program is free software: you can redistribute it and/or modify
REM it under the terms of the GNU General Public License as published by
REM the Free Software Foundation, either version 3 of the License, or
REM (at your option) any later version. 
REM see www.gnu.org/licenses

REM ================= ABOUT THE PROGRAM =================
REM This program is Created by Kvc at 'Tue 11/03/2020 - 16:12'
REM This program will help you download the batch plugins from selected
REM sources, you can search and see details about them before downloading
REM for More Visit: www.batch-man.com
REM OR
REM https://github.com/Batch-Man/BatCenter


REM Setting version information...
set _ver=20240130

REM Starting Main Program...
REM ============================================================================
:Main

REM Checking for the help menu...
REM Read more about '?' can't be escaped in FOR loop, so - checking for it seperately...
REM Source: https://superuser.com/questions/1576114/window-batch-escaping-special-characters-in-for-sentence 
If /i "%~1" == "/?" (Goto :Help)
for %%A in ("" "--help" "-h" "-help" "/help" "help") do (if /i "%~1"=="%%~A" (goto :help))
for %%A in ("--ver" "-v" "/v" "-ver" "/ver" "ver") do (if /i "%~1"=="%%~A" (echo.!_ver!&goto :End))

REM Verifying the Required folder tree for files...
Call :VerifyAndFixBatCenterFiles

set "path=!path!;!_BatCenter!\Files;!_BatCenter!\plugins;!cd!\files"
Pushd "!_BatCenter!"

REM Checking if the '-y' is provided in parameters...
REM Reading variables as per parameters...
Set _varCount=0
:varLoop
If /i "%~1" == "" (Goto :exitVarLoop)
Set /A _varCount+=1
Set _!_varCount!=%~1
REM Also checking for 'y' switch...
If /i "%~1" == "-y" (Set _y=True && Set /A _varCount-=1)
If /i "%~1" == "/y" (Set _y=True && Set /A _varCount-=1)
Shift /1
Goto :varLoop

:exitVarLoop
REM Acting as per the Passed parameters...
set _Valid=False
if /i "!_1!" == "reset" (if /I "!_2!" == "all" (Goto :ResetAll) else (Goto :Reset))

for %%A in (!_commands!) do (
	if "!_1!"=="%%~A" (
		call :%%~A
		set _Valid=True
	)
)
if /i "!_Valid!" == "False" (echo.Invalid parameter. Type 'bat /?' for help.)
goto :End

REM ============================================================================

:Uninstall
REM set _Index_Number=%_1%
REM Generating a Temp File, for the list of installed plugins
REM if not exist "Temp\_Plugins.installed" (echo.No plugins installed.&&goto :End)

REM set _Temp=0
REM for /f "usebackQ tokens=*" %%A in ("Temp\_Plugins.installed") do (if /I "%%~A" == "!_Index_Number!" (set /A _Temp+=1))
echo.This feature will come soon.
goto :EOF

:FirstLaunch
Set _UserPath=

echo Setting up BatCenter...
rem Reading the current path variable value...
for /f "skip=2 tokens=1,2,*" %%A in ('reg query HKCU\Environment /v Path') do (Set "_UserPath=%%C")

@REM REM Adding BatCenter path to Environment variable...
Echo Adding BATCENTER to PATH...
rem adding environmental variable to be used later... and to keep length of Path variable limited...
Echo creating environmental variable... 'batcenter'...
Setx batcenter "%localappdata%\BatCenter"

Setx path "!_UserPath!!_BatCenter!\Files;!_BatCenter!\plugins;"
@REM reg add HKCU\Environment /v Path /d "!path!;!_BatCenter!;!_BatCenter!\Files;!_BatCenter!\plugins;" /f

echo Setup completed successfully
REM Updating the environment path, without restarting.... (Thanks @anic17)
gpupdate /force
call EnvUpdate.bat
Goto :EOF

:Reset
del /f /q "!_BatCenter!\Files\hosts.txt" 
del /f /q "!_BatCenter!\Plugins\*.*"
del /f /q "!_BatCenter!\Index\*.*"
del /f /q "!_BatCenter!\Json\*.*"
del /f /q "!_BatCenter!\Zips\*.*"
del /f /q "!_BatCenter!\Temp\*.*"
Echo. BatCenter is Reset to its Initial State...as a New Install!!
Echo. All Installed plugins/tools are removed...
goto :EOF

:ResetAll
REM Removing BatCenter from Path...
set _NewPath=

REM Checking, if the Path already has path to BatCenter...
for /f "skip=2 tokens=1,2,*" %%A in ('reg query HKCU\Environment /v Path') do (Set "_UserPath=%%C")
echo !_UserPath! | find /i "batcenter" >nul 2>nul && (

	REM Thanks Bing-AI for the following trick so i can eliminate the use of dedicated
	REM dependenacy only for this task... (removed strsplit.exe)
	for %%A in ("!path:;=";"!") do (echo.%%~A | find /i "batcenter" || (set "_NewPath=!_NewPath!%%~A;"))
	
	set /p ".=Removing BatCenter from path... " <nul
	REM Removing BatCenter path from Environment variable...
	@REM reg add HKCU\Environment /v Path /d "!_NewPath!" /f 2>nul >nul
	setx path "!_NewPath!"
	setx batcenter ""
)
cd /
rd /s /q "!_BatCenter!" 2>nul 2>&1 >nul 
echo.done
Exit /b
goto :EOF

:iList
if not exist "Temp\_Plugins.installed" (
	dir /b "Zips\*.zip" > "!Temp!\List.txt" 2>nul
	if /i !Errorlevel! NEQ 0 (echo.No plugins installed && goto :EOF)
	del /q /f "plugins\*.*" >nul 2>nul

	REM Checking, if fixing of older batcenter SYSTEM is needed...
	set _Temp=0
	for /f "tokens=* delims=." %%A in ('dir /b "Zips\*.zip"') do (if %%~nA LSS 100000 (set /A _Temp+=1))
	if !_Temp! GTR 0 (
		if exist "Index\id.index" (del /f /q "Index\id.index" >nul 2>nul)

		REM Getting Json files of each host...
		for /f "tokens=*" %%a in (hosts.txt) do (for %%A in ("id") do (type "Json\%%a.json" | jq ".[] .%%~A" >> "Index\%%~A.index"))

		for /f "tokens=1,2* delims=." %%A in ('dir /b "Zips\*.zip"') do (
			for /f "tokens=*" %%a in ('ReadLine "Index\id.index" %%~nA') do (set "_GID=%%~a")

			Ren "Zips\%%~nA.zip" "!_GID!.zip" 2>nul >nul
			)
		)

	for /f "tokens=1,2* delims=." %%A in ('dir /b "Zips\*.zip"') do (
		REM Checking if the name of the file is - Numeric or alphabet
		set /A _Temp=%%~nA / 1

		if /i "!_Temp!" NEQ "0" (
			call :GetLocalID "%%~nA" _Index_Number
			call :Install_Tracking !_Index_Number!
			pushd plugins
			7za e -y "..\Zips\%%~nA.zip" >nul
			REM Removing Empty Folders...
			for /f "tokens=*" %%a in ('dir /b /a:d') do (Rd /S /Q "%%~a")
			popd
		)
	)
)

if not "%_2%"=="" (
	if exist "%_BatCenter%\Temp\_%_2%.content" (
		ReadLine "Index\name.index" %_2%
		goto :EOF
	) else (
		echo %_2% is not installed.
		goto :EOF
	)
) 

REM Tracking Number of installed Plugins in system...
set _Count=0
echo. ----------------------- Installed plugins ------------------------
if exist "Temp\_Plugins.installed" (
for /f "usebackQ tokens=*" %%A in ("Temp\_Plugins.installed") do (
	call :GetLocalID %%~A _Local_ID
	ReadLine "Index\name.index" !_Local_ID!
	set /A _Count+=1
	)
)
if !_Count! == 0 (echo.No plugins installed.)
echo. ------------------------------------------------------------------
goto :EOF


:Detail
if /i "%_2%" == "" (echo.Missing search term. See 'bat /?'&& goto :End)
set _Index_Number=!_2!
call :check_Number !_2! _Error
if /i "!_Error!" NEQ "T" (
	call :Search _RCount _Result
	if !_RCount! GTR 1 (
		set /A _RCount-=1
		echo.Multiple results found for the install term.
		echo.Try running 'bat search [Term1] [Term2]'
		echo.
		set _Temp=N
		if not defined _y (set /P "_Temp=See Details? [Y/N]:") else (set _Temp=Y)
		if /I "!_Temp!" == "Y" (
		for /L %%A in (0,1,!_RCount!) do (
			call :GetIndexNumber "!_Result[%%~A]!" _Index_Number
			call :FetchDetails !_Index_Number!
			)
		)
		goto :End
	)

	if !_RCount! EQU 0 (
		echo.Multiple results found for the search term.
		echo.Try running 'bat search [Term1] [Term2]'
		goto :End
	)
	call :GetIndexNumber "!_Result[0]!" _Index_Number
)

REM echo !_Index_Number!
call :FetchDetails !_Index_Number!
goto :End

REM =============================[ INSTALL ]====================================
:Install
REM Looking for the Searched term and returning the Value in _Result variable.
REM Saving the values of results in an array kind of structure...
REM E.g: _Result[0], _Result[1] ...
REM Where, _RCount contains the number of results and _Result is the array name
if /i "!_2!" == "" (echo.Missing search term. See 'bat /?' && goto :End)

set _Index_Number=!_2!
call :check_Number !_2! _Error
if /i "!_Error!" NEQ "T" (
	call :Search _RCount _Result
	if !_RCount! GTR 1 (
		set /A _RCount-=1
		echo.Multiple results found for the install term.
		echo.Try running 'bat search [Term1] [Term2]'
		echo.
		set _Temp=N
		if not defined _y (
			set /P "_Temp=See Details? [Y/N]:"
		) else (
			set _Temp=Y
		)
		if /i "!_Temp!" == "Y" (
			for /L %%A in (0,1,!_RCount!) do (
				call :GetIndexNumber "!_Result[%%~A]!" _Index_Number
				call :FetchDetails !_Index_Number!
			)
		)
		goto :End
	)

	if !_RCount! EQU 0 (
		echo.No results found matching the install term.
		goto :End
	)
	call :GetIndexNumber "!_Result[0]!" _Index_Number
)

call :Get_Max_Index _Max_Index
if !_Index_Number! GTR !_Max_Index! (
	echo.The specified index ^(!_Index_Number!^) is greater than the plugin count ^(!_Max_Index!^)
	goto :End
)

call :GetGithubID !_Index_Number! _Github_ID

REM echo !_Index_Number!
call :FetchDetails !_Index_Number!
echo.Starting download...
call :Download !_Index_Number!
<nul set /p ".=Extracting plugin files to %_BatCenter%\Plugins... "

pushd Plugins
7za l "..\Zips\!_Github_ID!.zip" > nul 2>&1 && (echo.done) || (echo.failed)
rem for /f "skip=13 tokens=5*" %%a in (' ^| findstr /c:"."') do (echo %%b)
7za x -y "..\Zips\!_Github_ID!.zip" >nul
REM Removing Empty Folders...


for /f "tokens=* delims=" %%A in ('dir /s /b "*.exe" "*.bat" "*.cmd" "*.com"') do (
    if /i "%%~fA" neq "%~f0" (
        echo.@echo off > "%%~nA.bat"
		echo.setlocal >> "%%~nA.bat"
		echo.set PATH=%%~dp0\wc\;%%PATH%%; >> "%%~nA.bat"
		echo."%%~dp0\wc\%%~nxA" %%* >> "%%~nA.bat"
		echo.endlocal >> "%%~nA.bat"
    )
)

popd
set /p ".=Updating the plugin database... "
call :Install_Tracking "!_Index_Number!"
echo.done
goto :End

:Install_Tracking
setlocal
set "_Index_Number=%~1"
call :GetGithubID !_Index_Number! _Github_ID

REM Verifying, if the plugin is already in the list of Installed plugins...
if exist "Temp\_Plugins.installed" (
	set _Temp=0
	for /f "tokens=*" %%A in ('type "Temp\_Plugins.installed"') do (if /i "%%~A" == "!_Github_ID!" (set /A _Temp+=1))
	if !_Temp! NEQ 0 (goto :EOF)
	)

REM Adding the ID of the Installed Plugin in INSTALLED PLUGINs list
echo.!_Github_ID!>> "Temp\_Plugins.installed"

for /f "tokens=*" %%A in ('ReadLine "Index\name.index" !_Index_Number!') do (
	echo. REGISTERING Plugin... %%~A
)

REM As, Registering a plugin takes some time ... I want to show some progress alognside...
REM for the Sake of Real-Time Showing Progress...
set /A _Count=0
set _Temp_Count=0
set _BarLength=75
for /f "skip=16 tokens=1,2,3,4,5,*" %%a in ('7za l "Zips\!_Github_ID!.zip"') do (set /a _Count+=1)

REM Checking Current CMD Size...
call GetDim _Rows _Columns
set /A _BarLength=!_Columns! - 5

REM Keeping names of all files those are Installed...

REM As All plugins are being extracted in one path, so multiple files/dependency files can be overwritten
REM while installing a plugin. Which is not a problem - but, while UNINSTALLING the plugin it can cause 
REM problems.

REM Here - I am Checking to see.. if any file is IMMUNE to 'install & uninstall' process of plugins
REM In other words, if a single file is being used by multiple Plugins, then it must be marked as IMMUNE
REM So, when user uninstalls a plugin from system - He/she would not want to accidently make other plugins
REM DEAD/Unfunctional because of the one dependency. (e.g: batbox.exe is used by many batch plugins)

if exist "Temp\_!_Index_Number!.content" (del /f /q "Temp\_!_Index_Number!.content" >nul 2>nul)
for /f "skip=16 tokens=1,2,3,4,5,*" %%a in ('7za l "Zips\!_Github_ID!.zip"') do (
	REM Just simple calculation for showing current progress on console screen...
	set /A _Temp_Count+=1
	call Progress !_BarLength! !_Temp_Count! !_Count!

	REM Checking, if the current thing is file or a folder...
	set "_Temp=%%~c"
	
	set _Dot=F
	REM Check, if there is any '.' in the _Temp... (So, that we can consider the line to be processed)
	if /i "!_Temp!" NEQ "!_Temp:.=_!" (set _Dot=T) else (set _Dot=F)
	
	if /i "!_Dot!" == "T" (
		REM Checking for the character 'D' to be present in the ATTRIBUTES...
		set _Folder=T
		if /i "!_Temp!" NEQ "!_Temp:D=_!" (set _Folder=T) else (set _Folder=F)
		if /i "!_Folder!" == "F" (
			echo %%~nxf>>"Temp\_!_Index_Number!.content"
			REM Checking if the file is IMMUNE or NOT
			if exist "plugins\%%~nxf" (
				REM Checking if the IMMUNE file is already in the DB List or NOT
				set _Temp=0
				if exist "Temp\_Immune.installed" (for /f "tokens=*" %%A in ('type "Temp\_Immune.installed"') do (if /I "%%~A" == "%%~nxf" (set /A _Temp+=1)))
				if !_Temp! == 0 (echo.%%~nxf>>"Temp\_Immune.installed")
				)
			)
		)
	)
Endlocal
goto :EOF


REM ============================================================================
:Download
set _Index_Number=%~1
if /I "!_Index_Number!" == "" (goto :EOF)
call :GetGithubID !_Index_Number! _Github_ID

REM Downloading the required Repository...
if not exist "Zips\!_Github_ID!.zip" (Wget "https://github.com/!_RepoFullName:"=!/archive/!_RepoBranch:"=!.zip" -O "Zips\!_Github_ID!.zip" -q --tries=5 --show-progress --timeout=5) else (
	echo. Already Installed...!
	echo. Do You want to ReDownlaod '!_RepoName:~1!' ?
	set _Temp=N
	if not defined _y (set /P "_Temp=Y/N or N] [Default:N] ") else (set _Temp=y)
	if /i "!_Temp!" == "y" (Wget "https://github.com/!_RepoFullName:"=!/archive/!_RepoBranch:"=!.zip" -O "Zips\!_Github_ID!.zip" -q --tries=5 --show-progress --timeout=5)
	)
goto :EOF

REM ============================================================================
:GetIndexNumber [_Repo_Name_String_With_Index] [_VariableName]
for /f "tokens=1* delims=[" %%A in ("%~1") do for /f "tokens=1* delims=]" %%X in ("%%A") do (set "%~2=%%X")
goto :EOF

REM ============================================================================
:GetLocalID [_Github_ID] [_VariableName]
set _GID=%~1
set %~2=
for /f "eol=- skip=2 tokens=1,2* delims=]" %%A in ('find /i /n "!_GID!" "Index\id.index"') do (set "_Result=%%~A")
set "%~2=!_Result:~1!"
goto :EOF

REM ============================================================================
:GetGithubID [_Index_Number] [_VariableName]
for /f "tokens=*" %%A in ('ReadLine "Index\id.index" %~1') do (set "%~2=%%~A")
goto :EOF

REM ============================================================================
:FetchDetails [Local_ID]
set _Index_Number=%~1
if not defined _Index_Number (goto :EOF)

REM Checking the max number of the plugins available
call :Get_Max_Index _Max_Index
if !_Index_Number! GTR !_Max_Index! (echo.The specified index ^(!_Index_Number!^) is greater than the plugin count ^(!_Max_Index!^) && goto:EOF)
for /f "tokens=2 delims=:" %%A in ('chcp') do set "codepage=%%A"
chcp 65001 > nul

REM Fetching Details of Selected Repo...
for %%A in (!_IndexFiles!) do (
	if /i "%%~A" == "name" (set _var=_RepoName)
	if /i "%%~A" == "full_name" (set _var=_RepoFullName)
	if /i "%%~A" == "default_branch" (set _var=_RepoBranch)
	if /i "%%~A" == "license.name" (set _var=_RepoLicense)
	if /i "%%~A" == "size" (set _var=_RepoSize)
	if /i "%%~A" == "description" (set "_var=_RepoDes")
	if /i "%%~A" == "owner.login" (set _var=_RepoOwner)
	if /i "%%~A" == "owner.avatar_url" (set _var=_RepoAvatarURL)
	if /i "%%~A" == "svn_url" (set _var=_RepoLink)
	if /i "%%~A" == "created_at" (set _var=_RepoInit)
	if /i "%%~A" == "updated_at" (set _var=_RepoUpdate)
	if /i "%%~A" == "id" (set _var=_RepoID)
	ReadLine "Index\%%~A.index" !_Index_Number! > "!Temp!\tmp.temp"
	set /P !_var!= < "!Temp!\tmp.temp"
)

REM Fixing a bug...
set _RepoOwner=!_RepoOwner:"=!
set _RepoLink=!_RepoLink:~9!

set _RepoDes=!_RepoDes:"=!

REM if not exist "Files\!_RepoOwner!.bmp" (
REM 	del /f /q "!Temp!\Tmp.Temp" >nul 2>nul
REM 	echo. Loading...
REM 	wget "!_RepoAvatarURL:"=!" -O "!Temp!\!_RepoOwner!.png" -q
REM 	Iconvert "!Temp!\!_RepoOwner!.png" "Files\!_RepoOwner!.bmp" >nul
REM 	)


REM Fixing RepoName...
for /f "tokens=1,2* delims=-" %%A in ("!_RepoName!") do (set _RepoName=%%~B)

REM Checking length of the Description...
call Getlen "!_RepoDes!"
set _Len=!Errorlevel!

if !_Len! GEQ 50 (set _RepoDes=!_RepoDes:~0,50!...)
echo. --------------------------------------------------------------------
echo. Name:			!_RepoName:~1!
echo. Owner:			!_RepoOwner!
echo. Local-ID:		!_Index_Number!
echo. Github-ID:		!_RepoID!
echo. Created:		!_RepoInit:~1,10!
echo. Updated-On:		!_RepoUpdate:~1,10!
echo. Branch:		!_RepoBranch:"=!
echo. License:		!_RepoLicense:"=!
echo. Size:			!_RepoSize! KBs
echo. Description:		!_RepoDes!
echo. Link:			!_RepoLink:"=!
echo. --------------------------------------------------------------------
if /i "!_1!" == "Detail" (echo.Install it with: "bat install !_Index_Number!")
chcp !codepage! > nul
goto :End

REM ============================[ CHECK_NUMBER ]================================
:check_Number
set _Number=%~1
for /L %%A in (0,1,9) do (if defined _Number (set _Number=!_Number:%%~A=!))
if not defined _Number (set %~2=T) else (set %~2=F)
Exit /b


REM ============================[ UPDATE ]======================================
:Update
REM Checking, if the Path already has path to BatCenter
for /f "skip=2 tokens=1,2,*" %%A in ('reg query HKCU\Environment /v Path') do (echo.%%C | find /i "batcenter" >nul 2>nul || (Call :FirstLaunch))

call :CheckConnection _Error
if !_Error! NEQ 0 (goto :End)

REM Checking for Limited API calls condition...
if exist "!_BatCenter!\Files\BlockUpdate.txt" (echo.Too many API requests. Please wait some time&&echo.Limiting API calls only 180 times/hour, So your IP will not get Blacklisted. && goto :End)

REM Checking for BatCenter Update...
set _UpdateBat=
set _online_ver=
wget -qO- "https://raw.githubusercontent.com/Batch-Man/BatCenter/main/Bat.bat" | find /i "set _ver=" > "!Temp!\_Ver.txt"
for /f "eol=w usebackq tokens=1,2* delims==" %%a in ("!Temp!\_Ver.txt") do (if not defined _online_ver (set "_online_ver=%%~b"))

REM Creating a backup of number...
set _Temp_ver=!_ver!
set _Temp_online_ver=!_online_ver!

REM Comparing the versions...
set _ver=!_ver:.=!
set _online_ver=!_online_ver:.=!
if !_online_ver! GTR !_ver! (
	echo.-------------------------------------------------------------------------------------------
    echo.A new version of BatCenter is available [Current: !_Temp_ver!, New: !_Temp_online_ver!]
	echo.-------------------------------------------------------------------------------------------
	echo.
    wget "https://github.com/Batch-Man/BatCenter/archive/main.zip" -O "!_BatCenter!\Zips\BatCenter.zip" -q --tries=5 --show-progress --timeout=5
	REM Creating a separate batch-file, as script overwriting  itself can lead to malfunctioning...
   	(
	echo @echo off
	echo setlocal EnableDelayedExpansion
    echo title Updating BatCenter...
    echo echo.Extracting files...
    echo pushd "!_BatCenter!\files"
    echo 7za e -y "!_BatCenter!\Zips\BatCenter.zip"
    echo REM Removing Empty Folders...
    echo for /f "tokens=*" %%%%A in ^('dir /b /a:d'^) do ^(Rd /S /Q "%%%%~A"^)
    echo popd
	echo del /f /q "!_BatCenter!\Zips\BatCenter.zip" 
	echo echo.Done
	echo 
	) >"!Temp!\UpdateBat.bat"
	set _UpdateBat=True
)

REM Removing Older Index Files...
del /f /q "!_BatCenter!\Index\*.*" >nul 2>nul
del /f /q "!_BatCenter!\Files\hosts.txt" >nul 2>nul

REM Need to check, if the Basic Json files are present...Otherwise, we'll update!
if not exist "!_BatCenter!\Files\hosts.txt" (Wget "https://raw.githubusercontent.com/Batch-Man/BatCenter/main/Install/hosts.txt" -O "!_BatCenter!\Files\hosts.txt" -q --tries=5 --show-progress --timeout=5)

if /i "!_2!" NEQ "" (find /i "!_2!" "!_BatCenter!\Files\hosts.txt" >nul 2>nul && (echo. Already in DB...) || (echo.!_2!>>"!_BatCenter!\Files\hosts.txt"))

REM Getting Json files of each host...
for /f "usebackq tokens=*" %%a in ("!_BatCenter!\Files\hosts.txt") do (
	wget "https://api.github.com/users/%%a/repos?per_page=100000&page=1" -O "!_BatCenter!\Json\%%a.json" -q --tries=5 --show-progress --timeout=5

	REM Indexing Details...
	for %%A in (!_IndexFiles!) do (type "!_BatCenter!\Json\%%a.json" | jq ".[] .%%~A" >> "!_BatCenter!\Index\%%~A.index")
	)

REM Setting _Count to '0' (Preventing mixing-up of numbers after "Bat Update")
set _Count=0

REM Indexing the main name.json file...
del /f /q "!Temp!\Tmp.index" >nul 2>nul
for /f "usebackQ tokens=*" %%A in ("!_BatCenter!\Index\name.index") do (
	set /A _Count+=1
	set _Temp_Line=%%~A
	if defined _Temp_Line (echo.[!_Count!]-!_Temp_Line:-= !>>"!Temp!\Tmp.index")
	)

copy /y "!Temp!\Tmp.index" "!_BatCenter!\Index\name.index" >nul 2>nul
REM Keeping an eye on the Max Number of Plugins available...
set _Max_Index=!_Count!
echo.!_Max_Index!>"!_BatCenter!\files\_Max_Index.Count"

echo.Database updated successfully.
REM LIMITING ACCESS TO API ONLY 180 TIMES/H (Thanks to @anic17 for Idea to improve)
REM Since, in 1 update, we are calling github atleast 4 times... reducing number
REM of requests to (180/4)... i.e. 45 times in an hour... 
set _TempTime=!Time:~0,-6!
set _TempTime=!_TempTime::=!

if not exist "!_BatCenter!\Files\_APIAccessTime.txt" (
	REM Recording the Time of Usage for UPDATE COMMAND with BATCenter
	echo.!_TempTime! >"!_BatCenter!\Files\_APIAccessTime.txt"
	echo.1 >"!_BatCenter!\Files\_APIAccessCount.txt"
	del /f /q "!_BatCenter!\Files\BlockUpdate.txt" >nul 2>nul
	) else (
	set /P _OldTime= < "!_BatCenter!\Files\_APIAccessTime.txt"
	set /A _TimeDifference=!_TempTime!-!_OldTime!
	set _TimeDifference=!_TimeDifference:-=!

	if !_TimeDifference! GTR 59 (del /f /q "!_BatCenter!\Files\_APIAccessTime.txt")
	set /p _TempCount= < "!_BatCenter!\Files\_APIAccessCount.txt"
	set /A _TempCount+=1
	echo.!_TempCount! > "!_BatCenter!\Files\_APIAccessCount.txt"
	if !_TempCount! GEQ 45 (echo.This file limits API calls...>"!_BatCenter!\Files\BlockUpdate.txt")
	)
REM Updating BatCenter in case, if there is an update...
if defined _UpdateBat (Start "" /SHARED /WAIT /B "!Temp!\UpdateBat.bat")
Exit /b 0

REM ============================================================================
:CheckConnection
set /p ".=Checking internet connection..." <nul
wget --server-response --spider --quiet "https://github.com" >nul 2>nul&& (echo. [OK]&&set "_Return=0") || (echo. [Failed]&&set "_Return=1")
REM curl -s "www.github.com" >nul 2>nul&& (echo. [OK]&&set "_Return=0") || (echo Failed to connect to the internet&&set "_Return=1")
If /i "%~1" NEQ "" (set %~1=!_Return!)
Exit /b !_Return!

:VerifyAndFixBatCenterFiles
REM Verifying the Required folder tree for files...
for %%A in (!_FolderStructure!) do (if not exist "!_BatCenter!\%%~A" (md "!_BatCenter!\%%~A"))

for %%A in (!_IndexFiles!) do (
	if not exist "!_BatCenter!\Index\%%~A.index" (
		echo.Please run 'Bat Update' to finish the installation.
		goto :End
	)
)
Goto :EOF

REM ================================[LIST]======================================
:List
set _Count=0
if not exist "!_BatCenter!\Index\name.index" (echo.No index file. Please run 'bat update' command.&&goto :End)
type "!_BatCenter!\Index\name.index"
goto :End

REM ===============================[SEARCH]=====================================
:Search [_ResultArrayName] [_ResultArrayMaxCount]
set "_RCount=%~1"
set "_Return=%~2"
if /i "%_2%" == "" (echo.Missing search term. See 'bat /?'&& goto :End)

REM Parameter handling...
set _Count=2

REM copying index file for later refined search...
REM copy /y "Index\full_name.index" "%Temp%\tmp.index" >nul 2>nul
copy /y "Index\name.index" "%Temp%\tmp.index" >nul 2>nul
:SearchLoop
if /i "!_%_Count%!" == "" (goto :SearchNext)
Find /i "!_%_Count%!" "!Temp!\tmp.index" > "!Temp!\tmp2.index"
copy /y "!Temp1\tmp2.index" "!Temp!\tmp.index" >nul 2>nul
set /A _Count+=1
goto :SearchLoop

:SearchNext
REM Printing all the results... Skipping lines starting with '-' becuase of Find 
REM command.
set _TempCount=0
for /f "eol=- skip=2 tokens=*" %%A in ('type "!Temp!\tmp.index"') do (
	if /i "!_Return!" == "" (echo.%%~A) else (set "!_Return![!_TempCount!]=%%~A")
	set /A _TempCount+=1
	)
if defined _RCount (set !_RCount!=!_TempCount!)
goto :End

:Get_Max_Index [%~1 = Variable to return the value of max-index of the list of plugins...]
setlocal
REM Checking the max number of the plugins available
if exist "Files\_Max_Index.count" (set /p _Max_Index=<"Files\_Max_Index.count") else (
	set _Max_Index=0
	for /F "usebackq tokens=*" %%A in ("Index\name.index") do (set /A _Max_Index+=1)
	echo.!_Max_Index!>"Files\_Max_Index.count"
	)
Endlocal && set "%~1=%_Max_Index%"
goto :EOF

REM ============================================================================
:End
Popd
Endlocal
Exit /b
REM ============================================================================

:Help
@(
echo.
echo.     BatCenter - A Package manager for your Scripts. [v!_ver!]
echo.                    Batch-Man's plugin manager
echo.
echo.BatCenter helps you searching, downloading batch plugins/tools from the
echo.selected trusted sources. You can add your own trusted sources too.
echo.
echo.                         www.batch-man.com
echo.                                Syntax:
echo.bat update [GITHUB USER]
echo.bat list
echo.bat ilist
echo.bat search [Term1] [Term2] ...
echo.bat install [Local ID ^| [Term1] [Term2] ...]
echo.bat detail [Local ID ^| [Term1] [Term2] ...]
echo.bat reset [all]
echo.bat [help ^| /? ^| -h ^| -help ^| --help ^| /help]
echo.bat [ver ^| --ver ^| -v ^| /v ^| -ver ^| /ver]
echo.
echo.                               Where:
echo.ver			: Displays version of program
echo.help			: Displays help for the program
echo.update			: Updates the database from Trusted hosts
echo.list			: Lists all the plugins that can be installed
echo.ilist			: Lists all the installed plugins
echo.search			: Filters out plugins as per the given keywords
echo.install			: Downloads and installs the plugins
echo.detail			: Provides detail about the filtered project
echo.reset [all]		: Removes installed plugins ^| with [all] it uninstalls BatCenter
echo.
echo.                               Switches:
echo.-y ^| /y			: Suppresses prompting to confirm your action
echo.
echo.                               Examples:
echo.bat update
echo.bat update microsoft
echo.bat list
echo.bat search batbox 3.1
echo.bat install batbox 3.1
echo.bat install batbox 3.1 -y
echo.bat install 10
echo.bat install all
echo.bat detail batbox 3.1
echo.bat detail 10
echo.bat reset
echo.bat reset all
echo.bat ver
echo.bat /?
echo.
echo.           Required external tools: ^(list of dependencies^)
echo.7za.exe 			by 7z
echo.jq.exe 				by stedolan 
echo.Getlen.bat			by Kvc
echo.ReadLine.exe			by Kvc ^& anic17
echo.wget.exe			by Hrvoje
echo.
echo.                               Authors:
echo.Kvc: 				Main developer, maintainer
echo.anic17: 			Various improvements, maintainer
echo.GroophyLifeFor: 		Minor improvements, created the 5S utility
echo.
echo.                       Made by and for Batch-Man
echo.                   See more at https://batch-man.com
) > "conout$"
goto :End
