#Requires -Version 5.1
<#
.SYNOPSIS
    Launch Claude Code with a quick-reference sidebar.

.DESCRIPTION
    Opens Windows Terminal with two panes:
      Left (65%)  - Claude Code (starts in project dir if given)
      Right (35%) - Quick-reference sidebar with commands and tips

.PARAMETER Project
    Optional path to a project directory. Claude starts there.
    Defaults to the current directory.

.EXAMPLE
    .\claude-session.ps1
    .\claude-session.ps1 -Project "C:\Users\eduar\my-project"
    .\claude-session.ps1 -Project .
#>

param(
    [string]$Project = ""
)

# sidebar.ps1 lives alongside this script in ~/.claude/.setup/
$sidebarScript = Join-Path $PSScriptRoot "sidebar.ps1"

# Default to calling directory
if ($Project -eq "") { $Project = $PWD.Path }

# Resolve to absolute path
if ($Project -ne "") {
    $Project = (Resolve-Path $Project -ErrorAction SilentlyContinue).Path
}

# Detect available PowerShell executable
$psExe = if (Get-Command pwsh -ErrorAction SilentlyContinue) { "pwsh" } else { "powershell" }

# Check wt is available
$wt = Get-Command wt -ErrorAction SilentlyContinue
if (-not $wt) {
    $wt = Get-Item "$env:LOCALAPPDATA\Microsoft\WindowsApps\wt.exe" -ErrorAction SilentlyContinue
}
if (-not $wt) {
    Write-Host "Windows Terminal (wt) not found." -ForegroundColor Red
    Write-Host "Install from: ms-windows-store://pdp/?productid=9N0DX20HK701" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Falling back: opening Claude Code directly..." -ForegroundColor Gray
    if ($Project -and (Test-Path $Project)) { Set-Location $Project }
    & claude
    exit
}

# Build wt argument string.
# Use -d for starting directory instead of embedding Set-Location in the command
# string — a semicolon inside -Command would be misread by wt as a command separator.
$leftCmd  = "$psExe -NoExit -Command claude"
$rightCmd = "$psExe -NoExit -ExecutionPolicy Bypass -File `"$sidebarScript`""

$dirFlag = if ($Project -and (Test-Path $Project)) { "-d `"$Project`"" } else { "" }

$wtArgs = "new-tab --title `"Claude Code`" $dirFlag -- $leftCmd ; split-pane -V --size 0.35 --title `"Quick Ref`" -- $rightCmd"

Write-Host "Opening Claude Code with sidebar..." -ForegroundColor Cyan
if ($Project) { Write-Host "  Project: $Project" -ForegroundColor DarkGray }
Write-Host ""

Start-Process wt -ArgumentList $wtArgs
