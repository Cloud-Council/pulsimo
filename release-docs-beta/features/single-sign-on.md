# Single sign-on (SSO)

> Available from api-gateway `rc1beta-v0.1.12`, frontend `rc1beta-v0.2.6`, migrations `rc1beta-v0.1.9`.

## What it is

People sign in to Pulsimo with your company's identity provider (Okta, Microsoft
Entra ID, Google Workspace, Keycloak, Authentik, Auth0, JumpCloud, or any other
OpenID Connect provider) instead of a Pulsimo password.

- **One button** on the login page: "Log in with Okta" (your text).
- **Accounts on first sign-in.** A Pulsimo account is created the first time someone
  signs in (you can turn this off and invite people instead).
- **Roles from groups.** The provider's groups decide who is admin, member or viewer,
  and the role is updated at every sign-in, so removing someone from a group in the
  provider takes effect the next time they sign in.
- **Existing accounts are linked**, by email, the first time the person uses SSO.
- **Enforce mode** turns off password login for everyone except a short list of
  break-glass administrators.
- Off by default. Nothing changes until you set the values below.

## Where to find it

| Where | What |
|---|---|
| Login page | The SSO button (and, in enforce mode, SSO first with "Use a password instead" for break-glass admins) |
| Settings → Security → Single sign-on | Read-only status for admins: provider, callback URL, allowed domains, role mapping, password login, linked and SSO-only users, **Test connection** |
| `.env` next to the release `docker-compose.yml` | Every setting (`SSO_*` on the api-gateway, `SSO_ENABLED` / `SSO_LABEL` on the frontend) |
| Event trail | `auth.sso_login` for every SSO sign-in |
| Users → login attempts | Refused SSO sign-ins, with the reason (`sso: …`) |

## How to set it up

### 1. Register Pulsimo at your provider

Create an **OpenID Connect web application** at the provider and give it this
redirect (callback) URI:

```
<SSO_PUBLIC_API_URL>/api/v1/auth/sso/callback
e.g. http://192.168.1.20:8080/api/v1/auth/sso/callback
     https://pulsimo.example.com/api/v1/auth/sso/callback
```

`SSO_PUBLIC_API_URL` is the address the **browser** uses to reach Pulsimo's API. When it is
empty it is `NEXT_PUBLIC_API_URL`, then `http://HOST_IP:EXPOSE_API_PORT`. The exact URL is
shown in Settings → Security → Single sign-on.

Grant the scopes `openid email profile`, and add a `groups` claim to the ID token if you
want roles from groups. Note the **issuer URL**, the **client ID** and the **client secret**.

### 2. Set the values in `.env`

```bash
# Frontend: show the button
SSO_ENABLED=true
SSO_LABEL=Log in with Okta

# api-gateway: the provider
SSO_OIDC_ISSUER=https://acme.okta.com
SSO_OIDC_CLIENT_ID=0oa1b2c3d4
SSO_OIDC_CLIENT_SECRET=••••••••
SSO_PROVIDER_NAME=Okta
SSO_ALLOWED_DOMAINS=acme.com

# Roles from groups (optional)
SSO_ADMIN_GROUPS=pulsimo-admins
SSO_MEMBER_GROUPS=engineering,sre
SSO_DEFAULT_ROLE=viewer
```

Leave `SSO_LOGIN_URL` empty: the button then uses Pulsimo's own SSO.

### 3. Apply it

```bash
docker compose up -d api-gateway frontend
```

The api-gateway log says `Single sign-on: on (…)`, or the reason it stays off (for example
`SSO_OIDC_ISSUER must use https`). Open Settings → Security → Single sign-on and press
**Test connection**: it reads the provider's metadata and signing keys now and shows the result.

### 4. (Optional) Enforce it

When everyone can sign in with SSO:

```bash
SSO_ENFORCE=true
SSO_BREAK_GLASS_EMAILS=root@acme.com
```

Only the break-glass emails can still use a password (on the login page, under
"Use a password instead"). Keep at least one, so you can still sign in if the provider is down.

## All settings

| Variable | Default | What it does |
|---|---|---|
| `SSO_ENABLED` (frontend) | `false` | Shows the SSO button on the login page |
| `SSO_LABEL` (frontend) | `Log in with SSO` | Text on the button |
| `SSO_LOGIN_URL` (frontend) | empty | Send the button somewhere else. Empty = Pulsimo's own SSO (recommended) |
| `SSO_OIDC_ISSUER` | empty | The provider's issuer URL. SSO is off while it is empty |
| `SSO_OIDC_CLIENT_ID` | empty | The client (application) ID. Required |
| `SSO_OIDC_CLIENT_SECRET` | empty | The client secret. Empty for a public client (PKCE is always used) |
| `SSO_OIDC_SCOPES` | `openid email profile` | Scopes asked for. `openid` is always added |
| `SSO_OIDC_REDIRECT_URI` | `<SSO_PUBLIC_API_URL>/api/v1/auth/sso/callback` | Set only if a proxy rewrites paths |
| `SSO_OIDC_TOKEN_AUTH` | from the provider | `basic` or `post`: how the secret is sent to the token endpoint |
| `SSO_PUBLIC_API_URL` | `NEXT_PUBLIC_API_URL`, then `http://HOST_IP:EXPOSE_API_PORT` | The API address the browser uses |
| `SSO_FRONTEND_URL` | `PULSIMO_PUBLIC_URL`, then `http://HOST_IP:EXPOSE_FRONTEND_PORT` | Where people are sent after signing in |
| `SSO_PROVIDER_NAME` | the issuer's host name | Name used in messages ("Your organization signs in with Okta") |
| `SSO_ALLOWED_DOMAINS` | empty (any) | Comma-separated email domains allowed to sign in |
| `SSO_ORG_SLUG` | empty | Organization new SSO users join. Empty = the organization whose users share the email domain, or the only organization |
| `SSO_ROLE_CLAIM` | `groups` | ID token claim with the groups. A dotted path works, e.g. `realm_access.roles` |
| `SSO_ADMIN_GROUPS` | empty | Groups that make someone an admin |
| `SSO_MEMBER_GROUPS` | empty | Groups that make someone a member |
| `SSO_VIEWER_GROUPS` | empty | Groups that make someone a viewer |
| `SSO_DEFAULT_ROLE` | `viewer` | Role for people in none of the groups |
| `SSO_JIT_PROVISIONING` | `true` | Create an account at first sign-in. `false` = only people who already have an account |
| `SSO_ENFORCE` | `false` | Turn off password login except for the break-glass emails |
| `SSO_BREAK_GLASS_EMAILS` | empty | Accounts that can always use a password; their role is never changed by groups |
| `SSO_REQUIRE_VERIFIED_EMAIL` | `true` | Refuse ID tokens whose `email_verified` is false |
| `SSO_ALLOW_INSECURE_HTTP` | `false` | Allow an `http://` issuer. Only for a local test provider |

All `SSO_OIDC_*` and `SSO_*` gateway values are read when the api-gateway starts; recreate
it after a change. The frontend values apply when the frontend container starts (no rebuild).

## Provider recipes

| Provider | `SSO_OIDC_ISSUER` | Groups |
|---|---|---|
| Okta | `https://<org>.okta.com` (or `…/oauth2/default`) | Add a **groups** claim to the ID token (filter e.g. "Starts with pulsimo-") |
| Microsoft Entra ID | `https://login.microsoftonline.com/<tenant-id>/v2.0` | Entra sends group **object IDs**: put the IDs in `SSO_*_GROUPS`, or define app roles and set `SSO_ROLE_CLAIM=roles` |
| Google Workspace | `https://accounts.google.com` | Google sends no groups: use `SSO_ALLOWED_DOMAINS=yourcompany.com` and `SSO_DEFAULT_ROLE`, then change roles in Pulsimo |
| Keycloak | `https://<host>/realms/<realm>` | A "Group Membership" mapper (claim `groups`, no full path), or realm roles with `SSO_ROLE_CLAIM=realm_access.roles` |
| Authentik | `https://<host>/application/o/<slug>/` | `groups` is in the default `profile` scope |
| Auth0 | `https://<tenant>.auth0.com/` | Add groups or roles with an Action into a namespaced claim, e.g. `SSO_ROLE_CLAIM=https://pulsimo/groups` |

## How it works

1. The button opens `GET /api/v1/auth/sso/start?redirect=/dashboard`. Pulsimo makes a
   state, a nonce and a PKCE (S256) verifier, keeps them in Redis for 10 minutes, and
   redirects to the provider.
2. The provider sends the browser to `/api/v1/auth/sso/callback?code=…&state=…`. Pulsimo
   checks the state (once only), exchanges the code with the PKCE verifier, and validates the
   ID token against the provider's signing keys: signature, issuer, audience, expiry and nonce.
   Metadata and keys are cached for an hour and reloaded at once when a new key appears.
3. It checks the email domain and `email_verified`, finds the person by provider and subject
   (or links the existing account with the same email, or creates one), applies the role from
   the groups, and keeps the normal Pulsimo token pair in Redis for 60 seconds under a
   one-time code.
4. The browser lands on `/login/sso?code=…`, which posts the code to
   `POST /api/v1/auth/sso/exchange` and receives the same answer as a password login. The code
   works once, and tokens never appear in a URL or in the browser history.
5. Any refusal (cancelled at the provider, wrong domain, unknown user, deactivated account)
   sends the person back to the login page with a plain message, and is recorded in the login
   attempts.

Accounts created by SSO have no password (`users.auth_source = 'sso'`) and can only sign in
with SSO. Linked accounts are kept in `user_identities` (provider, subject, email, groups,
last sign-in).

## Limits

- OpenID Connect only (no SAML). Most SAML providers also offer OIDC.
- One provider per Pulsimo installation.
- Signing out of Pulsimo does not sign you out of the provider.
- Groups and email come from the ID token; when either is missing Pulsimo asks the provider's
  userinfo endpoint. Providers that would send very large group lists (Entra ID with more than
  200 groups) send an overage marker instead: use app roles there.
- Roles change at the next sign-in, not while someone is signed in. To remove access at once,
  deactivate the user in Users.
