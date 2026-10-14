$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$project = Join-Path $root 'unreal\TerraForgeDemo\TerraForgeDemo.uproject'
if (-not (Test-Path $project)) { throw 'Run this launcher in your complete, built TerraForge project.' }
. (Join-Path $root 'scripts\Build-State.ps1')
if (-not (Test-TerraForgeBuild (Split-Path $project -Parent) (Join-Path $root 'diagnostics\build-state.json'))) {
  throw 'r25 Unreal rebuild required. Close Unreal, run Build-Unreal.cmd in THIS folder, wait for Build succeeded, then retry Start-TerraForge.cmd.'
}
$diag = Join-Path $root 'diagnostics'
New-Item -ItemType Directory -Force $diag | Out-Null
$log = Join-Path $diag 'companion-start.log'
'Checking Python 3.11+, tkinter and sqlite3...' | Set-Content $log -Encoding UTF8
$candidates = @()
foreach ($name in @('py.exe','python.exe')) {
  foreach ($cmd in @(Get-Command $name -CommandType Application -All -ErrorAction SilentlyContinue)) {
    if ($cmd.Source -notlike '*\Microsoft\WindowsApps\*' -or $name -eq 'py.exe') {
      $candidates += @{path=$cmd.Source; launcher=($name -eq 'py.exe')}
    }
  }
}
foreach ($base in @((Join-Path $env:LOCALAPPDATA 'Programs\Python'), $env:ProgramFiles)) {
  foreach ($dir in @(Get-ChildItem $base -Directory -Filter 'Python*' -ErrorAction SilentlyContinue)) {
    $exe = Join-Path $dir.FullName 'python.exe'
    if (Test-Path $exe) { $candidates += @{path=$exe; launcher=$false} }
  }
}
$priorInstall = $env:PYTHON_MANAGER_AUTOMATIC_INSTALL
$priorPythonPath = $env:PYTHONPATH
$selected = $null
$env:PYTHON_MANAGER_AUTOMATIC_INSTALL = 'false'
try {
  foreach ($candidate in $candidates) {
    $prefix = @(); if ($candidate.launcher) { $prefix = @('-3') }
    $ErrorActionPreference = 'Continue'
    $output = & $candidate.path @prefix -c "import sys, tkinter, sqlite3; assert sys.version_info >= (3,11); print(sys.executable)" 2>&1
    $code = $LASTEXITCODE
    $ErrorActionPreference = 'Stop'
    "Candidate: $($candidate.path); exit: $code" | Add-Content $log -Encoding UTF8
    if ($code -eq 0) { $selected = $candidate; break }
  }
  if (-not $selected) {
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.MessageBox]::Show('Python 3.11+ with Tcl/Tk was not found. If already installed, select its python.exe in the next window. Otherwise cancel, install Python with Tcl/Tk, then retry.', 'TerraForge') | Out-Null
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.Title = 'Select installed python.exe (Cancel if Python is not installed)'
    $dialog.Filter = 'Python runtime|python.exe'
    if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
      $selected = @{path=$dialog.FileName; launcher=$false}
    }
    $dialog.Dispose()
    if (-not $selected) { throw "Python not selected. Details: $log" }
    & $selected.path -c "import sys, tkinter, sqlite3; assert sys.version_info >= (3,11)"
    if ($LASTEXITCODE -ne 0) { throw 'Selected Python requires version 3.11+, Tcl/Tk and sqlite3.' }
  }
  $prefix = @(); if ($selected.launcher) { $prefix = @('-3') }
  $env:PYTHONPATH = Join-Path $root 'companion'
  Write-Host "Starting TerraForge. Log: $log"
  $ErrorActionPreference = 'Continue'
  & $selected.path @prefix -m terraforge.gui --project $project 2>&1 | Tee-Object -FilePath $log -Append
  $launchExit = $LASTEXITCODE
  $ErrorActionPreference = 'Stop'
  if ($launchExit -ne 0) { throw "TerraForge could not start. Send $log" }
} finally {
  $env:PYTHON_MANAGER_AUTOMATIC_INSTALL = $priorInstall
  $env:PYTHONPATH = $priorPythonPath
}
