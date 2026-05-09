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

.EXAMPLE
    .\claude-session.ps1
    .\claude-session.ps1 -Project "C:\Users\eduar\my-project"
    .\claude-session.ps1 -Project .
#>

param(
    [string]$Project = ""
)

$sidebarScript = "C:\Users\eduar\.claude\.setup\sidebar.ps1"

# Resolve project path
if ($Project -ne "") {
    $Project = (Resolve-Path $Project -ErrorAction SilentlyContinue).Path
}

# Build the claude command (with optional cd)
if ($Project -and (Test-Path $Project)) {
    $claudeCmd = "Set-Location -LiteralPath '$Project'; claude"
} else {
    $claudeCmd = "claude"
}

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

# Build wt argument string
# Format: wt new-tab ... -- pwsh ... ; split-pane ... -- pwsh ...
$leftCmd  = "pwsh -NoExit -Command `"$claudeCmd`""
$rightCmd = "pwsh -NoExit -ExecutionPolicy Bypass -File `"$sidebarScript`""

$wtArgs = "new-tab --title `"Claude Code`" -- $leftCmd ; split-pane -V --size 0.35 --title `"Quick Ref`" -- $rightCmd"

Write-Host "Opening Claude Code with sidebar..." -ForegroundColor Cyan
if ($Project) { Write-Host "  Project: $Project" -ForegroundColor DarkGray }
Write-Host ""

Start-Process wt -ArgumentList $wtArgs
