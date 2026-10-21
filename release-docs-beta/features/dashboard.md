# Dashboards

> Grafana-style dashboards with an editor, variables and Grafana JSON import.

## What it is

Grafana-style dashboards built on the metrics Pulsimo collects: a grid of panels that
share a time range and variables. Existing Grafana dashboards can be imported.

## Where to find it

**Dashboards** in the sidebar. Endpoints and sources also link to their dashboards
([Connected monitoring](metrics/connected-monitoring.md)).

## Panels

| Panel | Use it for |
|---|---|
| Time series | Anything over time: lines, areas, bars, points, stacked or percent-stacked, thresholds as lines or bands, legends as a list or a table with min/mean/max |
| Stat | One number with a sparkline, coloured by thresholds (e.g. "Application status") |
| Gauge, bar gauge | A value against a range (CPU, disk, pool usage) |
| Bar chart, pie/donut | Comparisons across routes, status codes, hosts |
| Table | Many series side by side |
| Text | Notes in Markdown |

## Working with a dashboard

- **Time**: quick ranges up to the retention period, an absolute range, ← → to shift,
  zoom out, and **drag across any time series to zoom in**. Auto-refresh pauses while
  the browser tab is hidden.
- **Variables** at the top (e.g. route, instance) filter every panel. They support
  `label_values(...)`, `metrics(...)`, `query_result(...)`, custom lists, constants,
  intervals and text boxes, multi-select and "All". Selections are kept in the URL.
- **Changes** button: shows deploys, restarts and new routes as dashed vertical lines on
  every time series (on by default; [Change markers](reliability/change-markers.md)). Hover a line to see what changed.
- **Monitors:** chips under the title link to the endpoints this dashboard describes.
- **⋯ menu**: TV mode (full screen), JSON model, export JSON, version history, delete.
- **Star** a dashboard to pin it to the top of the list.

## Editing

**Edit** turns on edit mode: drag panels by the title, resize from the corner, add
panels and collapsible rows. **Save** creates a new version (the last 50 are kept and can
be restored). If someone else saved after you opened the dashboard, you choose to reload
theirs or overwrite.

### The panel editor

- A **live preview** on top with the dashboard's time and variables.
- **Queries** below (A, B, C…), each in **Code** (the official PromQL editor with
  autocomplete for functions, metrics with their descriptions, labels, values and
  variables) or **Builder** (pick a metric, add label filters, chain operations such as
  rate, sum by, topk, histogram_quantile). Both stay in sync.
- **Metrics browser**: search metrics and descriptions, click label values to narrow
  down, see how many series match, then insert the selector or a ready rate()/p95 query.
- **Hints** point out common mistakes with a one-click fix: a counter without rate(),
  histogram buckets without histogram_quantile(), rate() on a gauge.
- **Query inspector**: the final queries after variables, timings, data and raw response.
- **Options** on the right: visualization, legend, unit, min/max/decimals, colours,
  thresholds, value mappings, per-series overrides.

**Apply** (Ctrl+S) puts the panel back; **Save** keeps the dashboard.

### `$__rate_interval`

Use `rate(x[$__rate_interval])` rather than a fixed window. Pulsimo sizes it from the
dashboard step **and your sources' real scrape intervals** (at least 4 scrapes), so a
source pulled every 60 s doesn't show gaps or zeros. `$__interval` and `$__range` work as
in Grafana.

## Importing from Grafana

**Dashboards → Import**, then paste the JSON or upload the file (Grafana: Dashboard
settings → JSON Model, or Share → Export; community dashboards from grafana.com work too).
Before anything is saved you get a report:

- which panels mapped and to what (`graph` → time series, `singlestat` → stat or gauge…);
- which became **placeholders** (types Pulsimo can't draw yet keep their place, size and
  queries, so nothing is lost);
- which variables were imported or skipped (data-source variables aren't needed);
- notes, such as queries for non-Prometheus data sources.

Tested with Node Exporter Full (1860), cAdvisor exporter (14282) and PostgreSQL Database
(9628). For Node Exporter Full, `job` is the source type (`node`) and `instance` is
host:port, so it works without edits.

## Ready-made dashboards

**Metrics → Sources → Connect → Create dashboard** builds one from what a source exposes
(HTTP app, host, PostgreSQL, MySQL, containers) and attaches it to the endpoints linked to
that source.

## Performance

Panels query only when scrolled into view, one batched request per panel; the step follows
the panel width; lines are downsampled keeping their shape; at most 50 series per time
series panel ("50 of N").

---

← [Metrics Explorer](metrics/explorer.md) · [Contents](../README.md) · [Connected monitoring](metrics/connected-monitoring.md) →
