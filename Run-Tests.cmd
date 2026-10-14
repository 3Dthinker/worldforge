@echo off
setlocal
cd /d "%~dp0"
set "PYTHONPATH=%~dp0companion"
if not exist diagnostics mkdir diagnostics
py -3 -m unittest discover -s tests -v > diagnostics\local-tests.log 2>&1
type diagnostics\local-tests.log
pause
endlocal
