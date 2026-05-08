---
name: Never execute git commands
description: User does not want Claude to execute any git commands via PowerShell or Bash
type: feedback
originSessionId: 73558073-081c-444b-95d7-35fc3edb6bb3
---
Never execute git commands (git status, git add, git commit, git push, etc.) via PowerShell or Bash tools.

**Why:** User has explicitly requested that git commands should not be executed automatically.

**How to apply:** 
- Do NOT run any git commands through PowerShell or Bash tools
- If git information is needed, ask the user to run the command themselves
- Only read git-related files if absolutely necessary, but never execute git binaries
- This applies to all git operations: status, log, diff, commit, push, pull, checkout, etc.
