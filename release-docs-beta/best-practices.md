# Best practices

> How to set up checks, alerts and projects so the right people hear about the right things.

How to set Pulsimo up so the right people hear about the right things, and nobody learns
to ignore it.

## Checks

- **Check what users touch.** Start with the public entry points (the website, the login,
  the main API routes), then the services and databases behind them.
- **Use health routes that mean something.** A `/health` that only returns 200 says the
  process is alive. One that touches the database and cache says the service works.
- **Keep the timeout well below the interval**, and the interval as long as you can
  afford: 30 seconds for customer-facing services, a minute for most internal ones.
- **Combine active checks with metrics** for critical services (**Both** mode): reachable
  from outside *and* healthy inside. See [Monitoring from metrics](features/metric-monitors.md).
- **Link metrics and logs to endpoints.** Alerts then say what the metrics and logs show,
  incidents keep evidence, and probable cause has something to rank. See
  [Connected monitoring](features/metrics/connected-monitoring.md).

## Projects and targets

- **One project per product or team.** It drives the status board, the error budget and
  alert routing.
- **Pick targets you can keep.** 99.5% is a sensible start. A target that is always red
  stops meaning anything.
- **Use SLOs for user-facing routes.** Burn-rate alerts tell you when the budget is going
  fast, before the outage is obvious. See [SLOs](features/reliability/slos.md).

## Alerts

- **Separate urgent from interesting.** Keep a channel on *Everything* for the team, and
  put on-call (a pager or webhook) on *Critical only*.
- **Route by project and category**, so the payments team gets payments and the DBA gets
  databases. See [routing](features/alarms.md#routing-who-gets-which-alarm).
- **Acknowledge.** It stops reminders and escalation and tells the channel who is on it.
- **Plan maintenance** instead of pausing endpoints: alarms are held, not lost, and sent
  only if the problem outlasts the window.
- **Let the digest carry the small stuff.** Anomalies and capacity forecasts arrive as one
  message every `DIGEST_INTERVAL_MINUTES`, not as pages.
- **Tune noisy log incidents per endpoint** rather than globally, and use **Test on last
  24 h** before saving. See [Incidents from logs](features/logs/incidents-from-logs.md).

## Metrics and logs

- **Watch cardinality.** Labels with user ids or raw paths create thousands of series and
  slow everyone down. Use route templates; the **Series** column shows the culprits.
- **Redact at the source** when you can. Pulsimo redacts common secrets in logs, but it is
  better that they never leave the app.
- **Set retention on purpose.** Long enough for your incident reviews and monthly reports,
  no longer.

## People and access

- **Give the least access that works.** Viewers see everything and change nothing; members
  run day-to-day monitoring; keep administrators few, but at least two.
- **One API key per tool**, read-only unless it must write, with an expiry.
- **Deactivate, don't delete**, when someone leaves. Access ends at once and the history
  stays.

## Incidents

- **Write the timeline as you go**: updates on the incident are what the post-mortem is
  built from.
- **Confirm the probable cause, and say what fixed it** when you resolve. It goes into the
  post-mortem and into *Seen before* for the next incident like it. See
  [Probable cause](features/probable-cause.md).

---

← [Running in production](production.md) · [Contents](README.md) · [Troubleshooting](troubleshooting.md) →
