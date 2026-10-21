# Incidents and evidence

> What the metrics showed, saved with the incident, and impact computed for you.

## What it is

When an endpoint linked to metrics has an incident, Pulsimo gathers the evidence for
you: what the metrics showed, what changed just before, how many requests failed, and
which other services failed for the same reason. All of it is kept with the incident.

## Where to find it

Incident page → **What the metrics show**. Generated post-mortems include it too.

## What you get

### Findings
Compared with the 30 to 10 minutes before the incident started (problems often begin
before an incident is declared):

- "p95 latency (orders-api) rose from 42 ms to 2.1 s"
- "5xx error rate (orders-api) reached 23.4%"
- "Requests / s (orders-api) dropped from 41 to 3.2"
- "Connections (orders-db) reached 98"

### Impact, computed
When the endpoint is linked to an HTTP app, the impact is worked out from the request
counters when the incident resolves: "**1,204 failed requests** of 52,880 (2.3% of traffic
during the incident)". It fills the incident's failed-requests field, so nobody has to
estimate it.

### Changes just before
"**Deploy** 4 min before the incident started: orders-api version changed", with the
same moment marked on the charts ([Change markers](reliability/change-markers.md)).

### Charts
One chart per linked metric, from 30 minutes before to 10 minutes after.

### Saved evidence (Live / Saved)
Pulsimo saves the linked metrics twice: a few seconds after the incident opens, and when
it resolves (covering the whole incident). Saved charts stay with the incident after the
live metrics expire, so a post-mortem written months later still has them. The
**Live / Saved** switch picks between them; incidents older than the retention period
open on **Saved**.

### Sharper data during incidents
While an incident is open, Pulsimo pulls the linked sources every **5 seconds** (for up to
30 minutes) instead of their normal interval, so short spikes aren't averaged away.

## Grouped incidents: shared infrastructure

When several endpoints fail within a few minutes and their metrics come from the **same
host, container or database exporter**, Pulsimo groups them into one incident group named
after it, e.g. "**host-1 outage**: Services that share host-1 (same host, container or
database) failed together". The group shows a **Shared: host-1** badge, and the shared
source is treated as the likely cause. One page instead of six. Grouping by dependencies
and timing still works as before, and grouping never mixes organizations.

## Post-mortems

**Generate post-mortem** now adds:

- **Impact from metrics**: failed requests, share of traffic, measured by which source;
- **What the metrics showed**: each metric before and at its worst;
- **Changes around the incident**: deploys and restarts, with "N min before it started".

## Limits

- Evidence needs the endpoint to be linked to metrics ([Connected monitoring](metrics/connected-monitoring.md)).
- Impact needs an HTTP app link with a request counter and a status label.

---

← [Kubernetes](infrastructure/kubernetes.md) · [Contents](../README.md) · [Probable cause](probable-cause.md) →
