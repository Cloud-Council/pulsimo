# API reference

> Every REST endpoint, grouped by feature.

Every endpoint is under `/api/v1` on the API address (port 8080 by default) and needs a signed-in session or an API key: see [Authentication](authentication.md). The core resources come first; the rest are grouped by feature, with details on each feature's page.

## Projects

| Method and path | Does |
|---|---|
| `GET /api/v1/projects` | List projects |
| `POST /api/v1/projects` | Create a project |
| `GET /api/v1/projects/:id` | One project |
| `PUT /api/v1/projects/:id` | Change a project |
| `DELETE /api/v1/projects/:id` | Delete a project (administrators) |

## Endpoints

| Method and path | Does |
|---|---|
| `GET /api/v1/endpoints` | List endpoints with their status |
| `POST /api/v1/endpoints` | Add an endpoint (`name`, `url`, `service_type`, `api_protocol`, `check_interval_seconds` 10 to 3600, `timeout_seconds`, `expected_status_code`, `project_id`…) |
| `GET /api/v1/endpoints/:id` | One endpoint |
| `PUT /api/v1/endpoints/:id` | Change it; `is_active: false` pauses it |
| `DELETE /api/v1/endpoints/:id` | Delete it (administrators) |
| `GET /api/v1/endpoints/:id/history` | Recent check results |
| `GET /api/v1/endpoints/:id/stats` | Uptime and response-time figures |

## Incidents

| Method and path | Does |
|---|---|
| `GET /api/v1/incidents` | List incidents |
| `POST /api/v1/incidents` | Open an incident by hand |
| `GET /api/v1/incidents/stats` | Counts by state and severity |
| `GET /api/v1/incidents/:id` | One incident |
| `PUT /api/v1/incidents/:id` | Change it (title, severity, assignee…) |
| `PUT /api/v1/incidents/:id/state` | Move it to another state |
| `POST /api/v1/incidents/:id/acknowledge` | Acknowledge: reminders and escalation stop |
| `GET /api/v1/incidents/:id/timeline` | Everything that happened, in order |
| `POST /api/v1/incidents/:id/updates` | Add an update |
| `GET /api/v1/incidents/:id/evidence` | Metrics, logs and changes saved with it |
| `GET /api/v1/incidents/:id/post-mortem` | A post-mortem draft with impact and evidence |
| `DELETE /api/v1/incidents/:id` | Delete it (administrators) |

## Alarms and maintenance

| Method and path | Does |
|---|---|
| `GET /api/v1/alarms` | Open and past alarms |
| `GET /api/v1/alarms/:id` | One alarm with its timeline |
| `POST /api/v1/alarms/:id/acknowledge` | Acknowledge one alarm |
| `POST /api/v1/alarms/acknowledge` | Acknowledge several |
| `POST /api/v1/alarms/:id/resolve` | Resolve by hand |
| `GET /api/v1/alarm-rules` | Alarm rules |
| `POST /api/v1/alarm-rules/preview` | Try a rule on recent data before saving |
| `PUT /api/v1/alarm-rules/:id/enabled` | Turn a rule on or off |
| `GET /api/v1/maintenance-windows` | Maintenance windows |
| `POST /api/v1/maintenance-windows/:id/end` | End a running window now |

## Projects and overview

| Method and path | Returns |
|---|---|
| `GET /api/v1/projects/insights?days=30` | Every project: health, endpoints by status, uptime, previous uptime, target, budget used, p95, incident figures (by severity, by source, MTTA, MTTR), one entry per day, weakest endpoints. Also totals and incidents per day by severity |
| `GET /api/v1/projects/:id/insights?days=30` | The same for one project, plus its endpoints (with one value per day) and its recent incidents |
| `PUT /api/v1/projects/:id/sla-target` | `{ "sla_target": 99.9 }` (members and administrators) |
| `GET /api/v1/overview/status` | The status board: summary, every endpoint with 48 half-hour slots, and the recent changes |

`days` is 1–90 (default 30).

More in [Projects and overview](../features/projects.md).

## Change markers

`GET /api/v1/changes?from=<unix>&to=<unix>[&source_id=…][&endpoint_id=…]`

More in [Change markers](../features/reliability/change-markers.md).

## Channels and delivery

| Method and path | Does |
|---|---|
| `GET /api/v1/notification-channels` | Channels, paused ones included, with masked secrets, target, categories and 7-day stats |
| `GET /api/v1/notification-channels/summary` | The figures at the top |
| `POST /api/v1/notification-channels` | Add (`name`, `channel_type`, `config`, `repeat_interval_minutes`, `categories`, `min_severity`, `project_ids`) |
| `PUT /api/v1/notification-channels/:id` | Edit. Masked or empty secrets keep the saved value |
| `PUT /api/v1/notification-channels/:id/active` | `{ "is_active": false }` pauses, `true` resumes |
| `POST /api/v1/notification-channels/:id/test` | Sends a test and waits for the result (`ok`, `error`, `took_ms`) |
| `DELETE /api/v1/notification-channels/:id` | Delete (administrators) |
| `GET /api/v1/notifications/deliveries` | The log. Filters: `channel_id`, `endpoint_id`, `status`, `include_tests`, `limit`, `before` |

Errors come back with a message and a status: 403 when you're not allowed, 404 when the
channel doesn't exist, 422 when the settings are invalid, and 504 when the notification
service didn't answer the test.

More in [Channels and delivery](../features/alerts.md).

## Users and access

All signed in; most are administrators only.

| Method and path | Does |
|---|---|
| `GET /api/v1/users` | The list with status, security, workload and warnings, the organization's figures, the password policy, and `can_manage` |
| `POST /api/v1/users` | Add (`name`, `email`, `password`, `role`) |
| `GET /api/v1/users/:id` | Details: everything above plus assigned incidents, activity, account changes, sign-ins, permissions |
| `PUT /api/v1/users/:id` | Change `name`, `email`, `role`, `is_active`, `phone`, `timezone`, `bio` |
| `DELETE /api/v1/users/:id` | Delete (409 when the person has history) |
| `POST /api/v1/users/:id/password` | `{ new_password, old_password? }`; `old_password` for your own |
| `POST /api/v1/users/:id/unlock` | Clear a lock |
| `POST /api/v1/users/:id/sign-out` | Sign out everywhere |
| `GET /api/v1/users/:id/permissions` | The role's permissions |
| `GET /api/v1/users/password-policy` | The password rules |
| `GET /api/v1/users/assignment` | Who can be assigned incidents, with their open incidents |

Refusals use 403 (not allowed), 404 (not in your organization), 409 (a safety rule or a
duplicate email) and 422 (password or email rules). The message says why.

More in [Users and access](../features/users.md).

## Settings and API keys

API keys let scripts, CI pipelines and other tools use the Pulsimo API.

**New key** asks for three things:

| Field | Options |
|---|---|
| Name | e.g. "GitHub Actions deploy". Use one key per tool so you can revoke it on its own |
| Access | **Read-only** (default): read endpoints, incidents, metrics, logs. **Read and write**: as a member. **Administrator**: everything |
| Expires | Never, 30 days, 90 days or 1 year |

The key (`ptk_…`) is shown **once**, with a `curl` example to try it. Pulsimo stores only
a hash of it.

**Using a key:**

```bash
curl -H "Authorization: Bearer ptk_…" https://pulsimo.example.com/api/v1/endpoints
curl -H "X-API-Key: ptk_…" https://pulsimo.example.com/api/v1/incidents
```

**What a key can do:**

- It acts as the administrator who created it, so events in the Event Trail show that
  person.
- Its access is the lower of what you chose and that person's current role.
- It stops working when you revoke it, when it expires, or when its creator is deactivated
  or deleted. The list then shows *Expired* or *Owner gone*.

The list shows each key's name and the start of the key, its access, who created it, when
it was last used, and when it expires. The bin icon revokes a key; anything using it stops
working at once.

More in [Settings and API keys](../features/settings.md).

## API metrics and Event trail

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

Records are kept for `API_METRICS_RETENTION_DAYS` (30 by default, [Configuration](../configuration/environment-variables.md)).

More in [API metrics and Event trail](../features/observability/api-metrics.md).

## Authentication

Create a key on **Settings → API keys → New key** (administrators only). Pick a name, an
access level and an expiry. The key starts with `ptk_` and is shown **once**.

Send it in either header:

```bash
curl -H "Authorization: Bearer ptk_…" https://pulsimo.example.com/api/v1/endpoints
curl -H "X-API-Key: ptk_…" https://pulsimo.example.com/api/v1/incidents
```

| Access | Can |
|---|---|
| Read-only (default) | Read endpoints, incidents, metrics and logs |
| Read and write | What a member can do |
| Administrator | Everything |

A key acts as the administrator who created it, so its actions show that person in the
Event trail. Its access is the lower of the level you chose and that person's current
role. It stops working when it is revoked, when it expires, or when its creator is
deactivated or deleted. Use one key per tool so you can revoke it on its own. More in
[Settings and API keys](../features/settings.md#api-keys).

More in [Authentication](authentication.md).

---

← [Authentication](authentication.md) · [Contents](../README.md) · [Webhooks](webhooks.md) →
