@Echo off
Setlocal EnableDelayedExpansion

Set "_path=%LocalAppData%\BatCenter"
Set "Original_Path=%path%"
If Not exist "%_path%" (Md "%_path%"&Echo.First Launch >"%_path%\FirstLaunch.txt")

REM THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY
REM KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
REM WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
REM AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
REM HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
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
REM For More Visit: www.batch-man.com


REM Setting version information...
Set _ver=2.5


REM Checking for various parameters of the function...
If /i "%~1" == "/?" (goto :help)
If /i "%~1" == "-h" (goto :help)
If /i "%~1" == "-help" (goto :help)
If /i "%~1" == "help" (goto :help)
If /i "%~1" == "ver" (
%_ver%&Goto :End)
If /i "%~1" == "" (goto :help)

REM Saving parameters to variables...
Set _1=%~1
Set _2=%~2
Set _3=%~3
Set _4=%~4
Set _5=%~5
Set _6=%~6
Set _7=%~7
Set _8=%~8
Set _9=%~9

REM Starting Main Program...
REM ============================================================================
:Main

REM Verifying the Required folder tree for files...
For %%A in ("Json" "plugins" "Files" "Index" "Zips" "Temp") do (If Not Exist "!_path!\%%~A" (MD "!_path!\%%~A"))
if /i "%_1%" NEQ "Update" (For %%A in ("name" "full_name" "default_branch" "license.name" "size" "description" "owner.login" "owner.avatar_url" "svn_url" "created_at" "updated_at" "id") do (If not Exist "!_path!\Index\%%~A.index" (Echo.^>^>Please Run 'Bat Update' before you do anything^^!^<^<&&Goto :End)))


Set "path=%path%;%_path%;%_path%\Files;%_path%\plugins;%cd%;%cd%\files"
CD /d "%_path%"

If exist "FirstLaunch.txt" (
	Echo Setting up Bat-Center by Kvc...
	Del /F /q "FirstLaunch.txt" >nul 2>nul
	Call :Update
	Set _Found=

	REM Reading Path of Current User...
	for /f "skip=2 tokens=1,2,*" %%a in ('reg query HKCU\Environment /v path') do (Set "_UserPath=%%c")

	REM Checking, if the Path already has path to Bat
	for /f "tokens=*" %%A in ('StrSplit ^; "!_UserPath!"') do (
		if /i "%%~A" EQU "!_path!" (Set _Found=Found)
		)
	If Not Defined _Found (	
		REM Adding BatCenter path to Environment variable...
		reg add HKCU\Environment /v Path /d "!_UserPath!;!_path!;!_path!\Files;!_path!\plugins" /f
		)
	Echo Setup Completed Successfully!
	REM Updating the environment path, without restarting.... (Thanks anic17)
	Call EnvUpdate.bat
	if /i "%_1%" == "Update" (Goto :End)
	)

REM Removing any background image...
REM Cmdbkg

REM Checking if the '-y' is provided in parameters...
Set _y=
For /l %%A in (1,1,9) do (
	If /i "!_%%~A!" == "-y" (Set _y=True&&Shift /%%~A)
	If /i "!_%%~A!" == "/y" (Set _y=True&&Shift /%%~A)
	)

REM Resetting Vairables as per parameters...
If /i "!_y!" == "True" (
REM Saving parameters to variables...
	Set _1=%~1
	Set _2=%~2
	Set _3=%~3
	Set _4=%~4
	Set _5=%~5
	Set _6=%~6
	Set _7=%~7
	Set _8=%~8
	Set _9=%~9
)

REM Acting as per the Passed parameters...

if /i "%_1%" == "Update" (Call :Update)
if /i "%_1%" == "ilist" (Call :Installed_List)
if /i "%_1%" == "list" (Call :List)
if /i "%_1%" == "search" (Call :Search)
if /i "%_1%" == "install" (Call :Install)
if /i "%_1%" == "uninstall" (Call :Uninstall)
if /i "%_1%" == "detail" (Call :Details)
if /i "%_1%" == "reset" (If /I "%_2%" == "all" (Call :ResetAll) ELSE (Call :Reset))

REM Echo. Invalid Parameter...
REM ECHO. TRY using 'Bat /?' for help!
REM Space for the new future options :]
REM BUFFER FOR FUTURE UPDATES...
REM BUFFER FOR FUTURE UPDATES...
REM BUFFER FOR FUTURE UPDATES...
REM BUFFER FOR FUTURE UPDATES...
REM BUFFER FOR FUTURE UPDATES...
Goto :End

REM ============================================================================

:Uninstall
REM Set _Index_Number=%_1%
REM Generating a Temp File, for the list of installed plugins
REM IF NOT Exist "Temp\_Plugins.installed" (Echo. NOTHING Is Installed Yet^^!&&Goto :End)

REM Set _Temp=0
REM For /f "usebackQ tokens=*" %%A in ("Temp\_Plugins.installed") do (If /I "%%~A" == "!_Index_Number!" (Set /A _Temp+=1))
Echo. This feature will come soon...
Goto :EOF

:Reset
Del /f /q "hosts.txt" 
Del /f /q "Plugins\*.*"
Del /f /q "Index\*.*"
Del /f /q "Json\*.*"
Del /f /q "Zips\*.*"
Del /f /q "Temp\*.*"
Call :update
Goto :EOF

:ResetAll
REM Removing BatCenter from Path...
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
Cd/ 2>nul 2>&1 >nul 
RD /S /Q "!_path!" 2>nul 2>&1 >nul 
Echo.[Done]
Exit /b
Goto :EOF

:Installed_List
If NOT Exist "Temp\_Plugins.installed" (
	Dir /b "Zips\*.zip" > "!Temp!\List.txt" 2>nul
	If /i !Errorlevel! NEQ 0 (Echo. NOTHING is INSTALLED YET^^! && Goto :EOF)

	Del /q /f "plugins\*.*" >nul 2>nul

	REM Checking, if fixing of older batcenter SYSTEM is needed...
	Set _Temp=0
	For /f "tokens=* delims=." %%A in ('Dir /b "Zips\*.zip"') do (If %%~nA LSS 100000 (Set /A _Temp+=1))
	if !_Temp! GTR 0 (
		If Exist "Index\id.index" (Del /f /q "Index\id.index" >nul 2>nul)

		REM Getting Json files of each host...
		For /f "tokens=*" %%a in (hosts.txt) do (For %%A in ("id") do (Type "Json\%%a.json" | jq ".[] .%%~A" >> "Index\%%~A.index"))

		For /f "tokens=1,2* delims=." %%A in ('Dir /b "Zips\*.zip"') do (
			For /f "tokens=*" %%a in ('ReadLine "Index\id.index" %%~nA') do (Set "_GID=%%~a")

			Ren "Zips\%%~nA.zip" "!_GID!.zip" 2>nul >nul
			)
		)

	For /f "tokens=1,2* delims=." %%A in ('Dir /b "Zips\*.zip"') do (
		REM Checking if the name of the file is - Numeric or alphabet
		Set /A _Temp=%%~nA / 1

		IF /i "!_Temp!" NEQ "0" (
			Call :GetLocalID "%%~nA" _Index_Number
			Call :Install_Tracking !_Index_Number!
			pushd plugins
			7za e -y "..\Zips\%%~nA.zip" >nul
			REM Removing Empty Folders...
			For /f "tokens=*" %%a in ('dir /b /a:d') do (Rd /S /Q "%%~a")
			Popd
			)
		)
	)

REM Tracking Number of installed Plugins in system...
Set _Count=0
Echo. ----------------------- Installed Plugins ------------------------
If Exist "Temp\_Plugins.installed" (
For /f "usebackQ tokens=*" %%A in ("Temp\_Plugins.installed") do (
	Call :GetLocalID %%~A _Index_Number
	ReadLine "Index\name.index" !_Index_Number!
	Set /A _Count+=1
	)
)
If !_Count! == 0 (Echo. NOTHING is INSTALLED YET^^!)
Echo. ------------------------------------------------------------------
Goto :EOF


:Details
If /i "%_2%" == "" (Echo. Search Term Missing... && Goto :End)
Set _Index_Number=!_2!
Call :check_Number !_2! _Error
IF /i "!_Error!" NEQ "T" (
	call :Search _RCount _Result
	if !_RCount! GTR 1 (
		Set /A _RCount-=1
		Echo. MULTIPLE RESULTS FOUND!
		Echo. Please Refine your Search...
		Echo. TRY: Bat Search [Term1] [Term2] ...
		Echo.
		Set _Temp=N
		if Not Defined _y (Set /P "_Temp=See Details? [Y/N]:") ELSE (Set _Temp=Y)
		If /I "!_Temp!" == "Y" (
		For /L %%A in (0,1,!_RCount!) do (
			Call :GetIndexNumber "!_Result[%%~A]!" _Index_Number
			Call :FetchDetails !_Index_Number!
			)
		)
		Goto :End
	)

	if !_RCount! EQU 0 (
		Echo. NO RESULTS FOUND!
		Echo. Please Refine your Search...
		Echo. TRY: Bat Search [Term1] [Term2] ...
		Goto :End
	)
	Call :GetIndexNumber "!_Result[0]!" _Index_Number
)

REM Echo !_Index_Number!
Call :FetchDetails !_Index_Number!
Goto :End

REM ============================================================================
:Install
REM Looking for the Searched term and returning the Value in _Result variable.
REM Saving the values of results in an array kind of structure...
REM E.g: _Result[0], _Result[1] ...
REM Where, _RCount contains the number of results and _Result is the array name
If /i "%_2%" == "" (Echo. Search Term Missing... && Goto :End)
Set _Index_Number=!_2!
Call :check_Number !_2! _Error
IF /i "!_Error!" NEQ "T" (
	call :Search _RCount _Result
	if !_RCount! GTR 1 (
		Set /A _RCount-=1
		Echo. MULTIPLE RESULTS FOUND!
		Echo. Please Refine your Search...
		Echo. TRY: Bat Search [Term1] [Term2] ...
		Echo.
		Set _Temp=N
		if Not Defined _y (Set /P "_Temp=See Details? [Y/N]:") ELSE (Set _Temp=Y)
		If /I "!_Temp!" == "Y" (
		For /L %%A in (0,1,!_RCount!) do (
			Call :GetIndexNumber "!_Result[%%~A]!" _Index_Number
			Call :FetchDetails !_Index_Number!
			)
		)
		Goto :End
	)

	if !_RCount! EQU 0 (
		Echo. NO RESULTS FOUND!
		Echo. Please Refine your Search...
		Echo. TRY: Bat Search [Term1] [Term2] ...
		Goto :End
	)
	Call :GetIndexNumber "!_Result[0]!" _Index_Number
)

Call :Get_Max_Index _Max_Index
If !_Index_Number! GTR !_Max_Index! (Echo. Index is more than available List.&&Goto:End)

call :GetGithubID !_Index_Number! _Github_ID

REM Echo !_Index_Number!
Call :FetchDetails !_Index_Number!
Echo. Initiating Download...
Call :Download !_Index_Number!
Echo. Repository DOWNLOADED!
Echo. Extracting... to '%_path%\Plugins'
Pushd Plugins
Echo.
7za l "..\Zips\!_Github_ID!.zip" > nul 2>&1
rem for /f "skip=13 tokens=5*" %%a in (' ^| findstr /c:"."') do (echo %%b)
7za e -y "..\Zips\!_Github_ID!.zip" >nul
REM Removing Empty Folders...
For /f "tokens=*" %%A in ('dir /b /a:d') do (Rd /S /Q "%%~A")
Popd
Echo. Extracted...!
Echo. UPDATING DATABASE...
Call :Install_Tracking "!_Index_Number!"
Echo. UPDATED^^!
goto :End

:Install_Tracking
SetLocal
Set "_Index_Number=%~1"
Call :GetGithubID !_Index_Number! _Github_ID

REM Verifying, if the plugin is already in the list of Installed plugins...
IF exist "Temp\_Plugins.installed" (
	Set _Temp=0
	for /f "tokens=*" %%A in ('type "Temp\_Plugins.installed"') do (if /i "%%~A" == "!_Github_ID!" (Set /A _Temp+=1))
	If !_Temp! NEQ 0 (Goto :EOF)
	)

REM Adding the ID of the Installed Plugin in INSTALLED PLUGINs list
Echo.!_Github_ID!>> "Temp\_Plugins.installed"

For /f "tokens=*" %%A in ('ReadLine "Index\name.index" !_Index_Number!') do (Echo. REGISTERING Plugin... %%~A)

REM As, Registering a plugin takes some time ... I want to show some progress alognside...
REM For the Sake of Real-Time Showing Progress...
Set /A _Count=0
Set _Temp_Count=0
Set _BarLength=75
for /f "skip=16 tokens=1,2,3,4,5,*" %%a in ('7za l "Zips\!_Github_ID!.zip"') do (Set /a _Count+=1)

REM Checking Current CMD Size...
Call GetDim _Rows _Columns
Set /A _BarLength=!_Columns! - 5

REM Keeping names of all files those are Installed...

REM As All plugins are being extracted in one path, so multiple files/dependency files can be overwritten
REM while installing a plugin. Which is not a problem - but, while UNINSTALLING the plugin it can cause 
REM problems.

REM Here - I am Checking to see.. if any file is IMMUNE to 'install & uninstall' process of plugins
REM In other words, If a single file is being used by multiple Plugins, then it must be marked as IMMUNE
REM So, when user uninstalls a plugin from system - He/she would not want to accidently make other plugins
REM DEAD/Unfunctional because of the one dependency. (e.g: batbox.exe is used by many batch plugins)

If Exist "Temp\_!_Index_Number!.content" (Del /f /q "Temp\_!_Index_Number!.content" >nul 2>nul)
for /f "skip=16 tokens=1,2,3,4,5,*" %%a in ('7za l "Zips\!_Github_ID!.zip"') do (
	REM Just simple calculation for showing current progress on console screen...
	Set /A _Temp_Count+=1
	Call Progress !_BarLength! !_Temp_Count! !_Count!

	REM Checking, if the current thing is file or a folder...
	Set "_Temp=%%~c"
	
	Set _Dot=F
	REM Check, if there is any '.' in the _Temp... (So, that we can consider the line to be processed)
	If /i "!_Temp!" NEQ "!_Temp:.=_!" (Set _Dot=T) ELSE (Set _Dot=F)
	
	if /i "!_Dot!" == "T" (
		REM Checking for the character 'D' to be present in the ATTRIBUTES...
		Set _Folder=T
		If /i "!_Temp!" NEQ "!_Temp:D=_!" (Set _Folder=T) ELSE (Set _Folder=F)
		if /i "!_Folder!" == "F" (
			Echo %%~nxf>>"Temp\_!_Index_Number!.content"
			REM Checking if the file is IMMUNE or NOT
			If Exist "plugins\%%~nxf" (
				REM Checking if the IMMUNE file is already in the DB List or NOT
				Set _Temp=0
				If Exist "Temp\_Immune.installed" (For /f "tokens=*" %%A in ('type "Temp\_Immune.installed"') do (If /I "%%~A" == "%%~nxf" (Set /A _Temp+=1)))
				If !_Temp! == 0 (Echo.%%~nxf>>"Temp\_Immune.installed")
				)
			)
		)
	)
Endlocal
Goto :EOF


REM ============================================================================
:Download
Set _Index_Number=%~1
If /I "!_Index_Number!" == "" (Goto :EOF)
Call :GetGithubID !_Index_Number! _Github_ID

REM Downloading the required Repository...
If not Exist "Zips\!_Github_ID!.zip" (
	Wget "https://github.com/!_RepoFullName:"=!/archive/!_RepoBranch:"=!.zip" -O "Zips\!_Github_ID!.zip" -q --tries=5 --show-progress --timeout=5
	) ELSE (
	Echo. Already Installed...!
	Echo. Do You want to ReDownlaod '!_RepoName:~1!' ?
	Set _Temp=N
	if Not Defined _y (Set /P "_Temp=[Y or N] [Default:N] ") ELSE (Set _Temp=y)
	if /i "!_Temp!" == "y" (Wget "https://github.com/!_RepoFullName:"=!/archive/!_RepoBranch:"=!.zip" -O "Zips\!_Github_ID!.zip" -q --tries=5 --show-progress --timeout=5)
	)
Goto :EOF

REM ============================================================================
:GetIndexNumber
Set _TempString=%~1
StrSurr [] "!_TempString!" > "!Temp!\Tmp.tmp"
Set /P %~2= < "!Temp!\Tmp.tmp"
Goto :EOF

REM ============================================================================
:GetLocalID [_Github_ID] [_VariableName]
Set _GID=%~1
Set %~2=
For /f "eol=- skip=2 tokens=1,2* delims=]" %%A in ('find /i /n "!_GID!" "Index\id.index"') do (Set "_Result=%%~A")
Set "%~2=!_Result:~1!"
Goto :EOF

REM ============================================================================
:GetGithubID [_Index_Number] [_VariableName]
For /f "tokens=*" %%A in ('ReadLine "Index\id.index" %~1') do (Set "%~2=%%~A")
Goto :EOF

REM ============================================================================
:FetchDetails
Set _Index_Number=%~1
IF Not Defined _Index_Number (Goto :EOF)

REM Checking the max number of the plugins available
Call :Get_Max_Index _Max_Index
If !_Index_Number! GTR !_Max_Index! (Echo. Index is more than available List.&&Goto:EOF)
for /f "tokens=2 delims=:" %%A in ('chcp') do set "codepage=%%A"
chcp 65001 > nul

REM Fetching Details of Selected Repo...
For %%A in ("name" "full_name" "default_branch" "license.name" "size" "description" "owner.login" "owner.avatar_url" "svn_url" "created_at" "updated_at" "id") do (
	If /i "%%~A" == "name" (Set _var=_RepoName)
	If /i "%%~A" == "full_name" (Set _var=_RepoFullName)
	If /i "%%~A" == "default_branch" (Set _var=_RepoBranch)
	If /i "%%~A" == "license.name" (Set _var=_RepoLicense)
	If /i "%%~A" == "size" (Set _var=_RepoSize)
	If /i "%%~A" == "description" (Set "_var=_RepoDes")
	If /i "%%~A" == "owner.login" (Set _var=_RepoOwner)
	If /i "%%~A" == "owner.avatar_url" (Set _var=_RepoAvatarURL)
	If /i "%%~A" == "svn_url" (Set _var=_RepoLink)
	If /i "%%~A" == "created_at" (Set _var=_RepoInit)
	If /i "%%~A" == "updated_at" (Set _var=_RepoUpdate)
	If /i "%%~A" == "id" (Set _var=_RepoID)
	ReadLine "Index\%%~A.index" !_Index_Number! > "!Temp!\tmp.temp"
	Set /P !_var!= < "!Temp!\tmp.temp"
	)

REM Fixing a bug...
Set _RepoOwner=!_RepoOwner:"=!
Set _RepoLink=!_RepoLink:~9!

Set _RepoDes=!_RepoDes:"=!

REM If NOT Exist "Files\!_RepoOwner!.bmp" (
REM 	Del /f /q "!Temp!\Tmp.Temp" >nul 2>nul
REM 	Echo. Loading...
REM 	wget "!_RepoAvatarURL:"=!" -O "!Temp!\!_RepoOwner!.png" -q
REM 	Iconvert "!Temp!\!_RepoOwner!.png" "Files\!_RepoOwner!.bmp" >nul
REM 	)

REM Cmdbkg "Files\!_RepoOwner!.bmp"

REM Fixing RepoName...
For /f "tokens=1,2* delims=-" %%A in ("!_RepoName!") do (Set _RepoName=%%~B)

REM Checking length of the Description...
Call Getlen "!_RepoDes!"
Set _Len=!Errorlevel!

If !_Len! GEQ 50 (Set _RepoDes=!_RepoDes:~0,50!...)

Echo. --------------------------------------------------------------------
Echo. Name:			!_RepoName:~1!
Echo. Owner:			!_RepoOwner!
Echo. Local-ID:		!_Index_Number!
Echo. Github-ID:		!_RepoID!
Echo. Created:		!_RepoInit:~1,10!
Echo. Updated-On:		!_RepoUpdate:~1,10!
Echo. Branch:		!_RepoBranch:"=!
Echo. License:		!_RepoLicense:"=!
Echo. Size:			!_RepoSize! KBs
Echo. Description:		!_RepoDes!
Echo. Link:			!_RepoLink:"=!
Echo. --------------------------------------------------------------------
chcp %codepage% > nul
If /i "%_1%" == "Detail" (Echo. INSTALL THIS WITH: "bat install !_Index_Number!")
REM Echo @timeout /t 5 ^>nul >"%Temp%\effect1.bat"
REM Echo @cmdbkg >>"%Temp%\effect1.bat"
REM Echo @exit >>"%Temp%\effect1.bat"
REM start /b "" "%Temp%\effect1.bat"
Goto :End

REM ============================================================================
:check_Number
Set _Number=%~1
For /L %%A in (0,1,9) do (If Defined _Number (Set _Number=!_Number:%%~A=!))
If Not Defined _Number (Set %~2=T) ELSE (Set %~2=F)
Exit /b


REM ============================================================================
:Update
Call :CheckConnection _Error
If %_Error% NEQ 0 (Goto :End)

REM Checking for Limited API calls condition...
If exist "Files\BlockUpdate.txt" (Echo.UPDATE BLOCKED! TRY AFTER SOMETIME...&&Echo.Limiting API calls only 180 times/hour && Goto :End)

REM Checking for BatCenter Update...
Set _UpdateBat=
Set _online_ver=
wget -qO- "https://raw.githubusercontent.com/Batch-Man/BatCenter/main/Bat.bat" | find /i "Set _ver=" > "!Temp!\_Ver.txt"
for /f "eol=w usebackq tokens=1,2* delims==" %%a in ("!Temp!\_Ver.txt") do (If Not Defined _online_ver (Set "_online_ver=%%~b"))

REM Creating a backup of number...
set _Temp_ver=!_ver!
set _Temp_online_ver=!_online_ver!

REM Comparing the versions...
Set _ver=!_ver:.=!
Set _online_ver=!_online_ver:.=!
If !_online_ver! GTR !_ver! (
	Echo. --------------------------------------------------------------------------
    Echo. A NEW VERSION OF BATCENTER IS AVAILABLE... [Current: !_Temp_ver!, New: !_Temp_online_ver!]
	Echo. --------------------------------------------------------------------------
	Echo.
    Wget "https://github.com/Batch-Man/BatCenter/archive/main.zip" -O "Zips\BatCenter.zip" -q --tries=5 --show-progress --timeout=5
    	REM Creating a separate batch-file, as script overwriting  itself can lead to malfunctioning...
   	(
	Echo @Echo off
	Echo SetLocal EnableDelayedExpansion
    Echo Title Updating BatCenter...
    Echo cls
    Echo Echo. Extracting... to 'PATH'
    Echo Pushd files
    Echo 7za e -y "!_path!\Zips\BatCenter.zip"
    Echo REM Removing Empty Folders...
    Echo For /f "tokens=*" %%%%A in ^('dir /b /a:d'^) do ^(Rd /S /Q "%%%%~A"^)
    Echo Popd
    Echo Echo. Extracted...
	Echo REM Adjusting and transferring all files to new path...
	Echo If Exist "%SystemDrive%\system\Bat\hosts.txt" ^(Start "" /SHARED /WAIT /B Transfer.bat^)
	Echo Echo. REMOVING JUNK!
	Echo Del /f /q "!_path!\Zips\BatCenter.zip" 
	Echo Pause
	) >"!Temp!\UpdateBat.bat"
	Set _UpdateBat=True
)

REM Removing Older Index Files...
Del /f /q "Index\*.*" >nul 2>nul

REM Need to check, if the Basic Json files are present...Otherwise, we'll update!
If Not Exist "hosts.txt" (Wget "www.batch-man.com/bat/hosts.txt" -O "hosts.txt" -q --tries=5 --show-progress --timeout=5) Else (If /i "%_2%" NEQ "" (find /i "%_2%" "hosts.txt" >nul 2>nul && Echo. Already in DB... || (Echo.>>hosts.txt&Echo.%_2%>>hosts.txt)))

REM Getting Json files of each host...
For /f "tokens=*" %%a in (hosts.txt) do (
	wget "https://api.github.com/users/%%a/repos?per_page=100000&page=1" -O "Json\%%a.json" -q --tries=5 --show-progress --timeout=5

	REM Indexing Details...
	For %%A in ("name" "full_name" "default_branch" "license.name" "size" "description" "owner.login" "owner.avatar_url" "svn_url" "created_at" "updated_at" "id") do (Type "Json\%%a.json" | jq ".[] .%%~A" >> "Index\%%~A.index")
	)

REM Setting _Count to '0' (Preventing mixing-up of numbers after "Bat Update")
Set _Count=0

REM Indexing the main name.json file...
Del /f /q "%Temp%\Tmp.index" >nul 2>nul
For /f "usebackQ tokens=*" %%A in ("Index\name.index") do (
	Set /A _Count+=1
	Set _Temp_Line=%%~A
	if Defined _Temp_Line (Echo.[!_Count!] - !_Temp_Line:-= !>>"!Temp!\Tmp.index")
	)

Copy /y "%Temp%\Tmp.index" "Index\name.index" >nul 2>nul
REM Keeping an eye on the Max Number of Plugins available...
Set _Max_Index=!_Count!
Echo.!_Max_Index!>"files\_Max_Index.Count"

Echo. UPDATED DATABASE...!
REM LIMITING ACCESS TO API ONLY 180 TIMES/H (Thanks to @anic17 for Idea to improve)
If not exist "Files\_APIAccessTime.txt" (
	REM Recording the Time of Usage for UPDATE COMMAND with BATCenter
	Set _TempTime=!Time:~0,-6!
	Set _TempTime=!_TempTime::=!
	Echo.!_TempTime! > "Files\_APIAccessTime.txt"
	Echo 1 > "Files\_APIAccessCount.txt"
	Del /f /q "Files\BlockUpdate.txt" >nul 2>nul
	) ELSE (
	Set _TempTime=!Time:~0,-6!
	Set _TempTime=!_TempTime::=!
	Set /P _OldTime= < "Files\_APIAccessTime.txt"
	Set /A _TimeDifference=!_TempTime!-!_OldTime!
	Set _TimeDifference=!_TimeDifference:-=!

	If !_TimeDifference! GTR 59 (Del /f /q "Files\_APIAccessTime.txt")
	Set /p _TempCount= < "Files\_APIAccessCount.txt"
	Set /A _TempCount+=1
	Echo !_TempCount! > "Files\_APIAccessCount.txt"
	IF !_TempCount! GEQ 180 (Echo.This file limits API calls...>"Files\BlockUpdate.txt")
	)
REM Updating BatCenter in case, if there is an update...
If Defined _UpdateBat (Start "" /SHARED /WAIT /B "!Temp!\UpdateBat.bat")

REM Adjusting and transferring all files to new path...
If Exist "%SystemDrive%\system\Bat\hosts.txt" (Start "" /SHARED /WAIT /B Transfer.bat && Echo. >"FirstLaunch.txt")
Exit /b 0

REM ============================================================================
:CheckConnection
Set /p ".=Checking internet connection..." <nul
wget --server-response --spider --quiet "https://google.com" >nul 2>nul&& (Echo.[OK]&&Set "_Return=0") || (Echo.[FAILED]&&Echo No Internet Connection&&Set "_Return=1")
Set %~1=%_Return%
Exit /b %_Return%


REM ============================================================================
:List
Set _Count=0
If Not Exist "Index\name.index" (Echo. Please Run 'Bat update' command first...&&Goto :End)
Type "Index\name.index"
goto :End

REM ============================================================================
:Search
Set "_RCount=%~1"
Set "_Return=%~2"
If /i "%_2%" == "" (Echo. Search Term Missing... && Goto :End)

REM Parameter handling...
Set _Count=2

REM Copying index file for later refined search...
REM Copy /y "Index\full_name.index" "%Temp%\tmp.index" >nul 2>nul
Copy /y "Index\name.index" "%Temp%\tmp.index" >nul 2>nul
:SearchLoop
If /i "!_%_Count%!" == "" (Goto :SearchNext)
Find /i "!_%_Count%!" "%Temp%\tmp.index" > "%Temp%\tmp2.index"
Copy /y "%Temp%\tmp2.index" "%Temp%\tmp.index" >nul 2>nul
Set /A _Count+=1
Goto :SearchLoop

:SearchNext
REM Printing all the results... Skipping lines starting with '-' becuase of Find 
REM command.
Set _TempCount=0
For /f "eol=- skip=2 tokens=*" %%A in ('Type "!Temp!\tmp.index"') do (
	If /i "!_Return!" == "" (Echo.%%~A) ELSE (Set "!_Return![!_TempCount!]=%%~A")
	Set /A _TempCount+=1
	)
If Defined _RCount (Set !_RCount!=!_TempCount!)
Goto :End

:Get_Max_Index [%~1 = Variable to return the value of max-index of the list of plugins...]
SetLocal
REM Checking the max number of the plugins available
If Exist "Files\_Max_Index.count" (Set /p _Max_Index=<"Files\_Max_Index.count") ELSE (
	Set _Max_Index=0
	For /F "usebackq tokens=*" %%A in ("Index\name.index") do (Set /A _Max_Index+=1)
	Echo.!_Max_Index!>"Files\_Max_Index.count"
	)
Endlocal && Set "%~1=%_Max_Index%"
Goto :EOF


REM ============================================================================
:End
Endlocal
Exit /b
REM ============================================================================

:Help
Echo.
Echo. This program will help you download the batch plugins from selected
Echo. sources, you can search and see details about them before downloading
Echo. CREDITS: Bat %_ver% by Kvc
echo.
echo. Syntax: Call Bat Update [Github_User]
echo. Syntax: Call Bat List
echo. Syntax: Call Bat iList
echo. Syntax: Call Bat Search [Term1] [Term2] [Term3] ...
echo. Syntax: Call Bat Install [Local-ID ^| [Term1] [Term2] [Term3] ...]
echo. Syntax: Call Bat Detail [Local-ID ^| [Term1] [Term2] [Term3] ...]
echo. Syntax: Call Bat Reset [all]
echo. Syntax: call Bat [help ^| /? ^| -h ^| -help]
echo. Syntax: call Bat ver
echo.
echo. Where:-
echo.
echo. ver			: Displays version of program
echo. help			: Displays help for the program
Echo. Update [User]		: Updates DATABASE with given user's plugins
Echo. List			: Lists out list of all Plugins in DATABASE
Echo. iList			: Lists out list of installed Plugins in System
Echo. Search			: Filters out plugins as per the given keywords
echo. Install		: Downloads and installs batch plugin in the PATH
Echo. Detail			: Provides detail about the filtered Project
echo. Reset [all]		: Removes installed plugins ^| with [all] it removes BAT
Echo.
Echo. Switch:-
Echo. -y ^| /Y		: Suppresses prompting to confirm your action
Echo.
Echo. Example: Call Bat Update
Echo. Example: Call Bat Update Microsoft
Echo. Example: Call Bat List
Echo. Example: Call Bat Search batbox 3.1
Echo. Example: Call Bat Install batbox 3.1
Echo. Example: Call Bat Install batbox 3.1 -y
Echo. Example: Call Bat Install 10
Echo. Example: Call Bat Detail batbox 3.1
Echo. Example: Call Bat Detail 10
Echo. Example: Call Bat Reset
Echo. Example: Call Bat Reset all
Echo. Example: Call Bat ver
Echo. Example: Call Bat /?
Echo.
Echo.
Echo. PLUGIN REQUIRED FOR THIS PROJECT...
Echo. 7za.exe 			by 7z
Echo. jq.exe 			by stedolan 
Echo. Getlen.bat			by Kvc
Echo. ReadLine.exe			by Kvc
Echo. StrSplit.exe			by Kvc
Echo. StrSurr.exe			by Kvc
Echo. wget.exe			by Hrvoje
Echo.
Echo. www.batch-man.com
Echo. #batch-man
Goto :End

