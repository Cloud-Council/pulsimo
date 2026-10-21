# Probable cause

> Ranked causes from changes, logs and metrics. Confirm, resolve, and see what happened before.

## What it is

When an incident opens, Pulsimo lines up everything it saw around the failure — deploys,
new log errors, metrics that left their normal range, dependencies, shared hosts — and
ranks the most likely causes, each with its evidence. You confirm the right one; it becomes
the incident's root cause and is recognised the next time.

No AI is involved: every step is a rule or a statistic you can inspect.

## Where to find it

Incident page → **Probable cause** (above the tabs), and the post-mortem.

## How causes are found

About 30 seconds after the incident opens (and again when it resolves), Pulsimo gathers
candidates from the endpoint's linked metrics and logs:

| Kind | Example |
|---|---|
| **Change** | Deploy: orders-api version changed (14:00:12) |
| **Logs** | New error in orders-api: `pq: sorry, too many clients already` (first seen 14:01:31) |
| **Metric** | Connections on orders-db rose to 98 (normal 12) |
| **Dependency** | Dependency payments-api went down (40 s earlier) |
| **Shared host** | host-1: 6 services on the same host failed together |
| **Outside the service** | DNS / TLS / network failure while metrics and logs look normal |

Each candidate is scored:

- **Lead**: started shortly before the failure scores highest; long before, lower; after
  the failure, lowest.
- **Strength**: how clear the signal is (a brand-new error is strong; a metric scores by how
  far it left its normal range, and higher when it moves together with the error rate).
- **Specificity**: only this service vs shared by many.

Metrics of the endpoint's own requests (its 5xx rate, latency, traffic) are treated as
symptoms, not causes. The engine looks at what the endpoint runs on and talks to.

## Reading the card

Each cause shows its kind, how long before the failure it started, and a confidence
(High ≥ 70, Medium ≥ 45). Expand it to see:

- **The sequence**: every signal in time order, ending with "The check started failing";
- **Sample lines** for log causes;
- the **correlation** with the error rate for metric causes.

**Confirm as root cause** sets the incident's root cause and category and stores a
fingerprint. **Not this** hides it (you can undo). **Seen before** lists earlier incidents
whose confirmed cause had the same fingerprint, with how they were fixed.

## Working the incident

The incident page has the actions:

- **Acknowledge**, **Investigating**;
- **Post update** (appears on the timeline);
- **Resolve**: write what fixed it. It goes into the post-mortem and into "Seen before".

## Fewer, truer incidents

- **One outage = one incident.** A failure within `INCIDENT_REOPEN_MINUTES` (default 10) of
  recovery reopens the last incident ("Reopened: failed again 40 s after recovering")
  instead of opening a new one. A flapping endpoint no longer creates hundreds of incidents.
  Causes stay measured from the first failure, so a reopened or hours-long incident still
  points at what changed when it began (log patterns compare the 12 minutes before with the
  first 15 minutes of the incident).
- **Groups close** when their last incident resolves (and reopen with it).
- **"Similar error"** grouping only joins endpoints on the same host or project, so two
  unrelated sites that both time out are no longer one group.
- Every incident API is limited to your organization.

## Post-mortems

Generated post-mortems now include the probable (or confirmed) root cause with its
sequence, the error patterns from the logs, impact from metrics, and changes around the
incident.

---

← [Incidents and evidence](incidents.md) · [Contents](../README.md) · [SLOs](reliability/slos.md) →
