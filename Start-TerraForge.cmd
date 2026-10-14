@echo off
if not exist "%~dp0Start-TerraForge-r7.ps1" (
  echo Extract ALL files from the ZIP first.
  pause
  exit /b 1
)
powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -File "%~dp0Start-TerraForge-r7.ps1"
pause
