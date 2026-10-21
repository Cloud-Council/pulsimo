# Webhooks

> The JSON Pulsimo sends to webhook channels, and how to handle it.

A **webhook** channel sends every alert it receives to a URL of yours as JSON. Use it to
connect PagerDuty, Opsgenie, a chat platform Pulsimo doesn't support natively, or your own
automation.

## Set one up

1. **Alerting → Add channel → Webhook.**
2. Enter the URL, the method (**POST**, PUT or PATCH) and any headers your receiver needs,
   for example `Authorization: Bearer …`. Header values are stored as secrets and never
   shown in full again.
3. Choose which severities, projects and kinds of alerts it takes, like any other channel.
4. Leave **Send a test after saving** on. The test goes through the same path as real
   alerts and shows your server's answer.

## The payload

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
    "id": "…",
    "kind": "endpoint_down",
    "source": "check",
    "severity": "critical",
    "state": "firing",
    "value": null,
    "threshold": null,
    "unit": null,
    "first_fired_at": "2026-10-14T09:12:01Z",
    "incident_id": "…",
    "project_id": "…"
  }
}
```

| Field | Meaning |
|---|---|
| `event` | What happened (see below) |
| `subject`, `message` | The same text the other platforms get, including what the linked metrics and logs show |
| `severity` | `info`, `warning` or `critical` |
| `alarm` | The alarm this message belongs to. Present on every alarm message, not on tests and digests |
| `alarm.state` | `firing`, `acknowledged` or `resolved` |
| `alarm.value`, `threshold`, `unit` | For rules on numbers (traffic, metrics, log counts) |

### Events

| `event` | Sent when |
|---|---|
| `endpoint_down` | An endpoint reached its alert policy's failures |
| `endpoint_recovered` | It is up again |
| `endpoint_partial_outage` | It answers, but not reliably |
| `endpoint_warning` | A warning: first failure, slow responses, a rule, a metric finding |
| `org_major_outage` | An outage across the organization |
| `incident_escalated` | Nobody acknowledged in time, so the next tier is told |
| `ssl_certificate_expiring` | A certificate expires soon |
| `test` | You clicked **Send test** |

## Handling it well

- **Deduplicate on `alarm.id`.** One alarm can send a first message, reminders, an
  escalation, an *acknowledged* note and a *resolved* message.
- **Close on `alarm.state: "resolved"`.** That message goes only to channels that heard
  about the alarm.
- **Answer quickly with a 2xx.** Pulsimo waits up to 15 seconds for an answer; the
  delivery log shows your status code and body when it fails.
- **Check the delivery log.** **Alerting → Delivery log** shows every attempt with the full
  message and the platform's answer. Filter by the channel to debug one webhook.

## Common errors

| Delivery log shows | Fix |
|---|---|
| `HTTP 401/403` | The URL or a header such as `Authorization` is wrong |
| `HTTP 404` | The URL no longer exists |
| `HTTP 429` | Your receiver is rate limiting; a longer repeat interval sends fewer reminders |
| `Could not reach the webhook: …` | DNS, firewall or TLS problem between Pulsimo and the URL |

---

← [API reference](README.md) · [Contents](../README.md) · [Running in production](../production.md) →
