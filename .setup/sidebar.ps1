#Requires -Version 5.1
# Claude Code quick-reference sidebar
# Runs in the right pane of the split terminal layout.

$startTime = Get-Date
$refreshSeconds = 60

function Write-Divider {
    param([int]$Width = 44)
    Write-Host ("  " + ([string][char]0x2500) * $Width) -ForegroundColor DarkGray
}

function Write-Section {
    param([string]$Title)
    Write-Host ""
    Write-Host "  $Title" -ForegroundColor Yellow
}

function Write-Cmd {
    param([string]$Cmd, [string]$Desc)
    Write-Host ("  " + $Cmd.PadRight(18)) -ForegroundColor Cyan -NoNewline
    Write-Host $Desc -ForegroundColor DarkGray
}

function Write-Tip {
    param([string]$Text)
    Write-Host "  " -NoNewline
    Write-Host ([string][char]0x2022) -ForegroundColor DarkYellow -NoNewline
    Write-Host " $Text" -ForegroundColor DarkGray
}

while ($true) {
    Clear-Host

    $now        = Get-Date
    $elapsed    = [int]($now - $startTime).TotalMinutes
    $timeStr    = $now.ToString("ddd dd MMM  HH:mm")
    $sessionStr = "${elapsed}m"

    # ── Header ──────────────────────────────────────
    Write-Host ""
    Write-Host "  Claude Code" -ForegroundColor Cyan -NoNewline
    Write-Host "                 " -NoNewline
    if ($elapsed -lt 60) {
        Write-Host $sessionStr -ForegroundColor Green
    } elseif ($elapsed -lt 90) {
        Write-Host $sessionStr -ForegroundColor Yellow
    } else {
        Write-Host $sessionStr -ForegroundColor Red -NoNewline
        Write-Host "  checkpoint!" -ForegroundColor DarkRed
    }
    Write-Host "  $timeStr" -ForegroundColor DarkGray
    Write-Divider

    # ── Session ─────────────────────────────────────
    Write-Section "SESSION"
    Write-Cmd "/start-work"   "begin session"
    Write-Cmd "/end-work"     "close + capture"
    Write-Cmd "/pulse"        "health check"
    Write-Cmd "/checkpoint"   "save state"
    Write-Cmd "/status"       "where am I"

    # ── Capture ─────────────────────────────────────
    Write-Section "CAPTURE"
    Write-Cmd "/learn"        "add learning"
    Write-Cmd "/brain-dump"   "unstructured"
    Write-Cmd "/reminder"     "side thought"

    # ── Workflow ─────────────────────────────────────
    Write-Section "WORKFLOW"
    Write-Cmd "/research"     "discover first"
    Write-Cmd "/plan"         "design (needs OK)"
    Write-Cmd "/implement"    "execute"
    Write-Cmd "/validate-work" "run tests"
    Write-Cmd "/rethink"      "pivot approach"

    # ── Git ──────────────────────────────────────────
    Write-Section "GIT"
    Write-Cmd "/quick-commit" "stage + push"

    # ── Pipeline ─────────────────────────────────────
    Write-Host ""
    Write-Divider
    Write-Section "PIPELINE"
    Write-Host "  " -NoNewline
    Write-Host "Idea" -ForegroundColor DarkGray -NoNewline
    Write-Host " -> " -ForegroundColor DarkGray -NoNewline
    Write-Host "Learn" -ForegroundColor Cyan -NoNewline
    Write-Host " -> " -ForegroundColor DarkGray -NoNewline
    Write-Host "Skill" -ForegroundColor Green -NoNewline
    Write-Host " -> " -ForegroundColor DarkGray -NoNewline
    Write-Host "Command" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  learning/ideas/backlog.md" -ForegroundColor DarkGray

    # ── Context health ───────────────────────────────
    Write-Host ""
    Write-Divider
    Write-Section "CONTEXT WINDOW"
    Write-Host "  " -NoNewline; Write-Host "0-40% " -ForegroundColor Green  -NoNewline; Write-Host " Smart Zone" -ForegroundColor DarkGray
    Write-Host "  " -NoNewline; Write-Host "40-60%" -ForegroundColor Yellow -NoNewline; Write-Host " /compact now" -ForegroundColor DarkGray
    Write-Host "  " -NoNewline; Write-Host ">60%  " -ForegroundColor Red    -NoNewline; Write-Host " Start fresh" -ForegroundColor DarkGray

    # ── Tips ─────────────────────────────────────────
    Write-Host ""
    Write-Divider
    Write-Section "TIPS"
    Write-Tip "Read code before changing"
    Write-Tip "Check in before big changes"
    Write-Tip "/compact proactively"
    Write-Tip "Commit learnings to ClaudeDocs"
    Write-Tip "1-2h sessions, 40 turns max"

    # ── Footer ───────────────────────────────────────
    Write-Host ""
    Write-Divider
    Write-Host "  refreshes every ${refreshSeconds}s  " -ForegroundColor DarkGray -NoNewline
    Write-Host "q" -ForegroundColor Cyan -NoNewline
    Write-Host "+Enter to exit" -ForegroundColor DarkGray

    # ── Input check (non-blocking) ───────────────────
    $waited = 0
    while ($waited -lt $refreshSeconds) {
        Start-Sleep -Seconds 1
        $waited++
        try {
            if ([Console]::KeyAvailable) {
                $key = [Console]::ReadKey($true)
                if ($key.KeyChar -eq 'q' -or $key.Key -eq 'Escape') { exit }
            }
        } catch { }
    }
}
