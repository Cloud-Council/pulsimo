# Channels and delivery

> Slack, Discord, Teams, Google Chat, email and webhooks, with tests, a delivery log and muting.

## What it is

**Alerting** (sidebar) is one page for what is wrong and who gets told. Its **Alarms**
tabs (Open now, History, Rules, Maintenance) are described in [Alarms and rules](alarms.md). This chapter
covers the **Delivery** tabs and the help tab:

| Tab | What it shows |
|---|---|
| **Channels** | Each alert channel: Slack, Discord, Microsoft Teams, Google Chat, email or a webhook. For each one: whether its last delivery worked, its 7-day counts, and how often it sends reminders |
| **Delivery log** | Every alert Pulsimo tried to send, with the full message and the platform's answer |
| **Muted** | Endpoints whose alerts are switched off for now |
| **How it works** | When alerts are sent, reminders, holds, deploys, flapping, digests, routing |

## Where to find it

In the sidebar, open **Alerting**, then **Channels**, **Delivery log** or **Muted**. Direct links: `/dashboard/alarms?tab=channels`, `?tab=deliveries`, `?tab=muted`, `?tab=how`. The old `/dashboard/notifications` address still works and opens the same tab. **Add channel** is in the page header on every tab.

## The figures at the top

| Figure | Meaning | Click |
|---|---|---|
| Channels | Active channels, and how many are paused | Opens Channels |
| Delivered, 24 h | Alerts delivered in the last 24 hours, and when the last one was sent | Opens the log |
| Failed, 24 h | Deliveries the platform refused or couldn't receive | Opens the log, showing failures only |
| Muted endpoints | Endpoints with alerts switched off | Opens Muted |
| Digest | How often low-urgency findings are grouped into one message | Opens How alerts work |

When there is no channel at all, a banner warns you: incidents still open, but nobody is
told.

## Adding a channel

Click **Add channel**, then:

1. **Platform.** Each platform tile lists the steps to get its webhook:

   | Platform | You enter |
   |---|---|
   | Slack | The Incoming Webhook URL; optionally a channel override (only older webhooks use it) |
   | Discord | The channel webhook URL |
   | Microsoft Teams | The URL from a Teams workflow or connector |
   | Google Chat | The space webhook URL |
   | Email | One or more addresses, separated by commas (at most 20) |
   | Webhook | URL, method (POST, PUT or PATCH) and optional headers, e.g. `Authorization` |

2. **Name.** Something people recognize, e.g. "Slack – production on-call".
3. **Severity.** *Everything* (info, warning, critical and the digest), *Warning and up*,
   or *Critical only* (a pager or on-call channel). See [Alarms and rules](alarms.md).
4. **Projects** (when there is more than one). Only alarms about the chosen projects;
   nothing chosen means every project. Alarms that belong to no project always come.
5. **Repeat while firing.** While a critical alarm stays unacknowledged, this channel gets a
   reminder every 5 min, 15 min, 30 min, 1 h, 2 h, 4 h, or a custom number of minutes
   (1–1440).
6. **Which alerts.** Choose **Everything**, or only alerts about **Applications**,
   **Databases**, **Hosts** or **Containers**. The category comes from the endpoint's
   linked metrics. Alerts without linked metrics always go to every channel.
7. **Send a test after saving** (on by default for a new channel). The test goes through
   the same path as real alerts, and the result shows when the channel is saved.

The form scrolls on small screens, and the buttons stay at the bottom. If something is
missing (a name, a URL that doesn't start with `https://`), the reason shows next to the
button.

### Secrets

Webhook URLs and header values are secrets, so the page never shows them in full. You see
`https://hooks.slack.com/…a1b2`. When you edit a channel:

- leave the URL field empty to keep the saved one;
- for headers, leave the value empty to keep it;
- type a new value to replace it.

If you change a channel's platform, you need to enter a new URL.

## The channel card

| Part | Meaning |
|---|---|
| Name, platform and target | e.g. `hooks.slack.com · #ops`, `oncall@company.com and 2 more`, `POST api.example.com` |
| Health line | *Last delivered 2 h ago*, *Last delivery failed 5 min ago: The platform answered HTTP 404 (the webhook no longer exists; create a new one)*, *Nothing sent yet*, or *Paused* |
| Delivered / Failed, 7 d | Real alerts only; tests don't count |
| Repeat | The reminder interval |
| Route line | The severity it takes, the categories and the number of projects |

The actions are:

- **Send test:** sends a real message now and shows *Test delivered in 0.8 s* or the platform's error.
- **Log:** opens the delivery log for this channel.
- **Pause / Resume:** a paused channel gets nothing, and keeps its settings.
- **Edit.**
- **Delete:** administrators only. It also removes the channel's delivery history and its mutes. The dialog offers **Pause instead**.

Members and administrators can add, edit, test and pause channels; viewers can only look.

## Delivery log

The log shows every attempt, newest first:

- a coloured dot for the kind of alert: red for down or escalated, green for recovered,
  amber for warnings, blue for tests;
- the subject, the channel, the alert kind and the endpoint;
- the result: **Sent**, **Failed** or **Pending**;
- when it happened.

Click an entry to see the full message, the platform's error if any, when it was queued
and delivered, and a link to the endpoint.

You can filter by channel and by result, hide tests, and load older entries 50 at a time.
The log refreshes every 15 seconds.

Common errors:

| Error | Fix |
|---|---|
| `HTTP 404 (the webhook no longer exists…)` | The webhook was deleted in Slack, Discord or Teams. Create a new one and edit the channel |
| `HTTP 401/403 (the webhook URL or token was refused)` | Wrong URL, or a header such as `Authorization` is wrong |
| `HTTP 429 (rate limited…)` | The platform is throttling; fewer reminders (a longer repeat) help |
| `Could not reach the webhook: …` | DNS, firewall or TLS problem between Pulsimo and the URL |
| `Email is not set up: set SMTP_HOST…` | Add the SMTP settings to `.env` and restart the notification service |
| `SMTP server refused the email: …` | Wrong SMTP username or password, or the server doesn't allow the sender |

## Muted

This tab lists every endpoint whose alerts are switched off. For each one you see whether
all channels or just one are muted, the reason, who muted it, and until when ("until
unmuted" if it has no end).

- **Unmute** turns alerts back on (members and administrators).
- To mute an endpoint, open its card on **Services → Endpoints**.

## How alerts are sent

Every alert is an **alarm** with a lifecycle ([Alarms and rules](alarms.md)): it is sent when it opens and
when it turns critical, reminded while critical and unacknowledged, held during
maintenance or while an upstream service is down, and closed with a Resolved message to
the channels that heard about it.

| Situation | What happens |
|---|---|
| An endpoint goes down | After its alert policy's failures, the channels its policy picked (or every channel that takes critical alarms) get **"… is down"**: what is wrong, what its linked metrics and logs show, and a dependency that is down if there is one |
| It stays down | Each channel that got it is reminded at its own repeat interval until someone acknowledges the alarm or its incident |
| Someone acknowledges | The channels that got it are told who is on it; reminders and escalation stop |
| It recovers | **Resolved**, with how long it lasted, to the channels that heard about it |
| A service it depends on is already down | It is recorded but held, so people get one alarm for the root cause; if it is still down after the upstream recovers, it is sent then |
| A deploy or restart just happened | A Down alert waits 3 minutes. If the endpoint recovers in that time, nothing is sent |
| It flaps | At most 3 Down alerts per endpoint per hour, plus one *"… is unstable"* warning |
| Alarm rules, logs and metrics find something | Sent as alarms with the rule's severity and channels. Anomalies and other low-urgency findings are grouped into one digest every `DIGEST_INTERVAL_MINUTES` (default 60), sent to channels that take everything |

### What each platform receives

| Platform | Format |
|---|---|
| Slack | A message with a coloured bar: red for down, green for recovered, amber for warnings, blue for tests |
| Discord | An embed in the same colours |
| Microsoft Teams | A card in the same colours |
| Google Chat | Bold title and text |
| Email | Plain text, sent through SMTP (STARTTLS on port 587, TLS on 465) |
| Webhook | JSON, shown below |

The webhook JSON looks like this:

```json
{
  "event": "endpoint_down",
  "label": "Down",
  "subject": "🚨 Service Down: Orders API",
  "message": "…",
  "endpoint_id": "…",
  "channel": "PagerDuty bridge",
  "timestamp": "2026-10-14T09:12:03Z",
  "source": "pulsimo",
  "severity": "critical",
  "alarm": {
    "id": "…", "kind": "endpoint_down", "source": "check", "severity": "critical",
    "state": "firing", "value": null, "threshold": null, "unit": null,
    "first_fired_at": "2026-10-14T09:12:01Z", "incident_id": "…", "project_id": "…"
  }
}
```

`alarm` is there for every alarm message (not for tests and digests). Deduplicate on
`alarm.id`; a message with `alarm.state` `resolved` closes it.

`event` is one of:

- `endpoint_down`
- `endpoint_recovered`
- `endpoint_partial_outage`
- `endpoint_warning`
- `org_major_outage`
- `incident_escalated`
- `ssl_certificate_expiring`
- `test`

## Email setup

Email uses the notification service's environment (`.env`):

```bash
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=alerts@company.com
SMTP_PASSWORD=app-password
FROM_EMAIL=alerts@company.com
```

After changing them, restart the notification service:

```bash
docker compose up -d notification
```

Then use **Send test** on an email channel.

## API

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

## Limits

- A test or an alert to a platform that is slow to answer can take up to 15 seconds. The
  test gives up after 20 seconds.
- Delivery history older than 30 days doesn't count in the channel figures. It stays in
  the log until it's cleaned up by the maintenance retention settings.

---

← [Alarms and rules](alarms.md) · [Contents](../README.md) · [Routing, digests and deploy grace](alert-routing.md) →
