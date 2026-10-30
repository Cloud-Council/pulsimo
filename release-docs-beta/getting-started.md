# Quick start

> From an empty install to your first endpoint, alert channel and metric source in about ten minutes.

This page takes you from a fresh install to a working setup: one endpoint checked every
30 seconds, alerts in Slack (or email), and, if you have them, your metrics and logs next
to it. Pulsimo must already be running; if not, start with
[Installation](installation/README.md).

## 1. Sign in

Open `http://<HOST_IP>:3000` and sign in as `superadmin@pulsimo.io` with the password
`admin`, then change that password (**Users** → **Reset password** on your own row). Self
sign-up is turned off in this release: every later account is added by an administrator
from **Users**.

## 2. Add an alert channel

Do this first, so the first outage already reaches someone.

1. Open **Alerting** in the sidebar and click **Add channel**.
2. Pick the platform. Each tile lists the steps to get its webhook:

   | Platform | You enter |
   |---|---|
   | Slack | An Incoming Webhook URL |
   | Discord | The channel webhook URL |
   | Microsoft Teams | The URL from a Teams workflow or connector |
   | Google Chat | The space webhook URL |
   | Email | One or more addresses (needs the SMTP settings in `.env`) |
   | Webhook | Any URL, with method and headers |

3. Give it a name people recognize, keep **Severity** on *Everything* for now, and leave
   **Send a test after saving** on.
4. Save. The result of the test shows on the channel card: *Test delivered in 0.8 s*, or
   the platform's error.

More in [Channels and delivery](features/alerts.md).

## 3. Add your first endpoint

1. Open **Services → Endpoints** and click **Add endpoint**.
2. Fill in:

   | Field | Example |
   |---|---|
   | Name | `Website` |
   | Service type | Frontend |
   | URL | `https://example.com` |
   | Check interval | 30 seconds |

3. Save. The first check runs straight away.

Databases, Redis, Elasticsearch, gRPC and WebSocket services are added the same way with
their own address; see [Endpoints and checks](features/health-checks.md).

## 4. Watch it

**Services → Overview** is the live status board. It refreshes every 30 seconds and shows
each endpoint's last 24 hours as 48 half-hour bars, its uptime and p95 response time.

To see an alert end to end, add an endpoint that fails, for example
`https://example.com/this-page-does-not-exist`. After its alert policy's failures, the
channel gets **"… is down"**, an incident opens on **Incidents**, and when you delete or
fix the endpoint the channel gets **Resolved**.

## 5. Bring in metrics (optional)

If your apps or servers already expose Prometheus metrics (an app's `/metrics`,
node_exporter, cAdvisor, postgres_exporter…):

1. **Metrics → Sources → Add source**, enter the URL, e.g.
   `http://10.0.1.12:9100/metrics`.
2. **Test connection**, then **Save**. Collection starts at once.
3. **Connect** on the source links its routes or database to your endpoints, so their
   metrics, dashboards and change markers show next to the checks.

See [Metric sources](features/metrics/sources.md) and
[Connected monitoring](features/metrics/connected-monitoring.md).

## 6. Bring in logs (optional)

**Logs → Sources → Add source** gives you a ready-made Fluent Bit configuration (or a
`docker run` command) with its own `plog_` token. Once lines arrive, search them in the
**Log Browser** and link them to an endpoint, so errors in the logs can open incidents by
themselves. See [Logs](features/logs/README.md) and the step-by-step
[Logs end to end](features/logs/walkthrough.md).

## 7. Add your servers (optional)

**Infrastructure → Add hosts** gives one command for a new server, or connects exporters
and a Prometheus you already run. Kubernetes clusters connect with one `kubectl apply`.
See [Hosts and containers](features/infrastructure/README.md) and
[Kubernetes](features/infrastructure/kubernetes.md).

## Where next

- [Your first project](first-project.md): group endpoints and set a reliability target.
- [Alarms and rules](features/alarms.md): alerts for logs, traffic, metrics and more.
- [Users and access](features/users.md): invite your team with the right role.

---

← [Installation](installation/README.md) · [Contents](README.md) · [Your first project](first-project.md) →
