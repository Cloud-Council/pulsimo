# Logs

> Collect app logs with Fluent Bit, search them in the Log Browser and link them to endpoints.

## What it is

Your applications' own log lines, collected by Fluent Bit, stored by Pulsimo, and shown
next to the endpoints, metrics and incidents they belong to. Use them to see *why*
something failed, not only *that* it failed.

## Where to find it

- **Logs** in the sidebar: the **Log Browser** and **Sources**.
- Endpoint → **Logs** tab: that endpoint's lines.
- Incident → **Logs** tab: errors around the failure, saved with the incident.

## 1. Send logs to Pulsimo

A complete worked example (a Docker host, from the Fluent Bit folder to incident
evidence) is in [Logs end to end](walkthrough.md).

Logs are **pushed**: Fluent Bit runs next to your applications, reads their logs, and sends
them to Pulsimo's ingest address (`POST /api/v1/logs/ingest`) with its `http` output.
Pulsimo never connects to Fluent Bit, so Fluent Bit opens no port. A **log source** is
just the token one Fluent Bit (or app) uses to push, with its own limits and redaction.

**Logs → Sources → Add log source**: name it (e.g. `prod-docker-host-1`), choose where the
logs are, then **Create and show setup**. The **ingest token is shown once**. The setup has
two views:

- **New Fluent Bit**: the files and commands for a fresh agent, token filled in.
- **I already run Fluent Bit**: only the `[OUTPUT]` to add next to your existing outputs
  (Elasticsearch, Loki, …). Set its `Match` to the tags Pulsimo should get, restart Fluent Bit.
- **Another shipper**: one more output for Promtail, Grafana Alloy, Vector, Filebeat,
  Logstash, the OpenTelemetry Collector or Fluentd. Pulsimo also accepts the Loki push,
  Elasticsearch bulk and OTLP/HTTP protocols, so these need no plugin; see
  [Hosts and containers](../infrastructure/README.md#3-logs-already-shipped).

```ini
[OUTPUT]
    Name             http
    Match            kube.*                 # the tags to send
    Host             pulsimo.example.com
    Port             443
    URI              /api/v1/logs/ingest
    Format           json_lines
    Json_date_key    date
    Json_date_format iso8601
    Header           Authorization Bearer plog_…
    Header_Tag       X-Fluent-Tag           # lets Pulsimo read pod/namespace/container from the tag
    Compress         gzip
    tls              On
    Retry_Limit      10
```

| Where the logs are | What Pulsimo generates |
|---|---|
| Docker host | `fluent-bit.conf` that tails `/var/lib/docker/containers/*/*-json.log` (the files Docker already writes), `docker-meta.lua` that adds the container name, Compose project and service, image and published ports, and a `docker-compose.yml` service for Fluent Bit. No changes to your containers. |
| Kubernetes | `pulsimo-values.yaml` for the `fluent/fluent-bit` Helm chart (DaemonSet). The chart already tails `/var/log/containers/*.log` with the Kubernetes filter; the values only add the output. With your own values file, add the output under `config.outputs` next to your outputs. |
| Server (VM) log files | `fluent-bit.conf` with a `tail` input per application, and the commands to install Fluent Bit as a system service (`/etc/fluent-bit/fluent-bit.conf`, `systemctl enable --now fluent-bit`). |
| Server (VM) systemd journal | Same, with the `systemd` input. |
| Anything else | A `curl` example: any tool that can POST JSON lines (gzip accepted). |

Fluent Bit keeps a position file (`DB`) per input, so a restart neither loses nor repeats lines,
and it retries when Pulsimo is unreachable.

The Sources table shows each source's status (**Receiving**, **Quiet**, **Waiting for
first lines**, **Paused**), lines received and lines dropped over its limit. **Token**
issues a new token (the old one stops at once); **Setup** shows the config again with the
token masked.

### What Pulsimo does to each line

- **Level**: taken from `level`/`severity` fields, else detected from the text (`ERROR`,
  `WARN`, panics, exceptions, HTTP 5xx in access logs).
- **Service**: the first of: a `service`/`app` field; the pod label `app.kubernetes.io/name`
  or `app`; Compose `project-service`; the container name (Docker or Kubernetes); the container in the Fluent Bit tag;
  the systemd unit; the tag's prefix (`quickopsbe` from `quickopsbe.var.log.containers…`);
  else the source's default service.
- **Kubernetes**: `namespace`, `pod`, `container` and `host` become fields (from the
  Kubernetes filter, or from the log file name in the tag when the filter isn't used).
- **JSON logs**: an app that writes JSON on stdout gets its fields lifted out (`msg`,
  `level`, `route`, `trace_id`, …).
- **Access logs**: `GET /api/orders?x=1 … 503` gets `method`, `route` (without the query
  string) and `status` fields, so lines can be matched to the request metrics of that route.
- **Redaction before storage**: emails, bearer tokens, `password=`/`secret=`/`token=`/
  `api_key=` values and card numbers are masked, plus your own patterns.
- **Limits**: lines longer than `LOG_INGEST_MAX_LINE_BYTES` are truncated; lines over a
  source's rate limit are dropped and counted.

## 2. The Log Browser

**Logs → Log Browser**:

- **Search** messages (`timeout`, `"connection refused"`; matches are highlighted).
- **Levels**: click ERROR / WARN / INFO / DEBUG to show or hide them; each shows its count.
- **Service**: pick one or more services.
- **LogsQL**: any extra filter, e.g. `route:"/api/orders" AND status:>=500`. The full query
  is shown under the box.
- **Time**: 15m to 7d. **Drag across the volume chart to zoom in.** **Go live** refreshes
  every 3 seconds.
- **Lines**: newest first. Click a line for the whole message (multi-line stack traces,
  pretty-printed JSON), all its fields (each with *only these* / *hide these* buttons), copy
  buttons, and **Lines around this one**, which opens the lines just before and after it from
  the same container or file.
- **Patterns**: groups lines that differ only in ids, numbers, addresses or times
  ("Connection to `<ip>` timed out after `<num>` ms") with counts, first and last time, and a
  **New** badge for patterns that first appeared in this time range. **Show lines** jumps back
  to the matching lines.

The URL keeps everything (query, levels, services, range), so you can share a link.

## 3. Logs of an endpoint

Endpoint → **Logs** tab:

- **Suggested log links**: Pulsimo looks at the services and hosts in your logs and suggests
  the ones that match the endpoint's host, its route and its metric sources — including
  endpoints you created from metrics or the Discovered inbox. One click links them.
- **Link logs with your own filter**: any LogsQL filter, e.g.
  `service:"orders-api" AND route:"/api/orders"`.
- The newest lines (15m to 24h, refreshed every 15 s) with a volume chart, an
  *errors and warnings only* switch, and **Open in Log Browser** (pre-filtered to this
  endpoint).

Linked logs are used everywhere else: incident evidence, probable causes, alerts and charts.
They also open incidents of their own when the app keeps throwing exceptions: see
[Incidents from logs](incidents-from-logs.md).

## 4. Logs in alerts

"Service down" and escalation alerts for an endpoint with linked logs include its most
frequent error patterns of the last 10 minutes:

```
What the logs show:
- 1240× pq: sorry, too many clients already (orders-api, since 14:01:31 UTC)
```

## 5. Logs as metrics and changes

Every minute Pulsimo counts lines per service and level, and the busiest error patterns:

| Series | Meaning |
|---|---|
| `pulsimo_log_lines_per_minute{service, level}` | Log volume, e.g. errors per minute per service |
| `pulsimo_log_pattern_per_minute{service, pattern, level}` | One error pattern's rate |

Chart them in dashboards or the Explorer next to latency and CPU, set SLO-style alerts on
them, or compare: `sum(pulsimo_log_lines_per_minute{service="orders-api",level="error"})`.

An error pattern never seen before becomes a **New error** change: a marker on charts,
a line in the digest, and a candidate cause for incidents ([Probable cause](../probable-cause.md)).

## Settings

| Variable | Default | Meaning |
|---|---|---|
| `LOGS_RETENTION` | `7d` | How long lines are kept (read by the log store at startup) |
| `LOG_INGEST_PUBLIC_URL` | (the address the page uses) | Address Fluent Bit uses to reach Pulsimo, put into generated configs |
| `LOG_INGEST_MAX_LINES_PER_SEC` | `2000` | Default rate limit per source |
| `LOG_INGEST_MAX_LINE_BYTES` | `16384` | Longer messages are truncated |
| `LOG_AGENT_IMAGE` | `fluent/fluent-bit:3.1` | Fluent Bit image in generated setups |
| `LOG_PATTERN_INTERVAL_SECONDS` | `60` | How often patterns and log rates are computed |
| `LOG_PATTERN_MAX_LINES` | `5000` | Most warning/error lines read per organization per pass |

## Limits

- Lines are searchable a few seconds after they arrive.
- Patterns are computed from warnings and errors only.
- Lines older than the retention are gone; incidents keep their saved log evidence.

---

← [Discovered services](../metrics/discovery.md) · [Contents](../../README.md) · [Logs end to end](walkthrough.md) →
