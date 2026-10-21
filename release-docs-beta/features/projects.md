# Projects and overview

> The live status board, project reliability against targets and error budgets, and project analytics.

Three pages answer three questions:

| Page | Question |
|---|---|
| **Services → Overview** | What is up or down right now, and what changed today? |
| **Projects** | How is each project doing against its reliability target? |
| **Project Analytics** | How reliable were the projects over a period, how fast were incidents handled, and is it better or worse than before? |

All figures come from your organization's health checks and incidents.

## How the figures are calculated

| Term | Meaning |
|---|---|
| **Uptime** | The share of an endpoint's checks that passed. A project's uptime is the average of its endpoints, each counting the same whatever its check interval |
| **Target** | The uptime a project should reach, 99.5% unless you change it. It is set per project |
| **Error budget** | The failed checks the target allows. A 99.5% target allows 0.5% of checks to fail. *60% budget left* means 40% of that allowance is used. Above 100%, the project is below its target |
| **Trend** | The same figure for the period just before, e.g. the previous 30 days, shown as a change in percentage points (pp) |
| **MTTA / MTTR** | Mean time to acknowledge and mean time to resolve, for incidents opened in the period |
| **p95** | 95% of successful checks answered faster than this |
| **Period** | The last 7, 30 or 90 days in UTC, including today |

Health of a project or endpoint:

| Health | When |
|---|---|
| **Down** | At least one endpoint is down |
| **Degraded** | An endpoint is degraded, or an incident is open |
| **Healthy** | Everything is up and no incident is open |
| **Not checked** / **No endpoints** | Nothing checked yet, or the project is empty |

## Services → Overview

Use it as the live status board. It refreshes every 30 seconds.

- **Banner**: either *All systems operational*, or how many endpoints are down or
  degraded and which ones, plus the number of checks in the last hour.
- **Figures**:
  - endpoints up;
  - availability over 24 hours;
  - response p95 over 24 hours;
  - checks in the last hour and how many failed;
  - open incidents.

  Click **Endpoints up** to show only the endpoints that are down. Click **Open
  incidents** to open the incident list.
- **Status board**: one row per endpoint, grouped by project (untick **Group by project**
  for one list). Problems come first. Each row shows:

  | Column | Shows |
  |---|---|
  | Endpoint | Status dot, name, type, when it was last checked. When down: for how long. An **incident** tag opens the open incident |
  | 24 hours | 48 bars of 30 minutes. Green: all checks passed. Amber: some failed. Red: most failed. Grey: not checked. Hover a bar for its time and checks |
  | Uptime | Over the 24 hours |
  | p95 | Over the 24 hours, coloured green, amber or red |
  | Last | The last check's response time |

  Click a row to open the endpoint. Filter by **Down**, **Degraded**, **Up** or
  **Paused**, or search by name, URL or project.
- **Recent changes**: what went down and what recovered (and after how long) in the last
  7 days. Click one to open its incident.
- **Slowest, 24 h**: the five slowest endpoints. Click one to open its response times.
- **Shortcuts** to Response times, Apdex & anomalies, Network and Certificates.

## Projects

- **Period**: 7, 30 or 90 days. It is kept in the address bar (`?days=90`).
- **Figures**:
  - **Projects**, and how many are below target. Click to show only those.
  - **Endpoints up**, with how many are down or degraded. Click to show the projects
    with a down endpoint.
  - **Uptime**, compared with the previous period.
  - **Incidents**: in the period, open now, and in the period before.
  - **Time to resolve**, and time to acknowledge.
- **Needs attention**: a line naming every project that is down or below its target.
  Click a name to open that project.
- **Filters**: search; **All**, **Down**, **Degraded**, **Healthy** or **Below target**;
  and a sort order (needs attention first, lowest uptime, most incidents, priority,
  name).

Each **project card** shows:

- the project colour, name, priority and health;
- uptime against the target, with the trend;
- the error budget bar;
- one bar per day, green when the day met the target. Hover a bar for that day's uptime
  and incidents;
- endpoints up out of the total (with how many are down), incidents (with how many are
  open), MTTR and p95;
- the weakest endpoint, when one wasn't up the whole time.

Click a card to open the project: edit it, see its endpoints, add one. On hover, a card
also shows **Analytics** (that project in Project Analytics) and **Delete**
(administrators only).

**Endpoint** adds an endpoint and **New project** creates a project. Endpoints not in a
project are listed under **Orphan Endpoints**, where you can move them.

Link to one project with `/dashboard/projects?open=<project id>`.

## Project Analytics

- **Period** (7/30/90 days) and **CSV**, which downloads the comparison table.
- **Figures**:
  - uptime, with its trend;
  - projects within target out of those measured. Click to sort by error budget;
  - incidents compared with the previous period;
  - open incidents, with how many are critical;
  - time to acknowledge;
  - time to resolve.
- **Uptime per day**: all projects together (dashed) and one line per project (up to 8).
  Click a name in the legend to hide or show its line.
- **Incidents per day**, stacked by severity.
- **Projects compared**:
  - uptime and its trend;
  - one bar per day;
  - error budget;
  - incidents and how many are open;
  - time to acknowledge and to resolve;
  - p95;
  - endpoints up out of the total.

  Click a column header to sort. Click a row to open the project panel.
- **Incidents by severity**, **What opened them** (health checks, logs or metrics) and
  **Weakest endpoints** across all projects.

The **project panel** shows:

- the project's health and priority, with a link to open it in Projects;
- uptime, incidents, time to acknowledge and time to resolve;
- the **error budget**, and **Change target** for members and administrators: 99%,
  99.5%, 99.9%, 99.95% or any value from 50 to 99.999;
- uptime per day, with the target as a dashed line;
- its endpoints, weakest first: uptime and trend, p95, incidents, and one bar per day.
  Click one to open the endpoint;
- its incidents, with duration or *open*. Click one to open the incident.

Link to a project's panel with `/dashboard/project-analytics?project=<project id>&days=30`.

## API

| Method and path | Returns |
|---|---|
| `GET /api/v1/projects/insights?days=30` | Every project: health, endpoints by status, uptime, previous uptime, target, budget used, p95, incident figures (by severity, by source, MTTA, MTTR), one entry per day, weakest endpoints. Also totals and incidents per day by severity |
| `GET /api/v1/projects/:id/insights?days=30` | The same for one project, plus its endpoints (with one value per day) and its recent incidents |
| `PUT /api/v1/projects/:id/sla-target` | `{ "sla_target": 99.9 }` (members and administrators) |
| `GET /api/v1/overview/status` | The status board: summary, every endpoint with 48 half-hour slots, and the recent changes |

`days` is 1–90 (default 30).

## Limits

- Uptime counts checks, not minutes. An endpoint checked every 30 seconds and one
  checked every 5 minutes both count as one endpoint in the project average.
- Health checks are kept for `HEALTH_RETENTION_DAYS` (90 by default). A 90-day period
  compares with the 90 days before only if that history still exists.
- *Recent changes* lists outages detected by health checks. Incidents opened from logs or
  metrics appear on the Incidents page.

---

← [Configuration](../configuration/environment-variables.md) · [Contents](../README.md) · [Endpoints and checks](health-checks.md) →
