# Getting Started with Pulsimo

This quick start guide will help you set up your first monitoring endpoints and configure alerts within minutes.

---

## 🎯 **What You'll Learn**

By the end of this guide, you'll have:

✅ Created your first project  
✅ Added and configured monitoring endpoints  
✅ Set up notification channels  
✅ Configured alert policies  
✅ Understood the dashboard and key features  

**Estimated Time:** 15-20 minutes

---

## 📋 **Prerequisites**

Before starting, ensure you have:

- ✅ Pulsimo installed and running
- ✅ Created an admin account
- ✅ Logged into the web interface

If you haven't completed installation, see the **[Installation Guide](installation/README.md)**.

---

## 🏗️ **Step 1: Create Your First Project**

Projects help organize your monitoring endpoints by team, application, or environment.

### **Navigate to Projects**

1. Click **"Projects"** in the left sidebar
2. Click the **"New Project"** button (top-right, blue gradient)

### **Fill Project Details**

| Field | Description | Example |
|-------|-------------|---------|
| **Project Name** | Descriptive name for your project | "Production Web Services" |
| **Description** | Brief overview of what this project monitors | "Main customer-facing web application" |
| **Color** | Visual identifier for the project | Choose blue, green, or any color |
| **Tags** | Keywords for filtering and organization | production, web, critical |
| **Priority** | Importance level | High, Medium, Low |

### **Click "Create Project"**

Your project is now ready to contain monitoring endpoints!

---

## 🔗 **Step 2: Add Your First Endpoint**

Endpoints are the services you want to monitor (APIs, websites, databases, etc.).

### **Navigate to Dashboard**

1. Click **"Dashboard"** in the left sidebar
2. Click the **"Add Endpoint"** button (top-right, blue gradient)

### **Basic Information**

| Field | Description | Example |
|-------|-------------|---------|
| **Endpoint Name** | Friendly name for this service | "Main API Health Check" |
| **URL** | The endpoint to monitor | https://api.yourcompany.com/health |
| **Service Type** | Type of service being monitored | HTTP/HTTPS, Database, Kafka, etc. |
| **Project** | Select the project you created | "Production Web Services" |

### **Health Check Configuration**

| Field | Description | Recommended Value |
|-------|-------------|-------------------|
| **Check Interval** | How often to check (seconds) | 10 seconds (frequent), 30-60 seconds (less critical) |
| **Timeout** | Request timeout (seconds) | 30 seconds |
| **Expected Status Code** | HTTP status code for "healthy" | 200 (OK) |

### **Authentication (if required)**

If your endpoint requires authentication:

**Bearer Token:**
- Select "Bearer Token" authentication type
- Enter your JWT or API token
- Pulsimo automatically handles the Authorization header

**API Key:**
- Select "API Key" authentication type
- Enter header name (e.g., X-API-Key)
- Enter your API key value

**Basic Auth:**
- Select "Basic Authentication"
- Enter username and password

### **Alert Policy**

Configure when you want to be notified:

| Setting | Description | Recommended |
|---------|-------------|-------------|
| **Failure Threshold** | Consecutive failures before alerting | 3 (prevents false positives) |
| **First Failure Warning** | Alert immediately on first failure | Enable for critical services only |
| **Recovery Notification** | Alert when service recovers | Enable (to know when issues resolve) |

### **Click "Create Endpoint"**

Your endpoint is now being monitored! Within 10 seconds, you'll see the first health check result.

---

## 🔔 **Step 3: Set Up Notification Channels**

Configure where you want to receive alerts when services go down.

### **Navigate to Alerts**

1. Click **"Notifications"** or **"Alerts"** in the left sidebar
2. Click the **"Add Channel"** button (top-right, blue gradient)

### **Choose Your Platform**

Pulsimo supports multiple notification channels:

#### **📧 Email Notifications**

| Field | Description | Example |
|-------|-------------|---------|
| **Channel Name** | Friendly name | "Team Email Alerts" |
| **Email Address** | Recipient email | team@yourcompany.com |
| **Repeat Interval** | How often to repeat alerts | 15 minutes |

**Note:** Ensure SMTP is configured in your .env file

---

#### **💬 Slack Integration**

| Field | Description | How to Get |
|-------|-------------|------------|
| **Channel Name** | Friendly name | "Slack Production Alerts" |
| **Webhook URL** | Slack incoming webhook | Create at: https://api.slack.com/messaging/webhooks |
| **Channel** | Slack channel name | #production-alerts |
| **Repeat Interval** | Alert frequency | 15 minutes |

**Getting Slack Webhook:**
1. Go to your Slack workspace settings
2. Navigate to "Apps" → "Incoming Webhooks"
3. Click "Add to Slack"
4. Select channel and copy webhook URL

---

#### **🎮 Discord Integration**

| Field | Description | How to Get |
|-------|-------------|------------|
| **Channel Name** | Friendly name | "Discord DevOps" |
| **Webhook URL** | Discord webhook | Server Settings → Integrations → Create Webhook |
| **Repeat Interval** | Alert frequency | 15 minutes |

**Getting Discord Webhook:**
1. Open Discord server settings
2. Go to "Integrations" → "Webhooks"
3. Click "New Webhook"
4. Copy webhook URL

---

#### **👥 Microsoft Teams**

| Field | Description |
|-------|-------------|
| **Channel Name** | Friendly name |
| **Webhook URL** | Teams incoming webhook |
| **Repeat Interval** | 15 minutes |

---

#### **📱 Google Chat**

| Field | Description |
|-------|-------------|
| **Channel Name** | Friendly name |
| **Webhook URL** | Google Chat webhook |
| **Repeat Interval** | 15 minutes |

---

#### **🔗 Custom Webhook**

For custom integrations (PagerDuty, Opsgenie, etc.):

| Field | Description |
|-------|-------------|
| **Channel Name** | Friendly name |
| **Webhook URL** | Your webhook endpoint |
| **HTTP Method** | GET or POST |
| **Custom Headers** | Optional headers (e.g., API keys) |
| **Repeat Interval** | 15 minutes |

### **Test Your Channel**

After creating a channel:

1. Find the channel in your list
2. Click the **"Test"** button
3. Check that you receive a test notification
4. If successful, you'll see a green checkmark

---

## 📊 **Step 4: Understanding Your Dashboard**

Now that you've set up monitoring, let's explore what you can see.

### **Dashboard Overview**

The dashboard is your central monitoring hub:

**Top Section - Quick Actions:**
- **Refresh Button** - Manually refresh all data
- **Add Endpoint Button** - Create new monitoring endpoints

**Stats Overview Cards:**

| Card | What It Shows |
|------|---------------|
| **Total Endpoints** | All monitored services |
| **Healthy (UP)** | Services currently online and responding |
| **Down** | Services currently failing health checks |
| **Partial Outage** | Services with degraded performance |

**Service Cards:**

Each endpoint displays:
- **Service Name** - Endpoint friendly name
- **URL** - The monitored endpoint
- **Status Badge** - UP (green), DOWN (red), CHECKING (blue)
- **Response Time** - Current response time in milliseconds
- **Check Interval** - How often it's checked
- **Last Checked** - Timestamp of last health check
- **Uptime Percentage** - 24-hour availability

**Real-Time Updates:**

The dashboard updates automatically via WebSocket:
- ⚡ **Instant feedback** when endpoints change status
- 🔄 **Live countdown** showing next check time
- 📊 **Real-time metrics** without page refresh

---

## 🚨 **Step 5: Understanding Incidents**

When a service goes down, Pulsimo automatically creates an incident.

### **Incident Lifecycle**

1. **Open** - Service just went down, alert sent
2. **Acknowledged** - Team member acknowledged they're working on it
3. **Investigating** - Team is actively troubleshooting
4. **Resolved** - Service is back up, incident closed

### **Viewing Incidents**

Navigate to **"Incidents"** in the sidebar:

**You'll see:**
- All open incidents (requiring attention)
- Recently resolved incidents (last 7 days)
- Incident severity, affected endpoint, and duration
- Who acknowledged and resolved each incident

### **Acknowledging an Incident**

When you receive an alert:

1. Navigate to Incidents page
2. Click on the incident
3. Click **"Acknowledge"** button
4. Add optional notes about what you're doing
5. This stops repeat notifications

### **Resolving an Incident**

When the service is back:

1. Open the incident
2. Click **"Resolve"** button
3. Add resolution notes (what fixed it)
4. Pulsimo calculates total downtime and MTTR

---

## 📈 **Step 6: Monitoring Performance**

### **Service Performance Page**

Navigate to **"Service Performance"** to see:

**Aggregate Metrics:**
- Average response time across all services
- Total requests processed
- Success rate percentage
- Error rate trends

**Per-Service Analytics:**
- Response time trends (last 24 hours)
- Availability percentage (last 7 days, 30 days)
- Slowest endpoints identification
- Most frequently failing services

**SLA Tracking:**
- 99.9% uptime compliance
- Monthly availability reports
- Downtime breakdown by endpoint

---

## 🔗 **Step 7: Mapping Dependencies**

### **Why Map Dependencies?**

Understanding service relationships helps you:
- Predict cascade failures
- Identify critical services
- Plan maintenance windows
- Understand blast radius

### **Navigate to Dependencies**

Click **"Dependencies"** in the sidebar

### **Create a Dependency**

1. Click **"Add Dependency"** button
2. Select **Source Service** (the service that depends on...)
3. Select **Target Service** (the service it depends on)
4. Choose **Dependency Type**:
   - **STRONG** - Source cannot function without target
   - **WEAK** - Source degraded but functional without target
   - **MONITORING** - Just tracking, no functional dependency
5. Add optional description
6. Click **"Create Dependency"**

### **Viewing the Graph**

The dependency graph shows:
- 🔵 **Nodes** - Your services
- ➡️ **Edges** - Dependencies between services
- 🔴 **Red nodes** - Services currently DOWN
- 🟢 **Green nodes** - Services currently UP
- ⚠️ **Yellow highlight** - Services on critical path
- ⚠️ **Orange highlight** - Single points of failure

---

## 👥 **Step 8: User Management & RBAC**

### **Adding Team Members**

Navigate to **"Users"** page:

1. Click **"Add User"** button
2. Enter user details:
   - Name
   - Email (their login username)
   - Password (they can change later)
   - Role (see below)
3. Click **"Create User"**

### **Understanding Roles**

| Role | Permissions | Best For |
|------|-------------|----------|
| **Admin** | Full system access, user management, settings | DevOps leads, SRE managers |
| **Member** | View all, manage incidents, configure endpoints | On-call engineers, developers |
| **Viewer** | Read-only access, cannot modify anything | Stakeholders, management, customers |

### **Role Permissions Matrix**

| Action | Admin | Member | Viewer |
|--------|-------|--------|--------|
| View dashboard & metrics | ✅ | ✅ | ✅ |
| View incidents | ✅ | ✅ | ✅ |
| Acknowledge incidents | ✅ | ✅ | ❌ |
| Resolve incidents | ✅ | ✅ | ❌ |
| Create/edit endpoints | ✅ | ✅ | ❌ |
| Delete endpoints | ✅ | ✅ | ❌ |
| Create/edit projects | ✅ | ✅ | ❌ |
| Configure alert channels | ✅ | ✅ | ❌ |
| Manage users | ✅ | ❌ | ❌ |
| Access settings | ✅ | ❌ | ❌ |
| Generate API keys | ✅ | ❌ | ❌ |

---

## ⚙️ **Step 9: Organization Settings**

### **Navigate to Settings**

Click **"Settings"** in the sidebar (Admin only)

### **Organization Tab**

Configure your organization:
- **Organization Name** - Your company name
- **Contact Email** - Primary contact
- **Timezone** - Your operational timezone
- **Date Format** - Preferred date format

### **API Keys Tab**

Generate API keys for programmatic access:

1. Click **"Generate New Key"**
2. Copy the key immediately (shown only once)
3. Use for automation, integrations, or external tools

**API Key Security:**
- Store securely (treat like passwords)
- Rotate regularly (recommended: every 90 days)
- Delete unused keys immediately

---

## ✅ **Quick Start Checklist**

Complete this checklist to ensure proper setup:

**Initial Setup:**
- ✅ Created at least one project
- ✅ Added 3-5 critical endpoints
- ✅ Configured at least one notification channel
- ✅ Tested notification channel successfully
- ✅ Set appropriate failure thresholds

**Understanding:**
- ✅ Can read dashboard status cards
- ✅ Know how to acknowledge incidents
- ✅ Understand the difference between UP/DOWN/CHECKING
- ✅ Can view performance metrics

**Team Setup:**
- ✅ Invited team members with appropriate roles
- ✅ Documented on-call rotation
- ✅ Tested alert delivery to all team members

**Best Practices:**
- ✅ Set check intervals appropriate to service criticality
- ✅ Configured failure thresholds to avoid alert fatigue
- ✅ Created projects to organize endpoints logically
- ✅ Documented dependencies between services

---

## 🎯 **Next Steps**

Now that you're familiar with the basics:

### **Explore Advanced Features**

1. **[Incidents Management](features/incidents.md)** - Deep dive into incident handling
2. **[Dependency Mapping](features/dependencies.md)** - Advanced graph features
3. **[Service Performance](features/service-performance.md)** - Analytics and trends
4. **[Alert Policies](features/alerts.md)** - Fine-tune notification rules

### **Production Readiness**

- Review **[Best Practices](best-practices.md)** for production deployment
- Set up **automated backups** for your database
- Configure **HTTPS/SSL** for secure access
- Enable **audit logging** for compliance

### **Integration & Automation**

- Explore the **[API Reference](api/README.md)** for integrations
- Set up **CI/CD monitoring** for deployment pipelines
- Create **custom dashboards** for stakeholders
- Implement **auto-scaling triggers** based on health metrics

---

## 💡 **Pro Tips**

### **Reduce Alert Fatigue**

- Start with conservative failure thresholds (3-5 consecutive failures)
- Use "First Failure Warning" only for critical services
- Set appropriate repeat intervals (15-30 minutes minimum)
- Create separate channels for different severity levels

### **Organize Effectively**

- Use projects to separate production, staging, and development
- Add tags to endpoints for easy filtering
- Use consistent naming conventions
- Color-code projects by environment or team

### **Performance Optimization**

- Set less frequent check intervals for non-critical services
- Use 10-second intervals only for mission-critical endpoints
- Monitor your monitoring system's resource usage
- Archive old incidents after resolution

### **Team Collaboration**

- Always add notes when acknowledging incidents
- Write detailed post-mortems for major outages
- Share incident reports with stakeholders
- Review incidents weekly to identify patterns

---

## 🆘 **Common Issues & Solutions**

### **Endpoints Always Showing DOWN**

**Possible Causes:**
- Endpoint requires authentication (configure in endpoint settings)
- Network firewall blocking health checks
- Wrong expected status code (check endpoint response)
- Timeout too short for slow services

**Solution:** Click on the endpoint, check recent health check logs for error details

---

### **Not Receiving Alerts**

**Check:**
- Notification channel is tested and green checkmark shown
- SMTP configured correctly in .env (for email)
- Webhook URLs are correct (for Slack/Discord)
- Failure threshold reached (need X consecutive failures)

**Test:** Use the "Test" button on your notification channel

---

### **Dashboard Not Updating**

**Possible Causes:**
- Browser lost WebSocket connection
- Checker service not running

**Solution:** 
- Refresh the page
- Check service status with: docker compose ps

---

## 📚 **Additional Resources**

- **[Full Features Documentation](features/README.md)** - Comprehensive feature guide
- **[Troubleshooting Guide](troubleshooting.md)** - Common issues and fixes
- **[API Reference](api/README.md)** - For developers and integrations
- **[FAQ](faq.md)** - Frequently asked questions

---

## 🎉 **You're All Set!**

Congratulations! You've completed the quick start guide and your monitoring system is now operational.

**Your monitoring journey has begun:**
- 🎯 Services are being checked every few seconds
- 🔔 You'll be notified instantly when issues occur
- 📊 Performance metrics are being collected
- 🔗 Dependencies are mapped and tracked

**Welcome to stress-free monitoring with Pulsimo!** 🚀

---

**Need Help?** Check the full **[Features Documentation](features/README.md)** or visit our **GitHub Discussions**.
