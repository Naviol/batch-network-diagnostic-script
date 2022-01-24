@title BBPOS Network Diagnostic Tool
@echo off
setlocal enabledelayedexpansion

:: Global Vars
set DOMAIN=cloudflare.com
set DOMAINv2=amazon.com
set PORTv1=80,443
set PORTv2=443
set "startTime=%time%"

:: Get YYYY-MM-DD
set TODAY=%date:~10,4%-%date:~7,2%-%date:~4,2%
set REPORT=%TODAY%/result.txt

echo Network Diagnostic Start Now...
IF NOT EXIST "%TODAY%" mkdir %TODAY%
echo ========================================== >> %REPORT%
echo. >> %REPORT%
echo Date: %date% >> %REPORT%
echo Time: %time% >> %REPORT%
echo. >> %REPORT%

CALL :NetworkCheck %DOMAIN%
CALL :NetworkCheckv2 %DOMAINv2%

:: Press any key to exit
set "endTime=%time%"
echo.
echo Start Time: %startTime%
echo End Time: %endTime%
echo.
echo Diagnostic Finished. Result output to folder "%TODAY%".
.\tool\7za.exe a -tzip %TODAY%.zip ".\%TODAY%" "*.txt" > nul
echo [101;93mReport has been compressed as %TODAY%.zip. Please pass this file to support person[0m
pause
EXIT /B

:::::::::: Functions TMSv1 ::::::::::
:NetworkCheck
echo Working on %~1...
:: PING DOMAIN
echo ################################################ >> %REPORT%
echo ######### Ping Test to %~1... #########>> %REPORT%
echo ################################################ >> %REPORT%
ping -w 1000 -n 10 %~1 >> %REPORT%
echo OK
echo. >> %REPORT%

:: TELNET DOMAIN
echo ################################################ >> %REPORT%
echo ######### Telnet to %~1... #########>> %REPORT%
echo ################################################ >> %REPORT%
.\tool\portqry.exe -n %~1 -o %PORTv1% -p TCP >> %REPORT%
echo OK
echo. >> %REPORT%

:: Resolve Domain to IP
IF EXIST ip-%~1.txt del /F ip-%~1.txt
break > ip-%~1.txt
for /f "skip=1 tokens=1,2" %%a in ('nslookup %~1 2^> nul ^|findstr /R "[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*"') do echo %%a %%b >> ip-%~1.txt
set "x=Addresses: "

:: Remove "Addresses:" from nslookup result
for /f "delims=" %%a IN (ip-%~1.txt) DO (
	set a=%%a
    echo !a:%x%=! >> ip-%~1.txt
)

for /f "skip=2 tokens=1" %%a in (ip-%~1.txt) do set IP_ONE=%%a & Goto :print
:print
for /f "skip=3" %%b in (ip-%~1.txt) do set IP_TWO=%%b

:: Ping IP 1
echo ################################################ >> %REPORT%
echo ######### Ping Test to %IP_ONE%... #########>> %REPORT%
echo ################################################ >> %REPORT%
ping -w 1000 -n 10 %IP_ONE% >> %REPORT%
echo OK
echo. >> %REPORT%

:: Telnet IP 1
echo ################################################ >> %REPORT%
echo ######### Telnet to %IP_ONE%... #########>> %REPORT%
echo ################################################ >> %REPORT%
.\tool\portqry.exe -n %IP_ONE% -o %PORTv1% -p TCP >> %REPORT%
echo OK
echo. >> %REPORT%

:: Traceroute IP 1
echo ################################################ >> %REPORT%
echo ######### Traceroute to %IP_ONE%... #########>> %REPORT%
echo ################################################ >> %REPORT%
tracert -d -w 1000 %IP_ONE% >> %REPORT%
echo OK
echo. >> %REPORT%

:: Ping IP 2
echo ################################################ >> %REPORT%
echo ######### Ping Test to %IP_TWO%... #########>> %REPORT%
echo ################################################ >> %REPORT%
ping -w 1000 -n 10 %IP_TWO% >> %REPORT%
echo OK
echo. >> %REPORT%

:: Telnet IP 2
echo ################################################ >> %REPORT%
echo ######### Telnet to %IP_TWO%... #########>> %REPORT%
echo ################################################ >> %REPORT%
.\tool\portqry.exe -n %IP_TWO% -o %PORTv1% -p TCP >> %REPORT%
echo OK
echo. >> %REPORT%

:: Tracroute IP 2
echo ################################################ >> %REPORT%
echo ######### Traceroute to %IP_TWO%... #########>> %REPORT%
echo ################################################ >> %REPORT%
tracert -d -w 1000 %IP_TWO% >> %REPORT%
echo OK
echo. >> %REPORT%
EXIT /B 0

:::::::::: Functions TMSv2 ::::::::::
:NetworkCheckv2
echo Working on %~1...
:: PING DOMAIN
echo ################################################ >> %REPORT%
echo ######### Ping Test to %~1... #########>> %REPORT%
echo ################################################ >> %REPORT%
ping -w 1000 -n 10 %~1 >> %REPORT%
echo OK
echo. >> %REPORT%

:: TELNET DOMAIN
echo ################################################ >> %REPORT%
echo ######### Telnet to %~1... #########>> %REPORT%
echo ################################################ >> %REPORT%
.\tool\portqry.exe -n %~1 -o %PORTv2% -p TCP >> %REPORT%
echo OK
echo. >> %REPORT%

:: Resolve Domain to IP
IF EXIST ip-%~1.txt del /F ip-%~1.txt
break > ip-%~1.txt
for /f "skip=1 tokens=1,2" %%a in ('nslookup %~1 2^> nul ^|findstr /R "[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*"') do echo %%a %%b >> ip-%~1.txt
set "x=Addresses: "

:: Remove "Addresses:" from nslookup result
for /f "delims=" %%a IN (ip-%~1.txt) DO (
	set a=%%a
    echo !a:%x%=! >> ip-%~1.txt
)

for /f "skip=3 tokens=1" %%a in (ip-%~1.txt) do set IP_ONE=%%a & Goto :print
:print
for /f "skip=4" %%b in (ip-%~1.txt) do set IP_TWO=%%b & Goto :print
:print
for /f "skip=5" %%c in (ip-%~1.txt) do set IP_THREE=%%c

:: Ping IP 1
echo ################################################ >> %REPORT%
echo ######### Ping Test to %IP_ONE%... #########>> %REPORT%
echo ################################################ >> %REPORT%
ping -w 1000 %IP_ONE% >> %REPORT%
echo OK
echo. >> %REPORT%

:: Telnet IP 1
echo ################################################ >> %REPORT%
echo ######### Telnet to %IP_ONE%... #########>> %REPORT%
echo ################################################ >> %REPORT%
.\tool\portqry.exe -n %IP_ONE% -o %PORTv2% -p TCP >> %REPORT%
echo OK
echo. >> %REPORT%

:: Traceroute IP 1
echo ################################################ >> %REPORT%
echo ######### Traceroute to %IP_ONE%... #########>> %REPORT%
echo ################################################ >> %REPORT%
tracert -d -w 1000 %IP_ONE% >> %REPORT%
echo OK
echo. >> %REPORT%

:: Ping IP 2
echo ################################################ >> %REPORT%
echo ######### Ping Test to %IP_TWO%... #########>> %REPORT%
echo ################################################ >> %REPORT%
ping -w 1000 %IP_TWO% >> %REPORT%
echo OK
echo. >> %REPORT%

:: Telnet IP 2
echo ################################################ >> %REPORT%
echo ######### Telnet to %IP_TWO%... #########>> %REPORT%
echo ################################################ >> %REPORT%
.\tool\portqry.exe -n %IP_TWO% -o %PORTv2% -p TCP >> %REPORT%
echo OK
echo. >> %REPORT%

:: Tracroute IP 2
echo ################################################ >> %REPORT%
echo ######### Traceroute to %IP_TWO%... #########>> %REPORT%
echo ################################################ >> %REPORT%
tracert -d -w 1000 %IP_TWO% >> %REPORT%
echo OK
echo. >> %REPORT%

:: Ping IP 3
echo ################################################ >> %REPORT%
echo ######### Ping Test to %IP_THREE%... #########>> %REPORT%
echo ################################################ >> %REPORT%
ping -w 1000 %IP_THREE% >> %REPORT%
echo OK
echo. >> %REPORT%

:: Telnet IP 3
echo ################################################ >> %REPORT%
echo ######### Telnet to %IP_THREE%... #########>> %REPORT%
echo ################################################ >> %REPORT%
.\tool\portqry.exe -n %IP_THREE% -o %PORTv2% -p TCP >> %REPORT%
echo OK
echo. >> %REPORT%

:: Tracroute IP 3
echo ################################################ >> %REPORT%
echo ######### Traceroute to %IP_THREE%... #########>> %REPORT%
echo ################################################ >> %REPORT%
tracert -d -w 1000 %IP_THREE% >> %REPORT%
echo OK
echo. >> %REPORT%
EXIT /B 0
