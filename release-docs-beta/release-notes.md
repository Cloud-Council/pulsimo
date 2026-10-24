# Release notes

> What changed in recent releases.

Pulsimo is in beta and changes often. These notes come from each feature page and list what was fixed or added, newest first.

## 24 Oct 2026 (themes)

Image: frontend `rc1beta-v0.2.3`; every other image stays as below.

### Colour themes

Eleven themes, applied to the whole app (charts, the dependency graph and the PromQL editor
included): Pulsimo Dark, Rosé Pine, Tokyo Night, Catppuccin Mocha, Nord and Dracula, and
Pulsimo Light, Rosé Pine Dawn, Catppuccin Latte, Solarized Light and GitHub Light. Open the
menu under your name: **Dark** switches to dark mode, and pressing **Dark** again moves to
the next dark theme (**Light** works the same way). **System** follows your computer and
keeps each series' choice. The choice is saved per browser and applies before the page
shows, so there is no flash on reload. Body and muted text meet WCAG AA in every theme. The
dependency graph's zoom buttons and minimap are now dark in dark mode.

## 24 Oct 2026

Images: migrations `rc1beta-v0.1.6`, api-gateway `rc1beta-v0.1.9`, checker `rc1beta-v0.1.2`,
notification `rc1beta-v0.0.4`, dependency-tracker `rc1beta-v0.1.1`, maintenance
`rc1beta-v0.0.4`, metrics-collector `rc1beta-v0.0.3`, frontend `rc1beta-v0.2.2`. No new
migrations and no new settings.

### Overview

The first page after sign-in was rebuilt. Its trend badges were fixed text and its small
charts were random. It now shows: a status line ("All 7 endpoints are operational" or which
ones are down), five figures with real trends, a live 24-hour heartbeat for every endpoint,
one list of everything that needs attention (incidents, alarms, expiring certificates,
error budgets, capacity, flapping endpoints, projects below target, dependencies), recent
changes, the slowest endpoints, 30 days of reliability, and the projects. A new
organization sees a setup checklist instead of empty charts.

### Sign-up turned off

The **Register** page now opens the sign-in page. Sign in with the administrator created on
install (`superadmin@pulsimo.io`, password `admin`), change its password, and add people from
**Users**.

### Staying up through restarts

The services no longer stop when PostgreSQL or Redis is briefly unreachable at start (a
restart, or a name lookup failing while containers start): they wait and try again. Wrong
credentials still stop them at once with the reason. The notification service reconnects to
Redis on its own after Redis restarts, and its health check reports whether it is connected.

### Probable cause

A check that fails because the connection was refused or timed out now shows that reason,
not only "error sending request". When a linked metric source stops answering at the same
time as the endpoint (its process or container stopped), that is offered as a probable cause.

## 17 Oct 2026

### API metrics and Event trail

The Event trail used to show the events of every organization on the server. It is now
limited to your organization: each event is tied to its organization through what it is
about (incident, endpoint, source…) or who did it, and older events were backfilled
(migration 038).

Read [API metrics and Event trail](features/observability/api-metrics.md).

## 14 Oct 2026

### Projects and overview

The old pages had several wrong or invented figures:

- *Total projects* (1) and the SLA list (2) disagreed.
- Projects Analytics showed *100% uptime* next to *200 incidents*, and *Issues 0* for
  every project.
- *Avg detection time 2–5 min* was fixed text.
- The trend arrows showed the uptime level, not a change over time.
- The incident figures came from the latest 1000 incidents, whatever the period.

All figures now come from the checks and incidents of the selected period, and the trend
compares with the period before. A reliability target per project is new (migration
036). The Services overview is now a live status board, replacing the old performance
table.

Read [Projects and overview](features/projects.md).

### Channels and delivery

- The channel form was cut off at the bottom. It now scrolls, with the buttons always
  visible.
- **Send test** used a separate code path in the gateway. That path ignored the email
  settings in `.env` and didn't show why it failed. It now goes through the notification
  service, the same as real alerts, and shows the platform's answer.
- Paused channels used to disappear from the page. They now stay listed, with Pause and
  Resume.
- Deliveries now record their endpoint. The delivery log, the per-channel figures and the
  Failed figure are new.
- Reminders were timed per channel, so two endpoints down at once delayed each other's
  reminders. They are now timed per endpoint.
- Webhook URLs and header values are masked in the page and the API.
- Viewers can no longer change channels, and only administrators can delete them.
- Slack, Discord and Teams messages are colour-coded. Webhooks now use the method you
  chose (it was always POST). Email supports several recipients and port 465.
- The SMTP fields in the email form were removed. They were never used: email always
  went through `.env`.

Read [Channels and delivery](features/alerts.md).

### Settings and API keys

- **Session & Authentication didn't work.**
  - The number fields reset while you typed, so you couldn't enter 30 or 120.
  - The lock duration could not be set.
  - "Never" could not be chosen for password expiry once a value was saved.
  - Errors only said *Request failed with status code 400*.
  - The "session timeout" signed everyone out a fixed time after signing in, even in the
    middle of work.

  It is now an inactivity timeout with a warning. Every field accepts typing, and errors
  say what to fix.
- **Settings that did nothing were removed:**
  - Security: two-factor, IP allow-list, SSO, "encrypt sensitive data", "automatic
    redaction", the audit logging switch, and the compliance badges;
  - Advanced: "experimental features" (including an AI switch) and a "reset everything"
    button that did nothing.
- **API keys work.** Before, keys were created but every request using one was refused.
  Keys now have access levels, expiry, last-used and creator, and only administrators
  manage them.
- **The Integrations tab** used to show placeholder cards (Datadog, New Relic, Zapier…)
  that couldn't connect to anything. It now shows real connections.

Read [Settings and API keys](features/settings.md).

## 12 Oct 2026

### Service analytics

- **Organization scoping.** These APIs used to return every organization's endpoints;
  they now return only yours.
- **Apdex is exact.** It was summed from overlapping one-hour windows written every
  minute, which counted each check about 60 times (703,540 "slow requests" against about
  32,500 real checks). It is now computed from the checks themselves, with failed checks
  counted as frustrated. The checker's hourly Apdex table now uses one row per clock hour.
- **Anomalies no longer fail.** Traffic and 5xx anomalies from metrics broke the
  anomalies API (HTTP 500), and the health-check anomaly detector had never run. Both
  are fixed.
- **Network timing is labelled honestly.** The five phases describe a first request; the
  check's own response time is shown next to them.

Read [Service analytics](features/service-performance.md).

### Users and access

- **Access is enforced at once.** A deactivated person kept working until their session
  expired, and could keep renewing it for up to 7 days. A role change only applied after
  signing in again. Both now apply on the next request.
- **Real numbers instead of placeholders.** The *Compliance 95%* score (fixed values),
  the permission count (always 0), failed sign-ins (always 0) and the password age (taken
  from the account's creation date) are replaced by real data. Every request used to
  overwrite *last sign-in*, so it really meant *last seen*; the two are now separate
 .
- **User details work.** The details request read columns that don't exist and always
  failed.
- **Safety rules** (above) are new, as are unlock, sign out everywhere, the password
  policy on every password, and password history.
- **The Event Trail** now records each user event under its organization. Before, user
  and other gateway events were saved without one, so they didn't appear in the
  organization's Event Trail.

Read [Users and access](features/users.md).

---

← [FAQ](faq.md) · [Contents](README.md)
