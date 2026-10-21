# Settings and API keys

> Organization, sign-in security, API keys, integrations and configuration backup.

## Where to find it

Sidebar → **Settings**. The sections are on the left (along the top on small screens):

| Section | Who sees it | Link |
|---|---|---|
| Organization | Everyone; only administrators change it | `/dashboard/settings` |
| Security | Administrators | `?tab=security` |
| API keys | Administrators | `?tab=apikeys` |
| Integrations | Everyone | `?tab=integrations` |
| Backup & tools | Administrators | `?tab=advanced` |

## Organization

You can set:

- the name;
- the contact email;
- the **time zone**, picked from the full list (used for digests and reports);
- the **date format**, with a live example.

The organization's identifier and creation date are shown below. **Save** and **Discard**
appear once something has changed.

## Security

Only settings that Pulsimo actually enforces are on this page. Changes collect in a bar
at the bottom (**Save** / **Discard**) and apply to the next sign-in and the next
password change.

### Sessions

| Setting | Effect |
|---|---|
| **Sign out after inactivity** | 15 min, 30 min, 1 h, 4 h, 8 h, 24 h or any value from 5 to 1440 minutes. With no clicks, typing or scrolling in any Pulsimo tab for that long, the browser signs out. A *Still there?* bar appears in the last minute with **Stay signed in**. While someone is active, they stay signed in, and their session renews itself in the background |
| **Sign everyone out** | Ends every session in the organization except yours, on every device, e.g. after a lost laptop or a leaked password. API keys keep working; revoke those separately |

After an inactivity sign-out, the sign-in page says why.

### Sign-in protection

| Setting | Effect |
|---|---|
| **Lock the account after** | 1–10 wrong passwords in a row lock the account |
| **Keep it locked for** | 5–120 minutes. An administrator can unlock it earlier from **Users** ([Users and access](users.md)) |

### Passwords

| Setting | Effect |
|---|---|
| **Minimum length** | 8–128 characters |
| **Require a mix of characters** | When on, choose which are required: uppercase, lowercase, number, special character. Turn it off to allow long passphrases |
| **Don't reuse the last** | Off, 3, 5 or 10 previous passwords |
| **Passwords expire** | Never, 90, 180 or 365 days. Expired passwords are flagged on the Users page |

The same rules are checked whenever a password is set (adding a user, a reset, or someone
changing their own). The forms show them as a checklist while you type.

Two-factor sign-in and single sign-on (SSO) are not available yet.

## API keys

API keys let scripts, CI pipelines and other tools use the Pulsimo API.

**New key** asks for three things:

| Field | Options |
|---|---|
| Name | e.g. "GitHub Actions deploy". Use one key per tool so you can revoke it on its own |
| Access | **Read-only** (default): read endpoints, incidents, metrics, logs. **Read and write**: as a member. **Administrator**: everything |
| Expires | Never, 30 days, 90 days or 1 year |

The key (`ptk_…`) is shown **once**, with a `curl` example to try it. Pulsimo stores only
a hash of it.

**Using a key:**

```bash
curl -H "Authorization: Bearer ptk_…" https://pulsimo.example.com/api/v1/endpoints
curl -H "X-API-Key: ptk_…" https://pulsimo.example.com/api/v1/incidents
```

**What a key can do:**

- It acts as the administrator who created it, so events in the Event Trail show that
  person.
- Its access is the lower of what you chose and that person's current role.
- It stops working when you revoke it, when it expires, or when its creator is deactivated
  or deleted. The list then shows *Expired* or *Owner gone*.

The list shows each key's name and the start of the key, its access, who created it, when
it was last used, and when it expires. The bin icon revokes a key; anything using it stops
working at once.

## Integrations

This section shows what Pulsimo is actually connected to, from live data. Each tile opens
the page where that connection is managed.

| Tile | Shows | Opens |
|---|---|---|
| Alert channels | Active channels and their platforms, or how many are failing; a warning when none exist | Alerts |
| Metrics (Prometheus format) | How many metric sources answer | Metrics → Sources |
| Logs (Fluent Bit) | Number of log sources | Logs → Sources |
| Grafana dashboards | Import a Grafana dashboard JSON | Dashboards |
| API keys | Number of keys | API keys |

Below the tiles, **REST API** shows the API address and a `curl` example you can copy.

## Backup & tools

- **Configuration backup and restore** exports your configuration (projects, endpoints,
  alert settings and the rest) to a file, and imports it again.
- **Developer tools** opens the debug console, the API request log and the performance
  profiler.

## API

| Method and path | Does |
|---|---|
| `GET/PUT /api/v1/security/settings` | Read or change the security settings (administrators). `password_expiration_days: 0` means never |
| `POST /api/v1/security/sign-out-all` | Sign everyone else out |
| `GET /api/v1/users/password-policy` | The password rules and the inactivity timeout, for any signed-in user |
| `GET/POST /api/v1/api-keys`, `DELETE /api/v1/api-keys/:id` | List, create (`name`, `role`, `expires_in_days`), revoke |

---

← [Users and access](users.md) · [Contents](../README.md) · [API metrics and Event trail](observability/api-metrics.md) →
