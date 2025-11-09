# Settings - System Configuration & Administration

The Settings page is your administrative control center for Pulsimo. Accessible only to Admin users, this is where you configure organization-wide settings, manage API keys, control integrations, and fine-tune system behavior. From SMTP configuration to security policies, everything that affects the entire system is managed here.

---

## 🎯 **Overview**

Settings provides centralized control over system-wide configuration. Rather than editing environment files or restarting services, administrators can modify critical settings through an intuitive web interface. Changes take effect immediately and are tracked in audit logs for compliance and troubleshooting.

### **Key Benefits**

✅ **Centralized Configuration** - All system settings in one place  
✅ **Admin-Only Access** - Restricted to protect critical settings  
✅ **API Key Management** - Generate and manage authentication keys  
✅ **Organization Profile** - Company branding and information  
✅ **SMTP Configuration** - Email notification setup  
✅ **Integration Controls** - Third-party service connections  
✅ **Security Policies** - Password rules and session management  
✅ **Audit Trail** - Track all configuration changes  

---

## 📊 **Settings Page Components**

### **1. Page Header**

**Page Title**
- **"Settings"** - Clear identification
- **Subtitle:** "Configure system and organization settings"

**Access Indicator:**
- 🔒 **Admin Only** badge
- Visible only to users with Admin role
- Other roles see "Access Denied" if they navigate here

**Quick Save:**
- **Save All Changes** button (top-right)
- Saves pending changes across all tabs
- Confirmation message on success

---

### **2. Settings Navigation Tabs**

**Four Main Tabs:**
1. **Organization** - Company profile and preferences
2. **API Keys** - Authentication key management
3. **Integrations** - Third-party service connections
4. **Security** - Security policies and access controls

---

## 🏢 **Organization Tab**

### **Organization Profile**

**Basic Information:**

**Organization Name** (Required)
- Your company or team name
- Displayed in UI, emails, reports
- Example: "Acme Corporation", "Platform Engineering Team"
- Used in branding

**Description** (Optional)
- Brief overview of organization
- Internal use
- Example: "Production monitoring for E-commerce platform"

**Contact Email** (Required)
- Primary contact for system
- Administrative notifications sent here
- Example: devops@company.com
- Used for system alerts

**Website** (Optional)
- Company website URL
- Displayed in reports
- Example: https://www.company.com

---

### **Regional Settings**

**Timezone**
- Select your operational timezone
- Affects all timestamps in UI
- Incident times, health check times, reports
- Default: UTC
- Options: All IANA timezones

**Why It Matters:**
- Incident timestamps in your local time
- Scheduled tasks run at correct times
- Reports show local business hours
- Team coordination

**Date Format**
- **MM/DD/YYYY** (US format) - Example: 11/07/2024
- **DD/MM/YYYY** (EU format) - Example: 07/11/2024
- **YYYY-MM-DD** (ISO format) - Example: 2024-11-07

**Time Format**
- **12-hour** (AM/PM) - Example: 2:30 PM
- **24-hour** (Military) - Example: 14:30

---

### **Branding** (Future Feature)

**Custom Logo:**
- Upload company logo
- Displayed in header
- Used in reports and emails
- Formats: PNG, SVG (transparent background recommended)
- Max size: 2MB

**Color Scheme:**
- Primary brand color
- Accent color
- Customizes UI theme
- Maintains accessibility

---

### **Default Preferences**

**Default Check Interval:**
- System-wide default for new endpoints
- Options: 10s, 30s, 1min, 5min
- Individual endpoints can override
- Recommended: 10-30 seconds

**Default Failure Threshold:**
- System-wide default consecutive failures
- Options: 1-10 failures
- Recommended: 3 failures
- Prevents false positives

**Default Timeout:**
- HTTP request timeout for health checks
- Options: 5s, 10s, 30s, 60s
- Recommended: 30 seconds
- Individual endpoints can override

**Retention Period:**
- How long to keep health check history
- Options: 7 days, 30 days, 90 days, 1 year, Forever
- Affects database size
- Recommended: 90 days (balance of history and performance)

---

### **Save Changes Button**

**Located at bottom of Organization tab:**
- Button changes color when unsaved changes exist
- **Blue** (unsaved changes pending)
- **Green** (all saved, no changes)
- Click to save
- Confirmation: "✓ Organization settings saved"

---

## 🔑 **API Keys Tab**

### **What are API Keys?**

**Purpose:**
- Programmatic access to Pulsimo API
- Automation scripts
- CI/CD integrations
- External monitoring tools
- Custom dashboards

**Authentication:**
- Bearer token authentication
- Include in HTTP header: `Authorization: Bearer YOUR_API_KEY`
- Equivalent to user login (inherit creator's permissions)

---

### **Active API Keys List**

**Table showing all generated keys:**

**Columns:**

**Key Name**
- Friendly identifier
- Example: "CI/CD Pipeline Key", "Terraform Integration"
- Helps identify purpose

**Key Preview**
- First and last 8 characters
- Middle obscured for security
- Example: `generated_secrets`
- Full key shown only once at creation

**Created By**
- User who generated the key
- Inherits this user's permissions
- Admin/Member only (Viewers cannot create)

**Created Date**
- When key was generated
- Example: "Created 3 months ago"

**Last Used**
- Most recent API call with this key
- Example: "Last used 2 hours ago"
- "Never used" if brand new

**Permissions**
- Same as creator's role
- Admin keys: Full access
- Member keys: Operational access
- Cannot change after creation

**Status**
- 🟢 **Active** - Key working normally
- 🔴 **Revoked** - Key disabled, calls fail
- 🟡 **Expired** - Past expiration date (if set)

**Actions**
- **Copy Key** - Copy to clipboard (only if just created)
- **Revoke** - Disable key immediately
- **Delete** - Permanently remove key
- **View Activity** - See API calls made with this key

---

### **Generate New API Key**

**Click "Generate New Key" button (blue-cyan gradient):**

#### **Key Creation Dialog**

**Key Name** (Required)
- Descriptive name for identification
- Example: "Production Deployment Script"
- Cannot be changed after creation

**Description** (Optional)
- Purpose of this key
- Example: "Used by GitHub Actions to trigger health checks"
- Internal documentation

**Expiration** (Optional)
- Set expiration date
- Options: Never, 30 days, 90 days, 1 year, Custom date
- Security best practice: Set expiration
- Expired keys automatically revoked

**Permissions** (Informational)
- Inherits your role permissions
- If you're Admin, key has admin access
- If you're Member, key has member access
- Cannot grant more permissions than you have

---

#### **Key Generated - Important!**

**⚠️ Security Warning:**
```
⚠️ IMPORTANT: Copy API key now!
For security reasons, this key will never be shown again.

If you lose this key, you'll need to generate a new one.

[Copy to Clipboard]  [I've Saved It Securely]
```

**After Copying:**
- Store securely (password manager, secrets vault)
- Never commit to version control
- Never share via insecure channels
- Treat like a password

**Usage Example:**
```
curl -H "Authorization: Bearer YOUR_API_KEY" \
     https://your-pulsimo-instance.com/api/endpoints
```

---

### **API Key Security**

**Best Practices:**

**Storage:**
- Use environment variables in scripts
- Use secrets managers (AWS Secrets Manager, HashiCorp Vault)
- Never hardcode in source code
- Never commit to Git repositories

**Rotation:**
- Rotate keys every 90 days (recommended)
- Generate new key before revoking old
- Update all systems using the key
- Then revoke old key

**Least Privilege:**
- Create keys with Member role when possible
- Only create Admin keys if absolutely necessary
- Use separate keys for different purposes
- Easier to track usage and revoke if compromised

**Monitoring:**
- Review "Last Used" regularly
- Investigate unused keys (delete or revoke)
- Check API activity logs
- Alert on suspicious patterns

---

### **Revoking API Keys**

**When to Revoke:**
- Key potentially compromised
- No longer needed
- Team member leaves
- System decommissioned
- Regular security rotation

**Revoke Process:**
1. Click "Revoke" button on key
2. Confirmation dialog: "Are you sure?"
3. Warning: "All API calls with this key will fail immediately"
4. Click "Confirm Revoke"
5. Key status changes to "Revoked"
6. Any systems using key will receive 401 Unauthorized

**Immediate Effect:**
- Next API call fails instantly
- No grace period
- Ensure replacement key distributed first

---

## 🔗 **Integrations Tab**

### **SMTP Email Configuration**

**Purpose:**
- Send email notifications
- User invitations
- Password resets
- Incident alerts via email
- Reports

**Why Configure SMTP:**
- Default email not configured on fresh install
- Must set up to send emails
- Uses your email infrastructure
- More reliable delivery

---

#### **SMTP Settings**

**SMTP Host** (Required)
- Your email server hostname
- Examples:
  - Gmail: smtp.gmail.com
  - AWS SES: email-smtp.us-east-1.amazonaws.com
  - SendGrid: smtp.sendgrid.net
  - Mailgun: smtp.mailgun.org
  - Office 365: smtp.office365.com

**SMTP Port** (Required)
- Port number for SMTP connection
- Common ports:
  - **587** - TLS (recommended)
  - **465** - SSL
  - **25** - Unencrypted (not recommended)
- Recommended: 587 with STARTTLS

**SMTP Username** (Required)
- Email account username
- Often your full email address
- Example: noreply@company.com

**SMTP Password** (Required)
- Email account password or app password
- Stored encrypted
- Shown as dots: ••••••••
- For Gmail: Use "App Password", not account password

**Sender Email** (Required)
- "From" address on emails
- Example: noreply@company.com
- Should match SMTP account

**Sender Name** (Optional)
- Display name for sender
- Example: "Pulsimo Monitoring System"
- Recipients see: "Pulsimo Monitoring System <noreply@company.com>"

**Use TLS/SSL**
- Checkbox: Enable encryption
- Recommended: Always enable
- Port 587: Use STARTTLS
- Port 465: Use SSL

---

#### **Test SMTP Configuration**

**Test Button:**
- Sends test email to your email address
- Verifies SMTP settings correct
- Checks connectivity and authentication

**Test Email Contents:**
- Subject: "Test Email from Pulsimo"
- Body: "If you're reading this, SMTP is configured correctly!"
- Timestamp and system info

**If Test Succeeds:**
- ✓ "Test email sent successfully"
- Check your inbox (and spam folder)
- SMTP configuration is working

**If Test Fails:**
- ✗ "Failed to send test email"
- Error message displayed:
  - Authentication failed (check username/password)
  - Connection refused (check host/port)
  - TLS error (check TLS settings)
  - Network timeout (firewall issue)

---

#### **Email Provider Examples**

**Gmail:**
```
Host: smtp.gmail.com
Port: 587
Username: your-email@gmail.com
Password: App Password (not account password)
TLS: Enabled
```

**How to get Gmail App Password:**
1. Google Account → Security
2. Enable 2-Step Verification
3. App Passwords → Generate
4. Use generated password

**AWS SES:**
```
Host: email-smtp.us-east-1.amazonaws.com
Port: 587
Username: SMTP username from SES
Password: SMTP password from SES
TLS: Enabled
```

**SendGrid:**
```
Host: smtp.sendgrid.net
Port: 587
Username: apikey
Password: Your SendGrid API key
TLS: Enabled
```

---

### **External Integrations** (Future)

**PagerDuty Integration:**
- Connect to PagerDuty for on-call management
- Automatic incident creation
- Escalation policies

**Slack App Integration:**
- More advanced than webhooks
- Interactive buttons in Slack
- Acknowledge incidents from Slack

**Jira Integration:**
- Create Jira tickets from incidents
- Link incidents to tickets
- Sync status

---

## 🔒 **Security Tab**

### **Password Policy**

**Minimum Password Length:**
- Slider: 8-20 characters
- Default: 8 characters
- Recommended: 12+ for better security

**Password Complexity Requirements:**
- **Require Uppercase** - Checkbox
- **Require Lowercase** - Checkbox
- **Require Numbers** - Checkbox
- **Require Special Characters** - Checkbox (!@#$%^&*)
- Recommended: Enable all for strong passwords

**Password Expiration:**
- Force password change every X days
- Options: Never, 30, 60, 90, 180 days
- Recommended: 90 days for compliance
- Users notified 7 days before expiration

**Password History:**
- Prevent reuse of last X passwords
- Options: 0 (no restriction), 3, 5, 10
- Recommended: 5 passwords
- Prevents password rotation cycles

---

### **Session Management**

**Session Timeout:**
- Auto-logout after inactivity
- Options: 30 min, 1 hour, 4 hours, 8 hours, 24 hours, Never
- Recommended: 8 hours for balance
- Applies to all users

**Allow Multiple Sessions:**
- User can log in from multiple devices simultaneously
- Enable/Disable toggle
- If disabled: New login kicks out old session
- Recommended: Enabled for convenience

**Remember Me:**
- Allow "Remember Me" checkbox on login
- Extends session duration
- Options: Allow, Disallow
- Security vs. convenience trade-off

---

### **Account Lockout**

**Failed Login Attempts:**
- Lock account after X failed attempts
- Range: 3-10 attempts
- Default: 5 attempts
- Prevents brute force attacks

**Lockout Duration:**
- How long account stays locked
- Options: 15 min, 30 min, 1 hour, 2 hours, Permanent (admin unlock)
- Default: 15 minutes
- Balance security and usability

**Notify User on Lockout:**
- Send email when account locked
- Includes unlock instructions
- Recommended: Enabled

---

### **IP Allowlist** (Future Feature)

**Restrict Access by IP:**
- Allow login only from specific IPs
- Useful for corporate networks
- Bypass for emergency access

---

## ⚙️ **Advanced Settings** (Future)

### **Backup Configuration**

**Automatic Backups:**
- Schedule: Daily, Weekly
- Retention: How many backups to keep
- Storage location
- Restore functionality

### **Maintenance Mode**

**System Maintenance:**
- Enable maintenance mode
- Display banner to users
- Disable certain functions
- Schedule downtime

---

## 📊 **Settings Change Audit**

### **Configuration Change Log**

**Track All Changes:**
- Who made the change
- What was changed
- Old value vs. New value
- Timestamp
- IP address

**Example Entry:**
```
User: admin@company.com
Action: Changed SMTP Host
From: smtp.oldprovider.com
To: smtp.newprovider.com
Timestamp: 2024-11-07 14:30:22 UTC
IP: 192.168.1.100
```

**Why Track:**
- Troubleshooting (what changed before issue started)
- Compliance (audit trail)
- Security (detect unauthorized changes)
- Knowledge (understand system evolution)

---

## 🎯 **Best Practices**

### **Organization Settings**

**Keep Information Updated:**
- Review organization profile quarterly
- Update contact email if team changes
- Adjust timezone if team relocates
- Keep branding current

**Choose Appropriate Defaults:**
- Don't make check intervals too aggressive (server load)
- Set failure thresholds to prevent false positives
- Consider retention period vs. database size
- Adjust based on team feedback

---

### **API Key Management**

**Key Hygiene:**
- Generate descriptive names
- Set expiration dates
- Rotate regularly (90 days)
- Delete unused keys
- Monitor "Last Used" column

**One Key Per Purpose:**
- Separate keys for CI/CD, scripts, integrations
- Easier to track usage
- Revoke one without affecting others
- Clearer audit trail

**Emergency Key:**
- Keep one emergency admin key secure
- Store in physical safe or offline vault
- Use only if other access lost
- Rotate after use

---

### **SMTP Configuration**

**Use Dedicated Email Account:**
- Don't use personal email
- Create noreply@company.com or similar
- Easier to manage
- Professional appearance

**Test Regularly:**
- Test after any changes
- Test monthly to ensure still working
- Monitor delivery rates
- Check spam scores

**Use Authenticated SMTP:**
- Don't use unauthenticated relay
- Configure SPF, DKIM, DMARC
- Improves deliverability
- Reduces spam classification

---

### **Security Policies**

**Balance Security and Usability:**
- Don't make policies too strict (users work around)
- Don't make too lenient (security risk)
- Adjust based on your threat model
- Consider user feedback

**Regular Review:**
- Review security settings quarterly
- Adjust based on incidents
- Update for new threats
- Stay compliant with regulations

---

## 🆘 **Troubleshooting**

### **Cannot Save Settings**

**Possible Causes:**
- Not logged in as Admin
- Browser lost session
- Validation error in form
- Network connectivity issue

**Solutions:**
- Verify Admin role
- Refresh page and re-enter changes
- Check for red error messages on form
- Review browser console for errors

---

### **SMTP Test Fails**

**Common Issues:**

**Authentication Failed:**
- Wrong username or password
- For Gmail: Use App Password, not account password
- Check for typos

**Connection Refused:**
- Wrong host or port
- Firewall blocking outbound SMTP
- SMTP provider requires allowlist

**TLS Error:**
- TLS/SSL setting doesn't match port
- Port 587: Use STARTTLS
- Port 465: Use SSL

**Timeout:**
- Network latency
- Firewall issue
- SMTP provider down

---

### **API Key Not Working**

**Possible Causes:**
- Key revoked or expired
- Key not copied completely (missing characters)
- Wrong API endpoint
- Missing "Bearer" prefix in header

**Solutions:**
- Check key status (Active?)
- Generate new key and copy carefully
- Verify API URL
- Ensure header format: `Authorization: Bearer YOUR_KEY`

---

### **Changes Not Taking Effect**

**If settings save but don't apply:**
- Refresh browser (Ctrl+Shift+R)
- Clear browser cache
- Check if service restart needed (rare)
- Verify in audit log that change was saved

---

## 📚 **Related Documentation**

- **[Users & RBAC](users.md)** - User management and roles
- **[Alerts](alerts.md)** - Email notification setup
- **[Installation](../installation/README.md)** - Initial SMTP configuration
- **[Getting Started](../getting-started.md)** - Initial setup walkthrough

---

**Settings are the foundation of your Pulsimo instance. Configure them carefully, document changes, and review regularly. A well-configured system is a reliable system!** ⚙️
