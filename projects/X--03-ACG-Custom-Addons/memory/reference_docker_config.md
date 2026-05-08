---
name: Docker / Odoo Server Configuration
description: Docker setup for the Odoo 18 instance — use to find upgrade commands, db name, container names, ports
type: reference
originSessionId: a572bd87-2e28-4d70-9b73-cd08231cacb6
---
Docker configuration for the Odoo 18 instance is at: `X:\03_ACG\Odoo_Docker`

## Key details
- **Container name:** `odoo_docker-web-1`
- **Database:** `postgres`
- **Compose file:** `X:\03_ACG\Odoo_Docker\docker-compose.yml`
- **Custom addons volume:** `X:/03_ACG/Custom_Addons` → `/mnt/extra-addons`

## Upgrade a module
```
docker exec -it odoo_docker-web-1 odoo -d postgres -u <module_name> --stop-after-init
```
After upgrade, the container restarts automatically (restart: always). Wait ~30s then refresh the browser.
