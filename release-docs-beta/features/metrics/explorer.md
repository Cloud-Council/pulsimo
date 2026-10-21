# Metrics Explorer

> Graph anything with PromQL or a point-and-click builder.

## What it is

A place to graph any metric Pulsimo has collected, without building a dashboard.

## Where to find it

**Metrics → Explorer**. Many other places open it with the query filled in: the
**Explore** button on a source, on a chart in an endpoint's Metrics tab, or on an
incident's charts.

## How to use it

- Pick a **source** and a **metric**, or type PromQL directly. Metric names autocomplete
  and **Tab** accepts a suggestion. For counters (names ending in `_total`), switch on
  **Rate/s** to see per-second rates instead of an ever-growing number.
- **Range**: 15m, 1h, 6h, 24h, 7d, 30d, 60d, 90d (up to the retention period), or
  **Custom** for a past window, with shortcuts such as "the same day last week".
- **Graph** or **Table** (the latest value of each series). Click a legend entry to hide
  that series. **Auto-refresh** keeps a live range moving.
- **Presets** for quick checks: sources up, scrape duration, samples per source.
- The URL holds the query and range, so you can share a link to exactly what you see.

## Useful queries

| Question | PromQL |
|---|---|
| Requests per second per route | `sum by (route) (rate(http_requests_total[5m]))` |
| Share of 5xx | `sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m]))` |
| p95 latency | `histogram_quantile(0.95, sum by (le) (rate(http_request_duration_seconds_bucket[5m])))` |
| Host CPU | `1 - avg(rate(node_cpu_seconds_total{mode="idle"}[5m]))` |
| **Your checks**, response time | `pulsimo_check_duration_seconds{endpoint="Checkout API"}` |
| **Your checks**, availability over a day | `avg_over_time(pulsimo_check_up{endpoint="Checkout API"}[1d])` |
| Time spent in TLS per check | `pulsimo_check_phase_seconds{phase="tls"}` |

Pulsimo's own check results are metrics too ([Monitoring from metrics](../metric-monitors.md) lists them), so you can chart an
endpoint's check latency next to the app's own p95.

## How it works

Every query goes through the API gateway, which adds your organization as a filter
(`org_id`), so you only ever see your own data. The store hides the newest ~30 s by
default, so a brand-new source appears in queries about half a minute after its first
scrape.

## Limits

- Queries older than the retention period return "outside retention".
- Heavy queries time out after 30 s; narrow the range or the label filters.

---

← [Metric sources](sources.md) · [Contents](../../README.md) · [Dashboards](../dashboard.md) →
