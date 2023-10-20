@echo on
for /r "%cd%" %%i in ("*") do ( move "%%i" "%cd%" )
ROBOCOPY "%cd%" "%cd%" /S /MOVE