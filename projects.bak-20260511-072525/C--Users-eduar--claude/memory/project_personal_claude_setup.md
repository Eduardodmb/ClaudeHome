---
name: Personal Claude Code environment setup
description: State of Eduardo's personal Claude Code environment — what exists, what's missing, what needs setup
type: project
originSessionId: 762cc180-ae9a-436f-9b2e-d6e7763bbb47
---
Personal Claude environment uses Obsidian vault at `D:\OneDrive\16 - Obsidian\00_Claude` as the source of truth.

**What exists:**
- Rich Obsidian structure with commands, skills, learning, reference (all under `_claude-*` subfolders)
- 30+ custom commands, 10+ skills, extensive learnings and best-practices docs
- Setup script at `.setup/setup-links.ps1` — but uses wrong paths (`C:\Users\emarquez` instead of actual `C:\Users\eduar` and D: drive)

**What was MISSING and now created:**
- `~/.claude/CLAUDE.md` — global personal source of truth (created 2026-05-08)

**Completed 2026-05-08:**
- `personal-claude-docs` repo cloned at `C:\Users\eduar\personal-claude-docs`
- All `~/.claude/` symlinks rewired: commands, skills, learning, reference, agents, enterprise, personal all point to `personal-claude-docs/.claude/enterprise/` or `users/emarquez-personal/`
- Obsidian vault `_claude-*` dirs rewired to same enterprise targets
- `~/.claude/CLAUDE.md` is now a thin loader: `@enterprise/CLAUDE.md` + `@personal/CLAUDE.md` + machine paths
- Runtime dirs exist: `state/`, `worktrees/`
- Committed and pushed to GitHub

**Work computer setup (when ready):**
- Clone `personal-claude-docs` to `C:\Users\emarquez\personal-claude-docs`
- Run `setup-personal.ps1` (auto-detects work profile)
- ClaudeWork `~/.claude/CLAUDE.md` should add `@enterprise/CLAUDE.md` and `@personal/CLAUDE.md` at the top

**Why:** Eduardo is building a personal second brain - same context, same knowledge base, same commands on every computer. Knowledge compounds over time: ideas → learnings → skills → commands. The architecture makes this automatic.
**How to apply:** When working on setup tasks, reference D: drive paths and `eduar` username. Don't assume emarquez paths.
