@echo off
powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -File "%~dp0Start-TerraForge-r7.ps1"
if errorlevel 1 pause
