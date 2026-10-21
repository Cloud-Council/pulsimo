# Logs end to end

> Walkthrough: a Docker host's logs from Fluent Bit to endpoints and incidents.

This walkthrough connects every container log on one Docker host to Pulsimo, then follows
the lines all the way to an endpoint and an incident. It uses the real setup that ships
WakerPortal's logs (`wakerportal-api`, `wakerportal-frontend`, `wakerportal-postgres`)
from a developer machine. For Kubernetes and plain servers, see the variants at the end.

## How it fits together

```
 WakerPortal containers                 Fluent Bit (one per host)                  Pulsimo
 ──────────────────────                 ─────────────────────────                  ───────
 api ─┐ stdout/stderr                    tail  /var/lib/docker/containers/*/*.log
 frontend ─┼─► Docker json-file ──────►  lua   container, Compose project/service,
 postgres ─┘   (files on disk)                 image, published ports
                                         grep  only the projects you choose
                                         multiline  stack traces → one line
                                         http  ──── POST /api/v1/logs/ingest ────►  api-gateway
                                               (Bearer token, gzip, X-Fluent-Tag)     │ token → org + source
                                                                                      │ level, service, route/status,
                                                                                      │ redaction, rate limit
                                                                                      ▼
                                                                                 VictoriaLogs (per-org tenant)
                                                                                      │
              Log Browser · endpoint Logs tab · incident evidence · probable cause ◄──┤
              log patterns · "New error" changes · pulsimo_log_* metrics · alerts  ◄──┘
```

- Fluent Bit **pushes**. Pulsimo never connects to it, so it opens no port and needs no
  inbound firewall rule. It only needs to reach Pulsimo's API.
- Your containers need **no changes**: Fluent Bit reads the files Docker already writes
  with its default `json-file` log driver.
- Fluent Bit remembers how far it read each file (`DB`), and retries while Pulsimo is
  unreachable, so restarts neither lose nor repeat lines.

## Before you start

On the Pulsimo side (its `.env`, then `docker compose up -d`):

| Variable | Set it to |
|---|---|
| `LOG_INGEST_PUBLIC_URL` | The address your hosts use to reach Pulsimo's API, e.g. `https://pulsimo.example.com`. It is written into generated configs. Empty = the address your browser used. |
| `LOGS_RETENTION` | How long lines are kept (`7d` default) |
| `LOG_INGEST_MAX_LINES_PER_SEC` | Default per-source limit (`2000`) |

On the Docker host: Docker with Compose v2. Nothing else; Fluent Bit runs as a container.

## Step 1. Create a log source

**Logs → Sources → Add log source**

- **Name**: something that says where the lines come from, e.g. `local-docker (wakerportal)`.
- **Where the logs are**: *Docker host*.
- Optional: lines-per-second limit and extra redaction rules (regex, one per line).

**Create and show setup.** Copy the **ingest token** now: it is shown once. (If you lose it,
**Token** on the source issues a new one and stops the old one.)

The setup shows the three files below with your token filled in. The version here keeps
the token and addresses in a `.env` file, so the config itself holds no secret.

## Step 2. Create the Fluent Bit folder on the host

```
~/Desktop/fluentbit/
├── .env                 Pulsimo address, token, which Compose projects to send
├── docker-compose.yml   runs Fluent Bit
├── fluent-bit.conf      the pipeline: tail → lua → grep → multiline → http
└── docker-meta.lua      adds container name, Compose project/service, image, ports
```

### `.env` (keep it private: `chmod 600 .env`)

```bash
# Where Fluent Bit sends the lines (Pulsimo's API)
PULSIMO_HOST=host.docker.internal     # Pulsimo on this same machine; else its hostname
PULSIMO_PORT=8080                     # 443 behind HTTPS
PULSIMO_TLS=Off                       # On behind HTTPS
# Ingest token of the log source (Logs -> Sources in Pulsimo)
PULSIMO_LOG_TOKEN=plog_xxxxxxxxxxxxxxxx
# Compose projects whose containers are sent (regex)
COMPOSE_PROJECTS=^wakerportal$
```

`COMPOSE_PROJECTS` is a regular expression on the Compose project name:
`^(wakerportal|billing)$` sends two projects, `.*` sends every container on the host.

### `docker-compose.yml`

```yaml
name: pulsimo-fluentbit

services:
  fluent-bit:
    image: ${FLUENT_BIT_IMAGE:-fluent/fluent-bit:3.1}
    container_name: pulsimo-fluent-bit
    restart: unless-stopped
    env_file: .env
    extra_hosts:
      - "host.docker.internal:host-gateway"   # reach Pulsimo on this machine
    volumes:
      - ./fluent-bit.conf:/fluent-bit/etc/fluent-bit.conf:ro
      - ./docker-meta.lua:/fluent-bit/etc/docker-meta.lua:ro
      - /var/lib/docker/containers:/var/lib/docker/containers:ro
      - fluent-bit-state:/fluent-bit/state
    logging:
      driver: json-file
      options:
        max-size: 10m
        max-file: "3"

volumes:
  fluent-bit-state:
```

### `fluent-bit.conf`

```ini

[SERVICE]
    Flush         2
    Log_Level     warn

# Every container's output, from the files Docker already writes (json-file driver)
[INPUT]
    Name              tail
    Path              /var/lib/docker/containers/*/*-json.log
    Tag               docker.*
    multiline.parser  docker
    DB                /fluent-bit/state/docker.db
    Mem_Buf_Limit     20MB
    Skip_Long_Lines   On
    Refresh_Interval  5

# Container name, Compose project and service, image
[FILTER]
    Name    lua
    Match   docker.*
    script  /fluent-bit/etc/docker-meta.lua
    call    docker_meta

# Only the Compose projects in COMPOSE_PROJECTS
[FILTER]
    Name    grep
    Match   docker.*
    Regex   compose_project ${COMPOSE_PROJECTS}

# Join multi-line stack traces into one line
[FILTER]
    Name                  multiline
    Match                 *
    multiline.key_content log
    multiline.parser      go, java, python

[OUTPUT]
    Name             http
    Match            docker.*
    Host             ${PULSIMO_HOST}
    Port             ${PULSIMO_PORT}
    URI              /api/v1/logs/ingest
    Format           json_lines
    Json_date_key    date
    Json_date_format iso8601
    Header           Authorization Bearer ${PULSIMO_LOG_TOKEN}
    Header_Tag       X-Fluent-Tag
    Compress         gzip
    tls              ${PULSIMO_TLS}
    tls.verify       On
    Retry_Limit      10
```

`${...}` values come from `.env`. Fluent Bit 3.x reads them from its environment.

### `docker-meta.lua`

Docker's log files carry only the message, stream and time. This script reads each
container's `config.v2.json` and `hostconfig.json` once and adds:

| Field | Example | Used for |
|---|---|---|
| `container_name` | `wakerportal-api` | the `container` field, the service when nothing better exists |
| `compose_project`, `compose_service` | `wakerportal`, `api` | the `grep` filter, the service name `wakerportal-api` |
| `image` | `wakerportal-api` | filtering |
| `host_ports` | `8081` | matching endpoints like `http://192.168.10.93:8081/...` to this container |

It also drops Fluent Bit's own output. Copy the script from the setup dialog (it is the same
for every Docker host).

## Step 3. Start it and check

```bash
cd ~/Desktop/fluentbit
docker compose up -d
docker compose logs -f        # Fluent Bit's own messages; quiet means fine
```

Within a few seconds:

1. **Logs → Sources**: the source shows **Receiving**, with the line count going up.
2. **Logs → Log Browser**: pick the services in **Service**. For WakerPortal you see:

   | Service | Where the name comes from | Example line |
   |---|---|---|
   | `wakerportal` | the API logs JSON with `"service":"wakerportal"`, which wins | `monitor check reported target down` (warn, with `monitor_name`, `error`, `latency_ms` as fields) |
   | `wakerportal-frontend` | Compose project + service | nginx access lines, with `method`, `route`, `status` fields |
   | `wakerportal-postgres` | Compose project + service | `database system is ready to accept connections` |

3. Click a line: the full message, every field (JSON logs are split into fields), and
   **Lines around this one** for the lines before and after it in the same container.

How Pulsimo names the service, first match wins: a `service`/`app` field the app logs itself →
Kubernetes pod label → Compose `project-service` → container name → systemd unit → the
source's default service.

## Step 4. Connect the logs to an endpoint

Open the endpoint (Services → Endpoints → the endpoint → **Logs** tab). Pulsimo suggests
the logs that belong to it:

| Suggestion | Why |
|---|---|
| **All lines of wakerportal (publishes port 8081)** | The endpoint is `http://192.168.10.93:8081/...` and `wakerportal-api` publishes port 8081 |
| **Only wakerportal requests to this route** | The API's lines carry `route:"/api/v1/monitors"`, the endpoint's path |
| All lines of wakerportal-frontend (serves /api/v1/monitors) | nginx proxies the same route |

Link **All lines of wakerportal**: error lines rarely carry a route, so the whole service is
the better link. Add your own LogsQL filter if needed, e.g.
`service:"wakerportal" AND (route:"/api/v1/monitors" OR level:error)`.

Endpoints created from metrics or from the Discovered inbox get the same suggestions,
using their metric source's name, host and route labels too.

## Step 5. What you get from then on

| Where | What |
|---|---|
| Endpoint → Logs | The newest lines with a volume chart, *errors and warnings only*, **Open in Log Browser** pre-filtered |
| Incident → Probable cause | Ranked causes. A new or surging error pattern that started just before the failure ranks high; failing-request access lines rank low (they are the symptom) |
| Incident → Logs | Error patterns before vs during, and the lines just before and after the first failure, saved with the incident (kept after log retention) |
| Alerts | "Service down" and escalations include the top error patterns of the last 10 minutes |
| Log Browser → Patterns | Lines grouped by template, with **New** for patterns first seen in the range |
| Changes | A never-seen error pattern becomes a **New error** marker on charts |
| Metrics | `pulsimo_log_lines_per_minute{service,level}` and `pulsimo_log_pattern_per_minute` for dashboards and alerts |

## Day-to-day

| Task | How |
|---|---|
| Send another Compose project | Add it to `COMPOSE_PROJECTS`, `docker compose up -d` |
| Pause sending | `docker compose stop` (Fluent Bit resumes from where it stopped). **Pause** on the source refuses its lines instead; Fluent Bit retries, then drops them. |
| Rotate the token | **Token** on the source, put the new one in `.env`, `docker compose up -d` |
| Forget read positions (re-read nothing old) | `docker compose down -v` |
| Hide a noisy line | Add a `grep` filter with `Exclude log healthcheck` before the output |
| Mask a secret the app prints | Add a redaction rule on the source (regex), applied before storage |

## Troubleshooting

| Symptom | Check |
|---|---|
| Source stays **Waiting for first lines** | `docker compose logs fluent-bit`. Connection refused or timeout: `PULSIMO_HOST`/`PORT` wrong, or a firewall between the host and Pulsimo. On the same machine use `host.docker.internal` with the `extra_hosts` line. |
| `401` in Fluent Bit's messages | Wrong or rotated token, or the source is paused |
| `429` in Fluent Bit's messages | Over the source's lines-per-second limit; raise it on the source. Fluent Bit retries. |
| No lines from one container | Its Compose project doesn't match `COMPOSE_PROJECTS`, or it uses a log driver other than `json-file` (`docker inspect -f '{{.HostConfig.LogConfig.Type}}' <name>`) |
| Service name is the container name, not `project-service` | The container wasn't started by Compose (no Compose labels) |
| Times are a few seconds off | Fluent Bit sends the time Docker recorded; check the host clock |
| Lines appear but not on the endpoint | Link them on the endpoint's Logs tab; suggestions need some lines from the last 24 h |

## Other platforms

- **Kubernetes**: create a source of kind *Kubernetes*. You get `pulsimo-values.yaml` for
  the `fluent/fluent-bit` Helm chart (DaemonSet). Already running Fluent Bit with your own
  values? Add the `[OUTPUT]` from **I already run Fluent Bit** under `config.outputs` next
  to your outputs and set `Match` to your tags. Pod, namespace and container come from the
  Kubernetes filter, or from the log file name in the tag (`Header_Tag X-Fluent-Tag`).
- **Server (VM)**: kind *Server (VM) log files* or *systemd journal*. Fluent Bit is installed
  as a system service (`/etc/fluent-bit/fluent-bit.conf`, `systemctl enable --now fluent-bit`)
  with a `tail` input per application or the `systemd` input.

All options and settings are in [Logs](README.md).

---

← [Logs](README.md) · [Contents](../../README.md) · [Incidents from logs](incidents-from-logs.md) →
