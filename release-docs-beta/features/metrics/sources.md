# Metric sources

> Tell Pulsimo where /metrics lives and it pulls on a schedule.

## What it is

A metric source is any HTTP URL that serves metrics in the Prometheus text format:
node_exporter, cAdvisor, postgres_exporter, mysqld_exporter, your application's
`/metrics`, or any other exporter. Pulsimo does not install exporters; you tell it
where the metrics are, and it pulls them on a schedule.

## Where to find it

**Metrics → Sources**.

## How to use it

1. **Add source**. Enter a name, the full URL (for example
   `http://10.0.1.12:9100/metrics`), how often to pull (5 s to 1 h, default 15 s), and
   optional authentication.
2. **Test connection**. Pulsimo makes one real scrape and shows how many samples it
   got and the first metric names. A source can be saved only after a successful test.
3. **Save**. Collection starts straight away.

Per source you can also set a project, static labels added to every sample, a sample
limit (default 50,000 per scrape), and **Skip TLS verification** for self-signed HTTPS.

| Auth | What Pulsimo sends |
|---|---|
| None | Nothing |
| Basic | `Authorization: Basic …` |
| Bearer | `Authorization: Bearer <token>` |

Credentials are encrypted in PostgreSQL with `METRICS_SECRET_KEY` and never returned by
the API.

## The Sources table

| Column | Meaning |
|---|---|
| **Status** | Up or Down from the last scrape, with the error when it failed ("failing for 6 scrapes") |
| **Last scrape** | When it was last pulled. **Stale** (amber) means no scrape for more than 3 intervals: usually the collector is stopped or overloaded. A purple line such as **Deploy 12 min ago** or **Restart 2 h ago** shows the latest change detected in its metrics ([Change markers](../reliability/change-markers.md)) |
| **Samples** | Samples in the last scrape, and how many distinct metrics |
| **Series** | Active series this source has in the store. Amber with a ⚠ above 10,000. Click it to see which metrics and labels produce the most series |
| **Duration** | How long the last scrape took |
| **Every** | The scrape interval |

Buttons per source: **Explore** (opens its metrics in the Explorer), **Connect** (monitor
its API routes or database, create a dashboard; [Connected monitoring](connected-monitoring.md)), **Edit**, **Pause/Resume**,
**Remove**.

### Editing a source

**Edit** opens the same form with the source's values: name, type, interval, URL, project,
authentication and TLS. When the last scrape failed, its error is shown on top.

- Changing the **URL**, the **credentials** or the **TLS** setting needs a successful
  **Test connection** before **Save changes**. The test uses the saved credentials unless
  you type new ones.
- Other changes (name, interval, project) save without a test.
- Monitors and dashboards linked to the source keep their links and follow on their next
  check. Collected metrics stay.

### When a server gets a new address

Edit its source's URL to the new address and save. When the **host** changed (for example
`192.168.1.105` → `192.168.1.110`), Pulsimo asks right away: **Move monitors to
192.168.1.110?** It lists every monitor still on the old host, old and new address side by
side:

- monitors **linked to this source**, ticked;
- other monitors on the same old host, not ticked.

**Move N monitors** changes only the host of each address; scheme, port, path and
credentials stay. **Not now** leaves them as they are. Each move is recorded in the Event
trail.

How each monitor mode reacts while the two addresses differ:

| Mode ([Connected monitoring](connected-monitoring.md)) | Monitor still on the old address, source on the new one |
|---|---|
| **Active check** | Down: Pulsimo calls the old address. The source plays no part |
| **Both** (hybrid) | Down: the call to the old address fails first. The failure says the source works on the new host |
| **From metrics** | Up: only the source's metrics count; the monitor's own address isn't called. Move it anyway so its links and pages show the right address |

And the other way round, monitor moved but source not (yet): **Both** and **From metrics**
are down because the source can't be scraped; **Active check** is up.

### When a monitor and its metrics source drift apart

Monitors in **hybrid** or **metrics** mode ([Connected monitoring](connected-monitoring.md)) are marked down when their metrics
source can't be scraped. Pulsimo points that out in three places:

- **Right after you change a monitor's address**, a message names each linked source that
  still scrapes the old host, with **Edit the source**.
- **The monitor's Metrics & dashboards tab** shows a warning on a linked source that can't
  be scraped and points at another host than the monitor, with **Edit the source**.
- **A monitor that is down while its source works on another host** shows **Move to
  <new host>** on its Metrics & dashboards tab, and its failure says so: the monitor's own
  address is the outdated one.
- **The failure itself** names the source and its URL, the scrape error, and the two hosts,
  for example *Metrics source "Golang" (http://192.168.10.93:8081/metrics) is not
  reachable: Timed out… It points at 192.168.10.93 while this monitor checks
  192.168.1.105*.

**Edit the source** opens Metrics → Sources with that source's editor already open.

Above the table, **Capacity forecast** lists disks, memory and database connections that
are growing toward their limit ([Capacity and anomalies](../reliability/capacity-and-anomalies.md)).

### Too many series?

A label with many values (a user id, a full URL with query string, a timestamp) turns one
metric into thousands of series. That slows every query for the whole organization. The
**Series** popover shows the culprits, e.g. `http_requests_total` 48,000 series and label
`path` 12,000 values. Fix it in the app (use a route template such as `/users/{id}`
instead of the raw path), or lower the source's sample limit so a bad deploy can't flood
the store.

## How it works

- The `metrics-collector` service pulls each active source on its own interval and
  writes the samples to VictoriaMetrics, adding these labels to every sample:
  `org_id`, `source_id`, `source` (the source name), `job` (the source type),
  `instance` (host:port), and `project_id` / `endpoint_id` when set.
- Each scrape also writes `up`, `scrape_duration_seconds` and `scrape_samples_scraped`,
  the names Prometheus uses, so `up == 0` works as you expect.
- Metric types and descriptions (`# TYPE`, `# HELP`) are stored for the editor's
  autocomplete.
- New or changed sources are picked up within a second (the gateway announces changes
  on Redis); all sources are also reloaded every 30 s.
- **During an incident** on an endpoint linked to a source, that source is pulled every
  5 s for 30 minutes so the evidence is sharp ([Incidents and evidence](../incidents.md)). It returns to its own interval
  afterwards.

## Retention

Metrics are kept for `METRICS_RETENTION` days (default 30, maximum 90), set once for the
whole installation. Change it in `.env` and run `docker compose up -d victoriametrics`.
Raising it keeps existing data; lowering it deletes older data.

## Limits

- Pull only: Pulsimo must be able to reach the URL. Push (remote write) is not supported.
- One retention period for everything.
- A scrape larger than `MAX_SCRAPE_BODY_MB` (default 20 MB) or above the source's sample
  limit is rejected and the source shows Down with the reason.

---

← [Dependencies](../dependencies.md) · [Contents](../../README.md) · [Metrics Explorer](explorer.md) →
