# Routing, digests and deploy grace

> The right channel, fewer pages during deploys, and one digest for the small stuff.

## Route alerts by what the metrics point at

### What it is
A database problem should reach the database on-call channel, not everyone. Each
notification channel can be limited to alert **categories**, worked out from the metrics
linked to the endpoint:

| Category | Linked metrics of type |
|---|---|
| Applications | HTTP app, process |
| Databases | PostgreSQL, MySQL |
| Hosts | node_exporter |
| Containers | cAdvisor |

### How to use it
**Notifications → channel → Edit → Alerts to send here**. Nothing selected = every alert
(the default). Channels with categories show "Only: database" on their card.

Rules:
- An alert goes to a channel when one of its categories is selected there.
- Alerts **without metric evidence** (endpoints not linked to metrics, digests) go to
  every channel, so nothing is silently dropped.
- Escalation tiers that name channel types still apply first.

## Digest

Low-urgency findings are collected and sent as **one message per hour** (when there is
something to say), grouped by kind:

- **Unusual behaviour**: traffic, latency and error anomalies ([Capacity and anomalies](reliability/capacity-and-anomalies.md))
- **Capacity**: limits expected within 3 days
- **Error budgets**: slow SLO burns ([SLOs](reliability/slos.md))
- **New in your metrics**: new API routes ([Discovered services](metrics/discovery.md))

The interval is `DIGEST_INTERVAL_MINUTES` (default 60) on the notification service.

## Immediate metric alerts

Sent right away, as warnings, through the same channels and routing:

- capacity limit within 24 hours ("⚠️ Capacity: …");
- fast SLO burn ("🔥 SLO burn: …").

## Deploy grace period

When an endpoint goes down within 3 minutes of a deploy or restart of one of its linked
sources ([Change markers](reliability/change-markers.md)), the "down" alert is held:

- still down when the 3 minutes are over → the alert is sent, with "This started right after
  a change: orders-api version changed (deploy) at 14:02 UTC. It is still down after the
  3-minute grace period, so it isn't just the restart.";
- recovered meanwhile → no down alert and no recovery alert.

Incidents and status still follow the checks as usual; only the notification is held.
Silences and maintenance windows work as before.

## "What the metrics show" in alerts

Down and escalation alerts for linked endpoints include up to five lines read from the
metrics at send time, e.g. "orders-api: 23.4% of requests failing with 5xx" or "host-1:
host memory 96% used". When nothing unusual is visible, the alert says so: the cause is
probably outside the service (network, DNS, TLS or a dependency).

---

← [Channels and delivery](alerts.md) · [Contents](../README.md) · [Users and access](users.md) →
