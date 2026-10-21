# Discovered services

> APIs, databases, hosts and containers found in your metrics, ready to monitor.

## What it is

Once a source is added, Pulsimo already knows every API route, database, host and
container that source reports. The metrics collector finds them in the background and
lists them in a **Discovered** inbox, ready to monitor with one click, and keeps the list
current as your apps change.

## Where to find it

**Services → Endpoints**: the banner "N services discovered in your metrics" → **Review**.

## What is discovered

| Kind | Found from | Shown with |
|---|---|---|
| API route | a request counter with a route label (`*_requests_total{route=…}`) | req/s, 5xx %, p95, methods |
| Database | postgres_exporter / mysqld_exporter | size, connections |
| Host | node_exporter | CPU, memory |
| Container | cAdvisor | CPU, memory |

Route templates are kept as the app reports them (`/users/{id}`), so there is one entry
per route, not per id. `/metrics`, `unmatched` and similar are skipped.

## How to use it

- **To review**: each candidate with live numbers. Per row choose **Active**,
  **Metrics** or **Both** (POST and internal routes: Metrics only, because Pulsimo can't
  call them safely), then **Monitor** (one or in bulk) or **Ignore**.
- **Monitored**: candidates that already have a monitor. A route not reported for 7 days
  shows a warning ("no longer reported, retire?") instead of paging someone.
- **Ignored**: restore any time.
- **Gone**: not reported for 7 days.
- **Rules**: **Auto-monitor from metrics** or **Ignore** by pattern, per source or for all
  sources. `*` matches one path segment, `**` matches anything: `/api/**`,
  `/internal/*`. Rules apply within a minute and on every pass.
- **Scan now** looks immediately; otherwise every 5 minutes.

## Which project new monitors go into

Next to **Monitor N** you choose the project:

| Choice | The new endpoints go into |
|---|---|
| **Same as the metric source** (default) | The source's project. With no project on the source, **Orphan Endpoints** |
| **None (Orphan Endpoints)** | Orphan Endpoints |
| A project | That project |

Monitors created by **Rules** (auto-monitor) follow the source's project the same way.

**Orphan Endpoints** holds every endpoint that is in no project: added from metrics, through
the API, or left behind when its project was deleted. Each organization has its own, it
can't be deleted, and the database makes sure no endpoint is ever without a project. Its
endpoints are listed at the bottom of **Projects**. Select them, pick a project and press
**Move**. They are checked and alerted on all the same while they wait there.

## New routes are changes

When a source reports routes it never reported before (typically after a deploy), Pulsimo
records a **New routes** change (a teal line on charts, [Change markers](../reliability/change-markers.md)) and adds a line to the
digest ("3 new routes on WakerPortal: /api/orders, /api/refunds, /api/v2/cart"), so you learn about new endpoints
without looking.

## Limits

- Only what the metrics report: a route that never received traffic since the app started
  isn't in the counters yet.
- A cap on candidates per source stops an app with millions of unique paths from flooding
  the inbox.

---

← [Connected monitoring](connected-monitoring.md) · [Contents](../../README.md) · [Logs](../logs/README.md) →
