# Endpoints and checks

> What Pulsimo can check, every endpoint setting, and how a check decides Up, Degraded or Down.

An **endpoint** is anything Pulsimo checks: a web page, an API route, a database, Redis,
Elasticsearch, a gRPC or WebSocket service. Each **check** is one attempt to reach it.
Checks decide whether the endpoint is up or down, open and close incidents, and feed
response times, uptime and the status board.

## Where to find it

**Services → Endpoints**. Click **Add endpoint**, or open an endpoint's card to edit it,
pause it, silence its alerts or see its history.

## What Pulsimo can check

The **service type** decides how the check is made.

| Service type | Address | The check passes when |
|---|---|---|
| Frontend, Backend, API, Microservice, API gateway | `https://…` or `http://…` | The response is 2xx or 3xx, or exactly the expected status you set |
| Database | `postgresql://host:5432` or `mysql://host:3306` | Pulsimo can sign in and run `SELECT 1` |
| Cache | `redis://host:6379` | Redis answers `PING` with `PONG` |
| Search engine | `https://host:9200` | `/_cluster/health` is green or yellow (red fails) |
| gRPC | `grpc://host:50051` | The standard gRPC health service reports `SERVING` |
| WebSocket | `ws://…` or `wss://…` | The connection opens and answers a ping |

Services that are hard to call from outside (POST-only routes, internal services,
databases you only see through an exporter) can be judged from their own metrics instead,
or as well. See [Monitoring from metrics](metric-monitors.md).

## HTTP checks

For HTTP-based types you can set:

- the **method** (GET by default; POST, PUT and PATCH can send a body with a content type);
- extra **headers** and **query parameters**;
- a **GraphQL** query and variables, sent as a POST;
- an **expected status**, which may be a 4xx, e.g. `401` for a route that should stay
  protected;
- **authentication**: none, Basic (username and password), Bearer token, or an API key in
  a header of your choice (`X-API-Key` by default).

Pulsimo reads up to 2 MB of the body, so the transfer time is real. Each HTTP check also
measures DNS, TCP connect, TLS, time to first byte and transfer on a side connection, so
the breakdown in [Service analytics](service-performance.md) costs the check nothing.

## Endpoint settings

| Setting | Range | What it does |
|---|---|---|
| Check interval | 10 s to 1 h | How often the endpoint is checked |
| Timeout | 1 to 60 s | A check without an answer in this time fails as a timeout |
| Expected status | any HTTP status | See above |
| Expected response time | ms | An answer slower than this counts as a **failed** check |
| Retries | 0 to 5 | Extra attempts before a check counts as failed |
| Project | – | Groups the endpoint for the status board, targets and routing |
| Tags, description, owner contact | – | Help people find the endpoint and know who owns it |

When it is **down** and who is told is set in the endpoint's **alert policy** (edit →
*Alert Policy*): failures before down, a warning on the first failure, escalation, which
channels get outages and warnings, and a slow-response warning that keeps the endpoint up.
See [Alarms and rules](alarms.md#endpoint-alert-policies).

## Status

| Status | Meaning |
|---|---|
| **Up** | The last checks passed |
| **Degraded** | A partial outage: it answers, but not reliably |
| **Down** | The alert policy's failures before down were reached, and an incident is open |
| **Unknown** | Not checked yet, or paused |

A failure that comes back within `INCIDENT_REOPEN_MINUTES` (10 by default) of a recovery
reopens the last incident instead of opening a new one, so a flapping endpoint is one
incident, not twenty.

## Choosing an interval

| Interval | Good for |
|---|---|
| 10 to 30 s | Customer-facing services where every minute counts |
| 1 min | Most internal APIs and databases |
| 5 min or more | Batch jobs, admin tools, third-party pages you only want to keep an eye on |

Keep the timeout well below the interval. With hundreds of endpoints on short intervals,
watch the check lag on [Monitoring pipeline](observability/pipeline-health.md) and raise
`MAX_CONCURRENT_CHECKS` if checks start running late.

## Checks as metrics

Every check is also written to the metrics store as `pulsimo_check_up`,
`pulsimo_check_duration_seconds`, `pulsimo_check_phase_seconds{phase}` and
`pulsimo_check_status_code`, so you can chart them in the
[Metrics Explorer](metrics/explorer.md) and on [Dashboards](dashboard.md).

## Certificates

For `https://` endpoints Pulsimo also reads the TLS certificate and warns before it
expires. See **SSL Certificates** in
[Service analytics](service-performance.md#ssl-certificates).

---

← [Projects and overview](projects.md) · [Contents](../README.md) · [Monitoring from metrics](metric-monitors.md) →
