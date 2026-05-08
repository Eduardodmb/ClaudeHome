# VCard Manager — Laravel + Docker

## Context
Build a multi-admin SaaS vCard platform from scratch in an empty git repo.
Admins buy seats; each seat lets them publish one employee vCard page styled like the Ryan vCard template (sidebar profile + tabbed content: About / Resume / Skills / Portfolio).
Super-admin manages all admins and their seat balances. No payment gateway yet — seat allocation is manual.

---

## Stack
- PHP 8.3-FPM + Laravel 11
- MySQL 8 via Docker Compose
- Nginx Alpine reverse proxy
- Node 20 (Vite + Tailwind CSS + Alpine.js)
- No extra Composer packages beyond base Laravel

---

## Data Model

```
users               id, name, email, password, role(enum: super_admin|admin), seats_total(int default 0)
customers           id, user_id FK, name, company, email, phone, logo, slug(unique), active, timestamps
employees           id, customer_id FK, name, title, bio, avatar, email, phone,
                    linkedin, github, twitter, website, slug, active, timestamps
                    UNIQUE(customer_id, slug)
employee_skills     id, employee_id FK, name, level(0-100), sort_order
employee_experiences id, employee_id FK, company, role, start_date, end_date nullable, description, sort_order
employee_portfolio   id, employee_id FK, title, category, description, image, url, sort_order
seat_transactions   id, user_id FK, seats, notes, created_by FK users, timestamps
```

Seat check: `$user->employees()->where('active',true)->count() >= $user->seats_total`

---

## Routes

| Method | URI | Controller |
|--------|-----|------------|
| GET/POST | /login | Auth\LoginController |
| POST | /logout | Auth\LoginController |
| GET | /admin | Admin\DashboardController |
| GET/POST | /admin/customers | Admin\CustomerController (index/create/store) |
| GET/PUT/DELETE | /admin/customers/{id}/edit | Admin\CustomerController (edit/update/destroy) |
| GET/POST | /admin/customers/{customer}/employees | Admin\EmployeeController (index/create/store) |
| GET/PUT/DELETE | /admin/customers/{customer}/employees/{employee}/edit | Admin\EmployeeController |
| GET | /admin/seats | Admin\SeatController (my balance) |
| GET/POST | /admin/users | Admin\UserController (super_admin only) |
| GET | /{customerSlug}/{employeeSlug} | VCardController |

---

## Seat Logic
- `users.seats_total` = total seats purchased (updated by super_admin via SeatTransaction)
- `seats_used` = active employees count across all customers of that admin
- Creating an employee: check `seats_used < seats_total`, abort(403) otherwise
- Deactivating employee frees a seat immediately

---

## File List to Create

### Infrastructure
- `docker-compose.yml` ✓
- `Dockerfile` ✓
- `docker/nginx/default.conf` ✓
- `.env.example` ✓
- `setup.sh`
- `Makefile`

### Database
- `database/migrations/2024_01_01_000000_add_role_seats_to_users.php`
- `database/migrations/2024_01_01_000001_create_customers_table.php`
- `database/migrations/2024_01_01_000002_create_employees_table.php`
- `database/migrations/2024_01_01_000003_create_employee_skills_table.php`
- `database/migrations/2024_01_01_000004_create_employee_experiences_table.php`
- `database/migrations/2024_01_01_000005_create_employee_portfolio_table.php`
- `database/migrations/2024_01_01_000006_create_seat_transactions_table.php`
- `database/seeders/DatabaseSeeder.php` (seeds super_admin + 3 admins)

### App Layer
- `app/Models/User.php`
- `app/Models/Customer.php`
- `app/Models/Employee.php`
- `app/Models/EmployeeSkill.php`
- `app/Models/EmployeeExperience.php`
- `app/Models/EmployeePortfolio.php`
- `app/Models/SeatTransaction.php`
- `app/Http/Controllers/Auth/LoginController.php`
- `app/Http/Controllers/Admin/DashboardController.php`
- `app/Http/Controllers/Admin/CustomerController.php`
- `app/Http/Controllers/Admin/EmployeeController.php`
- `app/Http/Controllers/Admin/SeatController.php`
- `app/Http/Controllers/Admin/UserController.php` (super_admin)
- `app/Http/Controllers/VCardController.php`
- `app/Http/Middleware/EnsureAdmin.php`
- `app/Http/Requests/StoreEmployeeRequest.php`
- `routes/web.php`
- `bootstrap/app.php`

### Views (Blade + Tailwind + Alpine.js)
- `resources/views/layouts/admin.blade.php`
- `resources/views/auth/login.blade.php`
- `resources/views/admin/dashboard.blade.php`
- `resources/views/admin/customers/index.blade.php`
- `resources/views/admin/customers/create.blade.php`
- `resources/views/admin/customers/edit.blade.php`
- `resources/views/admin/employees/index.blade.php`
- `resources/views/admin/employees/form.blade.php` (shared create/edit)
- `resources/views/admin/seats/index.blade.php`
- `resources/views/admin/users/index.blade.php`
- `resources/views/vcard/show.blade.php` ← Ryan-style public page

### Assets
- `tailwind.config.js`
- `resources/css/app.css`
- `resources/js/app.js`

---

## vCard Public Page Design
- Split layout: dark slate-900 sidebar (w-72) + white main content
- Sidebar: circular avatar, name, amber-500 title badge, contact icons, social links
- Main: sticky tab bar (About / Resume / Skills / Portfolio), Alpine.js tab switching
- Skill bars: animated width based on level %
- Experience: vertical timeline with dots
- Portfolio: 3-column grid with image hover overlay

---

## Seeded Accounts
| Email | Password | Role | Seats |
|-------|----------|------|-------|
| super@vcardapp.com | password | super_admin | 0 |
| admin1@vcardapp.com | password | admin | 5 |
| admin2@vcardapp.com | password | admin | 3 |
| admin3@vcardapp.com | password | admin | 3 |

---

## Setup Flow (for developer)
```bash
bash setup.sh         # creates .env, runs create-project, migrate, seed
docker compose up     # starts nginx + app + mysql
# open http://localhost:8080/login
```

---

## Verification
1. Login as super@vcardapp.com → see all users, add seats
2. Login as admin1 → create a customer, add employees up to seat limit
3. Try to add employee beyond seat limit → get 403 error message
4. Visit /{customerSlug}/{employeeSlug} → see vCard page
5. Upload avatar/logo → confirm file served correctly
