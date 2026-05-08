---
name: Odoo 18 uses list not tree
description: In Odoo 18, use <list> tag instead of <tree> for list views
type: feedback
originSessionId: 88ea4c87-1f4e-4765-b448-f79f0049550c
---
In Odoo 18, list views use `<list>` tag instead of `<tree>`.

**Why:** Odoo 18 renamed the view type from "tree" to "list" to better reflect its purpose. Using `<tree>` will cause a validation error.

**How to apply:** 
- When creating list views in Odoo 18 XML files, always use `<list>` opening and closing tags
- In context, use `list_view_ref` instead of `tree_view_ref`
- In view_mode, use `list` instead of `tree`
- Allowed view types in Odoo 18 are: list, form, graph, pivot, calendar, kanban, search, qweb, hierarchy, timeline, activity
