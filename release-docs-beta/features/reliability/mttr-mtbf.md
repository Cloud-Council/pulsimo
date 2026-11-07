# MTTR, MTBF and incident response

> How long failures take to fix, how long services stay up between them, and how each incident was handled, per endpoint and per project.

## What it is

Pulsimo measures reliability from your health checks:

- **MTTR** (mean time to recover): how long an endpoint is down, on average, from its **first failed check** until it is healthy again. Detection time is included, because your users were affected from the first failed check, not from the moment someone noticed.
- **MTBF** (mean time between failures): how long it stays up, on average, between two failures.
- **MTTD** (mean time to detect): first failed check until the incident opened.
- **MTTA** (mean time to acknowledge): incident opened until someone acknowledged it.
- **Availability**: the share of the monitored time it was up.

The same figures are worked out for a whole project, and every incident page shows how that one incident was handled against its targets and against the endpoint's history.

## Where to find it

| Where | What you see |
|---|---|
| **Incident page → Metrics** | How this incident went: detect, acknowledge and fix as one bar; the acknowledge and recover targets with *Met*, *Missed by 4d 16h* or *2h left*; how fast it was detected; how it compares with the endpoint's usual recovery; the last outages as a small chart |
| **Incident page → Timeline** | The incident's story, oldest first: first failed check, opened, acknowledged by whom, investigating, recovered or resolved by whom, reopened, and every update, each with its exact time and its offset from the start |
| **Incident page → top cards** | *Time to acknowledge* (or *Never* when nobody took it) against the target, and the real *Total downtime* |
| **Services → Endpoints → an endpoint → Overview → Reliability** | MTTR (with median and p90), MTBF, MTTD / MTTA and availability for 7, 30 or 90 days; the trend against the period before; failures per day; the endpoint's outages, each linking to its incident |
| **Projects** | MTTR and MTBF on every project card, and **MTTR / MTBF** for all projects in the figures at the top |
| **Project Analytics** | **MTTR / MTBF** in the figures at the top; sortable **MTTR** and **MTBF** columns in *Projects compared*; in a project's panel, MTTR (median, p90, trend), MTBF, time to detect and time to acknowledge, and MTTR · MTBF on each endpoint line. The CSV export has the failures, MTTR and MTBF columns |

## How the figures are calculated

### What counts as a failure

A **failure** is one health-check incident of an endpoint. It starts at the first failed check and ends at the final recovery.

- **Reopened incidents are one failure.** When an incident is reopened (within `INCIDENT_REOPEN_MINUTES`), it is still the same failure, but the healthy time between the recovery and the reopen is **not** counted as downtime.
- **Planned work is not a failure.** An outage that started and ended inside a maintenance window covering the endpoint (organization-wide, its project or the endpoint itself) is left out.
- **Incidents from logs or metrics rules don't count.** They describe errors, not the endpoint being down. They still get the incident Metrics tab and Timeline.

### The formulas

| Figure | Formula |
|---|---|
| MTTR | average of (recovered − first failed check) over the failures that recovered in the period |
| MTTR median, p90 | the middle value, and the value 90% of recoveries were faster than. One very long outage moves the mean a lot; the median shows what is usual |
| MTTD | average of (incident opened − first failed check) |
| MTTA | average of (acknowledged − incident opened), over the acknowledged failures only. The figure says how many of the failures were acknowledged |
| MTBF | (monitored time − downtime) ÷ number of failures |
| Availability | (monitored time − downtime) ÷ monitored time |

The **monitored time** starts at the beginning of the period, or when the endpoint was created if that is later. A failure still open counts with the time it has been down so far.

When nothing failed, MTBF shows **No failures** rather than an endless number. With one or two failures the figures are marked as rough (*Based on 2 failures*), because a single long outage decides them.

### Projects

A project is down when **any** of its endpoints is down. When endpoints fail at the same time (one database outage taking three APIs down), the overlapping outages are merged into one project failure, so a project's MTTR and MTBF describe what its users saw, not the number of endpoints. The project panel also shows the average of its endpoints' own figures.

### Targets on the incident page

The targets follow the incident's priority (or, when it has none, its severity):

| Priority | Severity | Acknowledge within | Recover within |
|---|---|---|---|
| P0 | critical | 5 minutes | 30 minutes |
| P1 | high | 15 minutes | 2 hours |
| P2 | medium | 1 hour | 8 hours |
| P3 | low | 4 hours | 24 hours |

These are the default incident SLA targets (table `incident_sla_targets`); the page shows the targets and labels stored there. Acknowledge is measured from the moment the incident opened; recover from the first failed check. An incident that recovered on its own before anyone took it shows **Never acknowledged**: this is the case worth fixing in your on-call routing.

## Example

*Orders API* failed 6 times in 90 days: five times for 8 to 41 minutes, and once for 5 days because nobody acknowledged it.

- MTTR **20h 22m**, median **16m**, p90 **5d**: usually fixed in a quarter of an hour, but the mean is pulled up by the one long outage.
- MTBF **14d 3h**: it fails about twice a month.
- MTTD / MTTA **30s / 3m 30s**, *4 of 6 acknowledged*.
- On the 5-day incident's Metrics tab: *Never acknowledged*, *Missed by 4d 16h (15× the target)*, *604× longer than Orders API usually takes to recover*, *its longest outage in 90 days*.

## How it works

- Each health-check incident has one row in `endpoint_outages` (migration `042_reliability_mttr_mtbf.sql`): first failed check, opened, acknowledged, recovered, real down seconds, reopen count, in maintenance.
- The rows are kept by database triggers on `incidents` and `incident_state_history`, so the checker, a manual resolve in the app, reopens and the API all keep them right. Nothing else needs to run. The migration fills the table from the incidents already kept.
- The rows outlive the incidents: incidents are deleted after `INCIDENT_RETENTION_DAYS` (90), reliability history is kept for `RELIABILITY_RETENTION_DAYS` (**400**, at least 30) by the maintenance scheduler, so a year can be compared with the one before.
- The migration also fixes the incident timeline wording ("Opened as open" instead of "State changed from to open") and adds who made each change.

## Settings

| Variable | Default | Service | What it does |
|---|---|---|---|
| `RELIABILITY_RETENTION_DAYS` | `400` | maintenance-scheduler | Days of reliability history (MTTR / MTBF) kept. At least 30 |
| `INCIDENT_REOPEN_MINUTES` | `10` | checker | A failure within this time after a recovery reopens the incident: one failure, the gap not counted as downtime |

## API

| Method and path | Returns |
|---|---|
| `GET /api/v1/endpoints/:id/reliability?days=30` | One endpoint: `current` and `previous` figures (failures, open failures, downtime, monitored time, MTTR mean/median/p90, MTTD, MTTA, acknowledged, MTBF, availability, longest, confidence), one entry per day, and its outages |
| `GET /api/v1/projects/:id/reliability?days=30` | One project, overlapping outages merged: `current`, `previous`, the endpoints' average MTTR and MTBF, one entry per day, and every endpoint with its figures and its share of the project's downtime |
| `GET /api/v1/incidents/:id/response` | One incident: first failed check, opened, acknowledged (by whom), recovered; detect / acknowledge / fix / recover / down seconds; its priority's targets; and the endpoint's last 90 days (median and mean recovery, MTBF, availability, how many times longer than usual, its rank among the longest, the previous failure, the last outages) |
| `GET /api/v1/projects/insights` and `GET /api/v1/projects/:id/insights` | Now also carry `reliability` per project, in the totals and per endpoint |

`days` is 1–365 (default 30). All figures are in seconds; MTBF and MTTR are `null` when there is nothing to average.

## Limits

- Only maintenance that covers an outage from start to end removes it. Maintenance time without a failure is still counted as monitored time.
- Paused endpoints keep counting monitored time while paused.
- A project failure is measured from the outages of its endpoints. When an endpoint was reopened, the healthy gap (a few minutes at most) is counted for the project.
- Response time from the incident's first public update isn't recorded, so there is no "first response" target.
- Figures before migration 042 come only from the incidents that were still kept (the last `INCIDENT_RETENTION_DAYS`).

---

← [Capacity and anomalies](capacity-and-anomalies.md) · [Contents](../../README.md) · [Alarms and rules](../alarms.md) →
