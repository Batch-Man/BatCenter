@Echo off
SetLocal EnabledelayedExpansion
REM GetDim Function ver.1.0 by kvc, Enhanced by Sounak;
REM It Returns the current Dimensions of cmd console, which is calling this Function.

REM Syntax: Call GetDim [Rows] [Columns]

Rem Visit www.thebateam.org for more extensions / plug-ins like this.... :]
Rem #TheBATeam


REM Checking things...
If /i "%~1" == "" (goto :help)
If /i "%~1" == "/?" (goto :help)
If /i "%~1" == "-h" (goto :help)
If /i "%~1" == "help" (goto :help)
If /i "%~1" == "-help" (goto :help)

If /i "%~1" == "ver" (echo.1.0&&goto :eof)

If /i "%~2" == "" (goto :help)


REM Main Code of function...
Set _Parameter=1
For /f "Skip=3 tokens=2" %%A in ('mode con') do (Set "_!_Parameter!=%%A"&&Set /A _Parameter+=1)
Endlocal && Set "%~1=%_1%" && Set "%~2=%_2%"
Goto :EOF

:help
Echo.
Echo. This function Simply Returns the current Dimensions of cmd console,
Echo. in Two variables provided.
echo.
echo. Syntax: Call GetDim [Rows] [Columns]
echo. Syntax: call GetDim [help ^| /^? ^| -h ^| -help]
echo. Syntax: call GetDim ver
echo.
echo. Where:-
Echo. Rows		= The Variable to save 'No. of Rows	[Y]'
Echo. Columns	= The Variable to save 'No. of Columns	[X]'
echo. Help		= Shows this screen.
echo. ver		= Version of the function.
echo.
echo. Visit www.thebateam.org for more...
echo. #Kvc with #TheBATeam
goto :eof