@echo off
del /Q C:\Windows\Prefetch\*.*
del /Q %temp%\*.*
del /Q C:\$Recycle.Bin\*.*
rd /s /Q %systemdrive%\$Recycle.bin
del /Q C:\Windows\Temp\*.*
del /Q C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Recent Items*.* 