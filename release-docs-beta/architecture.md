# Architecture

> The services that make up Pulsimo, where data lives and how a check becomes an alert.

Pulsimo is a set of small Rust services and a Next.js web app, started together with
Docker Compose. Configuration, checks, incidents and users live in PostgreSQL; metrics in
VictoriaMetrics; logs in VictoriaLogs. Redis carries events between the services.

## The big picture

```text
                 ┌────────────── your systems ──────────────┐
                 │  websites · APIs · databases · Redis     │
                 │  exporters and app /metrics · log files  │
                 └───────┬──────────────┬──────────────┬────┘
                  checks │       scrapes│     Fluent Bit│ (HTTPS, plog_ token)
                         ▼              ▼              ▼
                    ┌─────────┐  ┌──────────────┐  ┌─────────────┐
                    │ checker │  │  metrics-    │  │ api-gateway │◄── web app (frontend)
                    └────┬────┘  │  collector   │  └──────┬──────┘    and API clients
                         │       └──────┬───────┘         │
          events (Redis) │              │                 │
                         ▼              ▼                 ▼
                 ┌──────────────┐  ┌───────────────┐  ┌──────────────┐
                 │ notification │  │VictoriaMetrics│  │ VictoriaLogs │
                 └──────┬───────┘  │  + vmalert    │  └──────────────┘
                        │          └───────────────┘
                        ▼                  PostgreSQL holds configuration,
       Slack · Discord · Teams ·           checks, incidents, alarms and users
       Google Chat · email · webhooks
```

## Services

| Service | Role |
|---|---|
| `frontend` | The web app. Talks only to the API gateway |
| `api-gateway` | REST API and live updates (WebSocket) for the web app and API keys; sign-in and access checks; log ingestion; organization-scoped queries to the metrics and log stores |
| `checker` | Runs every endpoint's checks on its own schedule; evaluates monitors that use metrics; writes check results to PostgreSQL and as metrics |
| `metrics-collector` | Scrapes metric sources; discovery of routes, databases, hosts and containers; change detection; SLOs, anomalies, capacity forecasts; alarm rules; log patterns and incidents from logs |
| `notification` | Turns events into alarms and messages: routing, reminders, deploy grace, digests, delivery to each platform |
| `dependency-tracker` | Builds the dependency map between services |
| `maintenance-scheduler` | Retention, hourly roll-ups and database upkeep on cron schedules |
| `migrations` | Applies database migrations on start, then exits |
| `postgres` | Configuration, check results, incidents, alarms, users, the event trail |
| `redis` | Events between services and live updates to the browser |
| `victoriametrics` | All metric series, scraped and Pulsimo's own |
| `victorialogs` | Log lines; each organization is a separate tenant |
| `vmalert` | Evaluates the recording rules the collector generates, every 30 s |

## From a check to an alert

1. The **checker** keeps every endpoint's next check time in memory and starts checks as
   they come due, at most `MAX_CONCURRENT_CHECKS` at once. A slow endpoint never delays
   the others, and one endpoint never has two checks running at the same time.
2. Results are saved in batches and also written to VictoriaMetrics as
   `pulsimo_check_up`, `pulsimo_check_duration_seconds` and friends.
3. When an endpoint reaches its alert policy's failures, the checker opens an incident and
   publishes an event on Redis.
4. An alarm opens and the **notification** service picks the channels (rule or policy first,
   then each channel's severity, projects and categories), and sends the message with what
   the linked metrics and logs show.
5. If a deploy or restart of a linked source happened in the last 3 minutes, the message
   is held and sent only if the endpoint is still down. If a service it depends on is
   already down, it is held until that one recovers.
6. While the incident is open, the **metrics-collector** scrapes the linked sources every
   5 seconds for 30 minutes and saves the evidence, so the incident keeps its charts after
   the metrics retention has passed.

## Metrics

The collector pulls each source on its own interval and stores samples in
VictoriaMetrics with labels such as `org_id`, `source_id`, `job` and `instance`, and
`project_id` and `endpoint_id` when set. These labels override any label of the same name
sent by the exporter, and the gateway adds the organization to every query, so one
organization never sees another's series. More in [Metric sources](features/metrics/sources.md).

## Logs

Fluent Bit (or curl, Loki push, Elasticsearch bulk or OTLP/HTTP) sends lines to
`POST /api/v1/logs/ingest` with a source's `plog_` token. The gateway checks the token,
applies the source's rate limit, normalizes fields such as `level`, `service` and
`container`, redacts secrets, and writes to VictoriaLogs under the organization's tenant.
The collector groups warning and error lines into patterns and opens
[incidents from logs](features/logs/incidents-from-logs.md). More in [Logs](features/logs/README.md).

## Design choices

- **Detect from metrics, not agents.** Deploys, restarts, new routes and dependencies are
  inferred from what exporters already expose, so nothing extra is installed.
- **Hold, don't silence.** Deploy grace and maintenance windows delay and re-check instead
  of hiding alerts, so nothing is lost if the service stays down.
- **Keep evidence.** A small, downsampled copy of the metrics around each incident is
  saved in PostgreSQL and outlives the metrics retention.
- **Best effort around the core.** A slow or missing metrics store never delays an active
  check's verdict or an alert.

## Ports

| Port | Service | Exposed on the host |
|---|---|---|
| 3000 | frontend | Yes (`EXPOSE_FRONTEND_PORT`) |
| 8080 | api-gateway | Yes (`EXPOSE_API_PORT`) |
| 5432 | postgres | Yes by default; close it in production |
| 6379 | redis | Yes by default; close it in production |
| 8081 to 8084, 3007 | checker, notification, dependency-tracker, metrics-collector, maintenance-scheduler | No |
| 8428, 9428, 8880 | victoriametrics, victorialogs, vmalert | No |

---

← [Your first project](first-project.md) · [Contents](README.md) · [Configuration](configuration/environment-variables.md) →
