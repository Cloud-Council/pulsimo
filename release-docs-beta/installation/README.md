# Installation

> Run Pulsimo on your own server with Docker Compose and the published images.

Pulsimo runs on your own server with Docker Compose. Everything it needs, including
PostgreSQL, Redis, VictoriaMetrics and VictoriaLogs, starts in the same Compose project,
so one Linux machine is enough to get going.

## Requirements

| | Minimum | Recommended for production |
|---|---|---|
| CPU | 4 vCPU | 8 vCPU |
| Memory | 8 GB | 16 GB |
| Disk | 20 GB free | 50 GB SSD, more if you keep long metric and log history |
| Software | Docker 20.10+ with Docker Compose v2 | the same |
| OS | Linux (Ubuntu 20.04+, Debian 11+ or similar) | the same |

Browsers reach the web app on port **3000** and the API on port **8080**. Both can be
changed in `.env`. Check that Docker works before you start:

```bash
docker --version
docker compose version
```

## Get the files

Everything needed to run Pulsimo is in this repository: the Compose file, the `.env`
template and the setup script. No source code is needed; the services run from published
`pulsimo/*` images.

```bash
git clone https://github.com/Cloud-Council/pulsimo.git
cd pulsimo
```

## Install with the setup script

The script checks Docker and the machine's resources, detects the server's IP address,
writes `.env` with a generated database password and JWT secret, starts every service and
waits until the web app and the API answer.

```bash
chmod +x setup-prod.sh
./setup-prod.sh
```

The script does not generate `METRICS_SECRET_KEY`. When it pauses with "Press Enter to
continue with deployment", open `.env` in another terminal and replace that placeholder
with the output of `openssl rand -base64 32`, then press Enter.

When it finishes, open `http://<server-ip>:3000` and continue with
[First sign-in](#first-sign-in).

## Install by hand

1. **Create the configuration.** Start from the template that ships next to the Compose
   file:

   ```bash
   cp .env.example .env
   ```

2. **Set the address and the secrets.** At a minimum, set the address people will use and
   replace the three secrets:

   ```bash
   HOST_IP=192.168.1.100                     # the server's IP or name
   POSTGRES_PASSWORD=<openssl rand -base64 24>
   JWT_SECRET=<openssl rand -base64 32>
   METRICS_SECRET_KEY=<openssl rand -base64 32>
   ```

   `HOST_IP` matters: the web app calls the API at `http://HOST_IP:8080`, so with the default
   `localhost` nobody but the server itself can sign in. Behind a domain or HTTPS, set
   `NEXT_PUBLIC_API_URL` and `NEXT_PUBLIC_WS_URL` instead (see
   [Configuration](../configuration/environment-variables.md)).

3. **Start Pulsimo.**

   ```bash
   docker compose -f docker-compose.prod.yml pull
   docker compose -f docker-compose.prod.yml up -d
   ```

   The `migrations` container prepares the database and exits; every other service waits
   for it and for PostgreSQL to be healthy.

4. **Check that everything is up.**

   ```bash
   docker compose -f docker-compose.prod.yml ps
   curl -s http://localhost:8080/health
   ```

## First sign-in

1. Open `http://<HOST_IP>:3000`.
2. Sign in as `superadmin@pulsimo.io` with the password `admin` (created by the database
   migrations), and change that password at once: **Users** → **Reset password** on your own row.
   Self sign-up is turned off in this release.
3. Add someone else as an administrator too (Users → Add user), so you are never locked
   out of user management. See [Users and access](../features/users.md).

Then follow the [Quick start](../getting-started.md) to add your first endpoint and alert
channel.

## What runs

| Service | What it does |
|---|---|
| `frontend` | The web app (port 3000) |
| `api-gateway` | REST API and live updates for the web app (port 8080); log ingestion |
| `checker` | Runs endpoint checks and evaluates monitors that use metrics |
| `notification` | Sends alerts to Slack, Discord, Teams, Google Chat, email and webhooks |
| `metrics-collector` | Scrapes metric sources, discovery, SLOs, anomalies, capacity, alarm rules |
| `dependency-tracker` | Builds the dependency map |
| `maintenance-scheduler` | Retention, roll-ups and database upkeep on a schedule |
| `migrations` | Applies database migrations on start, then exits |
| `postgres` | Configuration, checks, incidents and users (PostgreSQL 17) |
| `redis` | Live updates and events between services |
| `victoriametrics` | Stores metrics (internal only) |
| `victorialogs` | Stores logs (internal only) |
| `vmalert` | Evaluates the recording rules Pulsimo generates |

How they fit together is on the [Architecture](../architecture.md) page.

## Upgrade

Published images are tagged with a version. Set the one you want in `.env` and recreate
the services:

```bash
PULSIMO_VERSION=<new version>
```

```bash
docker compose -f docker-compose.prod.yml pull
docker compose -f docker-compose.prod.yml up -d
```

Database migrations run automatically on start. To roll back, set the previous version
and run the same two commands. Take a database backup before upgrading (see
[Running in production](../production.md)).

## Stop or remove

```bash
docker compose -f docker-compose.prod.yml down      # stop, keep all data
docker compose -f docker-compose.prod.yml down -v   # stop and DELETE all data
```

`down -v` removes the volumes with your database, metrics and logs. There is no undo.

## Next steps

- [Quick start](../getting-started.md): your first endpoint, alert channel and metric source.
- [Configuration](../configuration/environment-variables.md): every `.env` value.
- [Running in production](../production.md): HTTPS, firewall, backups.

---

[Contents](../README.md) · [Quick start](../getting-started.md) →
