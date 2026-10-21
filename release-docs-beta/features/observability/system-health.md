# System and database health

> Every Pulsimo component probed with real uptime; storage, retention and maintenance jobs.

## What it is

These two pages show whether Pulsimo itself is healthy:

- **System Health** probes every service, data store and pipeline of the stack, keeps their
  uptime, and shows the numbers that tell whether each one is doing its job.
- **Database Health** shows where the data lives, how much there is, how long each kind is
  kept, and whether the maintenance jobs ran.

Every number on both pages is measured; none is a placeholder. Every address, threshold,
retention period and schedule comes from `.env` through `docker compose`.

## Where to find it

Sidebar → **Observability**:

- **System Health**
- **Database Health**

Addresses, container names and the configuration panel are shown to admins only.

## System Health

### How it works

The API gateway probes every component every `SYSTEM_HEALTH_PROBE_SECONDS` (30 s):

- HTTP `/health` for the services, VictoriaMetrics, VictoriaLogs and vmalert;
- `SELECT 1` for PostgreSQL;
- `PING` for Redis;
- the login page for the web app.

Each probe gives one of four states:

| State | Meaning |
|---|---|
| **Operational** | Answered within `SYSTEM_HEALTH_SLOW_MS` (1000 ms) |
| **Degraded** | Answered, but slower than that |
| **Down** | No answer within `SYSTEM_HEALTH_TIMEOUT_SECONDS` (5 s), connection refused, or an error status. The card shows the exact error, e.g. *Connection refused at http://checker:8081/health (container stopped or wrong address)* |
| **Unknown** | Not probed yet |

Each probe is written to the metrics store as `pulsimo_component_up{component=…}` and
`pulsimo_component_latency_ms{component=…}`. That gives real **24-hour uptime**, the
**status bars**, and series you can chart or alert on in Dashboards.

### Components

| Group | Component | Core | Address from |
|---|---|---|---|
| Services | API Gateway | ✓ | `API_GATEWAY_INTERNAL_URL` (itself) |
| | Checker | ✓ | `CHECKER_SERVICE_URL` |
| | Notification | ✓ | `NOTIFICATION_SERVICE_URL` |
| | Metrics Collector | | `METRICS_COLLECTOR_URL` |
| | Dependency Tracker | | `DEPENDENCY_TRACKER_SERVICE_URL` |
| | Maintenance Scheduler | | `MAINTENANCE_SERVICE_URL` |
| | Web App | | `FRONTEND_INTERNAL_URL` |
| Data stores | PostgreSQL | ✓ | `DATABASE_URL` |
| | Redis | ✓ | `REDIS_URL` |
| | VictoriaMetrics | | `METRICS_STORE_URL` |
| | VictoriaLogs | | `LOGS_URL` |
| Pipelines | vmalert | | `VMALERT_URL` |

The overall verdict:

- **Major outage** when a **core** component is down;
- **Partly degraded** when any other component is down or slow;
- **All systems operational** otherwise.

A component you don't deploy (say, no log store) goes in `SYSTEM_HEALTH_SKIP=victorialogs`,
so it is neither shown nor counted.

### What each card shows

Each card shows:

- the status, and how long it has been in it;
- what the component does;
- the probe time;
- **24-hour uptime**;
- **96 status bars**, one per 15 minutes. Green means up the whole time, amber partly down,
  red mostly down, grey no data yet;
- the exact error when it is not operational.

It also shows the numbers that tell whether it is doing its job:

| Component | Numbers |
|---|---|
| API Gateway | Requests (24h); server errors (5xx) and their share; p95 latency; how long the process has run |
| Checker | Checks (24h) and active endpoints; failed checks (the endpoints' problem, not the checker's); **check lag**: amber > 15 s, red > 60 s |
| Notification | Alerts sent and failed (24h); event-to-alert delay |
| Metrics Collector | Metric sources; scrape success (amber < 98%, red < 90%); samples per second; open incidents from logs |
| Dependency Tracker | Dependencies; discovered but not confirmed |
| Maintenance Scheduler | Last hourly roll-up (amber after 2 h, red after 3 h) |
| PostgreSQL | Size and version; connections against `max_connections` (amber > 75%, red > 90%); cache hit ratio; longest running query |
| Redis | Memory used (and limit); clients; version and uptime |
| VictoriaMetrics | Series; data on disk and retention; free disk (amber < 2 GB) |
| VictoriaLogs | Log sources receiving in the last 5 min; lines since start and lines dropped; data on disk and retention; free disk |
| vmalert | Recording rules; rules with errors |

For admins each card also has the address it probes and `docker logs --tail 100 <container>`,
both one click to copy.

The top of the page shows:

- the verdict, listing each component that isn't operational and why;
- **24-hour figures**: components up, monitored endpoints, checks and their failure share,
  open incidents (and how many came from logs), alerts sent, and log lines received.
  Each figure links to its page;
- **Monitoring pipeline** ([Monitoring pipeline](pipeline-health.md)): check lag, checks per minute,
  scrape success and alert delay.

**Configuration** (admins) lists the settings behind these numbers: probes, retention,
concurrency, log limits, incident thresholds. Each shows its current value and the variable
that sets it, marked *default* when it isn't set in `.env`.

## Database Health

| Section | What it shows |
|---|---|
| **Retention mode** | **Standard**, **Moderate** or **Aggressive**, and how long health checks are kept now. A bar shows the PostgreSQL size against the two thresholds where retention gets shorter |
| **Stores** | PostgreSQL (size, health checks stored, hourly roll-ups). Metrics (VictoriaMetrics: size, series, retention, free disk). Logs (VictoriaLogs: size, lines, retention, free disk) |
| **Maintenance jobs** | Hourly roll-up, daily cleanup and weekly deep cleanup. For each: its schedule in words (from the cron setting), and whether it last ran, when, how long it took, and the error if it failed |
| **How long data is kept** | Every kind of data, how long it is kept, and the variable that sets it |
| **Largest tables** | The 10 biggest tables: estimated rows, size (hover for index size), and dead rows (amber above 20%; the daily VACUUM reclaims them) |

**Run cleanup now** and **Deep cleanup** (editors and admins) run those jobs on demand. The
page refreshes when they finish.

### Retention

| Data | Default | Variable |
|---|---|---|
| Health checks | 90 days; 60 above 1000 MB; 30 above 2000 MB | `HEALTH_RETENTION_DAYS`, `HEALTH_RETENTION_MODERATE_DAYS`, `HEALTH_RETENTION_AGGRESSIVE_DAYS`, `DB_SIZE_WARN_MB`, `DB_SIZE_CRITICAL_MB` |
| Hourly roll-ups | Kept | |
| Resolved incidents | 90 days | `INCIDENT_RETENTION_DAYS` |
| Sent notifications | 60 days | `NOTIFICATION_RETENTION_DAYS` |
| Alert history | 30 days | `ALERT_HISTORY_RETENTION_DAYS` |
| Event trail (audit) | 180 days | `EVENT_TRAIL_RETENTION_DAYS` |
| Metrics | 30 days (90 max) | `METRICS_RETENTION` |
| Logs | 7 days | `LOGS_RETENTION` (incidents keep their saved log evidence) |

### Schedules (cron, UTC)

| Job | Default | Variable |
|---|---|---|
| Hourly roll-up | `5 * * * *` (every hour at :05) | `AGGREGATION_CRON` |
| Daily cleanup | `0 2 * * *` (02:00) | `CLEANUP_CRON` |
| Weekly deep cleanup | `0 3 * * 0` (Sundays 03:00) | `DEEP_CLEANUP_CRON` |

## Settings

| Variable | Default | Meaning |
|---|---|---|
| `SYSTEM_HEALTH_PROBE_SECONDS` | `30` | How often every component is probed (10 to 600) |
| `SYSTEM_HEALTH_TIMEOUT_SECONDS` | `5` | Probe timeout |
| `SYSTEM_HEALTH_SLOW_MS` | `1000` | Slower answers count as degraded |
| `SYSTEM_HEALTH_SKIP` | (empty) | Components not deployed, comma separated (`vmalert,victorialogs`) |
| `VMALERT_URL`, `FRONTEND_INTERNAL_URL` | compose defaults | Addresses probed (the others are the services' own variables) |
| Retention and schedules | see above | Read by the maintenance scheduler. The gateway gets the same values to display them |

Change `.env`, then run `docker compose up -d`.

## Limits

- Uptime and status bars come from the metrics store. If VictoriaMetrics is down, the cards
  still show the live state, but uptime shows "–" and the bars are grey for that time.
- The probes run from the API gateway. If the gateway is down, the page itself can't load.
  That is the "Major outage" you see first.
- **Last run** of the maintenance jobs resets when the scheduler restarts ("Not run since the
  scheduler started").

---

← [API metrics and Event trail](api-metrics.md) · [Contents](../../README.md) · [Monitoring pipeline](pipeline-health.md) →
