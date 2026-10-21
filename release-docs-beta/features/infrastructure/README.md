# Hosts and containers

> Servers and containers from node_exporter, cAdvisor and their logs, with built-in alarms.

**Monitor → Infrastructure** shows the servers and containers behind your endpoints. It is
built from data you may already collect:

| Data | Comes from | Gives |
|---|---|---|
| Host metrics | node_exporter | CPU, memory, disks, load, network, uptime of each machine |
| Container metrics | cAdvisor | CPU and memory against limits, restarts, out-of-memory kills, network of each container |
| Container logs | Fluent Bit (Logs → Sources) | The log lines next to each container's charts, and the *Errors in container logs* alarm |

Nothing new has to run on a machine that is already monitored. Pulsimo either scrapes the
exporters itself, or receives a copy from the Prometheus (or agent) that scrapes them today.

## Connecting

Click **Add hosts** (top right), or use the **Connect** tab. There are three ways in, and
they can be mixed:

| Tab of Add hosts | Use it when | What Pulsimo does |
|---|---|---|
| **New server** | A server with Docker that nothing monitors yet | Gives one command that starts a small agent |
| **Exporters already running** | node_exporter, cAdvisor or other exporters run and Pulsimo can reach them | Scrapes them |
| **Prometheus or agent** | A Prometheus or agent already scrapes them, or Pulsimo can't reach the machines | Receives a copy (remote_write) |
| **Logs already shipped** | Promtail, Alloy, Vector, Filebeat, Logstash, Fluentd or the OTel Collector already ship logs | Becomes one more output |

### New server (one command)

**Add hosts → New server.** For a server with Docker (and Docker Compose) that nothing
monitors yet.

1. Type the server's name, for example `web-1`. It becomes the `host` label: it names the
   host page and ties the server's containers and logs to it.
2. **Prepare the command.** Pulsimo creates two sources for the server, *web-1 agent*
   (metrics) and *web-1 logs* (logs), and shows one block to paste on the server. The tokens
   are inside and are shown only this once.
3. Paste it on the server as a user that can run Docker. It writes four files to
   `~/pulsimo-agent` and runs `docker compose up -d`.

The checklist next to the command updates every 5 seconds:

| Step | Done when |
|---|---|
| The agent connects | vmagent's first metrics arrive |
| Host metrics | node_exporter reports the machine |
| Containers | cAdvisor reports the containers |
| Container logs | Fluent Bit's first lines arrive (they come in batches, up to 30 s) |

When all four are ticked, **Open web-1** goes to the host page. You can close the window
before that; the server shows up under Hosts as soon as it reports.

What runs on the server, all with `network_mode: host` and `restart: unless-stopped`:

| Container | Does | Listens on |
|---|---|---|
| `pulsimo-agent-node-exporter` (node_exporter 1.8.2) | The machine: CPU, memory, disks, network | 127.0.0.1:9100 |
| `pulsimo-agent-cadvisor` (cAdvisor 0.60.6) | The containers; Compose labels only, per-CPU and network-protocol metrics off to keep it light | 127.0.0.1:18080 |
| `pulsimo-agent-vmagent` (vmagent 1.106.1) | Scrapes both every 15 s and pushes to Pulsimo; keeps up to 1 GB on disk while Pulsimo is unreachable | 127.0.0.1:8429 |
| `pulsimo-agent-fluent-bit` (Fluent Bit) | Reads the log files Docker already writes and pushes them | nothing |

Nothing is reachable from outside the server, and your containers are not changed.

The address the agent sends to is `LOG_INGEST_PUBLIC_URL` ([Configuration](../../configuration/environment-variables.md)), else the address
your browser uses. When that is `localhost`, the screen warns that the command only works on
the Pulsimo machine itself: set `LOG_INGEST_PUBLIC_URL` and prepare it again.

Preparing the same server again keeps its two sources and gives them new tokens, so an agent
started with the earlier command stops sending until you run the new one.

To remove the agent: `cd ~/pulsimo-agent && docker compose down -v`, then delete *web-1
agent* (Infrastructure → Connect) and *web-1 logs* (Logs → Sources).

### 1. Prometheus or agent (recommended)

Use this when node_exporter and cAdvisor are already scraped by Prometheus,
kube-prometheus-stack, Grafana Alloy, vmagent or the OpenTelemetry Collector, or when the
machines can't be reached from Pulsimo.

1. Click **Connect Prometheus**, give the connection a name (*Production Prometheus*) and,
   if you like, extra labels such as `env=production` or `cluster=eu-1`. They are added to
   every series the connection sends.
2. Pulsimo shows the **token** once, the **remote_write URL** and a ready-made snippet for
   Prometheus, kube-prometheus-stack, Grafana Alloy, vmagent and the OpenTelemetry
   Collector. Copy the token now: Pulsimo keeps only a hash of it.
3. Add the snippet to your Prometheus or agent and reload it.

Your Prometheus keeps working as before and also sends a copy to Pulsimo. Hosts and
containers appear within a minute. Under **Prometheus connections** each connection shows
when it last pushed, how many writes and how much data it sent. The dot turns green once
the first write arrives.

Each connection has three buttons:

- **Rotate token** makes a new token and stops the old one; update the snippet on your side
  afterwards.
- **Pause** refuses its writes, so what it sends meanwhile is lost; **Resume** accepts them
  again.
- **Delete** removes the connection and its token. The data it already sent stays until the
  metrics retention ends.

A change takes effect within a minute. Every series a connection sends is tagged with your
organization and the connection, and those tags cannot be overwritten by the sender.
Connections are not listed under Metrics → Sources (that page lists what Pulsimo scrapes);
it links here instead.

The address in the snippets is `LOG_INGEST_PUBLIC_URL` when set ([Configuration](../../configuration/environment-variables.md)), otherwise the
address your browser uses. Set it when your servers reach Pulsimo through a different name.

> **Agents on every machine.** When an agent on each server scrapes `localhost:9100` and
> they all push through one connection, give each agent a `host` label (for example
> `external_labels: { host: web-1 }`). Pulsimo uses it to keep the machines apart.

### 2. Exporters already running

**Add hosts → Exporters already running.** Paste the targets, or click **Load a file**:

- a list, one per line, with optional labels after it: `10.0.1.12:9100 env=prod`;
- a Prometheus `file_sd` file, JSON or YAML;
- the `scrape_configs` of a `prometheus.yml`: every `static_configs` target is read, with
  its labels and the job's `scheme` and `metrics_path`.

An address without a path gets `/metrics`, and without a scheme `http://`. Up to 300
targets at a time. Labels starting with `__` and the ones Pulsimo sets itself (`instance`,
`job`, `source`, `org_id`…) are dropped.

**Check targets** scrapes each one once and shows:

| Column | Meaning |
|---|---|
| Target | The URL, and whether it answered (with its sample count and operating system) or why not |
| Type | What it serves: node_exporter (it has `node_uname_info`), cAdvisor, PostgreSQL (`pg_up`), MySQL (`mysql_up`), an application (HTTP request metrics) or other. Change it if Pulsimo guessed wrong |
| Host label | Puts a machine's exporters on one host page. For node_exporter it is the machine name it reports; other exporters at the same address get the same one. Edit it freely |
| Name | The source's name, unique in your organization (Pulsimo adds a number when needed) |

Targets that are already a source are greyed out. Tick the ones to keep (those that answered
are ticked), pick how often to scrape (15, 30 or 60 seconds) and click **Add N sources**.
Targets that did not answer can be kept too: Pulsimo keeps trying and shows the error under
Metrics → Sources.

The machines must be reachable from Pulsimo. When they are behind a firewall or in another
network, use the Prometheus or agent tab: it pushes, so no port has to be opened.

You can still add a single exporter under Metrics → Sources, with authentication and
certificate options.

### 3. Logs already shipped

**Add hosts → Logs already shipped** (or Logs → Sources → Setup → **Another shipper**).
Create a log source, or pick one you have, and Pulsimo shows the output to add to your
shipper. Your current destination keeps getting everything.

| Shipper | Protocol | Address |
|---|---|---|
| Promtail, Grafana Alloy | Loki push (protobuf or JSON) | `/api/v1/logs/loki/api/v1/push` |
| Filebeat, Logstash | Elasticsearch bulk | `/api/v1/logs/elasticsearch` |
| OpenTelemetry Collector | OTLP/HTTP logs (protobuf or JSON) | `/api/v1/logs/otlp/v1/logs` |
| Vector, Fluentd, Fluent Bit, anything else | JSON lines | `/api/v1/logs/ingest` |

The token goes in as a Bearer token, or as the password of basic auth (Filebeat and
Logstash: user `pulsimo`). Lines from every protocol get the same treatment as Fluent Bit's:
the service, container, host, namespace and pod are read from the names each tool uses
(Loki labels such as `service_name` and `container`, ECS fields such as `service.name` and
`host.name`, OpenTelemetry attributes such as `service.name`, `k8s.pod.name`), the level is
detected, JSON messages are lifted into fields, redaction and the line-rate limit apply.

For Filebeat and Logstash, turn off index templates and lifecycle management (the snippet
does): Pulsimo answers like Elasticsearch 8 but stores lines its own way. Filebeat has a
single output, so either point it at Pulsimo or run a second Filebeat.

### Exporter versions

- **node_exporter** 1.6 or newer. Run it with the host's network and root file system so it
  sees the machine and not its own container (`--net=host --pid=host -v /:/host:ro` and
  `--path.rootfs=/host`).
- **cAdvisor** from `ghcr.io/google/cadvisor`, recent. Version 0.52 and older cannot read
  containers on Docker 29 with the containerd image store ("failed to identify the
  read-write layer ID"): containers are missing or have no name.

## The page

The cards on top:

| Card | Meaning | Click |
|---|---|---|
| **Hosts** | Hosts reporting / all seen in the last 24 hours | Hosts tab |
| **Containers** | Running / all seen in the last 24 hours | Containers tab |
| **Restarts, 24 h** | Restarts of all containers, and how many containers restarted | Containers that need a look |
| **Out of memory, 24 h** | Containers killed by the kernel for going over their memory limit | Containers that need a look |
| **Open alarms** | Host and container alarms firing now | Alerting |
| **Sources** | Scraped exporters and Prometheus connections | Connect tab |

A host is **Up** when its metrics are less than 2 minutes old. A container is **Running**
when cAdvisor saw it in the last 2 minutes; **Stopped** containers stay listed for a day.

### Hosts

Each host with CPU, memory and its fullest disk as bars (amber from 80%, red from 90%),
load (amber when above the number of cores), network, its containers (running / all), how
long it has been up, and its open alarms. Down hosts and hosts with alarms come first.
Click a host to open it.

### Containers

Each container with its image and Compose project, its host, CPU (with the limit when it
has one), memory against its limit, network, restarts and out-of-memory kills in 24 hours,
uptime and alarms. Filter by text, host, Compose project and **All / Running / Stopped /
Needs a look** (stopped, restarted, killed, alarm, or memory at 90% of its limit or more).

Stopped containers that never ran 10 minutes and were never restarted (one-off
`docker run --rm` commands, CI jobs) are left out, and the *Container stopped* alarm skips
them too. A service that crashes right after a redeploy still counts, because an earlier
container with its name ran longer, and so does one that crash-looped until it gave up.

A **restart** is the same container starting again (a crash, `docker restart`, a restart
policy). Recreating a container, as `docker compose up` does after a change, is a new
container and is not counted as a restart.

## A host

**Infrastructure → a host.** Pick 1 hour, 6 hours, 24 hours or 7 days.

- Cards: CPU, memory, fullest disk, load (and its share of the cores), network, uptime.
- **CPU** split into user, system and *waiting for disk*.
- **Memory** used, and cache and buffers, against the total.
- **Load** over 1, 5 and 15 minutes, with a line at the number of cores.
- **Network** received and sent (virtual interfaces of Docker and Kubernetes left out).
- **Disk activity**: bytes read and written.
- **Disks**: every file system, fullest first (tmpfs, overlay and similar left out).
- **Open alarms** of the host.
- **Containers on it**, with the same table and filters as the Containers tab.
- **Container events**: restarts, out-of-memory kills and new images.
- **Logs** of its containers, with **Warnings and errors** to narrow them.

## A container

**Infrastructure → a container.** The charts and the logs sit side by side, so a spike and
the lines written at that moment are in view together.

- Cards: CPU (cores, and the share of its limit), memory (and the share of its limit),
  restarts and out-of-memory kills in 24 hours, network, uptime.
- **CPU** and **Memory** with a red line at the limit, and **Network**.
- Dashed markers on every chart: amber for a restart, red for an out-of-memory kill,
  violet for a new image.
- **Logs** of the container (up to the last 24 hours), with **Warnings and errors** and a
  link to the Log Browser.
- **Open alarms** and **Events**.
- **Details**: host, Compose project and service, limits, the cAdvisor that reports it.
  A container without a memory limit gets a note: it can use all of the host's memory and
  the near-the-limit alarm cannot watch it.

## Built-in alarms

Every organization has these rules, on by default. They appear under **Alerting → Rules →
Built in**, where you can change their thresholds, severity, how long the problem must last,
or turn them off. They cannot be created a second time as custom rules.

| Rule | Fires when | Default | Closes by itself |
|---|---|---|---|
| **Host unreachable** | No metrics from a host | 120 s, critical | when its metrics arrive again |
| **Disk filling up** | A file system is nearly full | 90% for 5 min, critical at 95% | when it drops below |
| **Host memory pressure** | Memory used (not counting cache) | 90% for 10 min, critical at 97% | when it drops below |
| **Host CPU saturated** | CPU busy | 90% for 15 min | when it drops below |
| **Container restarting** | Restarts in a short while (crash loop) | 2 in 15 min, critical at 5 | when it stops restarting for the window |
| **Container out of memory** | The kernel killed it for its memory limit | any kill in 15 min, critical | when no kill happened in the window |
| **Container near memory limit** | Memory used against its limit | 90% for 5 min, critical at 98% | when it drops below |
| **Container stopped** | A container that once ran 10 minutes or more, or was restarted, in the last day stopped | 120 s | when it runs again |
| **Errors in container logs** | Error lines from one container | 20 in 5 min, critical at 100 | when the burst stops |

Alarms carry the source **Infrastructure** in Alerting and are routed, acknowledged and
muted like every other alarm ([Alarms and rules](../alarms.md)). A host or container that is removed for good
keeps its *unreachable* or *gone* alarm until it has not been seen for 24 hours; resolve it
by hand if you removed it on purpose.

## What else uses this data

- **Probable causes** of an incident: an out-of-memory kill, a restart or a new image of a
  container linked to the endpoint shortly before it failed is listed first.
- **Changes**: container restarts, out-of-memory kills and new images are recorded as
  changes, shown on the charts of linked endpoints.
- **Digest**: containers using far more CPU (3× and at least a quarter of a core) or memory
  (2× and at least 256 MB) than at the same time yesterday or last week.

## Kubernetes

Clusters, workloads and pods have their own tab and pages: see [Kubernetes](kubernetes.md).

---

← [Incidents from logs](../logs/incidents-from-logs.md) · [Contents](../../README.md) · [Kubernetes](kubernetes.md) →
