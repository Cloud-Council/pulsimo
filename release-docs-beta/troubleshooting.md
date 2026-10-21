# Troubleshooting

> Fixes for sign-in, checks, email, logs and metrics problems.

Start with **Observability → System Health**: it probes every Pulsimo component and shows
which one is down or slow. Then read that service's logs:

```bash
docker compose ps
docker compose logs --tail 100 <service>
```

With the published images, add `-f docker-compose.prod.yml` to every command on this page.

## Installing and signing in

| Symptom | Fix |
|---|---|
| The page loads, but sign-in fails or spins | The web app calls the API at `http://HOST_IP:8080`. Set `HOST_IP` in `.env` to the address people use (not `localhost`) and run `docker compose up -d frontend`. Behind a domain, set `NEXT_PUBLIC_API_URL` and `NEXT_PUBLIC_WS_URL` instead |
| Port 3000 or 8080 already in use | Change `EXPOSE_FRONTEND_PORT` or `EXPOSE_API_PORT` in `.env`, then `docker compose up -d` |
| Can't reach the server from another machine | Open ports 3000 and 8080 in the firewall (`sudo ufw allow 3000/tcp`, `sudo ufw allow 8080/tcp`) or put a reverse proxy in front |
| *Account is locked* | Too many wrong passwords. Wait for the lock to end, or have an administrator use **Unlock** on the Users page |
| Everyone was signed out | `JWT_SECRET` changed, or an administrator used *Sign everyone out*. Sign in again; API keys keep working |
| Every service fails to connect to the database after changing `POSTGRES_PASSWORD` | PostgreSQL reads the password only when its volume is created. Change it in the database first (`ALTER USER monitoring PASSWORD '…'`), then in `.env`, then `docker compose up -d` |
| A setting in `.env` has no effect | `docker compose restart` keeps the old environment. Use `docker compose up -d <service>`, which recreates it |

## Checks

| Symptom | Fix |
|---|---|
| An endpoint is down but opens fine in your browser | Pulsimo checks from the server it runs on. Test from there with `curl -v <url>` on the server. Firewalls, internal DNS and VPNs are the usual cause |
| *Expected status code 200, got 401* | The route needs authentication. Add it on the endpoint, or set the expected status to `401` if it should stay protected |
| *Response time … exceeds expected …* | The endpoint answered, but slower than its *expected response time*, which counts as a failure. Raise it, or use the alert policy's slow-response warning instead, which keeps the endpoint up |
| *Request timed out* | Raise the timeout (up to 60 s) or look at the target |
| Checks run late with many endpoints | **Monitoring pipeline** shows the check lag. Raise `MAX_CONCURRENT_CHECKS` and `docker compose up -d checker` |
| A monitor *from metrics* is down while the app is fine | Its metric source can't be scraped, often because the server got a new address. Edit the source's URL; Pulsimo offers to move the monitors with it |

## Alerts

| Delivery log shows | Fix |
|---|---|
| Nothing at all | There is no active channel, or none takes this severity, project or category. A banner warns when there are no channels |
| `HTTP 404 (the webhook no longer exists…)` | The webhook was deleted in Slack, Discord or Teams. Create a new one and edit the channel |
| `HTTP 401/403` | Wrong URL, or a header such as `Authorization` is wrong |
| `HTTP 429 (rate limited…)` | The platform is throttling. A longer repeat interval sends fewer reminders |
| `Email is not set up: set SMTP_HOST…` | Add the SMTP settings to `.env` and run `docker compose up -d notification` |
| *Application-specific password required* | Gmail and Microsoft 365 need an App Password, not the account password |
| `SMTP server refused the email` | Wrong username or password, or the server doesn't allow `FROM_EMAIL` as the sender |

Alerts that seem missing may be **held** on purpose: during a maintenance window, for 3
minutes after a detected deploy, or while a service the endpoint depends on is down. The
alarm's timeline on **Alerting** says why.

## Logs

| Symptom | Fix |
|---|---|
| `401` in Fluent Bit's output | Wrong or rotated token, or the log source is paused |
| `429` in Fluent Bit's output | Over the source's lines-per-second limit. Raise it on the source; Fluent Bit retries |
| Generated configs point at the wrong address | Set `LOG_INGEST_PUBLIC_URL` to the address your servers reach Pulsimo at |
| Long stack traces are cut | Raise `LOG_INGEST_MAX_LINE_BYTES` (default 16384) |
| No lines from one container | It uses a log driver other than `json-file`, or its Compose project isn't in the filter |

The full walkthrough, with its own checks, is [Logs end to end](features/logs/walkthrough.md).

## Metrics

| Symptom | Fix |
|---|---|
| Can't save a source | A successful **Test connection** is required. Check the URL from the Pulsimo server, the auth, and **Skip TLS verification** for self-signed HTTPS |
| **Stale** on a source | No scrape for more than three intervals: the metrics-collector is stopped or overloaded |
| *Invalid value for MAX_SCRAPE_BODY_MB* and the collector stops | A scraping setting in `.env` isn't a number. Fix it and `docker compose up -d metrics-collector` |
| Large exporter refused | Raise `MAX_SCRAPE_BODY_MB` (default 20), e.g. for kube-state-metrics on big clusters |
| Queries are slow, **Series** is amber | A label with many values (user id, raw path) created thousands of series. The Series popover shows which; use route templates or a lower sample limit |
| Saved source passwords stopped working | `METRICS_SECRET_KEY` changed. Re-enter the credentials on each source that uses them |

## Database and disk

**Observability → Database Health** shows the database size, the retention in use and
when each maintenance job last ran. When the database grows past `DB_SIZE_WARN_MB`,
Pulsimo keeps fewer days of check results automatically. See
[System and database health](features/observability/system-health.md) and the retention values in
[Configuration](configuration/environment-variables.md#10-data-retention-and-maintenance).

## Still stuck?

[Report the problem](https://docs.google.com/forms/d/e/1FAIpQLSc3ZuyIwqytCaw7NNatE79mkhB6DzbwMYq29fEIRC17bfO8vA/viewform)
with the output of `docker compose ps` and the relevant `docker compose logs`. Remove
secrets from anything you share.

---

← [Best practices](best-practices.md) · [Contents](README.md) · [FAQ](faq.md) →
