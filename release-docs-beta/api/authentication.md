# Authentication

> Sign in with an API key or a session token, scopes, and error responses.

Everything the web app does goes through the same REST API, so anything you can do on a
page you can also script. The API lives on the API address, `http://<HOST_IP>:8080` by
default, or your domain behind a reverse proxy. Every path starts with `/api/v1`.

## API keys (recommended for scripts)

Create a key on **Settings → API keys → New key** (administrators only). Pick a name, an
access level and an expiry. The key starts with `ptk_` and is shown **once**.

Send it in either header:

```bash
curl -H "Authorization: Bearer ptk_…" https://pulsimo.example.com/api/v1/endpoints
curl -H "X-API-Key: ptk_…" https://pulsimo.example.com/api/v1/incidents
```

| Access | Can |
|---|---|
| Read-only (default) | Read endpoints, incidents, metrics and logs |
| Read and write | What a member can do |
| Administrator | Everything |

A key acts as the administrator who created it, so its actions show that person in the
Event trail. Its access is the lower of the level you chose and that person's current
role. It stops working when it is revoked, when it expires, or when its creator is
deactivated or deleted. Use one key per tool so you can revoke it on its own. More in
[Settings and API keys](../features/settings.md#api-keys).

## Signing in with a password

The web app signs in with email and password and gets two tokens:

```bash
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@example.com","password":"…"}'
```

```json
{
  "access_token": "eyJ…",
  "refresh_token": "eyJ…",
  "user": { "id": "…", "org_id": "…", "email": "admin@example.com", "name": "…", "role": "…" }
}
```

Send the access token as `Authorization: Bearer <access_token>`. When it expires, get a
new one with `POST /api/v1/auth/refresh` and `{ "refresh_token": "…" }`. A refresh works
only while the account is active, and the new token gets the current role. Session
length and the inactivity sign-out come from **Settings → Security**.

Wrong passwords count toward the lock in Settings → Security (5 attempts and 15 minutes
unless you changed them). For scripts, prefer an API key: it isn't affected by password
changes, locks or *Sign everyone out*.

## Creating an organization

`POST /api/v1/auth/register` creates an organization and its first administrator. It is
what the **Register** page calls:

```json
{
  "org_name": "Acme",
  "org_slug": "acme",
  "org_contact_email": "ops@acme.com",
  "admin_name": "Dana",
  "admin_email": "dana@acme.com",
  "admin_password": "at least 8 characters"
}
```

## Organizations and access

Every request is scoped to the organization of the key or the signed-in account. Objects
of another organization answer **404**, as if they did not exist. Access is checked on
every request, so a role change or a deactivation applies at once.

## Errors

Errors come back as JSON with a message that says what to fix.

| Status | Meaning |
|---|---|
| 400 | The request is malformed |
| 401 | No key or token, or it expired or was revoked |
| 403 | Signed in, but your role (or the key's access) doesn't allow it |
| 404 | Not found in your organization |
| 409 | A safety rule or a duplicate, e.g. deleting someone with history |
| 422 | A value fails validation, e.g. the password policy |
| 504 | A Pulsimo service didn't answer in time (e.g. a channel test) |

## Health

`GET /health` (also `/api/v1/health`) needs no authentication and answers when the API
gateway is up. Load balancers and the setup scripts use it.

## Next

- [API reference](README.md): every endpoint, grouped by feature.
- [Webhooks](webhooks.md): what Pulsimo sends to your systems.

---

← [Monitoring pipeline](../features/observability/pipeline-health.md) · [Contents](../README.md) · [API reference](README.md) →
