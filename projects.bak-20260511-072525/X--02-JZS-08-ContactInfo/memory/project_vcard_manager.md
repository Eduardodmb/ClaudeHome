---
name: VCard Manager Project
description: Laravel + Docker SaaS vCard platform built in this repo
type: project
originSessionId: 64dd3afc-4c25-419e-b3a7-ddccba378c59
---
Multi-admin vCard platform at X:/02_JZS/08_ContactInfo.

**Stack:** Laravel 11, PHP 8.3-FPM, MySQL 8, Nginx, Node 20, Tailwind CSS, Alpine.js, Vite.

**Setup:** Run `bash setup.sh` once — it scaffolds Laravel via `create-project` (cp -n to preserve custom files), runs migrations/seeds, builds frontend assets.

**Why:** Customer bought a Ryan-vCard-style template theme but needs a full admin system where 3 admins manage customers and employee vCards. Each seat = 1 active employee vCard.

**How to apply:** When working on this project, know that all app-specific files are in repo. Laravel boilerplate (artisan, config/, public/, bootstrap/providers.php, etc.) comes from `create-project` at setup time and is NOT in the repo.

**Seeded accounts:**
- super@vcardapp.com / password (super_admin)
- admin1@vcardapp.com / password (5 seats)
- admin2@vcardapp.com / password (3 seats)
- admin3@vcardapp.com / password (3 seats)

**Key models:** User (role, seats_total), Customer (user_id, slug), Employee (customer_id, slug, active), EmployeeSkill/Experience/Portfolio, SeatTransaction.

**Public URL pattern:** /{customerSlug}/{employeeSlug} → vCard page.
