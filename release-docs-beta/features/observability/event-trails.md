# Event Trails - Comprehensive Audit Logging

Event Trails provides complete visibility into all actions and changes within Pulsimo through comprehensive audit logging. Track who did what, when, and from where—ensuring accountability, supporting compliance requirements, and enabling forensic analysis for security incidents or troubleshooting.

---

## 🎯 **Overview**

Every significant action in Pulsimo generates an audit event—from user logins to configuration changes, from incident acknowledgements to data exports. Event Trails captures, stores, and makes searchable this complete history, providing an immutable record for security auditing, compliance reporting, and operational analysis.

### **Key Benefits**

✅ **Complete Audit Trail** - Every action logged with full context  
✅ **Security Monitoring** - Detect suspicious activities and unauthorized access  
✅ **Compliance Support** - Meet SOC 2, GDPR, HIPAA, PCI-DSS requirements  
✅ **Troubleshooting** - Understand what changed before an issue occurred  
✅ **User Accountability** - Track individual user actions  
✅ **Change Tracking** - Before/after values for all modifications  
✅ **Forensic Analysis** - Investigate security incidents  
✅ **Retention Management** - Long-term storage with export capabilities  

---

## 📊 **Event Trails Dashboard**

### **1. Page Overview**

**Location:** Settings → Event Trails (or Observability → Audit Logs)  
**Access:** Admin only (sensitive audit information)  
**Refresh Rate:** Auto-updates every 10 seconds for recent events

**Page Title**
- **"Event Trails"** or **"Audit Logs"** - Clear identification
- **Subtitle:** "Complete audit trail of all system activities"

**Event Statistics Bar:**
- **Events Today:** 2,847 events
- **Events This Week:** 18,934 events
- **Unique Users:** 47 active users
- **Security Events:** 12 (login failures, permission denials)

---

### **2. Event Stream**

**Real-Time Event Feed:**

**Live event stream showing most recent activities:**

Each event displays as a card or row:

#### **Event Card Components**

**Timestamp**
- Precise time: "2024-11-07 14:32:18.456 UTC"
- Relative time: "2 minutes ago"
- Timezone-aware (user's local timezone)

**Event Type Badge**
- Color-coded by category:
  - 🔵 **Authentication** (blue) - Login, logout, password change
  - 🟢 **Read** (green) - View, search, export
  - 🟡 **Modify** (yellow) - Update, edit, configure
  - 🟠 **Create** (orange) - Add, create, initialize
  - 🔴 **Delete** (red) - Remove, delete, destroy
  - ⚫ **System** (gray) - Automated system actions
  - 🟣 **Security** (purple) - Security-related events

**Actor**
- **User:** Name and email
- **API Key:** Key name (if API call)
- **System:** "System (Automated)" for automated tasks
- Avatar/icon

**Action Description**
- Human-readable summary
- Examples:
  - "admin@company.com logged in successfully"
  - "john.doe@company.com created endpoint 'Production API'"
  - "jane.smith@company.com acknowledged incident INC-2024-001234"
  - "System automatically cleaned up 125,340 old health checks"

**Resource Affected**
- Type: Endpoint, Project, Incident, User, Settings, etc.
- Name or ID: "Production API" or "endpoint-123"
- Link to resource (if exists)

**Source Information**
- IP Address: 192.168.1.100
- User Agent: "Mozilla/5.0 ... Chrome/120.0"
- Location: City, Country (if geo-IP enabled)
- Device: Desktop, Mobile, API Client

**Result Status**
- ✅ **Success** (green) - Action completed successfully
- ⚠️ **Partial** (yellow) - Partially completed
- ❌ **Failed** (red) - Action failed
- 🚫 **Denied** (red) - Permission denied

**Details Button**
- Click to expand full event details
- View complete payload
- See before/after values
- Copy event data

---

### **3. Event Categories**

**Organized by Event Type:**

#### **Authentication Events**

**Login Activities:**
- **Successful Login**
  - User, timestamp, IP, device
  - Session ID created
  - Authentication method (password, SSO, API key)
  
- **Failed Login**
  - User attempted, reason (invalid password, account locked)
  - IP address (track brute force attempts)
  - Security alert if multiple failures

- **Logout**
  - User, timestamp
  - Session duration
  - Manual vs. timeout

- **Password Change**
  - User changed password
  - IP address
  - Forced change vs. voluntary

- **Two-Factor Authentication** (Future)
  - 2FA enabled/disabled
  - 2FA code verified
  - Backup codes generated

**Account Management:**
- **Account Created**
  - New user registered
  - Role assigned
  - Created by (admin) or self-registration

- **Account Disabled**
  - User disabled by admin
  - Reason (if provided)

- **Account Deleted**
  - User permanently removed
  - Data retention note

- **Role Changed**
  - User role modified
  - From: Member → To: Admin
  - Changed by (admin)

---

#### **Resource Management Events**

**Endpoints:**
- **Endpoint Created** - New endpoint added
- **Endpoint Updated** - Configuration changed (before/after values)
- **Endpoint Deleted** - Endpoint removed
- **Health Check Triggered** - Manual health check
- **Endpoint Status Changed** - UP → DOWN or vice versa

**Projects:**
- **Project Created**
- **Project Updated**
- **Project Archived**
- **Project Deleted**
- **Endpoints Assigned to Project**

**Incidents:**
- **Incident Created** - Automatically or manually
- **Incident Acknowledged** - Who acknowledged, notes
- **Incident Status Changed** - OPEN → ACKNOWLEDGED → INVESTIGATING → RESOLVED
- **Investigation Note Added**
- **Incident Resolved** - Resolution notes
- **Post-Mortem Generated**
- **Incident Exported** - JSON or PDF

**Dependencies:**
- **Dependency Created** - Source → Target, type
- **Dependency Updated** - Type or description changed
- **Dependency Deleted**
- **Auto-Discovery Run** - Results of discovery
- **Discovery Approved/Rejected**

**Alert Channels:**
- **Channel Created** - Platform, configuration
- **Channel Tested** - Success or failure
- **Channel Updated** - Configuration changed
- **Channel Disabled/Enabled**
- **Channel Deleted**
- **Notification Sent** - Which channel, which incident, delivery status

**Users:**
- **User Created** - New team member
- **User Updated** - Profile changes
- **User Disabled** - Account suspension
- **User Deleted** - Account removal
- **Password Reset** - Admin reset or self-service

---

#### **Configuration Changes**

**Settings Modified:**
- **Organization Settings Changed**
  - Field: Organization Name
  - From: "Acme Corp" → To: "Acme Corporation"
  - Changed by: admin@company.com

- **SMTP Configuration Updated**
  - Sensitive values masked in logs
  - Changed by, timestamp

- **API Key Generated**
  - Key name, permissions
  - Generated by user
  - Key ID (not full key for security)

- **API Key Revoked**
  - Which key, reason
  - Revoked by admin

- **Security Policy Changed**
  - Password requirements updated
  - Session timeout modified
  - Rate limits adjusted

- **Retention Policy Modified**
  - Health check retention: 90 days → 60 days
  - Changed by admin

- **Cleanup Schedule Changed**
  - New schedule configured
  - Old vs. new schedule

---

#### **Data Operations**

**Exports:**
- **Data Exported**
  - What data (incidents, performance metrics, audit logs)
  - Format (CSV, JSON, PDF)
  - Date range
  - Exported by user
  - IP address

**Imports:**
- **Data Imported**
  - What data imported
  - Number of records
  - Success/failure status
  - Imported by user

**Cleanup Operations:**
- **Cleanup Job Executed**
  - Job type (health checks, incidents, etc.)
  - Records deleted count
  - Space freed
  - Duration
  - Status (success/failed)

**Database Operations:**
- **VACUUM Executed**
  - Table name
  - Type (VACUUM, ANALYZE, FULL)
  - Duration, space freed
  - Triggered by (manual or automatic)

- **Backup Created**
  - Backup size, location
  - Status (success/failure)

- **Restore Executed**
  - Backup restored from
  - Restored by admin
  - Critical security event

---

#### **Security Events**

**Access Control:**
- **Permission Denied**
  - User attempted action
  - Resource they tried to access
  - Reason (insufficient role)
  - Security alert

- **Unauthorized Access Attempt**
  - IP address
  - Endpoint attempted
  - Repeated attempts (potential attack)

- **Rate Limit Exceeded**
  - User or IP
  - Endpoint
  - Request count
  - Blocked requests

**Suspicious Activities:**
- **Multiple Failed Logins**
  - Account lockout triggered
  - IP address
  - Security investigation needed

- **Unusual Data Export**
  - Large data export by user
  - Flag for review
  - Admin notification

- **API Key Misuse**
  - API key used from unusual IP
  - Excessive request rate
  - Potential key compromise

- **Session Hijacking Attempt**
  - Session used from different IP
  - User notified

---

### **4. Advanced Filtering**

**Powerful Search and Filter:**

#### **Quick Filters**

**Predefined Filters:**
- **My Activity** - Events by current user
- **Today** - Events in last 24 hours
- **This Week** - Last 7 days
- **Security Events** - Authentication, access denied, suspicious activity
- **Configuration Changes** - Any settings modifications
- **Failed Actions** - Any failed operations
- **Admin Actions** - Events by admin users only

---

#### **Advanced Filter Builder**

**Build Complex Queries:**

**Filter by Event Type:**
- Authentication
- Resource Management (CRUD operations)
- Configuration Changes
- Data Operations
- Security Events
- System Events

**Filter by Actor:**
- Specific user (dropdown)
- Role (Admin, Member, Viewer)
- API Key (select from list)
- System (automated actions)

**Filter by Resource Type:**
- Endpoints
- Projects
- Incidents
- Dependencies
- Users
- Settings
- Alert Channels

**Filter by Action:**
- Created
- Updated
- Deleted
- Viewed
- Exported

**Filter by Status:**
- Success
- Failed
- Denied
- Partial

**Filter by Source:**
- IP address or range (e.g., 192.168.1.0/24)
- Geographic location (country, city)
- User agent (browser, API client, mobile)

**Filter by Date/Time:**
- Specific date range (date pickers)
- Relative time (last hour, 24h, 7d, 30d, 90d)
- Custom range with time precision

---

#### **Full-Text Search**

**Search Event Details:**
- Search across all event fields
- Action descriptions
- Resource names
- User names/emails
- IP addresses
- Notes and comments

**Search Examples:**
- "password" - Find all password-related events
- "192.168.1.100" - All events from specific IP
- "john.doe@company.com" - All events by user
- "endpoint-123" - All events affecting specific endpoint
- "incident acknowledged" - All incident acknowledgements

---

### **5. Event Detail View**

**Click any event to see complete details:**

#### **Event Overview**

**Full Event Information:**

**Basic Details:**
- Event ID: Unique identifier
- Timestamp: Precise time with milliseconds
- Event Type: Category and subcategory
- Actor: Who performed action
- Result: Success, Failed, Denied

---

**Action Details:**
- **Action:** What was done (Created, Updated, Deleted, etc.)
- **Resource Type:** Endpoint, Incident, Project, etc.
- **Resource ID:** Unique identifier
- **Resource Name:** Friendly name

**Example:**
```
Action: Updated
Resource Type: Endpoint
Resource ID: endpoint-789
Resource Name: "Production API Gateway"
```

---

**Source Information:**
- **IP Address:** 192.168.1.105
- **User Agent:** Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/120.0.0.0
- **Device Type:** Desktop
- **Browser:** Chrome 120.0
- **Operating System:** Windows 10
- **Geographic Location:** San Francisco, CA, United States (if enabled)
- **Organization:** Acme Corporation (from IP)

---

**Session Context:**
- **Session ID:** sess_abc123xyz789
- **Session Start:** 2024-11-07 08:00:00
- **Session Duration:** 6 hours 32 minutes
- **Other Events in Session:** [Link to view]

---

#### **Change Details (for Update events)**

**Before and After Values:**

**Example: Endpoint Configuration Update**

**Changed Fields:**
```
Field: Check Interval
Before: 10 seconds
After: 30 seconds

Field: Failure Threshold
Before: 3 consecutive failures
After: 5 consecutive failures

Field: Alert Channels
Before: ["Slack Production Alerts"]
After: ["Slack Production Alerts", "PagerDuty On-Call"]
```

**Why This Matters:**
- Understand exactly what changed
- Rollback information if needed
- Compliance and audit requirements

---

#### **Additional Context**

**Request Information (for API calls):**
- HTTP Method: POST
- Endpoint: /api/endpoints/789
- Request Headers: (sanitized, no sensitive data)
- Request Body: (payload sent)
- Response Status: 200 OK
- Response Time: 45ms

**System Context:**
- Service: API Gateway
- Version: 1.0.0
- Environment: Production
- Server: api-gateway-pod-3

---

#### **Related Events**

**Events Related to This One:**

**Example: Incident Lifecycle**
```
1. Incident Created (2024-11-07 10:00:00) - System
2. Alert Sent via Slack (10:00:01) - System
3. Alert Sent via Email (10:00:02) - System
4. Incident Acknowledged (10:05:23) - john.doe@company.com ← Current Event
5. Investigation Note Added (10:15:00) - john.doe@company.com
6. Incident Resolved (10:45:00) - john.doe@company.com
```

**Navigation:**
- Click any related event to view
- Timeline visualization
- Understand complete story

---

### **6. Security Dashboard**

**Dedicated Security Event View:**

#### **Security Summary Cards**

**Failed Login Attempts (24h):**
- Count: 12 failed logins
- Unique IPs: 3
- Locked accounts: 1
- Trend: ↓ Decreasing (good)

**Permission Denials (24h):**
- Count: 8 denied actions
- Unique users: 2
- Most denied action: Delete endpoint
- Review access controls

**Suspicious Activities (7d):**
- Unusual login locations: 2
- Multiple device logins: 1
- Excessive API usage: 1
- Investigate: Yes

**API Key Issues (7d):**
- Rate limits exceeded: 5 keys
- Suspicious usage patterns: 1
- Keys to review: 1

---

#### **Security Event Timeline**

**Chronological Security Events:**
- All authentication events
- Permission denials
- Suspicious activities
- Rate limiting events
- Account lockouts

**Visual Timeline:**
- Red dots for failed logins
- Yellow triangles for permission denials
- Purple diamonds for suspicious activity

---

#### **Threat Detection**

**Automated Threat Detection:**

**Brute Force Detection:**
- Multiple failed logins from same IP
- Alert: "Potential brute force attack detected"
- IP: 203.0.113.50
- Attempts: 25 in 5 minutes
- Action: IP blocked automatically

**Account Compromise Indicators:**
- Login from unusual location
- Login from new device without 2FA (if enabled)
- Unusual data export activity
- Recommend: Password reset and investigation

**Insider Threat Indicators:**
- Excessive data exports
- Access to unauthorized resources
- Activity outside normal hours
- Unusual deletion patterns

**API Abuse:**
- Rate limit violations
- Unusual endpoint access patterns
- Potential data scraping
- Recommend: API key review or revocation

---

### **7. Compliance Reporting**

**Audit Reports for Compliance:**

#### **Generate Compliance Reports**

**Report Types:**

**SOC 2 Audit Report:**
- All user access events
- Configuration changes
- Data exports
- Security incidents
- Specified date range
- Format: PDF with attestation

**GDPR Data Access Report:**
- Who accessed what data
- When and from where
- Purpose (if logged)
- User consent records
- Format: PDF or Excel

**HIPAA Audit Trail:**
- All PHI access (if applicable)
- User authentication
- Access denials
- Configuration changes
- Format: Encrypted PDF

**PCI-DSS Report:**
- Payment-related data access
- Security events
- Configuration changes
- Admin activities
- Format: PDF with summary

---

#### **Report Configuration**

**Report Parameters:**
- **Date Range:** Start and end dates
- **Event Types:** Select categories to include
- **Users:** All users or specific subset
- **Format:** PDF, Excel, CSV, JSON
- **Include:** Event details, change history, attachments
- **Delivery:** Download immediately, email, or schedule

**Schedule Reports:**
- Monthly compliance report
- Email to compliance officer
- Automatic generation on 1st of month
- Retention in secure storage

---

### **8. Retention and Archival**

**Long-Term Audit Log Storage:**

#### **Retention Configuration**

**Retention Policy:**
- **Default Retention:** 2 years (730 days)
- **Extended Retention:** 7 years for compliance (optional)
- **Security Events:** Keep forever (recommended)
- **Regular Events:** 2 years then archive

**Storage Tiers:**
- **Hot Storage:** Last 90 days (fast access, database)
- **Warm Storage:** 90 days - 2 years (compressed, searchable)
- **Cold Storage:** 2+ years (archived, S3 Glacier, retrieval needed)

---

#### **Archival Process**

**Automatic Archival:**
- Events older than 90 days compressed
- Moved to warm storage
- Still searchable but slower
- Events older than 2 years moved to cold storage
- Retrieval requires request (4-12 hours)

**Manual Archive:**
- Export specific events to archive
- Remove from active storage
- Maintain searchable index
- Restore when needed

---

#### **Archive Retrieval**

**Restore Archived Events:**
1. Select date range to retrieve
2. Submit restore request
3. Wait for retrieval (4-12 hours for cold storage)
4. Events temporarily available in search
5. Export or analyze as needed
6. Re-archive after use

---

### **9. Real-Time Alerting**

**Alert on Specific Events:**

#### **Configure Event Alerts**

**Alert Rules:**

**Example Rules:**

**Rule 1: Failed Login Alert**
- Trigger: 5 failed login attempts in 10 minutes
- From: Same IP or same user
- Action: Email admin, Slack notification
- Severity: High

**Rule 2: Configuration Change Alert**
- Trigger: Any settings change
- By: Admin users
- Action: Email all admins
- Severity: Medium
- Include: Before/after values

**Rule 3: Data Export Alert**
- Trigger: Export of >10,000 records
- By: Any user
- Action: Email security team
- Severity: High
- Require: Review and approval

**Rule 4: Suspicious Activity**
- Trigger: Login from new country
- By: Any user
- Action: Email user and admin
- Severity: High
- Suggest: Password change

---

#### **Alert Destinations**

**Where to Send Alerts:**
- Email (specific addresses)
- Slack channel (#security-alerts)
- PagerDuty (critical only)
- Webhook (SIEM integration)
- In-app notification
- SMS (future feature)

---

### **10. Integration and Export**

**Export Audit Logs:**

#### **Export Options**

**Export Formats:**
- **CSV** - Spreadsheet analysis
- **JSON** - API integration, SIEM
- **Excel** - Business reports
- **PDF** - Compliance documentation
- **Syslog** - Forward to SIEM in real-time

**Export Scope:**
- Current filtered results
- All events in date range
- Specific event types
- Custom query results

---

#### **SIEM Integration**

**Security Information and Event Management:**

**Supported Integrations:**
- **Splunk** - Forward logs via syslog or HTTP Event Collector
- **ELK Stack** - Elasticsearch ingest
- **Datadog** - Log forwarder
- **Sumo Logic** - HTTP source
- **AWS CloudWatch** - CloudWatch Logs
- **Generic Syslog** - Any syslog receiver

**Configuration:**
- Enable syslog forwarding
- Configure destination (host, port)
- Select event types to forward
- Set up TLS/encryption
- Test connection

**Real-Time Forwarding:**
- Events sent as they occur
- Backup queue if destination unavailable
- Retry logic
- Delivery confirmation

---

## 💡 **Advanced Features**

### **Event Correlation**

**Link Related Events:**
- Automatically correlate events
- Example: Login → Multiple actions → Logout
- Timeline view of user session
- Understand context and intent

---

### **Anomaly Detection**

**ML-Powered Anomaly Detection (Future):**
- Learn normal user behavior
- Detect anomalies automatically
- Alert on unusual patterns
- Example: User typically works 9-5, suddenly active at 2 AM

---

### **Event Replay**

**Reproduce Event Sequence:**
- Select time range
- Replay events in order
- Understand what led to an issue
- Training and demonstrations

---

## 🆘 **Troubleshooting**

### **Cannot Find Event**

**Issue:** Event should exist but not visible

**Possible Causes:**
- Filters too restrictive
- Event archived to cold storage
- Insufficient permissions (viewing own events only)

**Solutions:**
- Clear all filters
- Expand date range
- Request archive retrieval
- Contact admin for full access

---

### **Export Failed**

**Issue:** Export hangs or fails

**Possible Causes:**
- Too many events (> 1 million)
- Network timeout
- Insufficient disk space

**Solutions:**
- Reduce date range
- Filter to specific event types
- Use CSV instead of PDF
- Export in batches

---

## 📚 **Related Documentation**

- **[System Health](system-health.md)** - System event monitoring
- **[API Metrics](api-metrics.md)** - API request logging
- **[Database Health](database-health.md)** - Database audit events
- **[Users & RBAC](../users.md)** - User action tracking
- **[Settings](../settings.md)** - Security configuration

---

**Event Trails provides the accountability and transparency essential for secure, compliant operations. Every action leaves a trace—use this power wisely to maintain trust, security, and operational excellence!** 📜
