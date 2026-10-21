# Dependencies

> A live map of which service needs which, suggestions with evidence, and impact on incidents.

## What it is

A live map of which service needs which. "Orders API depends on PostgreSQL" is used to:

- show the **impact** of an outage: who else is hit, and who can't work at all;
- add the likely cause to **alerts**: "probably caused by PostgreSQL, down since 14:02";
- rank **probable causes** on incidents: a dependency that failed first;
- find **weak spots**: single points of failure, long chains, cycles.

Everything is scoped to your organization. No other organization can see or change your map.

## Where to find it

- **Dependencies** in the sidebar: **Map**, **Suggestions**, **Analysis**.
- **Incident page → Dependencies**: what the failing service needs and who depends on it.
- **Alerts** for a service that goes down include a *Dependencies* section.

## The map

The KPI row at the top:

| Figure | What it counts |
|---|---|
| Services on the map | Services with a known dependency, out of all services |
| Dependencies | All dependencies, and how many are *required* |
| Affected now | Services whose dependency is unhealthy |
| Single points of failure | See Analysis |
| Suggestions | Waiting for you to confirm |
| Cycles | See Analysis |

When anything is affected, a banner names the unhealthy services and who they affect.

**Reading the map**: an arrow **A → B** means *A depends on B*. Services nobody depends on
(front ends, public APIs) are at the top; what they need is below them; the deepest
dependencies (databases, caches) are at the bottom. Services with no known dependency sit
in a last row.

| On a service | Meaning |
|---|---|
| Green / amber / red dot | Up / degraded / down, from its checks and open incidents |
| Project colour and name | Its project (Orphan Endpoints included) |
| **N incidents** (bug icon: from logs) | Open incidents |
| **needs N unhealthy** (amber border) | Something it requires is down or degraded |
| **changed** | A deploy or restart of its metric source in the last 6 hours |

| On an arrow | Meaning |
|---|---|
| Solid | **Required**: it can't work without it |
| Dashed | **Degrades without it**: it keeps working, worse |
| Dotted | **Fallback**: used only when the main one fails |
| Red, moving | What it points to is **down** |
| Amber | What it points to is **degraded** |
| Label | The kind of connection, when not HTTP: Database, Cache, Queue… |

**Using the map**:

- Click a service for its details: status, the open incident, recent changes, what it
  depends on and what needs it, how many services it can affect, and **It depends on…**
  to add one.
- Click an arrow to see how it was found (evidence, who confirmed it), and **Change or
  remove**.
- **Find a service**, highlight **a project**, show **Problems only** (unhealthy services
  and what they need), or hide services with no known dependencies.
- Drag services to arrange them. The layout is saved for you. **Auto layout** arranges
  them again.
- **Add dependency** (or drag from one service's bottom handle to another): choose the
  service, what it depends on, how much it needs it, and the kind of connection.

## Suggestions: found from what Pulsimo measures

Every 30 minutes (`DEPENDENCY_SCAN_MINUTES`), or when you press **Look for dependencies**,
Pulsimo looks in what it already collects:

| Source | What it sees | Confidence |
|---|---|---|
| **Client metrics** | An app's outgoing request metrics name another service's address (`server_address`, `peer_service`, `host`… labels). The evidence says how often it calls, e.g. "calls payments-api about 12 times a minute" | 85% |
| **Logs** | The app's own lines call another service's address (URLs, `upstream` / `peer_service` fields), or fail to connect to it (`dial tcp payments:8080: connection refused`, `could not connect to server: postgres:5432`). At least 2 lines in the last hour. Access-log lines are ignored: they are requests *to* the app, and their referer URLs would mislead | 70–80% |
| **Incident timing** | Over 30 days, at least 3 times, B failed first and A failed 15 s to 2 min later. It must happen more often in that order than the other way round, on different hosts, and not during an outage that took most of your services down at once | 40–60% |

Each suggestion shows its evidence:

- the summary;
- for logs, a sample line;
- for incident timing, the dates.

Each suggestion can be:

- **Confirmed**, choosing *Required / Degrades without it / Fallback* and the kind of
  connection (guessed from the port: 5432 is a database, 6379 a cache…);
- marked **Not a dependency**, after which it is never suggested again.

Suggestions that stop being true are removed:

- timing suggestions as soon as the pattern no longer holds;
- metrics and logs suggestions after 7 days without being seen.

Nothing is added to the map without a person confirming it. Pulsimo no longer guesses
dependencies from service types ("every front end depends on every back end").

## Analysis

| Section | What it lists |
|---|---|
| **Single points of failure** | A service required (directly or not) by 2 or more services that have no fallback for it, and those services |
| **Longest chains** | A needs B needs C…: each extra link is another way to fail |
| **Cycles** | Services that end up depending on themselves |
| **Not on the map yet** | Services with no known dependency either way, with **It depends on…** |

Click any service to jump to it on the map.

## During incidents

- **Incident page → Dependencies**:
  - *It depends on*: what the service needs, marked when unhealthy. A required dependency
    that is unhealthy too is called out as the **likely cause**;
  - *Affected*: every service that depends on it, directly or not, and how many can't work
    without it.
- **Alerts** ("Service down", escalations, incidents from logs) add:

  ```
  Dependencies:
  - Probably caused by a dependency that is down: PostgreSQL (down since 14:02 UTC).
  - 3 services can't work without it: Orders API, Checkout, Billing worker.
  ```

  Only **required** dependencies are used for this.
- **Probable cause** ([Probable cause](probable-cause.md)) ranks "a dependency went down
  first".

## Settings

| Variable | Default | Meaning |
|---|---|---|
| `DEPENDENCY_SCAN_MINUTES` | `30` | How often suggestions are looked for (metrics collector) |

## Limits

- The map shows monitored endpoints. A database or host that Pulsimo only found in metrics
  appears once you monitor it (Services → Discovered).
- Logs suggestions need the service's logs linked to its endpoint
  ([Logs](logs/README.md)). Client-metrics suggestions need the app's metric source
  linked to its endpoint ([Connected monitoring](metrics/connected-monitoring.md)).
- "Affected now" uses each service's own status and open incidents. The computed health
  from dependencies (fallbacks, degraded mode) is shown on the endpoint's health section.

---

← [Service analytics](service-performance.md) · [Contents](../README.md) · [Metric sources](metrics/sources.md) →
