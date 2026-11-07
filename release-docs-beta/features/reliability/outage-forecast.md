# Outage forecast

> Available from api-gateway `rc1beta-v0.1.12`, frontend `rc1beta-v0.2.6`, migrations `rc1beta-v0.1.9`.

## What it is

A weather forecast for your systems: what is likely to break, and when, from the
trends Pulsimo already records. Instead of waiting for the incident, you see

> **Disk / on db-1 fills up — in 2 days.** 88 % used now (88.0 GB of 100 GB). At the growth of
> the last 6 hours it reaches 100 % in about 2 days.
> 💡 Clean up old logs, backups or images, or grow the volume. Check log rotation first.

Each forecast says what will happen, when (with a date and "in 2 days"), how sure Pulsimo is,
why (the numbers behind it, with a small chart), and what to check. Nothing new has to be
collected or configured: it reads checks, outages, SLOs, certificates and capacity data that
Pulsimo already has.

## Where to find it

| Where | What |
|---|---|
| **Respond → Forecast** (`/dashboard/forecast`) | The full forecast. The nav badge shows how many are due within 7 days (red when one is due within 24 hours) |
| Overview (home page) | A compact Forecast card under "Needs attention" with the next few items |

## What it forecasts

| Kind | From | Forecast | Shown when |
|---|---|---|---|
| **Capacity** | Capacity forecasts of the metrics collector ([Capacity and anomalies](capacity-and-anomalies.md)) | A disk fills up, memory runs out, a database reaches its maximum connections | The predicted date is within the period |
| **Certificates** | The TLS certificates of your endpoints | A certificate expires (one forecast per certificate, even when several endpoints use it; a Let's Encrypt hint says the automatic renewal is probably failing) | It expires within the period |
| **Error budget** | Your reliability targets ([SLOs](slos.md)) | The SLO error budget runs out at the speed it is being used now (burn rate over the last 6 hours) | It runs out within the period |
| **Getting slower** | 14 days of daily p95 response times | The p95 crosses the SLO latency target, else the expected response time, else the timeout | At least 7 days of data, a steady climb (at least +1 %/day and a good straight-line fit) |
| **Recurring failure** | Outages of the last 28 days | It fails again at about the same time of day (or the same weekday): usually a cron job, a backup or a rotation | At least 3 different days within ±45 minutes, the latest within 10 days |
| **Failing more often** | Outages of the last 28 days | More failures soon: the last 7 days have at least 3 failures and at least twice the usual rate | The next one is expected within the period |

Outages during a maintenance window are ignored.

### When and how sure

| Group | Due |
|---|---|
| **Next 24 hours** (red) | Act today |
| **This week** (orange/amber) | Within 3 days or within 7 days |
| **Later** (blue) | Within the selected period |

Each forecast also has a **confidence** (high, medium or low), from how much data there is
and how well it fits: for example a latency trend with a very good fit over 10 or more days
is "high"; a recurring failure seen on 3 days only is "low".

## How to use it

- **Period:** 7, 30 or 90 days. **Project:** all projects or one.
- **Weather banner:** "Storm warning" when something is due within 24 hours, "Rain this week",
  "Mostly clear", or "Clear skies".
- **Timeline:** every forecast as a dot on a time line (now, 24 h, 3 days, 7 days…), coloured
  by when it is due.
- **Kind chips** filter the list.
- **Each card** has the chart (trend and a dashed projection to the limit; a 24-hour strip of
  failure times; weekly failure bars; days left for a certificate), the hint, and a link to the
  endpoint or metric source.
- **Mute** for 1, 7 or 30 days when you know about it (members and admins). Muted forecasts are
  listed under "Muted" with **Unmute**. A mute is per forecast (for example
  `certificate:shop.acme.com`), so a different problem on the same endpoint still shows.
- **Refresh** recomputes now; otherwise the list is computed at most every 5 minutes.

## How it works

`GET /api/v1/forecast` computes the forecasts for the organization from PostgreSQL (and the
metrics store for the capacity trend chart), keeps the result in Redis for 5 minutes, and then
applies the project filter and the mutes. If a source cannot be read (for example the metrics
store is down), the other forecasts are still shown and the page says which source was missing.

API:

| Method and path | What |
|---|---|
| `GET /api/v1/forecast?days=30&project_id=&endpoint_id=&fresh=true` | `days` 1 to 90 (default 30). Returns `generated_at`, `summary` (`next_24h`, `next_7d`, `total`, `by_kind`), `items`, `muted`, `unavailable` |
| `POST /api/v1/forecast/mute` `{ "key": "latency:<id>", "days": 7, "reason": "…" }` | Mute for 1 to 90 days. Not for viewers |
| `POST /api/v1/forecast/unmute` `{ "key": "…" }` | Remove a mute |

Each item has `key`, `kind`, `severity` (critical, high, medium, low), `title`, `detail`,
`hint`, `eta`, `confidence`, `subject` (endpoint or source, with project), `link`, `chart`
(`points` as `[unix ms, value]`, `limit`, `unit`) and `muted_until`. Mutes are stored in the
`forecast_mutes` table.

## Limits

- Forecasts are straight-line projections of recent behaviour. A sudden change (a big import,
  a traffic spike) is only seen after it starts.
- Capacity forecasts need the metrics collector's capacity data (node_exporter, PostgreSQL or
  similar sources, [Capacity and anomalies](capacity-and-anomalies.md)); latency needs at least 7 days with 10 or more successful checks a day.
- Recurring-failure times are shown in UTC.
- A forecast is not an alert: nothing is sent. Use the alarms ([Alarms](../alarms.md)) for notifications.
