# Incidents from logs

> Exceptions in the logs open incidents that resolve themselves. Tune, test on 24 hours, mute.

## What it is

Pulsimo opens an incident when an application keeps throwing exceptions or logging errors,
even while its health check still passes. Take `GET /api/v1/meta` failing with
`IllegalStateException: connection pool exhausted`, a few times a minute, in any language
or framework. Pulsimo:

- opens a **warning** incident;
- raises it to **critical** if the errors grow or last;
- **resolves it by itself** once they stop;
- shows the exception itself (message, code line, count, routes) as the cause.

Alerts go through the usual notification channels, so the rules are built to be trusted:

- short bursts never page;
- errors that always happen are compared with their usual rate;
- silence is never mistaken for recovery;
- every decision is written down.

## Where to find it

- **Endpoint → Logs tab → Incidents from errors in these logs** shows the rule, what it
  sees right now, *Change thresholds*, *Test on last 24 h*, *Turn off* and *Add a rule
  with its own filter*.
- **Incidents** list: incidents from logs carry a **From logs · service** badge and the
  severity **WARNING** or **CRITICAL**.
- **Incident page → What the logs show** explains why it opened and lists every error
  pattern with a sample, the code line it came from, and its routes.
- **Log Browser → Patterns** has **Mute** / **Unmute** for each error pattern.

## Before you start

It works for every endpoint that has **linked logs**: see [Logs](README.md) to ship
logs with Fluent Bit and [Logs end to end](walkthrough.md) to link them to an endpoint.
Nothing else needs setting up: the automatic rule starts as soon as the endpoint has linked
logs.

## How it decides

Every 30 seconds Pulsimo reads the **error lines** of the endpoint's linked logs:

- lines with level error or fatal;
- `ERROR`, `Exception`, `Traceback` and `panic:` lines;
- access-log lines with a 5xx status.

It looks at the last 5 minutes, ending 20 seconds ago so that late lines are counted. It
groups the lines by **pattern**: the message with ids, numbers and times masked. A
multi-line stack trace is one line. Different harmless errors are never added together.

| Step | When |
|---|---|
| **Watching** | Nothing over the threshold |
| **Pending** | One pattern reached the **warning count** (default 5 in 5 min) |
| **Short burst, no incident** | The errors stopped before they lasted the **sustain time** (default 60 s). You get a "Log spike … stopped by itself" line in the digest and a **Log spike** marker on charts, and nobody is paged |
| **Warning incident** | The errors kept coming for the sustain time |
| **Critical** | The pattern reached the **critical count** (default 15 in 5 min), or its errors per minute doubled since it opened, or it is still failing after 15 min, or the endpoint's own health check fails too |
| **Resolved** | No errors of its patterns for the **quiet time** (default 10 min) *while the service keeps logging* |
| **Reopened** | It fails again within `INCIDENT_REOPEN_MINUTES` (default 10) of resolving. It is the same incident, and it keeps its severity |

These rules keep it from paging for things that aren't real:

- **Never downgraded while open.** A critical incident whose errors drop stays critical
  until it resolves, so alarms don't flap.
- **Errors that always happen** must reach **3×** their usual rate. The usual rate is the
  median per window over the hour before. A failure earlier in that hour does not count as
  "usual".
- **Silence is not recovery.** If a service that normally logs goes quiet (crashed, or
  its agent died), the incident stays open and its timeline says "No log lines from X
  since 10:05". A service that rarely logs anyway can resolve after the quiet time.
- **Muted patterns** ("this timeout is expected") are still shown and counted, but never
  open incidents.
- **One outage, one incident.**
  - If the endpoint already has an open incident from its health check, the errors are
    added to that incident instead of opening a second one.
  - Endpoints that share exactly the same linked logs share one rule, so one failing
    service makes one incident. It is attached to the endpoint whose path the failing
    lines carry (`route:"/api/v1/meta"`), else the first one.
- **Restart-safe.** The rule's state lives in the database, so a restart doesn't re-alert,
  and only one collector evaluates at a time.

## What the incident shows

- **Title**: the endpoint and what broke, e.g. *Demo /api/v1/meta:
  java.lang.IllegalStateException: connection pool exhausted (12 in 5 min)*.
- **Why it opened**: the counts against the thresholds, e.g. *12 errors of "…" in the last
  5 min (warning at 5, critical at 15); errors kept coming for 110 s*. Raising it to
  critical and resolving it are written to the timeline the same way.
- **What the logs show**, for each pattern:
  - how many times, and per minute now;
  - its service;
  - **Not a usual error**, or its usual rate;
  - the routes;
  - the headline;
  - **at `MetaRepository.load(MetaRepository.java:42)`**: the first application frame of
    the stack trace, with library frames skipped;
  - first and last time;
  - the full newest sample.

  Buttons: **These lines in the Log Browser**, and **Expected error, mute**. A sparkline
  shows errors per minute.
- **Probable cause** ([Probable cause](../probable-cause.md)): the exception ranks first.
  Access-log lines of failing requests rank low because they are the symptom. Deploys,
  metric changes and dependencies that came just before are listed too.
- Evidence: the lines and linked metrics around the first error, saved with the incident.

## Alerts

| Event | Sent as | Example subject |
|---|---|---|
| Opened as warning | Warning | ⚠️ Warning: Demo /api/v1/meta: java.lang.IllegalStateException: … |
| Opened as critical, or raised to critical | Escalated (can go to your paging channel) | 🚨 Critical: Demo /api/v1/meta: … |
| Reopened | Warning or escalated, by severity | ⚠️ Reopened: … |
| Resolved | Recovered | ✅ Resolved: … |

The message lists up to three patterns with their counts, code line, route and times,
then the endpoint's linked metrics.

## Changing the rule

**Endpoint → Logs → Incidents from errors in these logs → Change thresholds**:

| Field | Default (`.env`) | Meaning |
|---|---|---|
| Warning at (errors) | `LOG_INCIDENT_WARNING_COUNT=5` | Errors of one pattern in the window that open a warning |
| Critical at (errors) | `LOG_INCIDENT_CRITICAL_COUNT=15` | Errors that make it critical (never below the warning count) |
| Window (minutes) | `LOG_INCIDENT_WINDOW_SECONDS=300` | 1 to 60 min |
| Keep coming for (s) | `LOG_INCIDENT_SUSTAIN_SECONDS=60` | Shorter bursts are only reported. 0 opens at once |
| Resolve after (minutes) | `LOG_INCIDENT_RESOLVE_QUIET_SECONDS=600` | Quiet time without the incident's errors |
| Usual-rate factor | `LOG_INCIDENT_BASELINE_FACTOR=3` | For errors that always happen |

- Only values that differ from the defaults are saved; the rest follow `.env`.
- **Back to defaults** removes the endpoint's changes.
- **Turn off** stops incidents from logs for this endpoint. Its logs are still shown and
  still used as evidence for check incidents.
- When several endpoints share the same logs, a change applies to all of them. The card
  says which.

**Test on last 24 h** (also **Test these values** while editing) replays the rule over the
last 24 hours of lines with exactly the decision logic the live rule uses. It tells you, for
example: "would have opened 1 incident, raised 1 to critical, resolved 1, and reported 1
short spike without paging anyone", with the time of each. Test new values before you save
them and before you build alarms on them.

### Rules with their own filter

**Add a rule with its own filter** watches other lines for the same endpoint, for example
`service:"payments" AND "PaymentDeclined"`. Its error lines count with the default
thresholds. Each rule is its own scope, so it can open its own incident next to the
automatic one. Use it for a specific error you always want to know about, not for lines
the automatic rule already covers.

### Muting a pattern

**Log Browser → Patterns → Mute**, or **Expected error, mute** on the incident. The pattern
is kept and counted, shows a **Muted** badge, and never opens an incident. **Unmute** turns
it back on.

## Settings

| Variable | Default | Where | Meaning |
|---|---|---|---|
| `LOG_INCIDENTS_ENABLED` | `true` | metrics-collector | `false` turns incidents from logs off everywhere |
| `LOG_INCIDENT_WARNING_COUNT` | `5` | collector, gateway | See above |
| `LOG_INCIDENT_CRITICAL_COUNT` | `15` | collector, gateway | |
| `LOG_INCIDENT_WINDOW_SECONDS` | `300` | collector, gateway | 60 to 3600 |
| `LOG_INCIDENT_SUSTAIN_SECONDS` | `60` | collector, gateway | 0 to 1800 |
| `LOG_INCIDENT_RESOLVE_QUIET_SECONDS` | `600` | collector, gateway | 60 to 86400 |
| `LOG_INCIDENT_BASELINE_FACTOR` | `3` | collector, gateway | ≥ 1 |
| `LOG_INCIDENT_CRITICAL_AFTER_SECONDS` | `900` | collector, gateway | A warning still failing after this long becomes critical |
| `LOG_INCIDENT_EVAL_SECONDS` | `30` | collector, gateway | How often rules run (10 to 300) |
| `LOG_INCIDENT_LAG_SECONDS` | `20` | collector | The window ends this long ago, so late lines are counted |
| `INCIDENT_REOPEN_MINUTES` | `10` | checker, collector | Reopen instead of a new incident |

The gateway reads the threshold variables too, to show the defaults and run the 24-hour
test with the same values. Keep both in the same `.env`.

## Limits

- An incident belongs to an endpoint. Logs from a service with no endpoint are searchable,
  make patterns and **Log spike** markers, but open no incident. Create an endpoint for the
  service and link its logs.
- Counts come from up to 5,000 error lines per window. Beyond that a sample is read and
  scaled. The 24-hour test reads up to 50,000 lines.
- A line counts as an error from its level field or its text. An app that logs errors at
  info level won't be seen.
- An exception without a route (most stack traces) is attached to the endpoint of the
  route its failing requests carry, else to the first endpoint sharing those logs.

---

← [Logs end to end](walkthrough.md) · [Contents](../../README.md) · [Hosts and containers](../infrastructure/README.md) →
