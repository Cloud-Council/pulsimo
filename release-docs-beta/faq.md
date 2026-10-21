# FAQ

> Short answers to common questions.

## What is Pulsimo?

A self-hosted monitoring platform. It checks your websites, APIs, databases and other
services, pulls their metrics and logs, opens incidents with the evidence attached, and
tells the right people on Slack, Discord, Teams, Google Chat, email or a webhook.

## Is it free?

Pulsimo is in beta and free to use during the beta. Pricing will be announced before the
official launch. For licensing questions, use the [contact page](https://pulsimo.github.io/contact/).

## Where does my data go?

Nowhere else. Pulsimo runs on your server, and checks, metrics, logs and users stay in its
own PostgreSQL, VictoriaMetrics and VictoriaLogs. Alerts go only to the channels you set
up.

## What do I need to run it?

A Linux server with Docker and Docker Compose, 4 vCPU and 8 GB of memory at minimum. See
[Installation](installation/README.md).

## Do I have to install agents?

No. Pulsimo calls your endpoints from its own server and pulls metrics from exporters you
may already run (node_exporter, cAdvisor, your app's `/metrics`). For logs you run Fluent
Bit, or point a shipper you already have (Promtail, Alloy, Vector, Filebeat, Logstash, the
OpenTelemetry Collector) at Pulsimo. A Prometheus you already run can forward its metrics
with `remote_write`.

## What can it check?

HTTP and HTTPS (any method, headers, body, GraphQL), PostgreSQL, MySQL, Redis,
Elasticsearch, gRPC and WebSocket. Anything with Prometheus metrics can be monitored from
those metrics instead. See [Endpoints and checks](features/health-checks.md).

## How often can it check?

Every 10 seconds to every hour, per endpoint.

## Does it replace Prometheus and Grafana?

For many teams, yes: it scrapes Prometheus-format metrics, runs PromQL, and has
Grafana-style dashboards that can import Grafana JSON. It can also sit next to them: a
Prometheus you already run can `remote_write` to Pulsimo. See
[Metric sources](features/metrics/sources.md) and [Dashboards](features/dashboard.md).

## Can it monitor Kubernetes?

Yes. One `kubectl apply` installs an agent that sends kube-state-metrics, cAdvisor and
node_exporter data, plus pod logs. See [Kubernetes](features/infrastructure/kubernetes.md).

## How do I stop alerts during a deploy or upgrade?

Plan a maintenance window on **Alerting**. Alarms during the window are held and sent only
if the problem is still there when it ends. Pulsimo also waits 3 minutes after a deploy or
restart it detects before sending a *down* alert.

## Can I use the API?

Yes. Everything in the web app is available through the REST API. Create an API key on
**Settings → API keys**. See [Authentication](api/authentication.md).

## Is there single sign-on or two-factor sign-in?

Not yet. Sign-in security today is inactivity sign-out, account locks after failed
attempts, and password rules, all on **Settings → Security**.

## How do I report a bug or ask for a feature?

Use the [bug report form](https://docs.google.com/forms/d/e/1FAIpQLSc3ZuyIwqytCaw7NNatE79mkhB6DzbwMYq29fEIRC17bfO8vA/viewform)
or the [contact page](https://pulsimo.github.io/contact/).

---

← [Troubleshooting](troubleshooting.md) · [Contents](README.md) · [Release notes](release-notes.md) →
