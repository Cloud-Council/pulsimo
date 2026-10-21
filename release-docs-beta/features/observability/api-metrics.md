# API metrics and Event trail

> How Pulsimo's API answers per route, and who did what, with filters and export.

Two pages under **Pulsimo** in the sidebar that look at Pulsimo itself: how its API is
answering your organization, and who did what.

## API metrics

**Pulsimo → API metrics**. Every request your organization's users and API keys make to
Pulsimo's API is recorded: route, method, status code and how long it took. Routes are
grouped, so `/api/v1/endpoints/3f2c…` and `/api/v1/endpoints/9a1b…` count as
`/api/v1/endpoints/:id`. Use it when pages feel slow or something fails to load.

Pick the period at the top: 1 hour, 6 hours, 24 hours, 7 days or 30 days. Every figure is
compared with the period just before it.

| Card | Meaning |
|---|---|
| **Requests** | Requests in the period, and the change against the period before |
| **Per minute** | Average requests per minute, and how many routes were used |
| **p95 latency** | 95% of requests were faster than this. Amber from 300 ms, red from 1 s |
| **p99 latency** | The slowest 1%, with the median (p50) and average under it |
| **Server errors** | 5xx answers: something broke in Pulsimo. The change is in percentage points of all requests. Click to list only routes with errors |
| **Client errors** | 4xx answers: bad input, no access, something not found. Usually the caller's mistake |

**Traffic and latency** draws requests per interval (grey OK, amber 4xx, red 5xx) with the
p50 and p95 lines on the right axis, so a slow spell and a burst of traffic line up.

**Status codes** shows the share of every answer. **Slowest routes** (by p95, at least 5
requests) and **Routes with errors** list where to look first; click one to open it.

**Routes**: every route with a sparkline of its requests, its share of all traffic, p50,
p95 (with ▲ / ▼ when it moved 10% or more against the period before), p99 and its 4xx and
5xx counts. Filter by text and method, tick **Only routes with errors**, and sort by any
column.

Click a route for its panel:

- p50, p95, p99, average, requests, 4xx, 5xx and success rate;
- its own traffic and latency chart;
- **How long requests take**: a histogram in 250 ms steps up to 5 s;
- its status codes;
- the **slowest requests**, with the exact path and time;
- the **latest errors**, with the status and the error message when there is one.

Records are kept for `API_METRICS_RETENTION_DAYS` (30 by default, [Configuration](../../configuration/environment-variables.md)).

## Event trail

**Pulsimo → Event trail**. Everything that happened in your organization: sign-ins, every
change to endpoints, alarm rules, channels, projects, dashboards and sources, incidents
opened and resolved, and what Pulsimo did on its own.

Only your organization's events are shown. Administrators also see Pulsimo's platform jobs
(clean-ups, aggregation) and the IP address and browser of each action.

### The top of the page

Pick 24 hours, 7, 30 or 90 days. **Live** adds new events every 10 seconds; click it to
pause. **CSV** and **JSON** download the events you are looking at, with the current
filters (up to 10,000). CSV cells are quoted, and values starting with `=`, `+`, `-` or `@`
are prefixed so spreadsheets don't run them as formulas.

| Card | Meaning | Click |
|---|---|---|
| **Events** | All events, and the change against the period before | Clears the filters |
| **People active** | Signed-in users who did something | Only events by people |
| **Changes** | Things people created, changed, paused or deleted, with the number of deletions | |
| **Sign-ins** | Sign-ins, and how many failed | Only sign-in events |
| **Failed** | Actions that did not go through | Only failed events |
| **By Pulsimo** | Incidents, jobs and automatic changes | Only Pulsimo's own events |

### Activity

A feed, newest first and grouped by day, written as sentences: *"Dana Rahman deleted
endpoint Orders API"*. Each row shows the area, *what changed* when the event recorded the
before and after values, and *failed* with the reason.

Filters: search (people, items, descriptions), area, action, person, **Anyone / People /
Pulsimo** and **Any result / Failed only**. Active filters show as chips; **Clear all**
removes them. **Save view** keeps the current filters under a name in this browser.

Click an event for its panel:

- who, when, what (with a link to the endpoint, incident, rule or channel), from where
  (web or API), and for administrators the IP address and browser;
- the error, if it failed;
- **What changed**: each field with its value before and after;
- **Details**: everything else the event recorded;
- **Earlier on this item** and **the same person, 15 minutes either side**, both clickable;
- **Everything about this item** and **Everything by this person** filter the feed.

### Insights

- **Activity over time**: changes by people, sign-ins, Pulsimo's own events and failures.
- **Most active people** and **Most changed** items: click one to filter the feed.
- **By area**: how events split between endpoints, incidents, sign-ins and so on.
- **When things happen**: events by day of the week and hour (UTC), useful to spot
  changes at unusual hours.

Events are kept for `EVENT_TRAIL_RETENTION_DAYS` (180 by default, [Configuration](../../configuration/environment-variables.md)).

---

← [Settings and API keys](../settings.md) · [Contents](../../README.md) · [System and database health](system-health.md) →
