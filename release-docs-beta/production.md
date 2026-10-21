# Running in production

> Secrets, HTTPS, firewall, backups, retention and upgrades.

A checklist for a Pulsimo that people depend on. Each item links to the details.

## Before anyone else can reach it

- **Change the three secrets** in `.env`: `POSTGRES_PASSWORD`, `JWT_SECRET` and
  `METRICS_SECRET_KEY`. Generate each with `openssl rand -base64 32`. Changing them later
  has side effects (see [Configuration](configuration/environment-variables.md#2-secrets)), so do it
  before the first start.
- **Keep `.env` private**: `chmod 600 .env`, and never commit it.
- **Make a second administrator**, so a locked account or someone leaving never locks you
  out of user management.

## Put it behind HTTPS

Run a reverse proxy (nginx, Caddy, Traefik) on 443 that forwards `/api` and `/ws` to port
8080 and everything else to port 3000. Then tell Pulsimo its public address:

```bash
NEXT_PUBLIC_API_URL=https://pulsimo.example.com
NEXT_PUBLIC_WS_URL=wss://pulsimo.example.com
LOG_INGEST_PUBLIC_URL=https://pulsimo.example.com
PULSIMO_PUBLIC_URL=https://pulsimo.example.com
```

```bash
docker compose up -d frontend api-gateway notification
```

`PULSIMO_PUBLIC_URL` makes every alarm message end with an *Open in Pulsimo* link.

A minimal nginx site:

```nginx
server {
    listen 443 ssl;
    server_name pulsimo.example.com;
    # ssl_certificate and ssl_certificate_key, e.g. from Let's Encrypt

    location /api/ { proxy_pass http://127.0.0.1:8080; proxy_set_header Host $host; }
    location /ws {
        proxy_pass http://127.0.0.1:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
    location / { proxy_pass http://127.0.0.1:3000; proxy_set_header Host $host; }
}
```

## Close what doesn't need to be open

PostgreSQL (5432) and Redis (6379) are published on the host by default for convenience.
Block them in the firewall, or remove their `ports:` from the Compose file. With a reverse
proxy, ports 3000 and 8080 only need to be reachable from the proxy.

```bash
sudo ufw allow 443/tcp
sudo ufw deny 5432/tcp
sudo ufw deny 6379/tcp
```

## Size it

The minimum is 4 vCPU and 8 GB of memory; 8 vCPU, 16 GB and an SSD are better for
production. Disk use grows with retention: about 0.3 GB a day for 50,000 metric series
scraped every 15 seconds, plus your log volume. Watch it on
[System and database health](features/observability/system-health.md).

## Decide how long to keep data

| What | Value | Default |
|---|---|---|
| Metrics | `METRICS_RETENTION` | 30 days (max 90) |
| Logs | `LOGS_RETENTION` | 7 days |
| Check results | `HEALTH_RETENTION_DAYS` | 90 days |
| Resolved incidents | `INCIDENT_RETENTION_DAYS` | 90 days |
| Event trail | `EVENT_TRAIL_RETENTION_DAYS` | 180 days |

Uptime, analytics and charts only reach back as far as the data is kept. All values are in
[Configuration](configuration/environment-variables.md#10-data-retention-and-maintenance).

## Back up

- **Configuration**: Settings → Backup & tools exports projects, endpoints, alert settings
  and the rest to a file you can import again.
- **Database**: back up PostgreSQL regularly, and always before an upgrade:

  ```bash
  docker compose exec -T postgres pg_dump -U monitoring monitoring_system | gzip > pulsimo-$(date +%F).sql.gz
  ```

- **Metrics and logs** live in the `vm_data` and `vl_data` volumes. Include them in volume
  backups if you need the history.

## Start on boot

The Compose services restart with Docker. To bring the whole stack up after a reboot, add a
systemd unit:

```ini
[Unit]
Description=Pulsimo
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/opt/pulsimo
ExecStart=/usr/bin/docker compose -f docker-compose.prod.yml up -d
ExecStop=/usr/bin/docker compose -f docker-compose.prod.yml down

[Install]
WantedBy=multi-user.target
```

## Watch Pulsimo itself

- [System and database health](features/observability/system-health.md) probes every component.
- [Monitoring pipeline](features/observability/pipeline-health.md) shows check lag, scrape success and alert
  delay, so you know Pulsimo itself is keeping up.
- Point a check from *outside* at Pulsimo's own address, so you hear about it if the whole
  server goes down.

## Upgrade safely

1. Back up the database.
2. Set `PULSIMO_VERSION` to the new version in `.env`.
3. `docker compose -f docker-compose.prod.yml pull && docker compose -f docker-compose.prod.yml up -d`.
4. Check **System Health**. To roll back, set the previous version and repeat step 3.

---

← [Webhooks](api/webhooks.md) · [Contents](README.md) · [Best practices](best-practices.md) →
