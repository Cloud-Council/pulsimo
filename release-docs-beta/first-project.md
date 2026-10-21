# Your first project

> Group endpoints into a project, set a reliability target and see it on the status board.

A **project** groups the endpoints of one product or team, for example *Checkout* with its
website, API, database and cache. Projects give you a reliability target with an error
budget, a section on the status board, analytics over time, and a way to send each team
only its own alerts.

## 1. Create the project

1. Open **Projects** and click **New project**.
2. Give it a name, a colour and a priority.
3. Save. It starts with no endpoints and shows *No endpoints*.

## 2. Add its endpoints

- Click the project card, then **add an endpoint** from its panel, or
- pick the project when you add or edit an endpoint on **Services → Endpoints**.

Endpoints that belong to no project are listed under **Orphan Endpoints** on the Projects
page, where you can move them in.

A good first project has the public entry point (the website or API), the services it
calls, and the database and cache behind them. With their metrics linked (see
[Connected monitoring](features/metrics/connected-monitoring.md)), Pulsimo can also map the
[dependencies](features/dependencies.md) between them, so an outage of the database
is one alarm about the database, not one per service.

## 3. Set the reliability target

Every project has an uptime target, **99.5%** unless you change it. The target sets the
**error budget**: at 99.5%, half a percent of checks may fail. The project card shows how
much of that budget is used; above 100%, the project is below its target.

To change it, open **Project Analytics**, click the project, and use **Change target**
(99%, 99.5%, 99.9%, 99.95% or any value from 50 to 99.999). Members and administrators
can change it.

| Target | Failed checks allowed | About this much downtime in 30 days |
|---|---|---|
| 99% | 1 in 100 | 7 h 12 min |
| 99.5% | 1 in 200 | 3 h 36 min |
| 99.9% | 1 in 1,000 | 43 min |
| 99.95% | 1 in 2,000 | 22 min |

Uptime counts checks, not minutes, and each endpoint counts the same in the project's
average whatever its interval.

## 4. Send its alerts to the right people

On **Alerting → Channels**, edit a channel and pick the project under **Projects**: that
channel then only gets alarms about this project (alarms that belong to no project still
reach every channel). A common setup is one channel per team plus one on-call channel set
to *Critical only*. See [Alarms and rules](features/alarms.md#routing-who-gets-which-alarm).

## 5. Plan maintenance

Before a planned upgrade, use **Alerting → Plan maintenance** and choose the project (or
some of its endpoints). A window can run once or every week, for example Sunday 02:00 for
the weekly backup. Alarms during the window are recorded but held, and sent only if the
problem is still there when the window ends. See
[Alarms and rules](features/alarms.md#maintenance-windows).

## 6. Watch how it does

| Page | Answers |
|---|---|
| **Services → Overview** | What is up or down right now, grouped by project |
| **Projects** | How each project does against its target over 7, 30 or 90 days |
| **Project Analytics** | Uptime per day, incidents by severity, time to acknowledge and resolve, weakest endpoints, with CSV export |

All three are described in [Projects and overview](features/projects.md).

---

← [Quick start](getting-started.md) · [Contents](README.md) · [Architecture](architecture.md) →
