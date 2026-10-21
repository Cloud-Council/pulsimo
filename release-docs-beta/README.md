<p align="center">
  <img src="cover.png" alt="Pulsimo" />
</p>

# Pulsimo documentation

> Version v1-rc2beta · public beta · also on the [website](https://pulsimo.github.io/docs/)

Pulsimo is a self-hosted monitoring platform. It checks your websites, APIs, databases and
other services, pulls their metrics and logs, opens incidents with the evidence attached,
and tells the right people on Slack, Discord, Teams, Google Chat, email or a webhook.

<p align="center">
  <picture><source media="(prefers-color-scheme: dark)" srcset="images/screenshots/dark/overview.png"><source media="(prefers-color-scheme: light)" srcset="images/screenshots/light/overview.png"><img src="images/screenshots/dark/overview.png" alt="System overview" width="100%"></picture>
</p>

## Start here

1. **[Installation](installation/README.md)**: run Pulsimo on one Linux server with Docker Compose.
2. **[Quick start](getting-started.md)**: your first endpoint, alert channel and metric source.
3. **[Your first project](first-project.md)**: group endpoints and set a reliability target.

Something not working? See [Troubleshooting](troubleshooting.md) and the [FAQ](faq.md).

## What Pulsimo does

- **Endpoint checks.** HTTP and HTTPS (with methods, headers, auth and GraphQL), PostgreSQL,
  MySQL, Redis, Elasticsearch, gRPC and WebSocket, every 10 seconds to every hour. Each check
  records DNS, connect, TLS, first byte and transfer, and every HTTPS certificate is watched.
- **Metrics and dashboards.** Point Pulsimo at any Prometheus `/metrics` and it scrapes on a
  schedule. Graph with PromQL or a point-and-click builder, build Grafana-style dashboards or
  import Grafana JSON, and judge a service from its own 5xx rate, p95 and traffic.
- **Logs.** Ship logs with Fluent Bit or a shipper you already run, search them in the Log
  Browser, and let new exceptions open incidents that resolve themselves.
- **Infrastructure.** Hosts and containers from node_exporter and cAdvisor, and Kubernetes
  clusters from kube-state-metrics, with alarms built in.
- **Incidents and reliability.** Incidents carry the evidence and the impact, with ranked
  probable causes. SLOs with error budgets and burn-rate alerts, deploy markers on every
  chart, capacity forecasts and anomaly detection.
- **Alerting.** Rules for checks, metrics, logs and traffic; delivery to Slack, Discord,
  Microsoft Teams, Google Chat, email and webhooks; routing, digests, deploy grace and
  maintenance windows.
- **Administration.** Roles, API keys, an event trail of who did what, and pages that show
  Pulsimo's own health, storage and retention.

## Contents

### Get started

- [Installation](installation/README.md): Run Pulsimo on your own server with Docker Compose and the published images.
- [Quick start](getting-started.md): From an empty install to your first endpoint, alert channel and metric source in about ten minutes.
- [Your first project](first-project.md): Group endpoints into a project, set a reliability target and see it on the status board.
- [Architecture](architecture.md): The services that make up Pulsimo, where data lives and how a check becomes an alert.
- [Configuration](configuration/environment-variables.md): Every .env value: what it controls, which service reads it, defaults, ranges and recipes.

### Services and checks

- [Projects and overview](features/projects.md): The live status board, project reliability against targets and error budgets, and project analytics.
- [Endpoints and checks](features/health-checks.md): What Pulsimo can check, every endpoint setting, and how a check decides Up, Degraded or Down.
- [Monitoring from metrics](features/metric-monitors.md): Health from the app's own metrics (5xx, p95, traffic) instead of, or as well as, calling it.
- [Service analytics](features/service-performance.md): Response times, Apdex and anomalies, network phases and certificates for every endpoint.
- [Dependencies](features/dependencies.md): A live map of which service needs which, suggestions with evidence, and impact on incidents.

### Metrics and dashboards

- [Metric sources](features/metrics/sources.md): Tell Pulsimo where /metrics lives and it pulls on a schedule.
- [Metrics Explorer](features/metrics/explorer.md): Graph anything with PromQL or a point-and-click builder.
- [Dashboards](features/dashboard.md): Grafana-style dashboards with an editor, variables and Grafana JSON import.
- [Connected monitoring](features/metrics/connected-monitoring.md): One service, one place: endpoint checks, its metrics and its dashboards together.
- [Discovered services](features/metrics/discovery.md): APIs, databases, hosts and containers found in your metrics, ready to monitor.

### Logs

- [Logs](features/logs/README.md): Collect app logs with Fluent Bit, search them in the Log Browser and link them to endpoints.
- [Logs end to end](features/logs/walkthrough.md): Walkthrough: a Docker host's logs from Fluent Bit to endpoints and incidents.
- [Incidents from logs](features/logs/incidents-from-logs.md): Exceptions in the logs open incidents that resolve themselves. Tune, test on 24 hours, mute.

### Infrastructure

- [Hosts and containers](features/infrastructure/README.md): Servers and containers from node_exporter, cAdvisor and their logs, with built-in alarms.
- [Kubernetes](features/infrastructure/kubernetes.md): Clusters, nodes, workloads and pods from kube-state-metrics, with the agent in one kubectl apply.

### Incidents and reliability

- [Incidents and evidence](features/incidents.md): What the metrics showed, saved with the incident, and impact computed for you.
- [Probable cause](features/probable-cause.md): Ranked causes from changes, logs and metrics. Confirm, resolve, and see what happened before.
- [SLOs](features/reliability/slos.md): Error budgets, burn-rate alerts and real-user Apdex.
- [Change markers](features/reliability/change-markers.md): Deploys, restarts and new routes drawn on every chart.
- [Capacity and anomalies](features/reliability/capacity-and-anomalies.md): "Disk full in about 3 days" and "traffic 70% below last week".

### Alerting

- [Alarms and rules](features/alarms.md): Rules for logs, traffic, metrics, incidents and checks; acknowledging, routing and maintenance windows.
- [Channels and delivery](features/alerts.md): Slack, Discord, Teams, Google Chat, email and webhooks, with tests, a delivery log and muting.
- [Routing, digests and deploy grace](features/alert-routing.md): The right channel, fewer pages during deploys, and one digest for the small stuff.

### Administration

- [Users and access](features/users.md): Roles, who needs attention, safe administration, and access that changes at once.
- [Settings and API keys](features/settings.md): Organization, sign-in security, API keys, integrations and configuration backup.
- [API metrics and Event trail](features/observability/api-metrics.md): How Pulsimo's API answers per route, and who did what, with filters and export.

### Pulsimo's own health

- [System and database health](features/observability/system-health.md): Every Pulsimo component probed with real uptime; storage, retention and maintenance jobs.
- [Monitoring pipeline](features/observability/pipeline-health.md): Check lag, scrape success, alert delay and series per source.

### API

- [Authentication](api/authentication.md): Sign in with an API key or a session token, scopes, and error responses.
- [API reference](api/README.md): Every REST endpoint, grouped by feature.
- [Webhooks](api/webhooks.md): The JSON Pulsimo sends to webhook channels, and how to handle it.

### Guides

- [Running in production](production.md): Secrets, HTTPS, firewall, backups, retention and upgrades.
- [Best practices](best-practices.md): How to set up checks, alerts and projects so the right people hear about the right things.
- [Troubleshooting](troubleshooting.md): Fixes for sign-in, checks, email, logs and metrics problems.
- [FAQ](faq.md): Short answers to common questions.
- [Release notes](release-notes.md): What changed in recent releases.

## Screenshots

<table>
<tr><td width="50%" valign="top"><picture><source media="(prefers-color-scheme: dark)" srcset="images/screenshots/dark/services.png"><source media="(prefers-color-scheme: light)" srcset="images/screenshots/light/services.png"><img src="images/screenshots/dark/services.png" alt="Status board" width="100%"></picture><br><b>Status board</b><br><sub>Every service live, grouped by project, with recent changes.</sub></td><td width="50%" valign="top"><picture><source media="(prefers-color-scheme: dark)" srcset="images/screenshots/dark/endpoints.png"><source media="(prefers-color-scheme: light)" srcset="images/screenshots/light/endpoints.png"><img src="images/screenshots/dark/endpoints.png" alt="Endpoints" width="100%"></picture><br><b>Endpoints</b><br><sub>Health, slowest endpoints and service types, with discovered services to add.</sub></td></tr>
<tr><td width="50%" valign="top"><picture><source media="(prefers-color-scheme: dark)" srcset="images/screenshots/dark/projects.png"><source media="(prefers-color-scheme: light)" srcset="images/screenshots/light/projects.png"><img src="images/screenshots/dark/projects.png" alt="Projects" width="100%"></picture><br><b>Projects</b><br><sub>Reliability against targets, error budgets and who needs attention.</sub></td><td width="50%" valign="top"><picture><source media="(prefers-color-scheme: dark)" srcset="images/screenshots/dark/service-dashboard.png"><source media="(prefers-color-scheme: light)" srcset="images/screenshots/light/service-dashboard.png"><img src="images/screenshots/dark/service-dashboard.png" alt="Service dashboard" width="100%"></picture><br><b>Service dashboard</b><br><sub>A service's own metrics: request rate, error rate, latency and routes.</sub></td></tr>
<tr><td width="50%" valign="top"><picture><source media="(prefers-color-scheme: dark)" srcset="images/screenshots/dark/response-analytics.png"><source media="(prefers-color-scheme: light)" srcset="images/screenshots/light/response-analytics.png"><img src="images/screenshots/dark/response-analytics.png" alt="Response analytics" width="100%"></picture><br><b>Response analytics</b><br><sub>Percentiles, spread and network phases for every check.</sub></td><td width="50%" valign="top"><img src="images/screenshots/dark/performance-insights.png" alt="Performance insights" width="100%"><br><b>Performance insights</b><br><sub>Apdex, anomalies and the endpoints that need attention.</sub></td></tr>
<tr><td width="50%" valign="top"><picture><source media="(prefers-color-scheme: dark)" srcset="images/screenshots/dark/alerting.png"><source media="(prefers-color-scheme: light)" srcset="images/screenshots/light/alerting.png"><img src="images/screenshots/dark/alerting.png" alt="Alerting" width="100%"></picture><br><b>Alerting</b><br><sub>Open alarms, rules, channels, maintenance windows and the delivery log.</sub></td><td width="50%" valign="top"><img src="images/screenshots/light/incidents.png" alt="Incidents" width="100%"><br><b>Incidents</b><br><sub>Related failures grouped into one incident, with root cause and impact.</sub></td></tr>
<tr><td width="50%" valign="top"><picture><source media="(prefers-color-scheme: dark)" srcset="images/screenshots/dark/logs.png"><source media="(prefers-color-scheme: light)" srcset="images/screenshots/light/logs.png"><img src="images/screenshots/dark/logs.png" alt="Logs" width="100%"></picture><br><b>Logs</b><br><sub>Search application logs, see what repeats and link them to endpoints.</sub></td><td width="50%" valign="top"><picture><source media="(prefers-color-scheme: dark)" srcset="images/screenshots/dark/infrastructure.png"><source media="(prefers-color-scheme: light)" srcset="images/screenshots/light/infrastructure.png"><img src="images/screenshots/dark/infrastructure.png" alt="Infrastructure" width="100%"></picture><br><b>Infrastructure</b><br><sub>Hosts, containers and Kubernetes from the exporters you already run.</sub></td></tr>
<tr><td width="50%" valign="top"><img src="images/screenshots/dark/ssl-certificates.png" alt="SSL certificates" width="100%"><br><b>SSL certificates</b><br><sub>Expiry timeline, issuer, grade and TLS version for every HTTPS endpoint.</sub></td></tr>
</table>

## Getting help

- [support@pulsimo.dev](mailto:support@pulsimo.dev) or the [contact page](https://pulsimo.github.io/contact/)
- The [bug report form](https://docs.google.com/forms/d/e/1FAIpQLSc3ZuyIwqytCaw7NNatE79mkhB6DzbwMYq29fEIRC17bfO8vA/viewform)

Pulsimo is proprietary software; see the [LICENSE](../LICENSE).
