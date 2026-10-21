# Monitoring pipeline

> Check lag, scrape success, alert delay and series per source.

## What it is

A monitoring system that is itself degraded is the classic blind spot: checks run late,
scrapes fail, alerts go out slowly, and nobody notices. Pulsimo's services report their own
metrics, and System Health shows them.

## Where to find it

**System Health → Monitoring pipeline** (admins). The rest of System Health (every
component probed, uptime, storage) is in [System and database health](system-health.md).

## What it shows

| Tile | Meaning | Turns amber / red |
|---|---|---|
| **Check lag** | How far the most overdue check is behind its schedule | > 15 s / > 60 s |
| **Checks / min** | Checks run, with the number of active endpoints | |
| **Scrape success** | Share of successful scrapes in the last 15 minutes, scrapes per minute, samples per second, and sources currently boosted for an incident | < 98% / < 90% |
| **Alert delay** | Average time from event to handled notification over the last hour, notifications sent and failed, and alerts held for deploys in 24 h | any failed notification |

Chips at the top show whether the **Checker**, **Metrics collector** and
**Notifications** services reported in the last 2 minutes. A red chip means the service is
down or can't reach the metrics store.

## Series per source

**Metrics → Sources → Series** shows each source's active series, warns above 10,000, and
explains what drives them ([Metric sources](../metrics/sources.md)). One misbehaving exporter can't slow everything down
unnoticed.

## Pulsimo's metrics

All have `pulsimo_internal="true"` and `job="pulsimo"`, with `service` set to the reporting
service. They are instance-wide (not per organization) and are written every 30 seconds.

| Series | Service |
|---|---|
| `pulsimo_checker_checks_total{result}` | checker |
| `pulsimo_checker_check_lag_seconds` | checker |
| `pulsimo_checker_active_endpoints` | checker |
| `pulsimo_collector_scrapes_total{result}` | metrics-collector |
| `pulsimo_collector_samples_total` | metrics-collector |
| `pulsimo_collector_sources` | metrics-collector |
| `pulsimo_collector_boosted_sources` | metrics-collector |
| `pulsimo_notifications_total{result}` | notification |
| `pulsimo_notification_events_total` | notification |
| `pulsimo_notification_delay_ms_sum` | notification |
| `pulsimo_notification_held_for_deploy_total` | notification |

Counters restart from zero when a service restarts; `increase()` and `rate()` handle that.

---

← [System and database health](system-health.md) · [Contents](../../README.md) · [Authentication](../../api/authentication.md) →
