#Requires -Version 5.1
<#
.SYNOPSIS
    Bootstrap ClaudeHome - home computer full setup.

.DESCRIPTION
    Runs in two steps:
      1. Calls setup-personal.ps1 to wire ~/.claude/ -> personal-claude-docs
      2. Wires the personal Obsidian vault (01_Claude_Home) -> ~/.claude/

    Run this once on the home computer (eduar / D:\OneDrive\).
    Re-run with -Force to recreate all symlinks.

.PARAMETER Force
    Remove and recreate existing symlinks/junctions.

.PARAMETER BackupExisting
    Backup real directories before replacing with symlinks.

.EXAMPLE
    .\.setup\setup-home.ps1
    .\.setup\setup-home.ps1 -Force
#>

[CmdletBinding()]
param(
    [switch]$Force,
    [switch]$BackupExisting
)

$ErrorActionPreference = "Stop"

function Write-Step { param([string]$m) Write-Host "  -> $m" -ForegroundColor Cyan }
function Write-Ok   { param([string]$m) Write-Host "  OK  $m" -ForegroundColor Green }
function Write-Skip { param([string]$m) Write-Host "  --  $m" -ForegroundColor Gray }
function Write-Warn { param([string]$m) Write-Host "  !!  $m" -ForegroundColor Yellow }
function Write-Fail { param([string]$m) Write-Host "  XX  $m" -ForegroundColor Red }

Write-Host ""
Write-Host "============================================" -ForegroundColor Blue
Write-Host "  ClaudeHome Setup - Home Computer (eduar) " -ForegroundColor Blue
Write-Host "============================================" -ForegroundColor Blue
Write-Host ""

$claudeRoot  = "C:\Users\eduar\.claude"
$claudeDocs  = "C:\Users\eduar\personal-claude-docs"
$vaultPath   = "D:\OneDrive\16 - Obsidian\01_Claude_Home"

# ─── 1. Run setup-personal.ps1 ───────────────────────────────────────────────

$setupScript = "$claudeDocs\.claude\scripts\setup-personal.ps1"

if (-not (Test-Path $setupScript)) {
    Write-Fail "personal-claude-docs not found at $claudeDocs"
    Write-Host "  Clone it first:" -ForegroundColor Gray
    Write-Host "  git clone https://github.com/Eduardodmb/ClaudeDocs.git $claudeDocs" -ForegroundColor Gray
    exit 1
}

Write-Step "Step 1: Wire ~/.claude/ -> personal-claude-docs"
$params = @{}
if ($Force)          { $params['Force']          = $true }
if ($BackupExisting) { $params['BackupExisting'] = $true }
& $setupScript @params

# ─── 2. Wire Obsidian vault -> ~/.claude/ ────────────────────────────────────

Write-Host ""
Write-Step "Step 2: Wire 01_Claude_Home vault -> ~/.claude/"

if (-not (Test-Path $vaultPath)) {
    Write-Warn "Vault not found at $vaultPath"
    Write-Host "  Wait for OneDrive to sync, then re-run." -ForegroundColor Gray
    exit 0
}

$canSymlink = $false
try {
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator)
    $devMode = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" `
        -ErrorAction SilentlyContinue).AllowDevelopmentWithoutDevLicense -eq 1
    $canSymlink = $isAdmin -or $devMode
} catch {}

$vaultLinks = @(
    @{ Link = "$vaultPath\04-Commands\_claude-commands";  Target = "$claudeRoot\commands";  Label = "vault/commands" },
    @{ Link = "$vaultPath\03-Skills\_claude-skills";      Target = "$claudeRoot\skills";    Label = "vault/skills"   },
    @{ Link = "$vaultPath\02-Learnings\_claude-learning"; Target = "$claudeRoot\learning";  Label = "vault/learning" },
    @{ Link = "$vaultPath\05-Reference\_claude-reference";Target = "$claudeRoot\reference"; Label = "vault/reference"}
)

foreach ($l in $vaultLinks) {
    $lp = $l.Link; $tg = $l.Target; $lb = $l.Label

    if (-not (Test-Path $tg)) { Write-Warn "${lb}: target missing ($tg)"; continue }

    if (Test-Path $lp) {
        $existing = Get-Item $lp -Force
        $isLink   = $existing.Attributes -band [IO.FileAttributes]::ReparsePoint

        if ($Force) {
            if ($isLink) {
                try   { [System.IO.Directory]::Delete($lp) }
                catch { try { Remove-Item $lp -Force } catch { Write-Warn "${lb}: could not remove - $_"; continue } }
            } else {
                $isEmpty = (@(Get-ChildItem $lp -Force -ErrorAction SilentlyContinue)).Count -eq 0
                if ($isEmpty) { Remove-Item $lp -Force -Recurse }
                elseif ($BackupExisting) {
                    Rename-Item $lp "$lp.bak-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
                } else { Write-Warn "${lb}: real dir with content - use -Force -BackupExisting"; continue }
            }
        } else {
            if ($isLink) { Write-Skip $lb } else { Write-Warn "${lb}: real dir exists (use -Force)" }
            continue
        }
    }

    $parent = Split-Path $lp -Parent
    if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }

    if ($canSymlink) {
        New-Item -ItemType SymbolicLink -Path $lp -Target $tg -Force | Out-Null
    } else {
        cmd /c mklink /J "$lp" "$tg" 2>&1 | Out-Null
    }

    if (Test-Path $lp) { Write-Ok $lb } else { Write-Fail "${lb}: creation failed" }
}

# ─── 3. Verification ─────────────────────────────────────────────────────────

Write-Host ""
Write-Host "  Verification" -ForegroundColor White

$allChecks = @(
    @{ Path = "$claudeRoot\commands";                        Label = "~/.claude/commands"  },
    @{ Path = "$claudeRoot\skills";                          Label = "~/.claude/skills"    },
    @{ Path = "$claudeRoot\learning";                        Label = "~/.claude/learning"  },
    @{ Path = "$claudeRoot\reference";                       Label = "~/.claude/reference" },
    @{ Path = "$claudeRoot\enterprise";                      Label = "~/.claude/enterprise"},
    @{ Path = "$claudeRoot\personal";                        Label = "~/.claude/personal"  },
    @{ Path = "$claudeRoot\CLAUDE.md";                       Label = "~/.claude/CLAUDE.md" },
    @{ Path = "$vaultPath\04-Commands\_claude-commands";     Label = "vault/commands"      },
    @{ Path = "$vaultPath\03-Skills\_claude-skills";         Label = "vault/skills"        },
    @{ Path = "$vaultPath\02-Learnings\_claude-learning";    Label = "vault/learning"      },
    @{ Path = "$vaultPath\05-Reference\_claude-reference";   Label = "vault/reference"     }
)

$allOk = $true
foreach ($c in $allChecks) {
    if (Test-Path $c.Path) {
        $item = Get-Item $c.Path -Force
        $tag  = if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) { "link" } else { "real" }
        Write-Host "    OK [$tag] $($c.Label)" -ForegroundColor Green
    } else {
        Write-Host "    XX       $($c.Label) MISSING" -ForegroundColor Red
        $allOk = $false
    }
}

Write-Host ""
if ($allOk) {
    Write-Host "  Home computer fully wired." -ForegroundColor Cyan
    Write-Host "  Edit content in Obsidian or personal-claude-docs - Claude sees both." -ForegroundColor Gray
} else {
    Write-Host "  Some links missing. Re-run with -Force." -ForegroundColor Yellow
    exit 1
}
Write-Host ""
