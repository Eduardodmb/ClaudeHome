---
name: Odoo 18 cron job fields
description: In Odoo 18, ir.cron model doesn't have numbercall or doall fields
type: feedback
originSessionId: 88ea4c87-1f4e-4765-b448-f79f0049550c
---
In Odoo 18, the ir.cron model has different fields than older versions.

**Why:** Fields like `numbercall`, `doall`, and complex `nextcall` evaluations cause errors in Odoo 18.

**How to apply:** When creating cron jobs in Odoo 18, use only these fields:
- `name`: Job name
- `model_id`: Reference to model
- `state`: Set to "code"
- `code`: Python code to execute
- `interval_number`: Number (1, 2, etc.)
- `interval_type`: Type (hours, days, weeks, months)
- `active`: Boolean (True/False)

Do NOT use: `numbercall`, `doall`, `nextcall` with complex eval expressions.
