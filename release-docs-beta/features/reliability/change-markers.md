# Change markers

> Deploys, restarts and new routes drawn on every chart.

## What it is

"It was the deploy" is the most common root cause. Pulsimo detects changes from the
metrics themselves, with nothing to install or configure, and shows them wherever you look
at a chart.

## What is detected

| Change | Detected from | Line colour |
|---|---|---|
| **Deploy** (version change) | the labels of `*_build_info`, `go_info` or `version_info` changing (`version`, `revision`, `commit`, `goversion`…) | purple |
| **Restart** | `process_start_time_seconds` moving forward (also "started" when a source is first seen less than 2 minutes after its process started) | amber |
| **New routes** | routes a source never reported before ([Discovered services](../metrics/discovery.md)) | teal |
| **New error** | an error pattern never seen before in your logs ([Logs](../logs/README.md)) | red |

Checks run every minute. Most client libraries expose `process_start_time_seconds`, and
many apps expose a `*_build_info` metric with their version: add one to yours to get
deploy markers, e.g. `myapp_build_info{version="1.4.2",revision="a1b2c3"} 1`.

## Where you see them

- **Dashboards**: the **Changes** button (on by default) draws dashed vertical lines on
  every time series; the button shows how many are in the range. Hover a line for
  "Deploy 14:02: orders-api version changed". Turn it off with the button (`?changes=0` in
  the URL).
- **Endpoint → Metrics & dashboards**: lines on the charts for changes of the sources
  linked to that endpoint.
- **Incidents**: "**Deploy** 4 min before the incident started: orders-api version
  changed", plus lines on the incident charts ([Incidents and evidence](../incidents.md)).
- **Post-mortems**: a "Changes around the incident" section.
- **Metrics → Sources**: the latest change per source ("Restart 2 h ago").
- **System Overview**: deploys and restarts in the last 24 hours.

## Alerts during deploys

A restart makes a service fail briefly by design. When an endpoint goes down within 3
minutes of a deploy or restart of a linked source, Pulsimo **holds the alert** until the
3 minutes are over, then sends it only if the endpoint is still down, saying "This started
right after a change: orders-api version changed (deploy) at 14:02 UTC". If it recovered meanwhile, neither the down nor the
recovery message is sent ([Routing, digests and deploy grace](../alert-routing.md)).

## API

`GET /api/v1/changes?from=<unix>&to=<unix>[&source_id=…][&endpoint_id=…]`

---

← [SLOs](slos.md) · [Contents](../../README.md) · [Capacity and anomalies](capacity-and-anomalies.md) →
