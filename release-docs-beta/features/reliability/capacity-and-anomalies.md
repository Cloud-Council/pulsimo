# Capacity and anomalies

> "Disk full in about 3 days" and "traffic 70% below last week".

Two background jobs look for trouble before any check fails.

## Capacity forecasts

### What it is
At the current trend, when does a disk fill up, a host run out of memory, or a database
reach its maximum connections? Pulsimo works it out every 15 minutes from the last 6
hours.

### Where to find it
**Metrics → Sources** (Capacity forecast, above the table) and **System Overview**
(Capacity card).

### What is forecast

| Resource | From | Limit |
|---|---|---|
| Disk, per mount point | node_exporter filesystem metrics (tmpfs, overlay and system mounts are skipped) | the filesystem size |
| Memory | node_exporter memory metrics | total memory |
| PostgreSQL connections | postgres_exporter | `max_connections` |
| MySQL connections | mysqld_exporter | `max_connections` |

Each row shows used vs limit and **Full in 2 days**, **At the limit**, or **Stable** when
it isn't growing.

### Notifications
- Limit reached within **24 hours** → an alert right away ("⚠️ Capacity: host-1 — disk /data
  full in ~9 h at the current trend (91% used now)").
- Within **3 days** → a line in the next digest.
- At most once a day per resource.

## Anomalies from real traffic

### What it is
Every 10 minutes, each endpoint linked to an HTTP app is compared with **the same time last
week** (or yesterday, when there isn't a week of history yet). Comparing with the same hour
avoids alerting on the normal lunch dip or night-time quiet.

| Finding | When |
|---|---|
| Traffic drop | below 30% of the usual requests (high severity below 20%) |
| Traffic spike | more than 3× the usual, and at least 1 req/s |
| Slower | p95 more than 2× the usual and above 200 ms (high above 4×) |
| More errors | 5xx share more than 3× the usual and above 2% (high above 10%) |

Routes with less than 0.05 req/s are only checked for traffic drops: too little traffic to
judge latency or error ratios.

### Where to find it
Findings appear with the endpoint's other performance anomalies (marked as coming from
metrics), resolve themselves when values are back to normal, and are listed in the
digest: "Checkout: traffic 72% lower than last week (3.10 vs 11.20 req/s)".

The older anomaly detector (synthetic response time vs its 7-day average) keeps running
alongside.

---

← [Change markers](change-markers.md) · [Contents](../../README.md) · [Alarms and rules](../alarms.md) →
