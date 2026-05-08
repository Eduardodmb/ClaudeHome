---
name: CMMCUnlock Project State
description: Current build status, what's been completed, and what's next for CMMCUnlock Laravel app
type: project
originSessionId: 8ddff70e-6b6b-4699-8c05-a238dc4b2079
---
CMMCUnlock is a CMMC compliance management Laravel 11 app at X:\02_JZS\06_CMMCUnlock.

**Why:** Building a full-featured CMMC/compliance SaaS platform — frameworks, assessments, risk management, vendor risk, task tracking, audit management, connectors, reports.

## Checkpoint history
- **Checkpoint 1 (Initial commit 2026-04-27):** Backend skeleton — models, migrations, controllers (stubs), seeders, Docker setup, Spatie Permission/ActivityLog.
- **Session 2 (2026-04-27, uncommitted):** Full UI buildout — all 40+ blade views rebuilt from stubs to real UI using app layout component with sidebar nav, breadcrumbs, flash messages.
- **Session 3 (2026-04-28):** Backend completions:
  - Created `app/Models/Connector.php` (was missing, ConnectorController used raw SQL)
  - Refactored `ConnectorController` to use Eloquent + route model binding
  - Completed `ReportController` — all 6 report types now export CSV (compliance_dashboard, document_inventory, control_activities were stubs)
  - Created `app/Mail/QuestionnaireInvitation.php` + `resources/views/emails/questionnaire-invitation.blade.php`
  - Updated `QuestionnaireController.send()` to actually send email to vendor primary contact
  - Implemented `VendorController.bulkImport()` — CSV import with optional primary contact columns
  - Implemented `UserController.bulkImport()` — CSV import, assigns random password (user must use forgot-password flow)
  - Added Import CSV modal to vendors/index and users/index views

## Session 4 (2026-04-28):
- Created `resources/views/components/layouts/public.blade.php` — unauthenticated layout for vendor-facing pages
- Built `vendors/show.blade.php` — full detail: contacts, questionnaires, linked controls, delete zone
- Built `vendors/edit.blade.php` — full edit form with contact sync (Alpine.js)
- Fixed `VendorController.update()` to sync contacts on save
- Built `questionnaires/show.blade.php` — meta, status, response token link, full response display
- Built `questionnaires/edit.blade.php` — edit name/due_date with sent-status warning
- Built `questionnaires/public.blade.php` — full vendor-facing form: yes_no, textarea, text, dropdown, file_upload, follow-up conditions
- Built `questionnaires/completed.blade.php` — "already submitted" public page
- Built `questionnaires/thank-you.blade.php` — post-submission confirmation
- Rewrote `routes/web.php` — full permission middleware on every route group using Spatie permissions

## Session 5 (2026-04-28) — Multi-tenancy
- 2 new migrations: `create_customers_table`, `add_customer_id_to_tenant_tables`
- New `Customer` model, `CustomerScope`, `BelongsToCustomer` trait
- Trait applied to: Framework, ControlActivity, Document, Assessment, Risk, Task, Vendor, Questionnaire, Audit, ConnectorConfiguration, Report (new model)
- `User` model: added `customer_id` fillable + `customer()` + `isSuperAdmin()` (no trait — avoids circular auth dependency)
- `CustomerController` + 4 views (index, create, edit, show) — super-admin only
- Routes: `customers.*` behind `can:customers.manage` middleware
- Sidebar: Customers link visible only to super-admins
- Seeders: `super_admin` role added, `customers.manage` permission, demo customer seeded
- `AdminUserSeeder`: admin user is now `super_admin` with `customer_id = null`
- `UserController`: scopes list by customer for non-super-admins; customer dropdown in create for super-admins
- Users index: shows Customer column for super-admins only

**To activate**: run `php artisan migrate` then `php artisan db:seed`

## What still needs to be built
- **Connector sync implementation** — currently just marks `sync_status = in_progress`; real API calls per connector type
- **Database seeder run** — ConnectorSeeder, RolesAndPermissionsSeeder, QuestionnaireTemplateSeeder exist but need to be run
- **ANTHROPIC_API_KEY** — needed for AI recommendations in AssessmentService (add to .env.example)
- **Assessment findings view** — quality of `assessments/findings.blade.php` unverified (not a stub but needs review)
- **Questionnaire index show link** — index view may not have a 'show' link to the new show view
- **Docker/deployment** — ready but untested end-to-end

## Tech stack
- Laravel 11.31, PHP (Docker), SQLite (dev), Tailwind CSS via Vite, Alpine.js, Spatie Permission + ActivityLog, Maatwebsite Excel, DomPDF, Laravel Sanctum

## Key files
- Routes: routes/web.php
- Layout: resources/views/components/layouts/app.blade.php
- Services: app/Services/AssessmentService.php, app/Services/FrameworkImportService.php

**How to apply:** Use this to know what's been done and continue building from the "still needs to be built" list.
