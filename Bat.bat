@echo off
setlocal EnableDelayedExpansion 

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
set _ver=20240209

REM Starting Main Program...
REM ============================================================================
:Main

REM Reading configuration file...
set _config=Bat.conf
for /f "tokens=*" %%A in ("!_config!") do (%%A)

REM Checking for the help menu...
REM Read more about '?' can't be escaped in FOR loop, so - checking for it seperately...
REM Source: https://superuser.com/questions/1576114/window-batch-escaping-special-characters-in-for-sentence 
If /i "%~1" == "/?" (Goto :Help)
for %%A in (!_helpOptions!) do (if /i "%~1"=="%%~A" (goto :help))
for %%A in (!_verOptions!) do (if /i "%~1"=="%%~A" (echo.!_ver!&goto :End))

REM Verifying the Required folder tree for files...
Call :VerifyAndFixBatCenterFiles

set "path=!path!;!_BatCenter!\Files;!_BatCenter!\plugins;!cd!\files"

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
	if /i "!_1!"=="%%~A" (
		call :%%~A
		set _Valid=True
	)
)
if /i "!_Valid!" == "False" (echo.Invalid parameter. Type 'bat /?' for help.)
goto :End

REM ============================ [UNINSTALL] ===================================
:Uninstall
REM set _Local_ID=!_1!
REM Generating a Temp File, for the list of installed plugins
REM if not exist "!_installedPluginsFile!" (echo.No plugins installed yet.&&goto :End)

REM set _Temp=0
REM for /f "usebackQ tokens=*" %%A in ("!_installedPluginsFile!") do (if /I "%%~A" == "!_Local_ID!" (set /A _Temp+=1))
echo.This feature will come soon.
goto :EOF

REM ============================ [FIRST LAUNCH] ================================
:FirstLaunch
Set _UserPath=

echo Setting up BatCenter...
rem Reading the current path variable value...
for /f "skip=2 tokens=1,2,*" %%A in ('reg query HKCU\Environment /v Path') do (Set "_UserPath=%%C")

@REM REM Adding BatCenter path to Environment variable...
Echo Adding BATCENTER to PATH...
rem adding environmental variable to be used later... and to keep length of Path variable limited...
rem Echo creating environmental variable... 'batcenter'...
rem Setx batcenter "!_BatCenter!"

Setx path "!_UserPath!!_BatCenter!\Files;!_BatCenter!\plugins;"
@REM reg add HKCU\Environment /v Path /d "!path!;!_BatCenter!;!_BatCenter!\Files;!_BatCenter!\plugins;" /f

echo Setup completed successfully
REM Updating the environment path, without restarting.... (Thanks @anic17)
gpupdate /force
call EnvUpdate.bat
Goto :EOF

REM ============================== [RESET] ====================================
:Reset
del /f /q "!_hostFile!"
for %%A in (!_FolderStructure!) do (if /i "%%~A" NEQ "Files" (rd /s /q "!_BatCenter!\%%~A" >nul 2>nul))
Echo. BatCenter is Reset to its Initial State...as a New Install!!
Echo. All Installed plugins/tools are removed...
goto :EOF

REM ============================ [RESET ALL] ==================================
:ResetAll
REM Removing BatCenter from Path...
set _NewPath=

REM Checking, if the Path already has path to BatCenter...
for /f "skip=2 tokens=1,2,*" %%A in ('reg query HKCU\Environment /v Path 2^>nul') do (Set "_UserPath=%%C")
echo !_UserPath! | find /i "batcenter" 2>nul >nul && (

	REM Thanks Bing-AI for the following trick so i can eliminate the use of dedicated
	REM dependenacy only for this task... (removed strsplit.exe)
	for %%A in ("!_UserPath:;=";"!") do (echo.%%~A | find /i "batcenter" >nul 2>nul || (set "_NewPath=!_NewPath!%%~A;"))
	
	set /p ".=Removing BatCenter from path... " <nul
   
	:checkLastchar
	rem it is noticed that sometimes, while removing batcenter from path
	rem it doens't remove extra semicolons from the path... 
	rem so, removing them in this loop...
	if /I "!_NewPath:~-1!" == ";" (
		set _NewPath=!_NewPath:~0,-1!
		goto :checkLastchar
	)

	REM Removing BatCenter path from Environment variable...
	@REM reg add HKCU\Environment /v Path /d "!_NewPath!" /f 2>nul >nul
	setx path "!_NewPath!"
)
rem creating another file... as a file can't remove itself...
echo.@timeout /t 3 >"!_resetFile!"
echo.@rd /s /q "!_BatCenter!" >>"!_resetFile!" 
echo.@exit >> "!_resetFile!"
start "Resetting batcenter" "!_resetFile!"
echo.done
goto :EOF

REM ============================== [iLIST] ====================================
:iList
if not exist "!_installedPluginsFile!" (
	dir /b "!_ZipsDir!\*.zip" > "!Temp!\List.txt" 2>nul
	if /i !Errorlevel! NEQ 0 (
		echo.No plugins installed yet.
		echo.If you have recently updated BatCenter, and it is not detecting
		echo.installed plugins from previous ver, it is recommended to 'reset'
		echo.your BatCenter installation and start fresh...
		echo.
		echo. Run "bat reset" ...
		goto :EOF
		)
	@rem del /q /f "!_pluginsDir!\*.*" >nul 2>nul
)

REM Tracking Number of installed Plugins in system...
set _Count=0
echo. ----------------------- Installed plugins ------------------------
if exist "!_installedPluginsFile!" (
for /f "usebackQ tokens=*" %%A in ("!_installedPluginsFile!") do (
	call :GetLocalID "%%~A" _Local_ID
	ReadLine "!_nameFile!" !_Local_ID!
	set /A _Count+=1
	)
)
if !_Count! == 0 (echo.No plugins installed yet.)
echo. ------------------------------------------------------------------
goto :EOF


:Detail
if /i "!_2!" == "" (echo.Missing search term. See 'bat /?'&& goto :End)
set _Local_ID=!_2!
call :check_Number "!_Local_ID!" _Error
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
			call :GetLocalID "!_Result[%%~A]!" _Local_ID
			call :FetchDetails !_Local_ID!
			)
		)
		goto :End
	)

	if !_RCount! EQU 0 (echo.No Result Found.&&goto :End)
	call :GetLocalID "!_Result[0]!" _Local_ID
)

REM echo !_Local_ID!
call :FetchDetails !_Local_ID!
goto :End

REM =============================[ INSTALL ]====================================
:Install
if /i "!_2!" == "" (echo.Missing search term. See 'bat /?' && goto :End)

set _Local_ID=!_2!
call :check_Number !_Local_ID! _IsNum

REM If the install parameter is not a number...
REM then, getting the index number of the given name...
if /i "!_IsNum!" NEQ "T" (
	call :Search _RCount _Result
	if !_RCount! GTR 1 (
		set /A _RCount-=1
		echo.Multiple results found for the install term.
		echo.refine the search term... 
		echo.Try running 'bat search [Term1] [Term2] [Term3] ...'
		echo.
		set _Temp=N

		if not defined _y (set /P "_Temp=See Details? [Y/N]:") else (set _Temp=Y)
		
		if /i "!_Temp!" == "Y" (
			for /L %%A in (0,1,!_RCount!) do (
				call :GetLocalID "!_Result[%%~A]!" _Local_ID
				call :FetchDetails !_Local_ID!
			)
		)
		goto :End
	)

	if !_RCount! EQU 0 (
		echo.No results found matching the install term.
		goto :End
	)
	call :GetLocalID "!_Result[0]!" _Local_ID
)

call :Get_Max_Index _Max_Index
if !_Local_ID! GTR !_Max_Index! (
	echo.The specified index ^(!_Local_ID!^) is greater than the plugin count ^(!_Max_Index!^)
	goto :End
)

call :GetGithubID !_Local_ID! _Github_ID
REM echo !_Local_ID!
call :FetchDetails !_Local_ID!
echo.Starting download...
call :Download !_Local_ID!
<nul set /p ".=Extracting plugin files... "

REM making sure that the temp folder is empty...
rd /s /q "!_BatCenter!\Temp" 2>nul >nul
if not exist "!_BatCenter!\Temp" (md "!_BatCenter!\Temp")

rem 7za l "!_BatCenter!\Zips\!_Github_ID!.zip" > nul 2>&1 
rem for /f "skip=13 tokens=5*" %%a in (' ^| findstr /c:"."') do (echo %%b)
7za e -y "!_BatCenter!\Zips\!_Github_ID!.zip" -o"!_BatCenter!\Temp" >nul 2>&1 && (echo.done) || (echo.failed && Goto :End)

rem the following is an experimental method... prepared by anic17 and kvc together,
rem it is to install a plugin, without messing up the remote folder structure...
rem I (kvc) has commented it for now, because i do not see its need right now...
rem i might be using it for making another sub-command for BatCenter...
rem
rem 7za x -y "!_BatCenter!\Zips\!_Github_ID!.zip" -o"!_BatCenter!\Temp" >nul 2>&1 && (echo.done) || (echo.failed && Goto :End)
REM getting the name of repo's root folder...
rem Set _RepoRootFolder=
rem for /f "tokens=*" %%A in ('dir /b /a:d "!_BatCenter!\Temp"') do (set "_RepoRootFolder=%%~A")

rem REM Installing the Repo, without affecting the repo folder structure...
rem pushd "!_BatCenter!\Temp\!_RepoRootFolder!"
rem for /f "tokens=*" %%A in ('dir /s /b /a:-d "*.exe" "*.bat" "*.cmd" "*.com"') do (
rem     echo.@echo off > "%%~nA.bat"
rem     echo.@setlocal EnableDelayedExpansion >> "%%~nA.bat"
rem 	 echo.@pushd "%%~dp0!_RepoRootFolder!" >> "%%~nA.bat"
rem     echo.@for /f "tokens=*" %%%%a in ^('dir /s /b /a:d'^) do ^(set PATH=%%%%a;^!PATH^!;^) >> "%%~nA.bat"
rem     echo."%%~nxA" %%* >> "%%~nA.bat"
rem 	 echo.popd >> "%%~nA.bat"
rem     echo.endlocal >> "%%~nA.bat"
rem    )
rem Popd
rem move /y "!_BatCenter!\Temp\!_RepoRootFolder!" "!_BatCenter!\plugins\"

move /y "!_BatCenter!\Temp\*" "!_BatCenter!\plugins" >nul 2>nul
echo.[DONE]

set /p ".=Updating the plugin database... "
call :Install_Tracking "!_Local_ID!"
echo.[DONE]
goto :End

REM ==========================[ INSTALL_TRACKING ]================================
:Install_Tracking
setlocal
set "_Local_ID=%~1"
call :GetGithubID !_Local_ID! _Github_ID

REM Verifying, if the plugin is already in the list of Installed plugins...
if exist "!_installedPluginsFile!" (
	set _Temp=0
	for /f "tokens=*" %%A in ('type "!_installedPluginsFile!"') do (if /i "%%~A" == "!_Github_ID!" (set /A _Temp+=1))
	if !_Temp! NEQ 0 (goto :EOF)
	)

REM Adding the ID of the Installed Plugin in INSTALLED PLUGINs list
echo.!_Github_ID!>> "!_installedPluginsFile!"

for /f "tokens=*" %%A in ('ReadLine "!_nameFile!" !_Local_ID!') do (
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

if exist "Temp\_!_Local_ID!.content" (del /f /q "Temp\_!_Local_ID!.content" >nul 2>nul)
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
			echo %%~nxf>>"Temp\_!_Local_ID!.content"
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
set _Local_ID=%~1
if /I "!_Local_ID!" == "" (goto :EOF)
call :GetGithubID !_Local_ID! _Github_ID

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
:GetLocalID [_Repo_Name_String_With_Index] [_VariableName]
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
:GetGithubID [_Local_ID] [_VariableName]
for /f "tokens=*" %%A in ('ReadLine "Index\id.index" %~1') do (set "%~2=%%~A")
goto :EOF

REM ============================================================================
:FetchDetails [Local_ID]
set _Local_ID=%~1
if not defined _Local_ID (goto :EOF)

REM Checking the max number of the plugins available
call :Get_Max_Index _Max_Index
if !_Local_ID! GTR !_Max_Index! (echo.The specified index ^(!_Local_ID!^) is greater than the plugin count ^(!_Max_Index!^) && goto:EOF)
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
	ReadLine "Index\%%~A.index" !_Local_ID! > "!Temp!\tmp.temp"
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
echo. Local-ID:		!_Local_ID!
echo. Github-ID:		!_RepoID!
echo. Created:		!_RepoInit:~1,10!
echo. Updated-On:		!_RepoUpdate:~1,10!
echo. Branch:		!_RepoBranch:"=!
echo. License:		!_RepoLicense:"=!
echo. Size:			!_RepoSize! KBs
echo. Description:		!_RepoDes!
echo. Link:			!_RepoLink:"=!
echo. --------------------------------------------------------------------
if /i "!_1!" == "Detail" (echo.Install it with: "bat install !_Local_ID!")
chcp !codepage! > nul
goto :End

REM ============================[ CHECK_NUMBER ]================================
:check_Number [%1 = String to Check] [%2 = True or False]
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
IF EXIST "!Temp!\UpdateBat.bat" (del /f /q "!Temp!\UpdateBat.bat" >nul 2>nul)

wget -qO- "https://raw.githubusercontent.com/Batch-Man/BatCenter/main/Bat.bat" | find /i "set _ver=" > "!Temp!\_Ver.txt"
for /f "eol=w usebackq tokens=1,2* delims==" %%a in ("!Temp!\_Ver.txt") do (if not defined _online_ver (set "_online_ver=%%~b"))

REM Creating a backup of number...
set _Temp_ver=!_ver!
set _Temp_online_ver=!_online_ver!

REM Comparing the versions...
set _ver=!_ver:.=!
set _online_ver=!_online_ver:.=!
if !_online_ver! GTR !_ver! (
    echo.----------------------------------------------------------------------------
    echo. BatCenter update available [Current: !_Temp_ver!, New: !_Temp_online_ver!]
    echo.----------------------------------------------------------------------------
    echo.
    wget "https://github.com/Batch-Man/BatCenter/archive/main.zip" -O "!_BatCenter!\Zips\BatCenter.zip" -q --tries=5 --show-progress --timeout=5
    REM Creating a separate batch-file, as script overwriting  itself can lead to malfunctioning...
    (
        echo @echo off 
        echo setlocal EnableDelayedExpansion
        echo @title Updating BatCenter...
        echo @echo.Extracting files...
        echo @7za e -y "!_BatCenter!\Zips\BatCenter.zip" 2^>nul ^>nul
        echo @echo.Extraction complete.
        echo @Echo Removing Empty Folders...
        echo @for /f "tokens=*" %%%%A in ^('dir /b /a:d'^) do ^(Rd /S /Q "%%%%~A" ^>nul 2^>nul ^)
        echo @del /f /q "!_BatCenter!\Zips\BatCenter.zip"
        echo @echo.Done
        echo exit /b
	 ) >"!Temp!\UpdateBat.bat"
	 set _UpdateBat=True
)

REM Removing Older Index Files...
del /f /q "!_BatCenter!\Index\*.*" >nul 2>nul
del /f /q "!_hostFile!" >nul 2>nul

REM Need to check, if the Basic Json files are present...Otherwise, we'll update!
if not exist "!_hostFile!" (Wget "https://raw.githubusercontent.com/Batch-Man/BatCenter/main/Install/hosts.txt" -O "!_hostFile!" -q --tries=5 --show-progress --timeout=5)

if /i "!_2!" NEQ "" (find /i "!_2!" "!_hostFile!" >nul 2>nul && (echo. Already in DB...) || (echo.!_2!>>"!_hostFile!"))

REM Getting Json files of each host...
for /f "usebackq tokens=*" %%a in ("!_hostFile!") do (
	wget "https://api.github.com/users/%%a/repos?per_page=100000&page=1" -O "!_BatCenter!\Json\%%a.json" -q --tries=5 --show-progress --timeout=5

	REM Indexing Details...
	for %%A in (!_IndexFiles!) do (type "!_BatCenter!\Json\%%a.json" | jq ".[] .%%~A" >> "!_BatCenter!\Index\%%~A.index")
	)

REM Setting _Count to '0' (Preventing mixing-up of numbers after "Bat Update")
set _Count=0

REM Indexing the main name.json file... 
del /f /q "!Temp!\Tmp.index" >nul 2>nul
for /f "usebackQ tokens=*" %%A in ("!_nameFile!") do (
	set /A _Count+=1
	set _Temp_Line=%%~A
	if defined _Temp_Line (echo.[!_Count!]-!_Temp_Line:-= !>>"!Temp!\Tmp.index")
	)

copy /y "!Temp!\Tmp.index" "!_nameFile!" >nul 2>nul
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
Goto :End

REM ============================================================================
:CheckConnection
set /p ".=Checking internet connection..." <nul
wget --server-response --spider --quiet "https://github.com" >nul 2>nul&& (echo. [OK]&&set "_Return=0") || (echo. [Failed]&&set "_Return=1")
REM curl -s "www.github.com" >nul 2>nul&& (echo. [OK]&&set "_Return=0") || (echo Failed to connect to the internet&&set "_Return=1")
If /i "%~1" NEQ "" (set %~1=!_Return!)
Exit /b !_Return!

:VerifyAndFixBatCenterFiles
IF NOT EXIST "!_BatCenter!" (MD "!_BatCenter!")

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
if not exist "!_nameFile!" (echo.No index file. Please run 'bat update' command.&&goto :End)
type "!_nameFile!"
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
copy /y "!_nameFile!" "%Temp%\tmp.index" >nul 2>nul
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
	for /F "usebackq tokens=*" %%A in ("!_nameFile!") do (set /A _Max_Index+=1)
	echo.!_Max_Index!>"Files\_Max_Index.count"
	)
Endlocal && set "%~1=%_Max_Index%"
goto :EOF

REM ==================================== [End] =================================
:End
Endlocal
Exit /b
REM ============================================================================

:Help
@(
echo.============================================================================
echo.     BatCenter - A Package manager for your Scripts. [v!_ver!]
echo.                    Batch-Man's plugin manager
echo.============================================================================
echo.BatCenter helps you searching, downloading batch plugins/tools from the
echo.selected trusted sources. You can add your own trusted sources too.
echo.
echo.                         www.batch-man.com
echo.----------------------------------------------------------------------------
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
echo.----------------------------------------------------------------------------
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
echo.----------------------------------------------------------------------------
echo.                               Examples:
echo.----------------------------------------------------------------------------
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
echo.============================================================================
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
