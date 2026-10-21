# Features

Every part of Pulsimo, by area. Each page says where to find the feature, how to use it and what its settings do.

- [Projects and overview](projects.md): The live status board, project reliability against targets and error budgets, and project analytics.
- [Endpoints and checks](health-checks.md): What Pulsimo can check, every endpoint setting, and how a check decides Up, Degraded or Down.
- [Monitoring from metrics](metric-monitors.md): Health from the app's own metrics (5xx, p95, traffic) instead of, or as well as, calling it.
- [Service analytics](service-performance.md): Response times, Apdex and anomalies, network phases and certificates for every endpoint.
- [Dependencies](dependencies.md): A live map of which service needs which, suggestions with evidence, and impact on incidents.
- [Metric sources](metrics/sources.md): Tell Pulsimo where /metrics lives and it pulls on a schedule.
- [Metrics Explorer](metrics/explorer.md): Graph anything with PromQL or a point-and-click builder.
- [Dashboards](dashboard.md): Grafana-style dashboards with an editor, variables and Grafana JSON import.
- [Connected monitoring](metrics/connected-monitoring.md): One service, one place: endpoint checks, its metrics and its dashboards together.
- [Discovered services](metrics/discovery.md): APIs, databases, hosts and containers found in your metrics, ready to monitor.
- [Logs](logs/README.md): Collect app logs with Fluent Bit, search them in the Log Browser and link them to endpoints.
- [Logs end to end](logs/walkthrough.md): Walkthrough: a Docker host's logs from Fluent Bit to endpoints and incidents.
- [Incidents from logs](logs/incidents-from-logs.md): Exceptions in the logs open incidents that resolve themselves. Tune, test on 24 hours, mute.
- [Hosts and containers](infrastructure/README.md): Servers and containers from node_exporter, cAdvisor and their logs, with built-in alarms.
- [Kubernetes](infrastructure/kubernetes.md): Clusters, nodes, workloads and pods from kube-state-metrics, with the agent in one kubectl apply.
- [Incidents and evidence](incidents.md): What the metrics showed, saved with the incident, and impact computed for you.
- [Probable cause](probable-cause.md): Ranked causes from changes, logs and metrics. Confirm, resolve, and see what happened before.
- [SLOs](reliability/slos.md): Error budgets, burn-rate alerts and real-user Apdex.
- [Change markers](reliability/change-markers.md): Deploys, restarts and new routes drawn on every chart.
- [Capacity and anomalies](reliability/capacity-and-anomalies.md): "Disk full in about 3 days" and "traffic 70% below last week".
- [Alarms and rules](alarms.md): Rules for logs, traffic, metrics, incidents and checks; acknowledging, routing and maintenance windows.
- [Channels and delivery](alerts.md): Slack, Discord, Teams, Google Chat, email and webhooks, with tests, a delivery log and muting.
- [Routing, digests and deploy grace](alert-routing.md): The right channel, fewer pages during deploys, and one digest for the small stuff.
- [Users and access](users.md): Roles, who needs attention, safe administration, and access that changes at once.
- [Settings and API keys](settings.md): Organization, sign-in security, API keys, integrations and configuration backup.
- [API metrics and Event trail](observability/api-metrics.md): How Pulsimo's API answers per route, and who did what, with filters and export.
- [System and database health](observability/system-health.md): Every Pulsimo component probed with real uptime; storage, retention and maintenance jobs.
- [Monitoring pipeline](observability/pipeline-health.md): Check lag, scrape success, alert delay and series per source.

---

[Back to the contents](../README.md)
