# Alerts & Notifications - Multi-Channel Alerting System

The Alerts feature ensures your team is immediately notified when services experience issues. With support for six notification channels, intelligent routing, and configurable policies, you can eliminate alert fatigue while ensuring critical issues never go unnoticed.

---

## 🎯 **Overview**

Effective alerting is the bridge between monitoring and incident response. Pulsimo's alerting system automatically sends notifications when endpoints fail, routing them through your preferred communication channels with smart controls to prevent notification spam while ensuring visibility into critical issues.

### **Key Benefits**

✅ **Multi-Channel Support** - Six platforms out-of-the-box (Email, Slack, Discord, Teams, Google Chat, Webhooks)  
✅ **Intelligent Routing** - Send critical to PagerDuty, warnings to Slack  
✅ **Alert Policies** - Per-endpoint configuration of when and how to alert  
✅ **Repeat Control** - Prevent alert spam with configurable intervals  
✅ **First-Failure Warnings** - Option for immediate notification on first failure  
✅ **Recovery Notifications** - Know when services come back online  
✅ **Testing & Validation** - Test channels before relying on them  
✅ **Delivery Tracking** - Audit trail of all notifications sent  

---

## 📊 **Alerts Page Components**

### **1. Page Header**

**Page Title**
- **"Notification Channels"** or **"Alerts"** - Clear identification
- **Subtitle:** "Configure how and where you receive alerts"

**Action Buttons** (Top-right)
- **Add Channel** (blue-cyan gradient) - Create new notification channel
- **Test All Channels** - Send test notification to all enabled channels
- **View Alert History** - See all notifications sent

**Stats Summary:**
- **Active Channels** - Number of enabled channels
- **Alerts Sent Today** - Count of notifications sent in last 24 hours
- **Delivery Success Rate** - Percentage of successful deliveries
- **Pending Tests** - Channels not yet tested

---

### **2. Notification Channels List**

**Grid or List View:**

Each channel displays as a card showing:

#### **Channel Card Components**

**Header:**
- **Platform Icon** - Visual identifier (📧 Email, 💬 Slack, 🎮 Discord, etc.)
- **Channel Name** - Friendly name you assigned
- **Status Badge:**
  - 🟢 **Active** - Enabled and tested
  - 🟡 **Untested** - Created but not validated
  - 🔴 **Failed** - Last test or alert failed
  - ⚫ **Disabled** - Manually disabled

**Channel Details:**
- **Platform Type** - Email, Slack, Discord, Microsoft Teams, Google Chat, Custom Webhook
- **Destination** - Email address, webhook URL (partially masked), channel name
- **Created Date** - When channel was added
- **Last Used** - Timestamp of last alert sent
- **Delivery Stats:**
  - Total alerts sent
  - Success rate percentage
  - Recent failures count

**Repeat Interval:**
- How often to repeat alerts
- Example: "Every 15 minutes"
- Prevents alert spam

**Quick Actions:**
- **Test** - Send test notification
- **Edit** - Modify channel configuration
- **Disable/Enable** - Toggle channel on/off
- **Delete** - Remove channel
- **View History** - See all alerts sent via this channel

---

### **3. Add Channel Dialog**

Click "Add Channel" to open the creation dialog.

#### **Step 1: Choose Platform**

**Six Platform Options:**

---

### **📧 Email Notifications**

**Use Cases:**
- Non-urgent alerts
- Summary reports
- Stakeholder notifications
- Audit trail

**Configuration Fields:**

**Channel Name** (Required)
- Friendly identifier
- Example: "Team Email Alerts", "On-Call Engineer Email"

**Email Address** (Required)
- Recipient email address
- Supports multiple addresses (comma-separated)
- Example: team@company.com, oncall@company.com

**Subject Template** (Optional)
- Customize email subject
- Variables: {service_name}, {status}, {timestamp}
- Default: "[ALERT] {service_name} is {status}"

**Email Format:**
- HTML (rich formatting, default)
- Plain Text (simple, widely compatible)

**Repeat Interval:**
- How often to repeat if not acknowledged
- Options: 2min, 5min, 15min, 30min, 1h, 2h
- Recommended: 15-30 minutes

**SMTP Requirements:**
- Must configure SMTP settings in environment variables
- See Installation Guide for SMTP configuration
- Providers: Gmail, AWS SES, SendGrid, Mailgun

---

### **💬 Slack Integration**

**Use Cases:**
- Team collaboration
- Real-time alerts
- Quick incident acknowledgement
- Popular choice for DevOps teams

**Configuration Fields:**

**Channel Name** (Required)
- Example: "Slack Production Alerts", "Slack DevOps Channel"

**Webhook URL** (Required)
- Slack incoming webhook URL
- Get from: https://api.slack.com/messaging/webhooks
- Example: https://hooks.slack.com/services/T00/B00/XXX

**How to Get Webhook:**
1. Go to Slack App settings
2. Navigate to "Incoming Webhooks"
3. Click "Add to Slack"
4. Select channel (e.g., #production-alerts)
5. Copy webhook URL

**Slack Channel** (Optional)
- Override default channel
- Use for routing to different channels
- Example: #critical-alerts, #team-notifications

**Mention Users** (Optional)
- Tag users on critical alerts
- Format: @username or @channel
- Example: @oncall, @here

**Message Format:**
- Rich (with attachments, colors, buttons) - Default
- Simple (plain text message)

**Repeat Interval:**
- Recommended: 15 minutes for team channels
- Use shorter intervals (5min) for critical services

**Test Button:**
- Sends sample alert to verify webhook
- Check Slack channel for test message

---

### **🎮 Discord Integration**

**Use Cases:**
- Gaming companies
- Tech communities
- Developer teams using Discord
- Real-time collaboration

**Configuration Fields:**

**Channel Name** (Required)
- Example: "Discord DevOps", "Discord Server Alerts"

**Webhook URL** (Required)
- Discord channel webhook
- Get from: Server Settings → Integrations → Webhooks

**How to Get Webhook:**
1. Open Discord server settings
2. Go to "Integrations"
3. Click "Create Webhook" or "New Webhook"
4. Select channel for alerts
5. Copy webhook URL

**Username** (Optional)
- Display name for bot
- Default: "Pulsimo Monitor"
- Customizable for branding

**Avatar URL** (Optional)
- Bot avatar image URL
- PNG or JPG format
- Default: Pulsimo logo

**Embed Color** (Optional)
- Color for alert embeds
- Red for DOWN, Green for UP
- Auto-colored by status (default)

**Repeat Interval:**
- Recommended: 10-15 minutes

---

### **👥 Microsoft Teams Integration**

**Use Cases:**
- Enterprise organizations
- Office 365 users
- Corporate environments
- Integration with Microsoft ecosystem

**Configuration Fields:**

**Channel Name** (Required)
- Example: "Teams Production Alerts", "Teams IT Channel"

**Webhook URL** (Required)
- Teams incoming webhook connector
- Get from: Teams channel → Connectors → Incoming Webhook

**How to Get Webhook:**
1. Open Teams channel
2. Click "..." (More options)
3. Select "Connectors"
4. Find "Incoming Webhook"
5. Click "Configure"
6. Name the webhook and upload icon (optional)
7. Copy webhook URL

**Card Style:**
- MessageCard (rich formatting) - Default
- Adaptive Card (modern, interactive)

**Theme Color:**
- Accent color for alerts
- Auto-set based on severity

**Repeat Interval:**
- Recommended: 15-30 minutes for Teams channels

---

### **📱 Google Chat Integration**

**Use Cases:**
- Google Workspace organizations
- G Suite users
- Teams using Google ecosystem

**Configuration Fields:**

**Channel Name** (Required)
- Example: "Google Chat Ops Room", "GChat Alerts"

**Webhook URL** (Required)
- Google Chat space webhook
- Get from: Google Chat space → Configure webhooks

**How to Get Webhook:**
1. Open Google Chat space
2. Click space name → Configure webhooks
3. Create new webhook
4. Name and optionally add avatar
5. Copy webhook URL

**Thread Replies:**
- Keep alerts in same thread (organize better)
- Create new thread per alert (default)

**Repeat Interval:**
- Recommended: 15 minutes

---

### **🔗 Custom Webhook**

**Use Cases:**
- PagerDuty integration
- Opsgenie integration
- Custom notification systems
- Internal tools and APIs
- Any HTTP-compatible service

**Configuration Fields:**

**Channel Name** (Required)
- Example: "PagerDuty Integration", "Custom Alert System"

**Webhook URL** (Required)
- Your custom endpoint URL
- Must accept HTTP POST requests
- Example: https://api.pagerduty.com/incidents
- Example: https://yourcompany.com/webhook/alerts

**HTTP Method:**
- POST (default, most common)
- GET (for simple integrations)
- PUT (for update operations)

**Headers** (Optional)
- Custom HTTP headers
- Common uses:
  - Authorization: Bearer YOUR_API_KEY
  - Content-Type: application/json
  - X-API-Key: YOUR_KEY

**Example Headers:**
```
Authorization: Bearer sk_live_abc123
Content-Type: application/json
X-Custom-Header: value
```

**Payload Template** (Optional)
- Customize JSON payload
- Variables available:
  - {service_name}
  - {service_url}
  - {status} (UP/DOWN)
  - {timestamp}
  - {response_time}
  - {error_message}

**Default Payload:**
```json
{
  "service": "{service_name}",
  "status": "{status}",
  "url": "{service_url}",
  "timestamp": "{timestamp}",
  "message": "{error_message}"
}
```

**Timeout:**
- Request timeout in seconds
- Default: 10 seconds
- Range: 5-30 seconds

**Retry Logic:**
- Retry on failure: Yes/No
- Max retries: 3 (default)
- Backoff strategy: Exponential

**Repeat Interval:**
- Configure based on downstream system
- Recommended: 10-15 minutes

---

#### **Step 2: Test Channel**

**After Configuration:**

**Test Button:**
- Sends sample alert
- Verifies connectivity
- Validates configuration
- Shows success or error message

**Test Message Contents:**
- Service name: "Test Service"
- Status: DOWN (to mimic real alert)
- Timestamp: Current time
- Message: "This is a test alert from Pulsimo"

**Verify Receipt:**
- Check destination platform
- Confirm message received
- Verify formatting looks correct
- Check if mentions/tags work (if configured)

**If Test Fails:**
- Review error message
- Common issues:
  - Invalid webhook URL
  - Network connectivity
  - Authentication failed
  - Rate limiting
- Correct configuration and retry

**Save Channel:**
- Only after successful test (recommended)
- Can save without testing (not recommended)
- Status badge shows "Untested" if not verified

---

## 🔔 **Alert Policies**

### **Per-Endpoint Configuration**

Alert policies are configured when creating or editing endpoints.

#### **Failure Threshold**

**What It Is:**
- Number of consecutive failures before creating incident and sending alerts
- Prevents false positives from transient issues

**Configuration:**
- Range: 1-10 consecutive failures
- Default: 3 failures
- Recommended: 3-5 for most services

**Example:**
- Threshold: 3
- Check interval: 10 seconds
- First failure: 10:00:00 - No alert
- Second failure: 10:00:10 - No alert  
- Third failure: 10:00:20 - **Alert sent!**

**When to Use Different Values:**
- **Threshold 1:** Critical services, need immediate alert
- **Threshold 3:** Standard services (recommended)
- **Threshold 5:** Services with occasional flakiness
- **Threshold 10:** Very flaky services (consider fixing root cause)

---

#### **First Failure Warning**

**What It Is:**
- Optional flag to send warning on first failure, even if threshold not reached
- Provides early heads-up

**Use Cases:**
- Extremely critical services
- Services with low tolerance for downtime
- Proactive teams wanting early warnings

**Configuration:**
- Checkbox: Enable first-failure warnings
- Separate notification channel (optional)
- Different message format (warning vs. alert)

**Behavior:**
- First failure: Sends "Warning" notification
- Threshold reached: Sends "Alert" notification + creates incident

**Example:**
- First failure: "⚠️ Warning: Service X failed first check"
- Third failure: "🚨 Alert: Service X is DOWN, incident created"

**Considerations:**
- Can increase alert volume
- May cause alert fatigue if service is flaky
- Use sparingly for truly critical services

---

#### **Repeat Interval**

**What It Is:**
- How often to send the same alert if incident not acknowledged
- Prevents missing critical alerts
- Prevents alert spam

**Options:**
- Don't repeat (send once only)
- Every 2 minutes
- Every 5 minutes
- Every 10 minutes
- Every 15 minutes (recommended default)
- Every 30 minutes
- Every 1 hour
- Every 2 hours

**Behavior:**
- Alert sent when incident created
- If not acknowledged, resend after interval
- Continue repeating until acknowledged
- Stop when incident acknowledged or resolved

**Best Practices:**
- Critical services: 5-10 minutes
- Standard services: 15-30 minutes
- Low-priority: 1-2 hours or don't repeat

**Example Timeline:**
```
10:00:00 - Service goes DOWN, alert sent
10:15:00 - Not acknowledged, alert sent again
10:30:00 - Not acknowledged, alert sent again
10:35:00 - Incident acknowledged, alerts stop
```

---

#### **Recovery Notifications**

**What It Is:**
- Alert when service recovers and comes back online
- Confirms issue is resolved

**Configuration:**
- Checkbox: Send recovery notifications
- Same channels as failure alerts
- Optional: Different channel for recoveries

**Message Format:**
- "✅ Service X has recovered and is now UP"
- Duration of outage
- Time to recovery
- Link to incident

**Use Cases:**
- Confirm resolution to team
- Close the loop on incidents
- Provide visibility into recovery
- Measure MTTR

**Considerations:**
- Adds to notification volume
- Most teams find them valuable
- Can be disabled for non-critical services

---

#### **Channel Selection**

**Per-Endpoint Channel Routing:**

**Configuration:**
- Select which channels receive alerts for this endpoint
- Can choose multiple channels
- Different channels for different severity

**Example Routing Strategy:**

**Critical Services:**
- PagerDuty (via Custom Webhook)
- Slack #critical-alerts
- Email to on-call engineer
- Microsoft Teams for visibility

**Standard Services:**
- Slack #general-alerts
- Email to team distribution list

**Low-Priority Services:**
- Email only
- Once daily summary (future feature)

---

## 📊 **Alert History**

### **Notification Log**

**View All Sent Notifications:**

**Table Columns:**
- **Timestamp** - When alert sent
- **Service** - Affected endpoint
- **Channel** - Which notification channel used
- **Status** - Sent successfully, Failed, Pending
- **Delivery Time** - Latency from trigger to delivery
- **Recipient** - Who received (email) or where sent (channel name)
- **Message Preview** - Truncated alert text
- **Actions** - View full details, Retry if failed

**Filters:**
- By date range
- By service
- By channel
- By status (success/failure)
- By incident

**Export:**
- Download as CSV
- Audit trail for compliance
- Analyze alert patterns

---

### **Channel Performance Metrics**

**Per-Channel Statistics:**

**Delivery Success Rate:**
- Percentage of successfully delivered alerts
- Goal: >99%
- Track over time

**Average Delivery Latency:**
- Time from alert trigger to delivery
- Example: 1.2 seconds
- Identifies slow channels

**Failure Analysis:**
- Common failure reasons
- Webhook errors
- Rate limiting issues
- Network timeouts

**Reliability Scoring:**
- A-F grade per channel
- Based on success rate and latency
- Informs channel selection

---

## 🎯 **Best Practices**

### **Reducing Alert Fatigue**

**Problem:**
Too many alerts → Team ignores alerts → Critical issues missed

**Solutions:**

**1. Appropriate Failure Thresholds**
- Use 3-5 consecutive failures
- Don't alert on first failure (unless critical)
- Account for network flakiness

**2. Reasonable Repeat Intervals**
- 15-30 minutes is usually appropriate
- Don't spam every minute
- Trust your team to acknowledge

**3. Severity-Based Routing**
- Critical: Page immediately
- High: Slack during work hours
- Medium: Email summary
- Low: Daily digest

**4. Maintenance Windows**
- Schedule known downtime
- Suppress alerts during maintenance
- Avoid false alarms

**5. Regular Review**
- Analyze alert volume
- Identify noisy endpoints
- Adjust thresholds
- Fix flaky services instead of tuning alerts

---

### **Multi-Channel Strategy**

**Layered Approach:**

**Layer 1: Critical (Immediate Action Required)**
- PagerDuty or similar on-call tool
- SMS alerts
- Phone calls
- Example: Payment processing down

**Layer 2: High (Team Awareness)**
- Slack #critical-alerts channel
- Microsoft Teams alerts
- Example: Core API degraded

**Layer 3: Standard (Monitoring)**
- Slack #general-alerts channel
- Email to team list
- Example: Non-critical service down

**Layer 4: Informational (FYI)**
- Email only
- Daily summary reports
- Example: Internal tool restart

---

### **Testing Your Alerts**

**Regular Testing Schedule:**
- **Monthly:** Test all channels
- **After Changes:** Test immediately
- **New Channels:** Test before relying on them
- **Disaster Recovery:** Full alert system test quarterly

**Test Scenarios:**
- Normal alert flow
- Repeat alerts (wait for interval)
- Recovery notifications
- Multiple simultaneous alerts
- Alert during outage (resilience)

---

## 💡 **Advanced Features**

### **Alert Suppression Rules**

**Temporary Muting:**
- Mute specific endpoint alerts
- Mute all alerts (emergency maintenance)
- Scheduled suppression windows
- Auto-unmute after duration

**Use Cases:**
- During deployments
- Planned maintenance
- Known issues being worked on
- Noisy service temporarily

---

### **Alert Aggregation**

**Future Feature:**
- Group related alerts
- Single notification for multiple failures
- Example: "5 services in us-east-1 are down" instead of 5 separate alerts

---

### **Escalation Policies**

**Future Feature:**
- Alert primary on-call first
- If not acknowledged in X minutes, alert secondary
- Continue escalating up chain
- Integration with PagerDuty/Opsgenie

---

### **Smart Alerting**

**Future Feature:**
- Machine learning to reduce false positives
- Anomaly detection
- Contextual alerts based on time/day
- Predictive alerts before failure

---

## 🆘 **Troubleshooting**

### **Alerts Not Being Sent**

**Possible Causes:**
- Notification channel disabled
- Failure threshold not reached
- Service disabled
- Channel configuration error

**Solutions:**
1. Check channel is enabled (green status)
2. Verify endpoint has channel assigned
3. Confirm failure threshold reached
4. Test channel manually
5. Check alert history for error messages

---

### **Slack Alerts Not Appearing**

**Common Issues:**
- Invalid webhook URL
- Webhook deleted in Slack
- Channel archived
- Rate limiting

**Solutions:**
- Regenerate webhook in Slack
- Verify channel exists and is active
- Check Slack App status
- Test webhook directly with curl
- Review error messages in Pulsimo

---

### **Email Alerts Going to Spam**

**Common Causes:**
- SMTP not configured with proper sender domain
- Email not authenticated (SPF, DKIM)
- Recipient email filtering
- Email provider reputation

**Solutions:**
- Use authenticated SMTP provider (SendGrid, AWS SES)
- Configure SPF and DKIM records
- Whitelist sender address
- Use custom domain, not free email providers
- Test with different recipient addresses

---

### **Custom Webhook Failing**

**Common Issues:**
- Incorrect URL
- Authentication header missing
- Timeout too short
- Payload format mismatch
- SSL certificate issues

**Solutions:**
- Test webhook URL with curl or Postman
- Verify authentication credentials
- Check receiving system logs
- Increase timeout setting
- Review payload template against API requirements
- Check for SSL/TLS issues

---

### **Too Many Duplicate Alerts**

**Causes:**
- Repeat interval too short
- Service flapping (up/down repeatedly)
- Multiple channels configured

**Solutions:**
- Increase repeat interval
- Investigate service flakiness (root cause)
- Increase failure threshold
- Consolidate channels
- Use alert aggregation (when available)

---

## 📚 **Related Documentation**

- **[Incidents](incidents.md)** - How alerts trigger incidents
- **[Dashboard](dashboard.md)** - Service status monitoring
- **[Projects](projects.md)** - Project-level alert configuration
- **[Settings](settings.md)** - SMTP configuration for email alerts
- **[Getting Started](../getting-started.md)** - Initial alert setup

---

**Effective alerting is about signal, not noise. Configure your channels wisely, test regularly, and always be refining. Your future on-call self will thank you!** 🔔
