# Configuration

> Every .env value: what it controls, which service reads it, defaults, ranges and recipes.

Pulsimo is controlled in two places:

- **In the app**, for anything that is about *what* you monitor and *who* gets told:
  endpoints, alert policies, channels, mutes, log-incident rules, SLOs, project targets,
  users and sign-in security. These take effect at once, with no restart.
- **In `.env`**, for how the platform itself runs: addresses, secrets, email server,
  how much work runs in parallel, how often background jobs run, default thresholds,
  and how long data is kept. These take effect when the service that reads them is
  recreated.

This chapter is the complete list of the `.env` values, what each one does in practice,
which service reads it, and when you would change it. Every value here was traced to
the code that reads it; values that are not listed do nothing.

## How to change a value

1. Edit `.env` next to `docker-compose.yml` (start from `.env.example` if you have none).
2. Recreate the services that read the value (the **Service** column below):

   ```bash
   docker compose up -d api-gateway metrics-collector
   ```

   With the published images, add the prod file:

   ```bash
   docker compose -f docker-compose.prod.yml up -d api-gateway metrics-collector
   ```

   `up -d` recreates only containers whose settings changed. No image rebuild is
   needed for any value in this chapter. `docker compose restart` is **not** enough:
   it restarts the old container with the old environment.
3. Check that the service picked it up:

   ```bash
   docker compose logs --tail 30 metrics-collector
   ```

   Observability → System Health also shows the retention and interval values the
   platform is running with.

Numbers outside their allowed range (shown below) are pulled into the range. A value
that is not a number at all either falls back to the default or, for the
metrics-collector's scraping settings, stops the service with
`Invalid value for MAX_SCRAPE_BODY_MB` (or similar) in its logs. Either way, check the
logs after a change.

## 1. Addresses, ports and release

| Variable | Default | Service | What it does |
|---|---|---|---|
| `HOST_IP` | `localhost` | frontend | Address people's browsers use to reach the API: the web app calls `http://HOST_IP:EXPOSE_API_PORT`. Set it to the server's IP or name, or nobody but the server itself can sign in. |
| `NEXT_PUBLIC_API_URL` | empty | frontend | Full API address, e.g. `https://pulsimo.example.com`. When set, wins over `HOST_IP`. Use it behind a reverse proxy or HTTPS. |
| `NEXT_PUBLIC_WS_URL` | empty | frontend | Live-update address, e.g. `wss://pulsimo.example.com`. Set together with the one above. |
| `EXPOSE_FRONTEND_PORT` | `3000` | frontend | Host port of the web app. |
| `EXPOSE_API_PORT` | `8080` | api-gateway, frontend | Host port of the API. The web app is told this port too, so recreate both. |
| `EXPOSE_POSTGRES_PORT` | `5432` | postgres | Host port of PostgreSQL. Close it in a firewall in production. |
| `EXPOSE_REDIS_PORT` | `6379` | redis | Host port of Redis. Close it in a firewall in production. |
| `LOG_INGEST_PUBLIC_URL` | empty | api-gateway | Address written into the Fluent Bit configs that Logs → Sources generates, and into the remote_write snippets of Infrastructure → Connect. Empty means "the address the browser is using", which is wrong when admins use an internal name but servers reach Pulsimo through a public one. |
| `PULSIMO_VERSION` | – | all (prod file) | Tag of every `pulsimo/*` image in `docker-compose.prod.yml`. Change it to upgrade or roll back, then `up -d`. |
| `APP_VERSION` | `v1beta1` | frontend (prod file) | Version text shown in the web app. |

The web app reads its addresses when its container starts, so changing them needs only
`docker compose up -d frontend`, not a rebuild.

## 2. Secrets

Change all three before anyone else can reach the server.

| Variable | Service | What it does | Changing it later |
|---|---|---|---|
| `POSTGRES_PASSWORD` | postgres, every service through `DATABASE_URL` | Database password. | PostgreSQL only reads it when the data volume is first created. To change it later, change it in the database first (`ALTER USER monitoring PASSWORD '...'`), then in `.env`, then `docker compose up -d`. Changing only `.env` leaves every service unable to connect. |
| `JWT_SECRET` | api-gateway | Signs sign-in tokens. Generate with `openssl rand -base64 32`. | Everyone is signed out and signs in again. API keys keep working (they are stored hashed, not signed). |
| `METRICS_SECRET_KEY` | api-gateway, metrics-collector | Encrypts the passwords and tokens of metric sources. Must be the same in both services. | Saved source credentials can no longer be read: re-enter them on each source that uses authentication. |

## 3. Database and Redis

| Variable | Default | Service | What it does |
|---|---|---|---|
| `POSTGRES_DB` / `POSTGRES_USER` | `monitoring_system` / `monitoring` | postgres, all | Database name and user. Like the password, only read when the volume is created. |
| `DATABASE_URL` | built from the above | all Rust services, migrations | Connection string. Point it at an external PostgreSQL to run without the bundled one. |
| `POSTGRES_PORT` | `5432` | maintenance-scheduler | Port PostgreSQL listens on inside the Docker network (not the host port). |
| `REDIS_URL` | `redis://redis:6379` | api-gateway, checker, notification, dependency-tracker | Redis carries live updates, alert events and test messages between services. |
| `MIGRATIONS_FORCE_RERUN` | `false` | migrations | `true` re-applies every migration once on the next start. Only for repairing a database restored from an old dump; set it back to `false` afterwards. |

## 4. Email and alert delivery

| Variable | Default | Service | What it does |
|---|---|---|---|
| `SMTP_HOST` / `SMTP_PORT` | `smtp.gmail.com` / `587` | notification | Mail server. Port `587` uses STARTTLS, `465` uses TLS. |
| `SMTP_USERNAME` / `SMTP_PASSWORD` | – | notification | Mail account. Gmail and Microsoft 365 need an **App Password**, not the account password; with the account password the channel test shows "Application-specific password required". |
| `FROM_EMAIL` / `FROM_NAME` | – / `Pulsimo Monitoring` | notification | Sender shown on alert emails. Many providers require `FROM_EMAIL` to be the account itself or a verified alias. |
| `DIGEST_INTERVAL_MINUTES` | `60` | notification, api-gateway | Low-urgency findings (anomalies, capacity forecasts, log spikes that did not become incidents) are collected and sent as one digest per organization this often, to the channels that take every severity. Lower it to hear sooner, raise it for fewer messages. |
| `PULSIMO_PUBLIC_URL` | `http://HOST_IP:EXPOSE_FRONTEND_PORT` | notification | The address people open Pulsimo at. Alarm messages end with *Open in Pulsimo: <this>/dashboard/alarms?open=<id>*. Set it to your real address (e.g. `https://pulsimo.example.com`) when Pulsimo is behind a domain. |

Slack, Discord, Microsoft Teams, Google Chat and webhook channels need no `.env` values: they are set
up in **Alerts** ([Channels and delivery](../features/alerts.md)). Email channels only work once the SMTP values are filled
in; the channel test says so if they are not.

## 5. Endpoint checks and incidents

How often each endpoint is checked, its timeout, retries, failure threshold and alert
policy are set **on the endpoint** (Services → Endpoints), not in `.env`.

| Variable | Default | Range | Service | What it does |
|---|---|---|---|---|
| `MAX_CONCURRENT_CHECKS` | `300` | 10–5000 | checker | Checks that may run at the same moment across all endpoints. Raise it if System Health shows growing check lag with many endpoints or slow targets; lower it on a small server. |
| `INCIDENT_REOPEN_MINUTES` | `10` | 0+ | checker, metrics-collector | A failure that comes back within this many minutes of recovery reopens the last incident instead of opening a new one, so a flapping service is one incident, not twenty. `0` always opens a new one. Applies to endpoint and log incidents. |

## 5b. Alarm rules

| Variable | Default | Range | Service | What it does |
|---|---|---|---|---|
| `ALARM_EVAL_SECONDS` | `30` | 10–300 | metrics-collector | How often alarm rules ([Alarms and rules](../features/alarms.md)) are evaluated: log counts, traffic, metrics, incidents, failing checks. A rule's *For* time still applies on top. Raise it on a busy installation with many log or PromQL rules. |

## 6. Logs

| Variable | Default | Range | Service | What it does |
|---|---|---|---|---|
| `LOGS_RETENTION` | `7d` | VictoriaLogs units (`7d`, `30d`, `1w`) | victorialogs, api-gateway | How long log lines are kept. Recreate `victorialogs`; lowering it deletes older lines. |
| `LOG_INGEST_MAX_LINES_PER_SEC` | `2000` | 1+ | api-gateway | Lines per second accepted per log source when the source has no limit of its own (Logs → Sources). Extra lines are refused with 429 and Fluent Bit retries them. |
| `LOG_INGEST_MAX_LINE_BYTES` | `16384` | 256–1048576 | api-gateway | Longer lines are cut to this size. Raise it for large stack traces. |
| `LOG_AGENT_IMAGE` | `fluent/fluent-bit:3.1` | – | api-gateway | Fluent Bit image used in the generated `docker run` commands. |
| `LOG_PATTERN_INTERVAL_SECONDS` | `60` | 15–3600 | metrics-collector | How often new warning and error lines are grouped into patterns. |
| `LOG_PATTERN_MAX_LINES` | `5000` | 1+ | metrics-collector | Most lines read in one grouping pass. Raise it if you log many errors per minute and patterns look incomplete. |

## 7. Incidents from logs

These are the **defaults**. Each endpoint can override them in the app (Endpoint → Logs →
Incidents from errors in these logs → Change thresholds, [Incidents from logs](../features/logs/incidents-from-logs.md)), and those
overrides win over `.env`.
Recreate both `metrics-collector` (which runs the rules) and `api-gateway` (which shows
the defaults and runs the 24-hour test).

| Variable | Default | Range | What it does |
|---|---|---|---|
| `LOG_INCIDENTS_ENABLED` | `true` | `false`/`0`/`off` disables | Turns incidents from logs on or off for the whole installation. Patterns and the Log Browser keep working. |
| `LOG_INCIDENT_WARNING_COUNT` | `5` | 1+ | Errors of one pattern in the window that open a **warning** incident. |
| `LOG_INCIDENT_CRITICAL_COUNT` | `15` | ≥ warning | Errors in the window that make it **critical**. |
| `LOG_INCIDENT_WINDOW_SECONDS` | `300` | 60–3600 | The counting window. |
| `LOG_INCIDENT_SUSTAIN_SECONDS` | `60` | 0–1800 | Errors must keep coming this long before an incident opens. Shorter bursts are only reported in the digest. `0` opens at once. |
| `LOG_INCIDENT_RESOLVE_QUIET_SECONDS` | `600` | 60–86400 | No errors of the incident's patterns for this long resolves it automatically. |
| `LOG_INCIDENT_BASELINE_FACTOR` | `3` | ≥ 1 | A pattern that is always present must reach this many times its usual rate, so background noise does not page anyone. |
| `LOG_INCIDENT_CRITICAL_AFTER_SECONDS` | `900` | ≥ 60 | A warning still firing after this long becomes critical. |
| `LOG_INCIDENT_EVAL_SECONDS` | `30` | 10–300 | How often the rules are evaluated. |
| `LOG_INCIDENT_LAG_SECONDS` | `20` | 0–300 | The window ends this far behind now, so lines that arrive a little late are still counted. Raise it if your shippers buffer for longer. |

## 8. Metrics

| Variable | Default | Range | Service | What it does |
|---|---|---|---|---|
| `METRICS_RETENTION` | `30d` | days, up to `90d` | victoriametrics, api-gateway | How long metrics are kept. Recreate `victoriametrics`; values above 90 days are cut to 90, and lowering it deletes older data. Rough disk use: 50,000 series every 15 s is about 0.3 GB a day. |
| `MAX_CONCURRENT_SCRAPES` | `200` | 1+ | metrics-collector | Metric sources fetched at the same moment. |
| `MAX_SCRAPE_BODY_MB` | `20` | 1+ | metrics-collector | A `/metrics` response larger than this is refused and the source shows an error. Raise it for very large exporters (e.g. kube-state-metrics on big clusters). |
| `TARGET_RELOAD_INTERVAL_SECONDS` | `30` | 1+ | metrics-collector | How soon a new, edited or paused metric source is picked up. |
| `DISCOVERY_INTERVAL_SECONDS` | `300` | 60+ | metrics-collector | How often routes, databases, hosts and containers are looked for in the metrics (Discovered services, [Discovered services](../features/metrics/discovery.md)). |
| `DEPENDENCY_SCAN_MINUTES` | `30` | 5–1440 | metrics-collector | How often dependency suggestions are looked for ([Dependencies](../features/dependencies.md)). |

## 9. System Health page

| Variable | Default | Range | Service | What it does |
|---|---|---|---|---|
| `SYSTEM_HEALTH_PROBE_SECONDS` | `30` | 10–600 | api-gateway | How often every Pulsimo component is probed. |
| `SYSTEM_HEALTH_TIMEOUT_SECONDS` | `5` | 1–60 | api-gateway | A probe without an answer in this time counts as down. |
| `SYSTEM_HEALTH_SLOW_MS` | `1000` | 1+ | api-gateway | Answers slower than this show the component as degraded. |
| `SYSTEM_HEALTH_SKIP` | empty | – | api-gateway | Components you do not run, comma separated (`vmalert,victorialogs,dependency-tracker`), so they are not shown as down. |

## 10. Data retention and maintenance

The maintenance-scheduler deletes old rows and keeps the database fast. Recreate
`maintenance-scheduler` after changes. Observability → Database Health shows the current
values and when each job last ran.

| Variable | Default | What it does |
|---|---|---|
| `HEALTH_RETENTION_DAYS` | `90` | Days of individual check results kept. Uptime, analytics and charts only reach back this far. |
| `HEALTH_RETENTION_MODERATE_DAYS` | `60` | Used instead once the database is larger than `DB_SIZE_WARN_MB`. |
| `HEALTH_RETENTION_AGGRESSIVE_DAYS` | `30` | Used instead once the database is larger than `DB_SIZE_CRITICAL_MB`. |
| `DB_SIZE_WARN_MB` / `DB_SIZE_CRITICAL_MB` | `1000` / `2000` | Database sizes that switch to the shorter retentions above. Raise them on a server with plenty of disk. |
| `EVENT_TRAIL_RETENTION_DAYS` | `180` | Days of the event trail (who changed what) kept. |
| `ALERT_HISTORY_RETENTION_DAYS` | `30` | Days of alert history kept. |
| `INCIDENT_RETENTION_DAYS` | `90` | Resolved incidents older than this are deleted. Open incidents are never deleted. |
| `NOTIFICATION_RETENTION_DAYS` | `60` | Delivered alerts (Alerting → Delivery log) older than this are deleted. |
| `ALARM_RETENTION_DAYS` | `90` | Resolved alarms, with their timelines, older than this are deleted. Open alarms are never deleted. |
| `API_METRICS_RETENTION_DAYS` | `30` | Requests to Pulsimo's own API (Pulsimo → API metrics) older than this are deleted. |
| `CLEANUP_CRON` | `0 2 * * *` | Daily cleanup and `VACUUM ANALYZE`. |
| `AGGREGATION_CRON` | `5 * * * *` | Hourly roll-ups of check results. |
| `DEEP_CLEANUP_CRON` | `0 3 * * 0` | Weekly: expired silences, the event trail, orphaned status history, `REINDEX`. |
| `TZ` | `UTC` | Time zone the three schedules above run in. Check results are always stored in UTC. |

A fixed job also records database statistics every 6 hours.

## 11. Log levels

| Variable | Service |
|---|---|
| `API_LOG_LEVEL` | api-gateway |
| `CHECKER_LOG_LEVEL` | checker |
| `NOTIFICATION_LOG_LEVEL` | notification |
| `METRICS_LOG_LEVEL` | metrics-collector |
| `DEPENDENCY_LOG_LEVEL` | dependency-tracker |

Values: `trace`, `debug`, `info` (default), `warn`, `error`. Use `debug` on one service
while investigating, then set it back: `debug` is noisy and fills the container logs.

## 12. Internal addresses

Only change these if you rename services or run one of them outside this Compose file.

| Variable | Default | Used by |
|---|---|---|
| `API_HOST` / `API_PORT` | `0.0.0.0` / `8080` | api-gateway (listen address inside the container) |
| `CHECKER_SERVICE_URL` | `http://checker:8081` | api-gateway (System Health) |
| `NOTIFICATION_SERVICE_URL` | `http://notification:8082` | api-gateway (System Health) |
| `DEPENDENCY_TRACKER_SERVICE_URL` | `http://dependency-tracker:8083` | api-gateway |
| `MAINTENANCE_SERVICE_URL` | `http://maintenance-scheduler:3007` | api-gateway (Database Health, run jobs now) |
| `METRICS_COLLECTOR_URL` | `http://metrics-collector:8084` | api-gateway (scrape now, tests) |
| `METRICS_STORE_URL` | `http://victoriametrics:8428` | api-gateway, checker, notification |
| `LOGS_URL` | `http://victorialogs:9428` | api-gateway, notification, metrics-collector |
| `VMALERT_URL` | `http://vmalert:8880` | api-gateway, metrics-collector |
| `FRONTEND_INTERNAL_URL` | `http://frontend:3000` | api-gateway (System Health) |
| `CHECKER_HEALTH_PORT`, `NOTIFICATION_HEALTH_PORT`, `DEPENDENCY_TRACKER_PORT`, `MAINTENANCE_PORT` | `8081`, `8082`, `8083`, `3007` | the service's own health/API port |

## Controlled in the app, not in `.env`

| What | Where | Chapter |
|---|---|---|
| Check interval, timeout, retries, expected status, failure threshold | Services → Endpoints → edit | – |
| Who is alerted for an endpoint, slow-response warning, escalation | Endpoint → edit → Alert Policy | 21, 25 |
| Alarm rules (logs, traffic, metrics, incidents, checks), maintenance windows | Alerting → Rules, Maintenance | 25 |
| Which severities and projects a channel takes | Alerting → Channels → the channel | 21, 25 |
| Alert channels, which kinds of alert each receives, pausing a channel | Alerting → Channels | 21 |
| Silencing an endpoint's alerts for a while, muting an error pattern | Endpoint card → Silence; Log Browser → Patterns → Mute | 13, 16 |
| Log-incident thresholds per endpoint, or turning them off | Endpoint → Logs → Incidents from errors in these logs | 16 |
| Metric sources: interval, timeout, auth, lines-per-second limit for log sources | Metrics → Sources, Logs → Sources | 1, 13 |
| Reliability targets and burn-rate alerts | SLOs | 7 |
| Project uptime target (error budget) | Projects → project → target | 23 |
| Sign out after inactivity, lock after failed sign-ins, password rules, token lifetime | Settings → Security | 22 |
| Roles, deactivating people, signing someone out everywhere | Users | 20 |

## Fixed values (not configurable)

These are built in. They are listed so you know what to expect, not to change.

| Behaviour | Value |
|---|---|
| "Down" alerts per endpoint | at most 3 per hour; further failures go to the incident, not to channels |
| Alarm reminders, and alarms held for maintenance | checked every minute; only critical alarms repeat unless a rule says otherwise |
| Certificate expiry rule | evaluated every 5 minutes |
| Slow-response warning (endpoint policy) | after 5 minutes of slow answers (at least 2 checks), resolved after 2 fast checks |
| Deploy grace: a Down alert right after a detected deploy or restart is held, and sent only if still down after | 180 s |
| Response-time anomaly: smallest slowdown reported | 100 ms |
| Metric anomalies (traffic drop/spike, latency, 5xx) evaluated | every 10 min; routes under 0.05 req/s ignored |
| SLO burn-rate alerts | checked every 5 min; fast burn 14.4×, slow burn 6× |
| Capacity forecasts | every 15 min; "full within 1 day" alerts, "within 3 days" goes to the digest |
| Change markers (deploys, restarts, new routes) | detected every 60 s |
| Metrics around an incident | scraped every 5 s for 30 min after it opens; 30 min before it saved as evidence |
| Status board on Services → Overview | 48 slots of 30 min (last 24 h) |
| Users shown as online | seen in the last 5 min; "dormant" after 30 days |
| Dashboards | up to 300 panels, 50 saved versions |

## Recipes

**Run Pulsimo on a server people reach by IP**

```bash
HOST_IP=10.0.0.15
```
```bash
docker compose up -d frontend
```

**Put Pulsimo behind HTTPS on a domain** (reverse proxy forwarding `/api` and `/ws` to
port 8080 and everything else to 3000)

```bash
NEXT_PUBLIC_API_URL=https://pulsimo.example.com
NEXT_PUBLIC_WS_URL=wss://pulsimo.example.com
LOG_INGEST_PUBLIC_URL=https://pulsimo.example.com
```
```bash
docker compose up -d frontend api-gateway
```

**Send alert emails through Gmail**: create an App Password (Google Account → Security →
App passwords), then:

```bash
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=alerts@yourcompany.com
SMTP_PASSWORD=<16-character app password>
FROM_EMAIL=alerts@yourcompany.com
```
```bash
docker compose up -d notification
```

Then use **Send test** on an email channel in Alerting → Channels.

**Fewer pages from noisy logs**: raise the thresholds and the time errors must last.

```bash
LOG_INCIDENT_WARNING_COUNT=20
LOG_INCIDENT_CRITICAL_COUNT=60
LOG_INCIDENT_SUSTAIN_SECONDS=180
```
```bash
docker compose up -d metrics-collector api-gateway
```

Prefer an override on the endpoint (Endpoint → Logs → Change thresholds) when only one
service is noisy.

**Keep more history on a server with plenty of disk**

```bash
METRICS_RETENTION=90d
LOGS_RETENTION=30d
HEALTH_RETENTION_DAYS=180
DB_SIZE_WARN_MB=10000
DB_SIZE_CRITICAL_MB=20000
```
```bash
docker compose up -d victoriametrics victorialogs maintenance-scheduler
```

**Many endpoints, checks running late** (System Health shows check lag):

```bash
MAX_CONCURRENT_CHECKS=1000
```
```bash
docker compose up -d checker
```

**Hear about small findings more often**

```bash
DIGEST_INTERVAL_MINUTES=15
```
```bash
docker compose up -d notification api-gateway
```

## Removed values

Earlier versions of `.env.example` listed values that no service reads. They have been
removed from `.env.example` and the Compose files; if they are still in your `.env`,
they are ignored and you can delete them.

| Value | Why it did nothing | Use instead |
|---|---|---|
| `CHECK_INTERVAL_SECONDS` | Each endpoint has its own interval | The endpoint's interval |
| `CHECK_TIMEOUT_SECONDS` | Each endpoint has its own timeout | The endpoint's timeout |
| `IMPACT_CALCULATION_INTERVAL_SECONDS` | Impact is recalculated every 30 s, fixed | – |
| `DISCOVERY_INTERVAL_SECONDS` (on dependency-tracker) | Not read there | Now passed to metrics-collector, where discovery runs |

Two values the code reads were not passed to their containers before, so the defaults
always applied. They are now: `TARGET_RELOAD_INTERVAL_SECONDS` and
`DISCOVERY_INTERVAL_SECONDS` (metrics-collector), and `DIGEST_INTERVAL_MINUTES` on the
api-gateway, so the digest interval shown in the app matches the one in use.

---

← [Architecture](../architecture.md) · [Contents](../README.md) · [Projects and overview](../features/projects.md) →
