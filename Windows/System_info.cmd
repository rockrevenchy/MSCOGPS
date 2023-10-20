@echo off
echo System Information:
echo -------------------
echo.

:: Get CPU Information
echo CPU Information:
wmic cpu get caption /format:list | findstr /i /c:"caption"
echo.

:: Get RAM Information
echo RAM Information:
wmic memorychip get capacity /format:list | findstr /i /c:"capacity"
echo.

:: Get Motherboard Information
echo Motherboard Information:
wmic baseboard get product /format:list | findstr /i /c:"product"
echo.

:: Get GPU Information
echo GPU Information:
wmic path win32_videocontroller get caption /format:list | findstr /i /c:"caption"
echo.

:: Get Disk Information
echo Disk Information:
wmic diskdrive get caption,size /format:list | findstr /i /c:"caption" /c:"size"
echo.

pause
