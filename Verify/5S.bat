@Echo off
SETLOCAL EnableDelayedExpansion

REM Five Step
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
REM This program is Created by Groophy at 'Wed 09/11/2022 - 09:35'
REM This program will help you download the batch plugins from selected
REM sources, you can search and see details about them before downloading
REM For More Visit: www.batch-man.com
REM OR
REM https://github.com/Batch-Man/BatCenter
REM 

:Update_parameters
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

:Step_One
if exist "C:\Users\%USERNAME%\AppData\Local\BatCenter\Files\bat.bat" (
    goto :Step_Three
) else (
    goto :Step_Two
)

:Step_Two
call ..\Install\batcenter_install.bat
goto :Step_Three

:Step_Three
SET Counter=0
SET ID="NA"
for /F "delims=" %%a in ('bat search %_1%') do (
    SET str=%%a
    ECHO."%str%"| FIND /I "Bat Update">Nul && ( 
        Bat update 1>NUL
        goto :Step_Three
    )
    SET /a Counter+=1
    SET ID="%%a"
)
IF %Counter% GTR 1 (
    echo You can't Install Many Plugin In One Inject!
    goto :EOF
)

call :indexof %ID% "[" _BracketStart
call :indexof %ID% "]" _BracketEnd

set /a _BracketStart += 2
set /a _BracketEnd += 1
set /a NumberLen = %_BracketEnd% - %_BracketStart%

Set PluginID="!ID:~%_BracketStart%,%NumberLen%!"

IF /I "%PluginID%"==" Search Term Missing..." (
    echo Search Term Missing...
    goto :EOF
)
for /F "delims=" %%a in ('bat ilist %PluginID%') do (
    set test=%%a
    set test=!test:~0,1!
    if /I "!test!"=="[" (
        goto :Step_Five
    )
    goto :Step_Four

)

:Step_Four
bat install %PluginID% 
goto :Step_Five


:Step_Five
goto :EOF


:indexof [%1 - string ; %2 - find index of ; %3 - if defined will store the result in variable with same name]
@echo off
setlocal enableDelayedExpansion

set "str=%~1"
set "s=!str:%~2=&rem.!"
set s=#%s%
if "%s%" equ "#%~1" endlocal& if "%~3" neq "" (set %~3=-1&exit /b 0) else (echo -1&exit /b 0) 

  set "len=0"
  for %%A in (2187 729 243 81 27 9 3 1) do (
    set /A mod=2*%%A
    for %%Z in (!mod!) do (
        if "!s:~%%Z,1!" neq "" (
            set /a "len+=%%Z"
            set "s=!s:~%%Z!"
            
        ) else (
            if "!s:~%%A,1!" neq "" (
                set /a "len+=%%A"
                set "s=!s:~%%A!"
            )
        )
    )
  )
  endlocal & if "%~3" neq "" (set %~3=%len%) else echo %len%
exit /b 0