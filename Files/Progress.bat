@Echo off
Setlocal EnableDelayedExpansion

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
REM This program is Created by Kvc & Anic17 at 'Sat 01/09/2021 - 22:10'
REM This program can Show a CLI progress bar on the cmd Screen!
REM For More Visit: www.batch-man.com


REM Setting version information...
Set _ver=1.0


REM Checking for various parameters of the function...
If /i "%~1" == "/?" (goto :help)
If /i "%~1" == "-h" (goto :help)
If /i "%~1" == "-help" (goto :help)
If /i "%~1" == "help" (goto :help)
If /i "%~1" == "ver" (Echo.%_ver%&Goto :End)
If /i "%~1" == "" (goto :help)

If /i "%~2" == "" (goto :help)
If /i "%~3" == "" (goto :help)

REM Saving parameters to variables...
Set _1=%~1
Set _2=%~2
Set _3=%~3
Set _4=%~4
Set _5=%~5

REM Starting Main Program...
:Main
for /f %%A in ('copy /Z "%~dpf0" nul') do set "CR=%%A"

Set _BarLength=%_1%
Set _CurrentValue=%_2%
Set _MaxValue=%_3%

If /I "%_4%" == "" (Set _ProgressChar=#) ELSE (Set _ProgressChar=%_ProgressChar:~0,1%)
If /I "%_5%" == "" (Set _EmptyChar=-) ELSE (Set _EmptyChar=%_EmptyChar:~0,1%)

Set /A _progress= !_CurrentValue! * !_BarLength!
Set /A _progress= !_progress! / !_MaxValue!
Set _ProgBar=
For /L %%A in (1,1,!_progress!) do (Set "_ProgBar=!_ProgBar!!_ProgressChar!")
Set /A _Remaining= !_BarLength! - !_progress!
For /L %%A in (1,1,!_Remaining!) do (Set "_ProgBar=!_ProgBar!!_EmptyChar!")
<nul set /p "=[!_ProgBar!]!CR! "

REM Clearing the Progress-bar...
If /I "!_CurrentValue!" == "!_MaxValue!" (
	Set _ProgBar=
	For /L %%A in (0,1,!_BarLength!) do (Set "_ProgBar=!_ProgBar! ")
	<nul set /p "=!CR!.!_ProgBar!!CR!    !CR!"
)

Goto :End


:End
Goto :EOF

:Help
Echo.
Echo. This function will Show a CLI progress bar on the cmd Screen!
echo. It will help in making your programs more user Friendly.
Echo. CREDITS: progress %_ver% by Kvc
echo.
echo. Syntax: Call progress [BarLength] [CurrentValue] [MaxValue]
echo. Syntax: call progress [help , /? , -h , -help]
echo. Syntax: call progress ver
echo.
echo. Where:-
echo.
echo. ver		: Displays version of program
echo. help		: Displays help for the program
echo. [BarLength]	: The Total Length of the Progress-bar on the CMD Screen
Echo. [CurrentValue]	: Current Progress Step, out of the total Steps
echo. [MaxValue]	: Max number of Steps needed to get to the Task Complition
Echo.
Echo. Example: Call progress 75 45 68
Echo. Example: Call progress ver
Echo. Example: Call progress [/? , -h , -help , help]
Echo.
Echo. www.batch-man.com
Echo. #batch-man
Goto :End

