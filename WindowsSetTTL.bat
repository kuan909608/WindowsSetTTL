@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul
cls

:: Set the title of the console window
title Set or Reset Windows Global IPv4 TTL

:: Parameter default value
set "resetTTL=N"
set "changeTTL=N"

:: ===== Permission Check and Prompt =====
:: Check if the script is running with administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [^^!] Admin rights required. Attempting elevation via powershell...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

:: ===== Display Current IPv4 Interface Information =====
:: Display a list of IPv4 interfaces on the machine
echo [+] IPv4 Interfaces on this machine:
for /f "delims=" %%i in ('powershell -Command "Get-NetIPInterface | Where-Object {$_.AddressFamily -eq 'IPv4'} | ForEach-Object { '- ' + $_.InterfaceAlias + ' (Index: ' + $_.InterfaceIndex + ', Status: ' + $_.ConnectionState + ')' }"') do (
    echo %%i
)
echo.

:: ===== Get Current TTL Setting =====
:: Get the current global IPv4 TTL value using PowerShell
for /f %%a in ('powershell -Command "(Get-NetIPv4Protocol).DefaultHopLimit.ToString().Trim()"') do (
    set "currentTTL=%%a"
)
echo [+] Current global IPv4 TTL: !currentTTL!
echo.

:: ===== If TTL ≠ 128, Ask Whether to Restore =====
:: If the current TTL is not 128, prompt the user to restore it to 128
if not "!currentTTL!"=="128" (
    choice /C YN /N /M "Restore TTL to 128 (Y/N)?"
    echo.
    if "%errorlevel%"=="1" set "resetTTL=Y"
    if "%errorlevel%"=="2" set "resetTTL=N"
    if %errorlevel%==255 (
        echo [x] Operation canceled by user.
        echo.
        pause
        exit /b
    )
)

:: If the user confirms to restore TTL
if /i "!resetTTL!"=="Y" (
    echo [^^!] Restoring TTL to 128...
    echo.
    powershell -Command "try { Set-NetIPv4Protocol -DefaultHopLimit 128 -ErrorAction Stop } catch { exit 1 }"

    if errorlevel 1 (
        echo [x] Failed to restore TTL
    ) else (
        echo [v] Successfully restored TTL to 128
    )

    echo.
    pause
    exit /b
)

:: ===== Ask Whether to Set a New TTL =====
:: Prompt the user to set a new TTL value
choice /C YN /N /M "Do you want to set a new TTL value (Y/N)?"
echo.
if "%errorlevel%"=="1" set "changeTTL=Y"
if "%errorlevel%"=="2" set "changeTTL=N"
if %errorlevel%==255 (
    echo [x] Operation canceled by user.
    echo.
    pause
    exit /b
)

if /i not "!changeTTL!"=="Y" (
    echo [+] No changes made.
    echo.
    pause
    exit /b
)

:: Prompt the user to enter a new TTL value
set /p newTTL=Enter new TTL value ^(1~255^) [65]: 
echo.
if "!newTTL!"=="" set "newTTL=65"

:: Pass to PowerShell for safe type conversion (avoid octal, leading zeros, illegal input)
:: Convert the input to an integer using PowerShell
for /f %%z in ('powershell -Command "try { [int]::Parse('"!newTTL!"') } catch { -1 }"') do set "newTTL=%%z"

:: Verify that the conversion was successful
if "!newTTL!"=="-1" (
    echo [x] TTL must be a valid number between 1 and 255.
    echo.
    pause
    exit /b 1
)

:: Verify that the TTL is within the range of 1~255
set /a testTTL=!newTTL!
if !testTTL! lss 1 (
    echo [x] TTL must be at least 1.
    echo.
    pause
    exit /b 1
)
if !testTTL! gtr 255 (
    echo [x] TTL must be no more than 255.
    echo.
    pause
    exit /b 1
)

:: Set TTL
echo [^^!] Setting TTL to !newTTL!...
echo.
powershell -Command "try { Set-NetIPv4Protocol -DefaultHopLimit !newTTL! -ErrorAction Stop } catch { exit 1 }"

if errorlevel 1 (
    echo [x] Failed to set TTL.
    echo.
    pause
    exit /b 1
)

echo [v] TTL successfully set to !newTTL!.
echo.

pause
exit /b
