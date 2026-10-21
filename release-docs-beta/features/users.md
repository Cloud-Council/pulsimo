# Users and access

> Roles, who needs attention, safe administration, and access that changes at once.

## What it is

The **Users** page shows who can use Pulsimo, what each person can do, and what needs an
administrator's attention: locked accounts, expired passwords, people who never signed
in, and anyone overloaded with incidents. Changes to access take effect on the person's
next request. They don't have to sign out first.

## Where to find it

Sidebar → **Users**. A link with `?user=<id>` opens that person's panel directly.

## Roles

| Role | Can | Can't |
|---|---|---|
| **Administrator** | Everything: also delete endpoints, projects and incidents; add users, change roles, reset passwords, deactivate; security settings, backups, system controls | – |
| **Member** | Add and change endpoints, projects, dashboards, metric and log sources, dependencies; acknowledge, resolve and be assigned incidents | Delete endpoints, projects or incidents; manage users or security |
| **Viewer** | See everything: endpoints, incidents, metrics, logs, dashboards | Change monitoring or incidents; be assigned incidents |

Everyone can change their own profile and password. The cards at the bottom of the page
list the same, with how many people hold each role.

## What administrators see

### Figures

| Figure | Meaning | Click |
|---|---|---|
| People | Active accounts, with total and deactivated | Clears every filter |
| Online now | Used Pulsimo in the last 5 minutes | Shows only them |
| Administrators | Active administrators | Shows only them |
| Need attention | People with at least one warning (below) | Shows only them |
| Open incidents | Open incidents assigned to people, and how many are unassigned | Opens Incidents |

With only one administrator, a banner says so. If that account is locked, or its owner
leaves, nobody can manage users, so make a second person an administrator.

### Needs attention

| Warning | When |
|---|---|
| Locked after failed sign-ins | Too many wrong passwords (Settings → Security: attempts and lock length) |
| Password expired | Older than the expiry set in Settings → Security |
| N failed sign-ins in 7 days | 3 or more, and not locked |
| Has never signed in | Account older than a day, never used |
| Not seen for N days | No activity for 30 days or more |
| N open incidents assigned | 5 or more open incidents |

Deactivated people never show warnings.

### The list

Search by name or email, and filter by role (**Administrators**, **Members**, **Viewers**)
and state (**Online**, **Need attention**, **Locked**, **Deactivated**). Each row shows:

- **User**: initials (a green dot when online, red when locked), name, email, and a
  **You** or **System** tag;
- **Role**;
- **Status**: *Online*, *Active* (with when they were last seen), *Locked* or
  *Deactivated*;
- **Last sign-in**: the last time they actually signed in;
- **Incidents**: open incidents assigned to them (red when one is critical), and how many
  they resolved this week;
- **Needs attention**: the warnings above;
- **Edit** and **Reset password** buttons.

Click a row for the person's panel.

## The user panel

**Actions** at the top (each one asks for confirmation, except Edit and passwords):

| Action | Effect |
|---|---|
| Edit | Name, email, role, phone, time zone, about |
| Reset password | Sets a new password, ends all their sessions and clears a lock |
| Unlock | Shown when locked: clears the lock and the failed sign-in count |
| Sign out everywhere | Ends every session; they can sign in again right away |
| Deactivate / Reactivate | Deactivated people lose access at once, on every device; everything they did stays |
| Delete | Only for people with no history (see below) |

**Sections**

- **Incidents**: open and critical incidents assigned, resolved in 7 days, average time
  to resolve (last 30 days), and their latest incidents with links.
- **Sign-in and security**: last sign-in, last activity, when the password was changed
  and when it expires, failed sign-ins in 7 days, lock, and the last 10 sign-in attempts.
- **What they can do**: their role's permissions.
- **Recent activity**: what they did in Pulsimo, from the Event Trail.
- **Account changes**: who changed this account and how (created, role changed,
  deactivated, password reset…).
- **Profile**: member since, time zone, phone, about.

## Adding someone

**Add user** → name, email, role, and a temporary password:

- **Generate** makes a random 16-character password that meets the policy;
- **Copy** copies it so you can share it securely;
- the checklist under the field shows which rules are met.

Pick the least access the person needs. Emails are stored in lower case; an email already
in use in the organization is refused. Ask the person to change the password after their
first sign-in (their panel, or the key icon on their row).

## Passwords

The rules come from **Settings → Security**: length; upper case, lower case, numbers and
special characters; how many old passwords can't be reused; expiry; sign-in attempts
before a lock, and how long the lock lasts.

| Who | How | What happens |
|---|---|---|
| You, for your own account | Current password + new password twice | Other sessions keep working |
| An administrator, for someone else | New password (or Generate) | All their sessions end; a lock is cleared |

A new password can't be one of the last N passwords (N from Settings → Security). Every
change is recorded in the Event Trail.

## Safety rules

Pulsimo refuses, with a message saying why:

- changing your own role, or deactivating or deleting your own account;
- removing the last active administrator;
- changing the system administrator's role, email or status, or deleting it;
- deleting someone who has history (incident changes, alerts, settings they made).
  Deactivate them instead: they lose access and the history stays.

Members and viewers see only their own account on this page, with the organization's
figures. They can edit their own profile and password, not their role, email or status.

## How access is checked

On every request, Pulsimo checks the account behind the session:

| If the account is… | Then |
|---|---|
| deleted or deactivated | the request is refused at once, on every device |
| given another role | the new role applies from the next request |
| signed out everywhere, or its password reset by an administrator | sessions started before that are refused |

A session can be renewed only while the account is active, and it gets the current role
and the session length from Settings → Security.

**Online** means a request in the last 5 minutes. Activity is recorded at most once a
minute per person. **Last sign-in** is the last actual sign-in.

## API

All signed in; most are administrators only.

| Method and path | Does |
|---|---|
| `GET /api/v1/users` | The list with status, security, workload and warnings, the organization's figures, the password policy, and `can_manage` |
| `POST /api/v1/users` | Add (`name`, `email`, `password`, `role`) |
| `GET /api/v1/users/:id` | Details: everything above plus assigned incidents, activity, account changes, sign-ins, permissions |
| `PUT /api/v1/users/:id` | Change `name`, `email`, `role`, `is_active`, `phone`, `timezone`, `bio` |
| `DELETE /api/v1/users/:id` | Delete (409 when the person has history) |
| `POST /api/v1/users/:id/password` | `{ new_password, old_password? }`; `old_password` for your own |
| `POST /api/v1/users/:id/unlock` | Clear a lock |
| `POST /api/v1/users/:id/sign-out` | Sign out everywhere |
| `GET /api/v1/users/:id/permissions` | The role's permissions |
| `GET /api/v1/users/password-policy` | The password rules |
| `GET /api/v1/users/assignment` | Who can be assigned incidents, with their open incidents |

Refusals use 403 (not allowed), 404 (not in your organization), 409 (a safety rule or a
duplicate email) and 422 (password or email rules). The message says why.

## Limits

- There are no invitation emails yet: you share the temporary password yourself.
- Pulsimo can't force a password change at the next sign-in yet.
- There is no two-factor sign-in yet.

---

← [Routing, digests and deploy grace](alert-routing.md) · [Contents](../README.md) · [Settings and API keys](settings.md) →
