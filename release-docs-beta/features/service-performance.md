# Service analytics

> Response times, Apdex and anomalies, network phases and certificates for every endpoint.

## What it is

Four pages under **Services** that turn every health check into answers:

| Page | Answers |
|---|---|
| **Response Analytics** | How fast do my endpoints answer, and is it getting worse? |
| **Performance Insights** | Would users be happy with that speed (Apdex)? Is anything unusual right now? |
| **Network Analysis** | Where does a request's time go: DNS, connecting, TLS, the server, or the download? |
| **SSL Certificates** | Which certificates expire soon, and how are they configured? |

Every page is clickable. A figure at the top filters the table or opens the endpoint
behind it, a row opens a side panel with that endpoint's details, and from there you can
open the endpoint itself, its metrics, its logs or its incidents.

Everything is limited to your organization.

## Where to find it

Sidebar → **Services** → **Response Analytics**, **Performance Insights**,
**Network Analysis** or **SSL Certificates**.

## What every page has

### Filters

At the top right:

| Filter | Effect |
|---|---|
| **Search** | Endpoint name, project, URL (and domain on SSL Certificates) |
| **Project** | One project, or all. The charts follow it too |
| **Period** | 24 hours, 7 days, 14 days, 30 days (not on SSL Certificates) |

The filters are kept in the address bar (`?days=30&project=…&q=orders`), so you can
bookmark a view or send it to someone.

### Figures that do something

A figure with an arrow on hover is clickable:

- a count such as **Slow**, **Need attention** or **Expiring within 30 days** filters the
  table to those endpoints (click it again to show everything);
- a single endpoint such as **Slowest endpoint** or **Next to expire** opens its side panel;
- on Network Analysis, a phase (**DNS**, **TLS**, …) ranks the endpoints by that phase.

### The endpoint table

- Click a column header to sort; click again to reverse.
- The chips above the table (**All**, **Slow**, **With failures**, …) are quick filters, with
  how many endpoints each one holds.
- Click a row (or press Enter on it) to open its side panel.
- The four icons at the end of a row go straight to:

| Icon | Opens |
|---|---|
| Open endpoint | The endpoint's details on Services → Endpoints |
| Metrics | The same, on its **Metrics & dashboards** tab |
| Logs | The Log Browser, limited to the endpoint's linked logs |
| Incidents | The incident list, searched for the endpoint's name |

### The side panel

The panel shows the endpoint's own figures and charts for the page you are on, the same
four links, and at the bottom links to the endpoint on the other three pages
(e.g. from its response times to its network timing). Close it with ✕, Esc, or a click
outside. The open endpoint is in the address bar (`?endpoint=<id>`), so a link opens
the page with that panel open.

## Response Analytics

**Figures**

| Figure | Meaning | Click |
|---|---|---|
| Typical p95 | The median of the endpoints' p95: what a normal endpoint looks like | – |
| Slowest endpoint | The highest p95, and which endpoint | Opens it |
| Slow (p95 > 1 s) | Endpoints whose p95 is above 1 second | Shows only those |
| Checks | All checks in the period, and how many failed | Shows endpoints with failures |

**Charts**

- **Response time over time**: p50, p95 and p99 per hour (24 hours), per 6 hours (7 days),
  per 12 hours (14 days) or per day (30 days).
- **Spread of response times**: successful checks by how long they took, from *< 100 ms*
  to *> 2 s*.

**Table**: p50, p95, p99 (green under 300 ms, amber under 1 s, red above), a p95 trend
line, the share of failed checks, and the number of checks.

**Side panel**: p50, p95, p99, average, fastest, slowest, checks, failed; the endpoint's own
trend and spread; and failed checks over time when there were any.

> Percentiles use **successful** checks only, so an outage doesn't hide in the p95; it
> shows in *Failed* instead.

## Performance Insights

### Apdex

Apdex scores how satisfied users would be with response times, from 0 to 1. Each check is:

| Check | Counts as |
|---|---|
| Successful and at most **T** | Satisfied (1) |
| Successful and at most **4×T** | Tolerating (½) |
| Slower than 4×T, failed or timed out | Frustrated (0) |

Apdex = (satisfied + tolerating ÷ 2) ÷ all checks.

| Score | Rating |
|---|---|
| 0.94 and up | Excellent |
| 0.85 – 0.94 | Good |
| 0.70 – 0.85 | Fair |
| 0.50 – 0.70 | Poor |
| below 0.50 | Unacceptable |

**T, the target response time**, is per endpoint:

1. the latency threshold of the endpoint's SLO ([SLOs](reliability/slos.md)), else
2. the endpoint's *expected response time* (edit the endpoint), else
3. 100 ms.

A low score with T = 100 ms often only means T is too strict for that endpoint. Set its
expected response time to what users actually tolerate (e.g. 500 ms for a page, 1 s for a
report), and the score follows on the next refresh.

**Figures**

| Figure | Meaning | Click |
|---|---|---|
| Overall Apdex | Apdex over every check in scope | – |
| Need attention | Endpoints below 0.70 | Shows only those |
| Active anomalies | Anomalies not yet back to normal | Scrolls to the list |
| Frustrated checks | Checks slower than 4×T or failed | – |

**Apdex over time**: the score per point in time, with dashed lines at 0.94 (Excellent)
and 0.70 (Fair).

**Table**: worst first, with the satisfied / tolerating / frustrated split as a bar, an
Apdex trend line, T and the number of checks.

**Side panel**: the score and rating, the split with counts and shares, T, Apdex over
time, and the endpoint's anomalies.

### Anomalies

Two detectors write anomalies:

| Kind | Found by | Compared with |
|---|---|---|
| Slower responses | Health checks (every 5 min) | The 7-day average; at least 50% **and** 100 ms slower |
| Slower responses (p95) | Application metrics (every 10 min) | Same time last week (or yesterday) |
| More 5xx errors | Application metrics | Same time last week |
| Traffic drop / spike | Application metrics | Same time last week |

Each shows the value now, the normal value, the change in %, its severity, where it came
from, and whether it is still active or when it went back to normal. Click one to open
the endpoint's side panel. **Active** / **All** switches between open anomalies and
everything in the period.

The metrics-based kinds need the endpoint linked to its application metrics
([Connected monitoring](metrics/connected-monitoring.md) and [Capacity and anomalies](reliability/capacity-and-anomalies.md)).

## Network Analysis

Every HTTP(S) check is timed in five phases:

| Phase | What it is | Measured on |
|---|---|---|
| **DNS** | Finding the server's address | A fresh connection |
| **Connect** | Opening the TCP connection | A fresh connection |
| **TLS** | Setting up encryption (https) | A fresh connection |
| **Server** | Time to first byte: the server preparing the response | The check itself |
| **Download** | Receiving the response body | The check itself |

**First request** is the five phases added up: what a new visitor waits. The check's
own **response** time is usually shorter, because the checker reuses its connection the
way a browser does on later requests.

**Figures**: one per phase (average, and its share of the first request) and
**First request**. Click a phase to rank the endpoints by it; the column is highlighted.

**Charts**: **Where the time goes** lays the phases end to end with their times and
shares; **Over time** stacks them per point in time.

**Table**: the phases as a bar (scaled to the slowest endpoint), each phase, first request
and response (p95 in the tooltip).

**Side panel**: first request, check response, p95, the breakdown, the phases over time,
and **What this suggests**, plain rules on the averages:

| When | It says |
|---|---|
| Server > 50% of the time | Look at the application, its database or its dependencies, not the network |
| Download > 100 ms and > 40% | The body is large or the link slow; compress or shrink the response |
| TLS > 100 ms | Move the TLS endpoint closer, or use TLS 1.3 with session resumption |
| Connect > 100 ms | The server is far from Pulsimo, or slow to accept connections |
| DNS > 50 ms | Use a faster resolver or a longer TTL |

A DNS time near 0 means the answer came from cache. Databases and other non-HTTP
endpoints have no phases and don't appear here.

## SSL Certificates

Pulsimo reads the certificate of every https endpoint when it checks it.

**Figures**

| Figure | Meaning | Click |
|---|---|---|
| Valid | Valid for more than 30 days | Shows only those |
| Expiring within 30 days | Renew these | Shows only those |
| Expired or invalid | Browsers reject these | Shows only those |
| Next to expire | The soonest expiry, its domain and date | Opens it |

**Expiry timeline**: the eight soonest expiries; the bar fills over the last 90 days.

**Configuration**: how many certificates have each security grade and TLS version
(green A / TLS 1.3, amber B / TLS 1.2, red otherwise).

**Table**: endpoint and domain, issuer, expiry date and days left, grade, TLS version,
status.

**Side panel**: status and days left, grade, TLS version, the certificate's lifetime (or
chain length), validation problems if any, and the details: domain, subject, issuer,
valid from / until, serial number and SHA-256 fingerprint (click to copy) when known,
the endpoint URL and when it was last checked.

Days left are computed when you open the page, not when the certificate was read.

## Links you can build

| Link | Opens |
|---|---|
| `/dashboard/services/response-analytics?days=30&project=<id>` | Response Analytics, 30 days, one project |
| `/dashboard/services/performance-insights?endpoint=<id>` | Performance Insights with that endpoint's panel open |
| `/dashboard/services/network-analysis?q=checkout` | Network Analysis searched for "checkout" |
| `/dashboard/services/endpoints?open=<id>&tab=metrics` | The endpoint, on its Metrics & dashboards tab (`tab=logs` for Logs) |
| `/dashboard/logs?endpoint=<id>` | The Log Browser for that endpoint's logs |
| `/dashboard/incidents?q=<text>` | Incidents, searched |

## How it works

Everything is computed on request from the `health_checks` table of your organization's
endpoints, so the pages always agree with each other and with the endpoint details.

| API (all `GET`, signed in) | Returns |
|---|---|
| `/api/v1/performance/percentiles` | Per endpoint: checks, failures, error rate, p50–p99, min, max, avg, last check |
| `/api/v1/performance/latency-distribution` | Successful checks in six response-time buckets |
| `/api/v1/performance/percentile-trends` | p50, p95, p99, avg, checks and failures per point in time |
| `/api/v1/performance/sparklines` | p95 and Apdex per endpoint per point in time |
| `/api/v1/performance/apdex` | Per endpoint: score, rating, satisfied / tolerating / frustrated, T |
| `/api/v1/performance/apdex/trend` | Apdex per point in time |
| `/api/v1/performance/anomalies` | Anomalies with value now, normal value, unit, change, status |
| `/api/v1/performance/network-timing` | Per endpoint: average phases, response, p95, checks |
| `/api/v1/performance/network-trends` | Average phases per point in time |
| `/api/v1/ssl/certificates` | The latest certificate per https endpoint, soonest expiry first |

They all take `days` (1–90, default 7), `endpoint_id` and `project_id`. The point size
follows the period: 1 hour (1 day), 6 hours (up to 7 days), 12 hours (up to 14 days),
1 day (longer).

## Limits

- The figures cover what Pulsimo measures from where it runs. Users far from Pulsimo see
  different network times.
- The percentile and Apdex figures need checks in the period; a new or paused endpoint
  shows "–" until it has some.
- The API reads up to 90 days, but the page offers 30 at most, and only within your
  health-check retention ([System and database health](observability/system-health.md)).
- Certificate serial number, fingerprint, subject and chain are shown only when the
  certificate check recorded them.

---

← [Monitoring from metrics](metric-monitors.md) · [Contents](../README.md) · [Dependencies](dependencies.md) →
