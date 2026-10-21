# Monitoring from metrics

> Health from the app's own metrics (5xx, p95, traffic) instead of, or as well as, calling it.

## What it is

Besides calling an endpoint (an **active check**), Pulsimo can judge its health from the
service's own metrics: the share of 5xx responses, p95 latency, traffic stopping, a
database's connections, a host's CPU. This covers what active checks can't reach:
POST/PUT routes, internal services behind a firewall, routes that need auth or a body,
databases seen only through their exporter.

A metric monitor is an ordinary endpoint: same card, incidents, alert policies,
escalation, history and status. Only the source of the verdict differs.

## Where to find it

Endpoint → **Metrics & dashboards** → **How it's monitored**, or the **Metrics** /
**Both** choice in the Discovered inbox ([Discovered services](metrics/discovery.md)).

## The three modes

| Mode | Healthy when | Good for |
|---|---|---|
| **Active check** | Pulsimo can call it and gets the expected answer in time | Public URLs, "can users reach it?" |
| **From metrics** | Its metrics are within the limits below | POST routes, internal services, databases via exporters |
| **Both** | Both are fine | Critical services: reachable from outside **and** healthy inside |

## Limits you can set

| Limit | Default | Applies to |
|---|---|---|
| 5xx share | 5% | HTTP apps |
| p95 latency | 1 s | HTTP apps with a latency histogram |
| Alert when traffic stops | on | HTTP apps that normally have traffic (≥ 0.01 req/s an hour ago) |
| Saturation | 95% | CPU and memory (hosts), connections (PostgreSQL, MySQL) |

An unreachable exporter (its last scrape failed) also counts as down: if Pulsimo can't
read the metrics, the service or its host is usually unreachable.

## How the verdict avoids false alarms

Spiky traffic would make a naive "5xx > 5% right now" flap. Pulsimo evaluates like an SRE
team would:

- **Two windows for errors.** Down when the last 5 minutes are over the limit **and** the
  last hour is at least half the limit, so one bad minute doesn't page anyone. A severe
  spike (3× the limit) is down at once.
- **Sustained latency.** Down when p95 over 5 minutes is over the limit **and** p95 over
  15 minutes is near it (80%), or at once when p95 is twice the limit.
- **Hysteresis.** Once down, it must fall clearly below the limit (under 80% of it) to
  recover, so a value hovering at the limit doesn't flip Up/Down every check.
- The usual alert policy (consecutive failures, quiet hours, throttling) still applies on
  top.

Messages say what was measured, e.g. "23.0% of requests fail with 5xx (limit 5.0%), from
metrics" or "p95 latency 1.84 s (limit 1.00 s), from metrics".

## Recording rules (faster, consistent numbers)

For every HTTP app linked to an endpoint, Pulsimo pre-computes per-route request rates
and latency buckets every 30 seconds (`pulsimo:http_requests:rate1m`,
`pulsimo:http_latency_bucket:rate1m`). Metric monitors read these first and fall back to
the raw series, so checks stay cheap on busy exporters and every view shows the same
numbers. Nothing to configure.

## Your checks as metrics

Every check (active or from metrics) is also written to the metrics store:

| Series | Meaning |
|---|---|
| `pulsimo_check_up` | 1 = passed, 0 = failed |
| `pulsimo_check_duration_seconds` | Total response time |
| `pulsimo_check_phase_seconds{phase}` | `dns`, `tcp`, `tls`, `ttfb`, `transfer` |
| `pulsimo_check_status_code` | HTTP status, when there is one |

Labels: `endpoint` (the name), `endpoint_id`, `project_id`, `org_id`,
`source="pulsimo-checks"`, `job="pulsimo"`. Use them in dashboards and the Explorer, for
example availability over 30 days with `avg_over_time(pulsimo_check_up{endpoint="Checkout"}[30d])`.

## Active HTTP checks

Active checks support the method, headers and body (POST/PUT checks), query parameters,
GraphQL queries, an expected status that may be a 4xx (e.g. 401 for a protected route),
and a timeout up to 60 s.

---

← [Endpoints and checks](health-checks.md) · [Contents](../README.md) · [Service analytics](service-performance.md) →
