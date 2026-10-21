# Connected monitoring

> One service, one place: endpoint checks, its metrics and its dashboards together.

## What it is

One service, one place. An endpoint check answers "can users reach it right now?"
(outside-in). Its metrics answer "what is happening inside?" (inside-out). Pulsimo links
the two, and the dashboards that describe them, so "it's slow" becomes "it's slow because
p95 on `/checkout` jumped and the database pool is full", on one screen.

## Where to find it

- **Services → Endpoints → click a card → Metrics & dashboards** tab.
- **Endpoint cards** (Compact or Detailed, switch above the grid).
- **Metrics → Sources → Connect** for each source.
- **Dashboards**: "Monitors:" chips under the title.

## Linking an endpoint to its metrics

Pulsimo **suggests** links; you confirm with one click.

| Suggestion | Example |
|---|---|
| Same route | endpoint `/api/v1/orders` ↔ `route="/api/v1/orders"` (also `path`, `handler`, `uri`…) |
| Same host | endpoint `http://10.0.1.5:8080/...` ↔ a source on `10.0.1.5:8080` |
| Same database | a PostgreSQL check ↔ the postgres_exporter for that server |
| Same project | the source and the endpoint are in the same project |

You can also **link a metric source manually** with your own label filters. One endpoint
can link to several sources: the app, its database, the host it runs on.

What a link gives you depends on what the source exposes (its **profile**):

| Profile | Charts and numbers |
|---|---|
| HTTP app | requests/s, 5xx share, p95 latency (for the linked route) |
| Process | CPU, memory |
| Host (node_exporter) | CPU, memory |
| PostgreSQL / MySQL | up, connections |
| Containers (cAdvisor) | CPU, memory |

## The Metrics & dashboards tab

From top to bottom:

1. **How it's monitored**: Active check, From metrics, or Both ([Monitoring from metrics](../metric-monitors.md)).
2. **Reliability target**: set or view the endpoint's SLO ([SLOs](../reliability/slos.md)).
3. **Suggested links**, one click each.
4. **Charts per linked source** for 1h, 6h, 24h or 7d, with **Explore** on each chart.
   Dashed vertical lines mark deploys and restarts of those sources ([Change markers](../reliability/change-markers.md)).
5. **Dashboards**: attach an existing one (variables such as route and source are preset
   when you open it from here) or **Create dashboard for <source>**.

## Endpoint cards

Linked cards show live numbers from the metrics (`4.2 req/s · 0.3% 5xx · p95 38 ms`). A
value over its threshold turns amber or red, **even while the check itself is Up**, which
is exactly the early warning you want.

## From a source to monitors

**Metrics → Sources → Connect**:

- **Monitor API routes** (app sources): the routes found in the request metrics, with
  req/s and methods. Templated routes such as `/users/{id}` ask for a real value for an
  active check. Creates the checks already linked.
- **Monitor this database** (PostgreSQL/MySQL sources): opens the add-endpoint form
  pre-filled and links the new check to the exporter.
- **Create dashboard**.

The **Discovered** inbox ([Discovered services](discovery.md)) does the same in the background, for every source.

## In alerts and incidents

- "Service down" and escalation alerts include **What the metrics show**, read at send
  time ("p95 latency 2.1 s (was 40 ms 30 min ago)", "orders-db: 100% connections used").
- Incidents show the linked metrics around the start, saved with the incident ([Incidents and evidence](../incidents.md)).

---

← [Dashboards](../dashboard.md) · [Contents](../../README.md) · [Discovered services](discovery.md) →
