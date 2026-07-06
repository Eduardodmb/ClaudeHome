---
name: Docker Odoo workflow for ACG project
description: Project folder structure, Docker commands, and workflow for Odoo development across all project directories
type: project
originSessionId: 88ea4c87-1f4e-4765-b448-f79f0049550c
---
Docker workflow for Odoo development in the ACG project.

**Why:** The Odoo instance runs in Docker containers, and all debugging/upgrades must go through Docker commands. Database is 'odoo18', not 'postgres'. User works across multiple project folders and needs consistent commands regardless of current directory.

**How to apply:**

## Project Folder Structure
- **Custom Addons**: `X:\03_ACG\Custom_Addons` — Odoo custom modules (search_leads, crm_custom_fields, etc.)
- **Docker Config**: `X:\03_ACG\Odoo_Docker` — Docker Compose files and container configuration
- **Documentation**: `X:\03_ACG\Odoo_Docs` — Project documentation and guides

## Container Names
- Odoo container: `odoo_docker-web-1`
- Database container: `odoo_docker-db-1`
- Nginx container: `odoo_docker-nginx-1`

## Database
- Database name: `odoo18` (NOT postgres!)
- User: `odoo`
- Connection: `psql -U odoo -d odoo18`

## Common Commands

### Upgrade Module
```bash
docker exec odoo_docker-web-1 odoo -d odoo18 -u module_name --stop-after-init
```

### Restart Odoo
```bash
cd X:/03_ACG/Odoo_Docker
docker-compose restart web
```

### Check Database Tables
```bash
docker exec odoo_docker-db-1 psql -U odoo -d odoo18 -c "SELECT ..."
```

### View Logs
```bash
docker logs odoo_docker-web-1 --tail=50
```

### Full Restart (if needed)
```bash
cd X:/03_ACG/Odoo_Docker
docker-compose down
docker-compose up -d
```

### Restart Nginx (for 502 errors)
```bash
docker restart odoo_docker-nginx-1
```

## File Paths
- Custom addons: `X:/03_ACG/Custom_Addons` (mounted to `/mnt/extra-addons` in container)
- Config: `/etc/odoo/odoo.conf` (inside container)

## Access Points
- Direct Odoo: http://localhost:8080
- Via Nginx HTTPS: https://odoo-dev.local:8443

## Typical Workflow
1. Edit code in `X:/03_ACG/Custom_Addons/module_name/`
2. Upgrade module: `docker exec odoo_docker-web-1 odoo -d odoo18 -u module_name --stop-after-init`
3. Restart: `cd X:/03_ACG/Odoo_Docker && docker-compose restart web`
4. Test in browser (clear cache: Ctrl+Shift+R)
