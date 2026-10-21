# SLOs

> Error budgets, burn-rate alerts and real-user Apdex.

## What it is

An SLO (service level objective) is a promise such as "99.9% of requests to Checkout
succeed over 30 days". The 0.1% that may fail is the **error budget**. Pulsimo tracks how
much of it is left, how fast it is being used (**burn rate**), and alerts before it runs
out. It also scores the experience of real users with **Apdex**.

## Where to find it

Endpoint → **Metrics & dashboards** → **Reliability target**. The System Overview shows
the targets at risk.

## How to use it

1. **Set a reliability target**. Choose:
   - **Target**: 99%, 99.5%, 99.9%, 99.95% or 99.99%. The form tells you what it means,
     e.g. 99.9% over 30 days ≈ 43 minutes of full outage.
   - **Window**: 7, 30 or 90 days.
   - **Apdex T** (optional): the response time users are happy with. Defaults to the
     endpoint's expected response time, else 500 ms.
   - **Alert when the error budget burns too fast** (on by default).
2. **Save target**. The first numbers appear within seconds and refresh every 5 minutes.

## Reading the card

| Item | Meaning |
|---|---|
| **Achieved** | Good share over the window, e.g. 99.962%. Red when below the target |
| **Error budget left** | 100% = untouched; "none (used up)" once the target is missed. Bar turns amber under 50% and red under 20% |
| **Bad of total** | e.g. 1,204 bad of 3,100,550 requests |
| **Burn rate 1h / 6h** | How fast the budget is used compared with "exactly on budget". 1× uses it all by the end of the window; 14.4× over an hour uses 2% of a month's budget in that hour |
| **Apdex (24h)** | 0 to 1: (satisfied + tolerating/2) / all. Satisfied = under T, tolerating = under 4×T. Excellent ≥ 0.94, Good ≥ 0.85, Fair ≥ 0.70, Poor ≥ 0.50 |

## Where "good" comes from

| The endpoint… | Good means | Apdex from |
|---|---|---|
| is linked to an HTTP app with a request counter and a status label | a request that isn't 5xx (real users) | the app's latency histogram (real users) |
| isn't | a passed check | the checks' response times |

Real-user numbers are better: they count every request, not one probe a minute.

## Burn-rate alerts

Pulsimo uses the multi-window rule from Google's SRE workbook, which catches real burns
quickly without alerting on short blips:

| Burn | Condition | What you get |
|---|---|---|
| **Fast** | 1-hour **and** 5-minute burn ≥ 14.4× | An alert right away: "🔥 SLO burn: Checkout is burning its error budget 42x faster than allowed … At this rate a 30-day budget lasts about 17 hours" |
| **Slow** | 6-hour **and** 30-minute burn ≥ 6× | A line in the next digest |

At most one burn alert per endpoint every 6 hours.

## Also improved

The **Apdex** shown in Performance analytics now uses each endpoint's own threshold (its
SLO's Apdex T, else its expected response time) instead of a fixed 100 ms.

## Limits

- A window longer than the metrics retention can't be fully counted from real requests;
  it uses what is kept.
- Check-based SLOs depend on how often the endpoint is checked.

---

← [Probable cause](../probable-cause.md) · [Contents](../../README.md) · [Change markers](change-markers.md) →
