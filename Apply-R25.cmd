@echo off
if not exist "%~dp0scripts\Apply-R25.ps1" (
  echo Extract ALL files from the ZIP first. Do not run this from inside the ZIP.
  pause
  exit /b 1
)
powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -File "%~dp0scripts\Apply-R25.ps1"
pause
