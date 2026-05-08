# Plan: Add Inline Editing + Popup Wizard Link to Activity Lists

**Status:** Approved - Proceeding without validation

## Context

The user needs activity lists in recruitment applicants, department projects, and employee growth plans to support **both** inline editing for quick changes AND a way to open detailed popup wizards for full ticket editing (including adding updates).

Current issue: Lists were made non-editable to avoid button column alignment issues, but this removed the inline editing capability which is essential.

**Goal:** Restore `editable="bottom"` for inline editing while adding a working button/link to open the detailed popup wizard without column alignment issues.

## Solution Approach

Use the proven pattern from `ticket_system/views/ticket_update_view.xml` (lines 95-116) which successfully combines:
- `editable="bottom"` for inline editing
- Action button at the END of the list (after all fields)
- `type="object"` calling the existing `action_open_as_wizard()` method
- Icon-only button to minimize visual footprint

### Key Pattern (from ticket_update_view.xml):
```xml
<list editable="bottom">
    <field name="date" string="Date"/>
    <field name="user_id" string="User" readonly="1"/>
    <field name="note" string="Update Note"/>
    <button name="%(action_open_activity_update)d" 
            type="action" 
            icon="fa-external-link" 
            string="" 
            title="Open in popup"/>
</list>
```

## Files to Modify

### 1. `X:\03_ACG\Custom_Addons\ticket_system\views\hr_applicant_views.xml`
- **Change:** Add `editable="bottom"` back to `<list>` element
- **Change:** Add button at END of field list: `<button name="action_open_as_wizard" type="object" icon="fa-external-link" title="Open full wizard"/>`
- **Keep:** All existing fields and decorations
- **Remove:** Inline `<form>` view (not needed, will use mail.activity default form)

### 2. `X:\03_ACG\Custom_Addons\ticket_system\views\hr_department_project.xml`
- Same changes as above
- Ensures consistent behavior across all activity tabs

### 3. `X:\03_ACG\Custom_Addons\ticket_system\views\hr_employee_growth_views.xml`
- Same changes as above
- Maintains pattern consistency

## Implementation Details

### Button Placement
- **Position:** LAST element in the list (after all fields)
- **Why:** Buttons at the end don't create column header shift issues
- **Type:** `type="object"` (calls Python method)
- **Method:** `action_open_as_wizard` (already exists in ticket.py lines 343-358)
- **Icon:** `fa-external-link` (standard external link icon)
- **No string:** Empty or no string attribute to show only icon
- **Title:** Tooltip for hover explanation

### Expected XML Structure
```xml
<list editable="bottom" decoration-bf="activity_type_id.category == 'meeting'">
    <field name="res_model" column_invisible="True"/>
    <field name="res_model_id" column_invisible="True"/>
    <field name="activity_type_id"/>
    <field name="summary"/>
    <field name="target_department_id" placeholder="Select Department..." 
           column_invisible="context.get('default_res_model') != 'hr.department'"/>
    <field name="target_document_item_id" placeholder="Select Document..."/>
    <field name="custom_state" widget="badge" 
           decoration-success="custom_state == 'done'" 
           decoration-info="custom_state == 'planned'" 
           decoration-danger="custom_state == 'cancelled'"/>
    <field name="date_deadline"/>
    <field name="user_id"/>
    <button name="action_open_as_wizard" 
            type="object" 
            icon="fa-external-link" 
            title="Open full wizard"/>
</list>
```

## Why This Will Work

1. **Proven Pattern:** This exact pattern works in `ticket_update_view.xml` - editable list with action button at end
2. **Method Exists:** `action_open_as_wizard()` in `ticket.py` properly returns popup action with `target='new'`
3. **No Column Shift:** Button at END doesn't create header alignment issues (tested pattern)
4. **Icon Only:** No string attribute means icon-only rendering, minimal space
5. **Both Capabilities:** 
   - Inline edit: Click field, edit directly
   - Full wizard: Click icon button, opens popup with updates tab

## Verification Steps

After implementation:
1. **Test inline editing:**
   - Open Activities tab in recruitment applicant
   - Click "Add a line" at bottom
   - Fill in fields inline (Activity Type, Summary, etc.)
   - Save - should work without opening popup

2. **Test popup wizard:**
   - Click the external-link icon button on any existing activity row
   - Should open full popup with all fields
   - Check "Updates" tab is available in popup
   - Add an update note
   - Save and close popup

3. **Test column alignment:**
   - Verify all column headers align with their data
   - Button icon appears in last column without header
   - No shifting of columns

4. **Test across all three views:**
   - Recruitment applicants: Activities tab
   - Department projects: Activities tab  
   - Employee growth plans: Activities tab

## Dependencies

- Existing method: `action_open_as_wizard()` in `X:\03_ACG\Custom_Addons\ticket_system\models\ticket.py` (lines 343-358)
- Existing popup form: `mail.mail_activity_view_form_popup` (standard Odoo view)
- Update model: `mail.activity.update` (for updates in popup)

## Notes

- Module upgrade required after XML changes
- No Python code changes needed (method already exists)
- Pattern is already working in ticket_update_view.xml
- This restores original desired functionality: quick inline + detailed popup
