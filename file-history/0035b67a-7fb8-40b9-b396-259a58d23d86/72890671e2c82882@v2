---
name: Docker Compose port conflict check
description: Always verify ports are not already in use by other containers before writing docker-compose files
type: feedback
originSessionId: 0035b67a-7fb8-40b9-b396-259a58d23d86
---
When creating or editing docker-compose files, always check that the chosen host ports are not already in use by other running containers on the machine before finalising the configuration.

**Why:** Port conflicts cause containers to fail on startup and are easy to miss — checking upfront avoids broken setups.

**How to apply:** Before writing any `ports:` mapping in a docker-compose file, run `docker ps` (or check existing compose files in the project) to identify occupied ports and pick a free one. Call out any potential conflicts to the user.
