# Alarms and rules

> Rules for logs, traffic, metrics, incidents and checks; acknowledging, routing and maintenance windows.

**Alerting** (sidebar, under Incidents) is one page with two groups of tabs: **Alarms**
(Open now, History, Rules, Maintenance), described here, and **Delivery** (Channels,
Delivery log, Muted), described in [Channels and delivery](alerts.md). The Alarms tabs are where everything that can wake someone up comes
together: endpoint outages, slow and failing checks, exceptions in logs, traffic spikes and
drops, metrics, incidents nobody picked up, expiring certificates, SLO burn and capacity.

An **alarm** is one problem, from the moment it starts until it is over. It is not a
message: one alarm can send a first message, reminders, an escalation, an "acknowledged"
note and a "resolved" message, and the Alarms page shows all of them in one place.

## How an alarm works

```
condition met ──(held for "for")──► FIRING ──► message to the routed channels
                                       │
                                       ├─ severity rises ─► message again ("now critical")
                                       ├─ still firing ───► reminders (critical, per channel interval)
                                       ├─ acknowledged ───► ACKNOWLEDGED: reminders and escalation stop,
                                       │                    channels told who is on it
                                       ▼
                         condition clears / resolved by hand ─► RESOLVED: "Resolved" to the
                                                                channels that heard about it
```

1. **Fires once.** While a condition keeps holding, the same alarm is updated (its value,
   how many times it was seen); people are told when it opens and when its severity goes
   up, not on every evaluation.
2. **Reminders.** A **critical** alarm that nobody has acknowledged is sent again on each
   channel at that channel's repeat interval (Alerting → Channels → the channel → *Repeat while
   firing*). A rule can set its own repeat, including for warnings, or turn it off.
3. **Acknowledge.** On the alarm, on several at once, or on its incident. Reminders and
   escalation stop, and the channels that got the alarm get a short note:
   *"👀 Acknowledged: Orders API is down. Dana is looking into it."*
4. **Resolved.** When the condition clears (or someone resolves it by hand) only the
   channels that heard about it get the Resolved message, with how long it lasted.
5. **Held, not lost.** During a maintenance window, or while a service the endpoint
   depends on is down, the alarm is recorded but nobody is notified (*Held*). If it is
   still firing when the window ends or the upstream service recovers, it is sent then.

Every message links back to the alarm (*Open in Pulsimo*) when `PULSIMO_PUBLIC_URL` is set
([Configuration](../configuration/environment-variables.md)).

### Closing by itself

**Open now** only lists alarms that are still firing, acknowledged or held. Every alarm
closes by itself when what it is about is over, and moves to **History**, where it stays
for `ALARM_RETENTION_DAYS` (90) for weekly and monthly figures:

| Alarm | Closes when |
|---|---|
| *… is down* | its checks pass again |
| *… failed a check* | the next check passes (or it becomes the outage) |
| *… is slow* | two fast checks |
| *… is unstable* | 15 minutes without an up/down change |
| From logs | the errors stop and its incident resolves (or someone resolves the incident) |
| Rules | the condition no longer holds (checked every 30 s); also when the rule is switched off or deleted |
| SLO burn | the burn drops below 14.4× |
| Capacity | it is no longer close to the limit |

Every minute Pulsimo also compares the open alarms with the real state, so an alarm can't
stay stuck if a "recovered" signal was missed (for example while a service restarted), and
an endpoint that is down without an alarm gets one. The alarm panel says when the alarm
will close. **Resolve** by hand is only needed when you know it is over before Pulsimo
can see it.

### Severity

| Severity | Use it for | By default |
|---|---|---|
| **Critical** | Someone must act now: an outage, traffic gone, an incident nobody picked up | Sent to every channel, repeated until acknowledged |
| **Warning** | Needs attention today: slow, flaky, errors rising, a certificate expiring | Sent to channels that take warnings, not repeated |
| **Info** | Good to know | Only to channels that take everything |

A rule can turn its alarm critical past a second threshold (*Critical above*), for example
warning at 5% errors and critical at 20%. Going from warning to critical is announced again.

## The Alarms tabs

**Top cards**: critical and warning alarms firing now (click to filter), acknowledged,
held (maintenance or upstream down), fired in the last 24 hours (with how many were
resolved and how many messages were sent), and the average time to acknowledge and to
resolve over 7 days.

**Open now**: every alarm that is not resolved, critical first. Each row shows what it is
about (endpoint, project, rule), its value against the limit, how long it has been firing,
its state and how many messages went out. Tick several and **Acknowledge** them at once, or
use **Ack** on a row.

Click an alarm for its panel:

- severity, state, and *Seen N× in 30 days* when the same thing keeps coming back;
- value, limit, how long, messages sent;
- **Acknowledge** or **Resolve** with an optional note (the note goes into the timeline);
- links to the endpoint, its logs or metrics, the incident and the rule's runbook;
- the **timeline**: fired, sent to each channel (or *Not delivered* with the platform's
  answer), held and why, released, escalated, reminders, acknowledged by whom, resolved;
- every **delivery**: channel, status, subject and error.

**History**: everything that fired in the last 24 hours, 7 or 30 days. The side cards show
alarms per hour, the **noisiest** rules and endpoints of the week (tune those first), and
alarms by source. Clicking a source or a noisy rule filters the list.

Links: `/dashboard/alarms?open=<alarm id>` opens an alarm; `?tab=rules`,
`?tab=maintenance`, `?tab=history`, `?tab=channels`, `?tab=deliveries`, `?tab=muted`,
`?tab=how` open a tab.

## Alarm rules

**Alerting → New rule** (header, any tab). Pick a kind or a template, then set:

| Field | What it does |
|---|---|
| **Name** | Shown in every alarm the rule opens: *"Checkout errors: Orders API: 6.2% of requests fail (5xx)"* |
| **Severity** | Info, warning or critical |
| **Watch** | The whole organization / all endpoints, one project, or one endpoint |
| **Condition** | Depends on the kind (below). *Critical above* (optional) makes the alarm critical past a second value |
| **For** | How long the condition must hold before it fires: right away, 1, 2, 5, 10, 15, 30 min or 1 h. Short blips never page anyone |
| **Check it now** | Runs the rule against your data without sending anything and lists what would fire, with the current values |
| **Send to** | Specific channels, or *Route by severity* (see Routing) |
| **Repeat while firing** | The channel's interval (critical only), never, or every 5 min to 4 h |
| **When it is over** | Tell the channels that got it, or stay quiet |
| **Runbook link**, **Notes** | Shown on the alarm and in the message |

Rules are evaluated every 30 seconds (`ALARM_EVAL_SECONDS`). A rule that can't be
evaluated (a typo in a query, the log store down) shows the error under **Status** on the
Rules tab instead of firing.

Switching a rule off resolves its open alarms. Deleting a rule (administrators) does the
same; its past alarms stay in the history.

### Endpoint checks

| Kind | Fires when | Condition |
|---|---|---|
| **Failing checks** | A share of an endpoint's checks failed, even though it never went fully down (intermittent errors, a flaky dependency) | more than *N*% of checks failed over the last *M* minutes, with at least *K* checks |
| **Slow checks** | The successful checks are slow | p95 or average check time above *N* ms over *M* minutes |

One alarm per endpoint in scope.

### Traffic (from the application's own metrics)

These read real requests from the app's `/metrics` ([Connected monitoring](metrics/connected-monitoring.md)), so
the endpoint must be **linked to an HTTP app's metrics**. Endpoints without such a link are
skipped (a rule for one endpoint says so in its status).

| Kind | Fires when |
|---|---|
| **Traffic spike** | Requests per second above *N*× the usual (the same 15 minutes last week, or yesterday when there is no week of history), or above a fixed rate |
| **Traffic drop** | Below *N*× the usual (0.3 = less than 30%), or below a fixed rate. Often a broken client, DNS, a load balancer or an upstream service |
| **Error rate (5xx)** | More than *N*% of requests fail with 5xx |
| **Request latency** | p95 latency of real requests above *N* ms (needs a duration histogram) |

Routes with almost no traffic (under 0.05 req/s) are ignored, so a quiet night does not
look like a 100% error rate.

### Logs

| Kind | Fires when | Condition |
|---|---|---|
| **Log lines / exceptions** | More than *N* lines match a LogsQL filter in the last *M* minutes | `level:error OR "Exception"`, `"PaymentDeclined"`, `service:"auth" "invalid token"`… Optional **one alarm per** field (e.g. `service`): one alarm per service that has a burst |
| **Logs stopped** | Fewer than *N* (default 1) lines match in *M* minutes | `service:"billing-worker"`: the worker went silent, a cron job didn't run, a log shipper died |

The filter is the part before any `|` in the Log Browser: try it there first. Only your
organization's logs are read.

This is different from **incidents from logs** ([Incidents from logs](logs/incidents-from-logs.md)): those find new error
patterns on their own and open incidents; log rules count exactly what you ask for.

### Metrics

**Any metric (PromQL)**: an expression, a comparison (`>`, `>=`, `<`, `<=`, `==`, `!=`) and a
threshold. Only your organization's series are read (the same scoping as the Metrics
Explorer).

- **One alarm for the rule** (default): the worst series decides; the message lists up to
  five that breach.
- **One alarm per series**: e.g. one per host for
  `100 * (1 - avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])))  > 90`.

Write the unit (`%`, `ms`, `items`) so messages read well.

### Incidents

| Kind | Fires when |
|---|---|
| **Unacknowledged incident** | An incident is still open and nobody acknowledged it after *N* minutes. Resolves when someone acknowledges or it is resolved |
| **Long-running incident** | An incident (acknowledged or not) is still open after *N* minutes |
| **New incident** | Any new incident matching the filters (severity, opened by checks or logs), including incidents created by hand |
| **Incident came back** | A resolved incident reopened: the fix didn't hold |

All take an optional minimum incident severity. One alarm per incident.

### Built-in rules

Every organization has two rules from the start. They can be tuned or switched off, not
deleted.

| Rule | Default |
|---|---|
| **Major outage** (many endpoints down) | At least 50% of the endpoints and at least 3 are down at once. One critical alarm instead of one per endpoint |
| **Certificate expiry** | A TLS certificate of an endpoint expires within 14 days (warning), within 3 days or already expired (critical). Checked every 5 minutes |

A project-only copy of these (e.g. *"half of the Payments project is down"*) can be added
as a normal rule.

## Routing: who gets which alarm

For each alarm, in this order:

1. **Channels chosen explicitly** by its rule (*Send to*) or by the endpoint's alert policy
   (*Send outages to*, *Send first-failure warnings to*, *Escalate to*). Only those get it.
   If none of them is active any more, it falls back to step 2 rather than getting lost.
2. Otherwise every **active channel** whose settings match (Alerting → Channels → the channel):
   - **Severity**: *Everything*, *Warning and up* or *Critical only*;
   - **Projects**: all, or only the alarms of some projects (alarms without a project
     always pass);
   - **Which alerts** (categories): applications, databases, hosts, containers, from the
     endpoint's linked metrics.
3. A **silenced endpoint** (endpoint card → Silence) skips the channels it is silenced on.

Typical setup:

| Channel | Severity | Projects |
|---|---|---|
| `#ops-alerts` (Slack) | Everything | All |
| On-call webhook (PagerDuty, Opsgenie) | Critical only | All |
| `#payments` (Slack) | Warning and up | Payments |
| Email to the DBA | Warning and up | All, category *Databases* |

**Digests** ([Routing, digests and deploy grace](alert-routing.md)) go to the channels that take *Everything*.

The **webhook** channel now also sends `severity` and an `alarm` object (`id`, `kind`,
`source`, `severity`, `state`, `value`, `threshold`, `unit`, `first_fired_at`,
`incident_id`, `project_id`), so on-call tools can deduplicate on `alarm.id` and close the
alert when the Resolved message arrives.

## Maintenance windows

**Alerting → Plan maintenance** (header, any tab, or the **Maintenance** tab).

- **What it covers**: everything, a project, or chosen endpoints.
- **Once**: a start and an end (up to 31 days). *Starting now for 30 min / 1 h / 2 h /
  4 h* fills both in.
- **Every week**: days, a start time, a length (up to 24 h) and a time zone, e.g. Sunday
  02:00 for 120 minutes in Europe/Berlin for the weekly backup. Windows can cross
  midnight.

During a window, alarms it covers are still opened and recorded, marked *Held:
Maintenance: <name>*, and nobody is notified. When the window ends, alarms that are **still
firing** are sent (*"still firing after maintenance"*); those that cleared in the meantime
never page anyone. **End now** stops a running one-off window early.

The Alarms page shows a banner while a window is in progress.

## Endpoint alert policies

Each endpoint's **alert policy** (Services → Endpoints → edit → *Alert Policy* →
*Advanced Settings*) decides when the endpoint is **down** and who hears about it:

| Setting | What it does |
|---|---|
| Severity preset | Fills in the values below (critical: check every 10 s, down after 1 failure, warn at once, escalate after 5 min) |
| Failures before down | Consecutive failed checks before the endpoint is down and the critical *"… is down"* alarm opens |
| Send WARNING on first failure | A warning alarm on the first failed check; it resolves quietly if the next check passes, or turns into the outage |
| Escalation | If nobody acknowledges the outage within *N* minutes, it is sent to the *Escalate to* channels (tiers) |
| **Send outages to / warnings to / Escalate to** | Pick channels; empty = every channel that takes the severity |
| **Warn when responses are slower than (ms)** | A warning alarm *"… is slow"* after 5 minutes of slow answers. The endpoint stays **up**. It resolves after two fast checks |

Editing an endpoint keeps its saved policy (it used to reset to the defaults).

The endpoint's *expected response time* (on the endpoint itself) is different: an answer
slower than that counts as a **failed** check.

## What sends alarms without a rule

| Alarm | From | Severity | Resolves when |
|---|---|---|---|
| *Orders API is down* | Endpoint checks and alert policy | Critical | Checks pass again |
| *Orders API failed a check* | Policy: warn on first failure | Warning | Next check passes, or it becomes the outage |
| *Orders API is slow* | Policy: slower than *N* ms | Warning | Two fast checks |
| *Orders API is unstable* | The endpoint keeps going up and down | Warning | Stable again |
| Incidents from logs | [Incidents from logs](logs/incidents-from-logs.md) | Warning, then critical | The errors stop |
| *SLO burn: …* | SLO fast burn ([SLOs](reliability/slos.md)) | Critical | Burn drops below 14.4× |
| *Capacity: … disk / memory / connections* | Runs out within 24 h (critical within 4 h) | Warning / critical | No longer close to the limit |

Escalation tiers and acknowledged-incident reminders of an outage are added to the same
*"… is down"* alarm's timeline.

## Recipes

**Page on-call only for real outages**

1. Alerting → **Add channel**: the on-call webhook with **Critical only**.
2. Keep `#ops-alerts` on **Everything**.
3. Endpoint policies: leave *Send outages to* empty (both channels get it); warnings go to
   Slack only, because the webhook takes critical only.

**Exceptions per service**

Template *Exceptions in the logs*: `level:error OR "Exception" OR "Traceback"`, more than
20 lines in 5 minutes, one alarm per `service`, critical above 100.

**Traffic fell off a cliff**

Template *Traffic drop*: below 0.3× the usual for 10 minutes, critical, on the checkout
endpoint. Catches broken deploys and DNS problems the health check doesn't see.

**Nobody picked up the incident**

Template *Unacknowledged incident*: high or critical incidents not acknowledged after 15
minutes, critical, *Send to* the manager's channel.

**Nightly backup makes the database slow**

Maintenance → *Every week*, all days, 01:30 for 60 minutes, project *Data*.

**Certificate renewal reminders a month ahead**

Alerting → Rules → *Certificate expiry* (built in) → warning within 30 days, critical within 7.

## Settings and limits

| | |
|---|---|
| Rule evaluation | every `ALARM_EVAL_SECONDS` (30 s); certificates every 5 minutes |
| Reminders and held alarms | checked every minute by the notification service |
| Down alarms per endpoint | at most 3 an hour (flapping) |
| Deploy grace | Down held 180 s after a linked deploy or restart |
| "For" | 0 s to 24 h |
| Maintenance | one-off up to 31 days; weekly up to 24 h per day |
| Who can do what | viewers see alarms; members acknowledge, resolve and manage rules and maintenance; administrators delete rules |
| History | resolved alarms are kept `ALARM_RETENTION_DAYS` (90); deliveries follow `NOTIFICATION_RETENTION_DAYS` (60) |

Environment values: `ALARM_EVAL_SECONDS`, `PULSIMO_PUBLIC_URL`, `DIGEST_INTERVAL_MINUTES`
([Configuration](../configuration/environment-variables.md)).

---

← [Capacity and anomalies](reliability/capacity-and-anomalies.md) · [Contents](../README.md) · [Channels and delivery](alerts.md) →
