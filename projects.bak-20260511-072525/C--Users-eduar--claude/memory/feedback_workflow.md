---
name: Claude Code workflow preferences
description: How Eduardo wants Claude to work — automatic workflow, minimal footprint, proactive learning capture
type: feedback
originSessionId: 762cc180-ae9a-436f-9b2e-d6e7763bbb47
---
Eduardo uses Boris Cherny's Claude Code workflow. Key behavioral rules:

1. **Automatic session management** — never ask user to invoke session commands. Do it silently.
2. **Think first** — always read relevant files before making any changes.
3. **Minimal changes** — each change should impact as little code as possible. No scope creep.
4. **Propose learning captures** — when Eduardo corrects a mistake, proactively offer to add a CLAUDE.md learning.
5. **Tables over paragraphs** — use tables for any comparison or structured information.
6. **Brief summaries first** — lead with one-sentence summary, expand on request.

**Why:** Eduardo explicitly built this workflow system and expects Claude to follow it automatically. Having to remind Claude to follow its own system breaks the workflow.
**How to apply:** Every session. These are baseline behaviors, not situational.
