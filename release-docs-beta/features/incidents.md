# Incidents - Complete Incident Lifecycle Management

Incidents are the cornerstone of operational response when services fail. Pulsimo provides a comprehensive incident management system that tracks the entire lifecycle from detection through resolution, ensuring nothing falls through the cracks and every outage is properly documented.

---

## 🎯 **Overview**

When a monitored endpoint fails health checks beyond its configured threshold, Pulsimo automatically creates an incident. This incident becomes the central hub for all information, actions, and collaboration related to that outage. From automatic creation to post-mortem generation, the incident management system guides your team through effective incident response.

### **Key Benefits**

✅ **Automatic Detection** - Incidents created instantly when thresholds exceeded  
✅ **Structured Workflow** - Clear states from open to resolved  
✅ **Alert Management** - Stop notification spam by acknowledging incidents  
✅ **Collaboration** - Multiple team members can work on same incident  
✅ **Documentation** - Investigation notes and resolution details captured  
✅ **Post-Mortems** - Automatic report generation with timeline and metrics  
✅ **Analytics** - Track MTTR, incident frequency, and patterns  
✅ **Compliance** - Complete audit trail for regulatory requirements  

---

## 🔄 **Incident Lifecycle**

### **The Four States**

Every incident progresses through a defined lifecycle:

#### **1. OPEN** (Red Badge)

**Triggered When:**
- Endpoint fails consecutive health checks (threshold exceeded)
- Example: 3 consecutive failures with failure threshold = 3
- Automatic incident creation, no manual intervention

**System Actions:**
- Creates incident record
- Sends alerts to configured notification channels
- Displays in Incidents page
- Updates Dashboard status
- Records start time

**What This Means:**
- Service is confirmed down
- Team needs to respond
- Alerts are actively being sent
- Clock is ticking on downtime

**User Actions Available:**
- Acknowledge incident (stops alerts)
- View incident details
- Check affected endpoint
- Review dependencies

---

#### **2. ACKNOWLEDGED** (Yellow Badge)

**Triggered When:**
- Team member clicks "Acknowledge" button
- Can be acknowledged by any user with Member or Admin role

**System Actions:**
- Stops sending repeat alerts
- Records who acknowledged and when
- Updates incident status
- Notifies team of acknowledgement

**What This Means:**
- Someone is aware and working on it
- Alert fatigue prevented
- Ownership established
- Investigation in progress (implicit)

**User Actions Available:**
- Add investigation notes
- Change status to Investigating (explicit)
- Resolve incident (if fixed)
- View timeline
- Check dependencies

**Best Practice:**
- Acknowledge immediately when starting work
- Add note explaining what you're doing
- Prevents duplicate effort from other team members

---

#### **3. INVESTIGATING** (Blue Badge)

**Triggered When:**
- User explicitly changes status to "Investigating"
- Optional intermediate state for clarity

**System Actions:**
- Updates incident status
- Records investigator and timestamp
- Continues to track downtime
- Allows note additions

**What This Means:**
- Active troubleshooting underway
- Root cause analysis in progress
- Fix being implemented
- Team coordinating on resolution

**User Actions Available:**
- Add detailed investigation notes
- Document findings
- Link related incidents
- Attach screenshots or logs
- Update progress
- Resolve when fixed

**Best Practice:**
- Document each troubleshooting step
- Note potential causes ruled out
- Record what was tried
- Useful for post-mortem later

---

#### **4. RESOLVED** (Green Badge)

**Triggered When:**
- User clicks "Resolve" button
- Service has recovered and is healthy

**System Actions:**
- Marks incident as resolved
- Records resolver and timestamp
- Calculates total downtime
- Calculates time-to-resolve (TTR)
- Updates MTTR metrics
- Sends recovery notification (if enabled)
- Moves to resolved incidents list

**What This Means:**
- Service is back online
- Issue is fixed
- Incident complete
- Metrics recorded

**User Actions Available:**
- Add resolution notes (what fixed it)
- Generate post-mortem report
- Export incident data
- View incident timeline
- Link to related incidents

**Best Practice:**
- Always add resolution notes
- Document what fixed the issue
- Generate post-mortem for major incidents
- Share learnings with team

---

## 📊 **Incidents Page Components**

### **1. Page Header**

**Page Title**
- **"Incidents"** - Clear identification
- **Subtitle:** "Track and manage service outages"

**Quick Stats Bar**
- **Open Incidents** - Requiring immediate attention (red count)
- **Acknowledged** - Being worked on (yellow count)
- **Investigating** - Active troubleshooting (blue count)
- **Resolved Today** - Fixed in last 24 hours (green count)

**Action Buttons**
- **Export All** - Download incident data (CSV/JSON)
- **View Analytics** - Open incident analytics dashboard

---

### **2. Incident Tabs**

**Tab Navigation:**

**Active Incidents Tab** (default view)
- Shows OPEN, ACKNOWLEDGED, and INVESTIGATING incidents
- Sorted by severity, then by start time
- Requires immediate attention
- Real-time updates

**Resolved Incidents Tab**
- Shows incidents resolved in last 7 days (configurable)
- Sorted by resolution time (newest first)
- Historical reference
- Can extend view to 30 days, 90 days, or all time

**All Incidents Tab**
- Combined view of all incidents
- Advanced filtering available
- Export capabilities
- Historical analysis

---

### **3. Incident List View**

Each incident displays as a row with the following information:

#### **Incident Identification**

**Incident ID**
- Unique identifier (e.g., INC-2024-001234)
- Clickable to open details
- Used for reference and linking

**Affected Endpoint**
- Service name that went down
- Clickable to view endpoint details
- URL shown below name (truncated)
- Service type badge (HTTP, Database, etc.)

---

#### **Status and Severity**

**Status Badge**
- Color-coded by state:
  - 🔴 OPEN (red background)
  - 🟡 ACKNOWLEDGED (yellow background)
  - 🔵 INVESTIGATING (blue background)
  - 🟢 RESOLVED (green background)
- Shows current state clearly

**Severity Indicator** (if configured)
- **CRITICAL** - Business-critical service down
- **HIGH** - Important service impacted
- **MEDIUM** - Non-critical service affected
- **LOW** - Minor issue or degraded performance

---

#### **Timeline Information**

**Started At**
- Timestamp when incident created
- Relative time ("2 hours ago")
- Absolute time on hover ("Nov 7, 2024 2:30 PM UTC")

**Duration**
- For open incidents: Time elapsed since start
- For resolved incidents: Total downtime
- Format: "2h 35m" or "45m" or "12h 5m"
- Updates in real-time for open incidents

**Acknowledged At** (if acknowledged)
- Timestamp of acknowledgement
- Who acknowledged (user name)
- Time to acknowledgement from start

**Resolved At** (if resolved)
- Timestamp of resolution
- Who resolved (user name)
- Total time to resolve (MTTR contribution)

---

#### **Metadata**

**Project**
- Which project the endpoint belongs to
- Color badge matching project theme
- Click to filter by project

**Priority**
- Inherited from endpoint configuration
- High, Medium, Low
- Affects sorting and alerting

**Assigned To** (if assigned)
- Team member handling incident
- Avatar and name
- Can reassign

---

#### **Actions Column**

**Quick Actions:**
- **View Details** - Open full incident view
- **Acknowledge** - Mark as acknowledged (if open)
- **Resolve** - Close incident (if acknowledged/investigating)
- **Add Note** - Quick note entry
- **Export** - Download incident report

---

### **4. Incident Detail View**

Click any incident to open the comprehensive detail view.

#### **Header Section**

**Incident Title**
- Incident ID and affected service name
- Status badge (large, prominent)
- Last updated timestamp

**Key Metrics Card**
- **Started:** Incident start timestamp
- **Duration:** Total time down (live for open incidents)
- **Impact:** Number of affected users/requests (if available)
- **MTTR:** Comparison to average (faster/slower)

**Primary Actions**
- **Acknowledge Button** (if open)
- **Start Investigating Button** (if acknowledged)
- **Resolve Button** (if acknowledged/investigating)
- **Reopen Button** (if resolved, but issue returned)

---

#### **Affected Service Details**

**Service Information Panel:**
- Service name and URL
- Service type
- Project assignment
- Current status (with real-time updates)
- Health check configuration
- Last successful check timestamp
- Response time trends

**Recent Health Checks:**
- Last 10-20 health checks
- Success/failure status
- Response times
- Error messages
- Timestamps

**What Failed:**
- Specific error message from health check
- HTTP status code (if applicable)
- Timeout details
- Connection errors
- DNS resolution issues

---

#### **Timeline Tab**

**Chronological Event Log:**

Shows all events related to the incident:

**Event Types:**
- 🔴 **Incident Created** - Initial detection with details
- 📧 **Alert Sent** - Which channels notified, timestamps
- 👤 **Acknowledged** - Who, when
- 📝 **Note Added** - Investigation updates
- 🔍 **Status Changed** - State transitions
- ✅ **Resolved** - Who fixed it, how
- 📊 **Metric Updated** - Downtime calculations

**Timeline Features:**
- Scrollable list (newest first or oldest first toggle)
- Filterable by event type
- Expandable entries for details
- Export timeline to PDF/JSON
- Share timeline URL

**Visual Timeline:**
- Graphical representation
- Shows duration of each state
- Highlights key moments
- Time-to-acknowledge visual
- Time-to-resolve visual

---

#### **Investigation Notes Tab**

**Collaborative Note-Taking:**

**Add New Note:**
- Rich text editor
- Support for markdown formatting
- Attach screenshots
- Timestamp auto-added
- Author auto-recorded

**Note Thread:**
- All notes displayed chronologically
- Each note shows:
  - Author name and avatar
  - Timestamp (relative and absolute)
  - Note content (formatted)
  - Edit button (for author only)
  - Delete button (for author only)

**Note Categories:**
- Investigation finding
- Attempted solution
- Root cause identified
- Workaround applied
- Permanent fix
- Follow-up needed

**Best Practices for Notes:**
- Document each troubleshooting step
- Note what was checked and results
- Record commands run or queries executed
- Describe what worked and what didn't
- Summarize findings for post-mortem

---

#### **Dependencies Tab**

**Impact Analysis:**

**Upstream Dependencies:**
- Services this endpoint depends on
- Their current health status
- Possible cascade failure indication
- Dependency type (STRONG, WEAK)

**Downstream Impact:**
- Services depending on this endpoint
- Blast radius calculation
- Number of potentially affected services
- Critical path indicators

**Visual Dependency Graph:**
- Interactive graph centered on affected service
- Red nodes for down services
- Green nodes for healthy services
- Arrows showing dependency direction
- Click nodes to navigate

**Cascade Failure Detection:**
- Automatic detection if upstream failure
- Shows root cause service
- Highlights cascade chain
- Recommendations to check root cause first

---

#### **Alerts & Notifications Tab**

**Notification History:**

**Alerts Sent:**
- Timestamp of each alert
- Channel used (Email, Slack, Discord, etc.)
- Recipients
- Delivery status (sent, failed, bounced)
- Message content preview

**Alert Timeline:**
- When first alert sent
- Repeat alerts (if before acknowledgement)
- Recovery notification (if enabled)
- Total alerts sent for this incident

**Channel Performance:**
- Which channels delivered successfully
- Which channels failed
- Retry attempts
- Delivery latency

**Mute/Unmute:**
- Temporarily stop alerts for this incident
- Useful during extended troubleshooting
- Can set mute duration
- Unmute automatically when resolved

---

#### **Post-Mortem Tab**

**After Resolution:**

This tab becomes available once incident is resolved.

**Auto-Generated Post-Mortem:**

**Incident Summary:**
- What happened (service name, failure type)
- When it happened (start time, duration)
- Who was affected (users, services)
- Severity and impact

**Timeline of Events:**
- Detailed chronological log
- All status changes
- All notes and actions
- Alert history

**Root Cause:**
- Extracted from investigation notes
- Can be edited and refined
- Categorization (infrastructure, application, human error, external)

**Resolution:**
- What fixed the issue
- Extracted from resolution notes
- Steps taken to restore service

**Metrics:**
- Total downtime
- Time to detect (if applicable)
- Time to acknowledge
- Time to resolve (MTTR)
- Number of alerts sent

**Action Items:**
- Preventive measures identified
- Follow-up tasks
- Assignees for each action
- Due dates
- Link to ticket system (if integrated)

**Lessons Learned:**
- What went well
- What could be improved
- Process improvements
- Technical improvements

---

#### **Export Options**

**Multiple Export Formats:**

**JSON Export:**
- Complete incident data
- All fields and relationships
- Timeline events
- Notes and comments
- Metrics and calculations
- Machine-readable format
- For integrations and APIs

**PDF Report:**
- Professional formatted document
- Company branding (if configured)
- Executive summary
- Detailed timeline
- Charts and graphs
- Suitable for stakeholders

**CSV Export:**
- Tabular format
- For spreadsheet analysis
- Multiple rows per incident (timeline events)
- Easy filtering and sorting

**Markdown:**
- Formatted text document
- Include in documentation
- Version control friendly
- Easy to edit and share

---

## 🚨 **Incident Response Workflow**

### **Scenario 1: Simple Incident**

**1. Detection (Automatic)**
- Service fails 3 consecutive checks
- Incident created automatically
- Alerts sent to Slack

**2. Acknowledgement (30 seconds)**
- On-call engineer sees Slack alert
- Opens Pulsimo, clicks Acknowledge
- Alerts stop, pressure reduced

**3. Investigation (5 minutes)**
- Checks service logs
- Finds temporary network issue
- Service already auto-recovered

**4. Resolution (1 minute)**
- Adds note: "Temporary network blip, self-recovered"
- Clicks Resolve
- Total incident time: 6.5 minutes

---

### **Scenario 2: Complex Incident**

**1. Detection (Automatic)**
- Database service goes down
- Incident created
- Critical alerts sent immediately

**2. Acknowledgement (2 minutes)**
- DBA on-call acknowledges
- Adds note: "Checking database logs"

**3. Investigation (45 minutes)**
- Status changed to Investigating
- Multiple notes added:
  - "Disk full on database server"
  - "Clearing old logs"
  - "Attempting restart"
  - "Still failing, checking backup"

**4. Escalation (10 minutes)**
- Assigns to senior DBA
- Conference call initiated
- Multiple team members adding notes

**5. Resolution (30 minutes)**
- Root cause: Automated backup filled disk
- Fixed: Cleaned disk, adjusted backup retention
- Service restored
- Total incident time: 87 minutes

**6. Post-Mortem (Next day)**
- Generate post-mortem report
- Action items:
  - Implement disk monitoring alerts
  - Review all backup retention policies
  - Set up automated cleanup
- Share with team and management

---

## 📊 **Incident Analytics**

### **Metrics Dashboard**

**MTTR (Mean Time To Resolve)**
- Average time from detection to resolution
- Calculated across all incidents
- Trend over time (improving or degrading)
- Compare by service, project, or team

**MTTA (Mean Time To Acknowledge)**
- Average time from detection to acknowledgement
- Measures response speed
- Indicator of on-call effectiveness

**Incident Frequency**
- Total incidents per day/week/month
- Trend analysis
- Identify problematic services
- Seasonal patterns

**Incident Duration Distribution**
- Histogram showing incident lengths
- Most incidents short (good) vs. long (bad)
- Outlier identification

---

### **Incident Trends**

**By Service:**
- Which endpoints fail most frequently
- Chronic problems identification
- Candidates for improvement

**By Time:**
- Hour of day analysis
- Day of week patterns
- Correlation with deployments
- Predictive insights

**By Severity:**
- Critical vs. minor incidents ratio
- Severity creep (more severe over time)
- Impact on business

---

### **Team Performance**

**By Resolver:**
- Who resolves most incidents
- Average MTTR per person
- Workload distribution
- Training needs identification

**By Project/Team:**
- Which teams have most incidents
- Which teams resolve fastest
- Cross-team collaboration metrics

---

## 🎯 **Best Practices**

### **Acknowledgement**

**Always Acknowledge:**
- Don't let incidents stay in OPEN state
- Acknowledge immediately when you start looking
- Stops alert spam to team

**Add Context:**
- Include quick note when acknowledging
- "Looking into it now"
- "Checking logs"
- "Escalating to platform team"

**Don't Acknowledge and Forget:**
- Acknowledgement means you're actively working on it
- If you get pulled away, reassign or add note

---

### **Investigation Notes**

**Document Everything:**
- Each step you take
- What you checked
- Results of investigation
- Dead ends (what didn't work)

**Use Structured Format:**
- Timestamp actions in notes
- Use bullet points for clarity
- Include command outputs (relevant parts)
- Link to logs or dashboards

**Collaborate:**
- Read others' notes before duplicating work
- Add to existing threads
- Tag team members if needed

---

### **Resolution**

**Detailed Resolution Notes:**
- Describe what fixed the issue
- Include how to prevent recurrence
- Document any workarounds still in place
- Link to code changes or configurations

**Don't Resolve Prematurely:**
- Ensure service is stable for at least 5-10 minutes
- Verify dependent services recovered
- Check for any degraded performance
- Confirm monitoring shows healthy

**If Issue Returns:**
- Reopen original incident (continuity)
- Or create new incident and link to previous
- Document pattern recognition

---

### **Post-Mortems**

**When to Create:**
- All critical incidents (mandatory)
- High severity incidents lasting > 1 hour
- Incidents affecting customers
- Novel or interesting incidents
- Repeat incidents (pattern analysis)

**Blameless Culture:**
- Focus on systems and processes, not people
- Assume good intentions
- Learn from mistakes
- Improve continuously

**Actionable Outcomes:**
- Every post-mortem should have action items
- Assign owners and due dates
- Track completion
- Measure effectiveness

---

## 💡 **Advanced Features**

### **Incident Assignment**

**Auto-Assignment:**
- Based on on-call schedule
- Project ownership rules
- Round-robin distribution
- Workload balancing

**Manual Assignment:**
- Assign to specific user
- Reassign if needed
- Multiple assignees for major incidents

---

### **Incident Linking**

**Related Incidents:**
- Link similar incidents
- Cascade failure chains
- Repeat incident tracking
- Pattern identification

**Parent/Child Incidents:**
- Master incident for widespread outage
- Child incidents for each affected service
- Aggregate metrics
- Coordinated resolution

---

### **Incident Templates**

**Runbooks:**
- Associate runbooks with service types
- Quick access during incident
- Standard troubleshooting steps
- Reduce MTTR

**Note Templates:**
- Standard investigation format
- Quick insertion of common actions
- Ensure completeness

---

### **Incident Replay**

**Time-Travel View:**
- See incident state at any point in time
- Replay timeline visually
- Training tool for new engineers
- Root cause analysis

---

## 🆘 **Troubleshooting**

### **Incident Not Created**

**Possible Causes:**
- Failure threshold not reached
- Endpoint disabled
- Alert policy not configured

**Solutions:**
- Check endpoint configuration
- Verify failure threshold setting
- Ensure endpoint is enabled
- Review recent health checks

---

### **Cannot Acknowledge Incident**

**Possible Causes:**
- Insufficient permissions (viewer role)
- Incident already acknowledged by someone else
- Network connectivity issue

**Solutions:**
- Verify you have Member or Admin role
- Refresh page to see current state
- Contact admin for permissions

---

### **Incident Shows Resolved But Service Still Down**

**Possible Causes:**
- Different endpoint/service failed
- Intermittent failure (passed then failed again)
- Manual resolution too early

**Solutions:**
- Check Dashboard for current status
- Create new incident if service still down
- Review recent health check results
- Reopen incident if same issue

---

## 📚 **Related Documentation**

- **[Dashboard](dashboard.md)** - Monitor real-time service status
- **[Alerts](alerts.md)** - Configure notification channels
- **[Service Performance](service-performance.md)** - Analyze incident trends
- **[Dependencies](dependencies.md)** - Understand incident impact
- **[Users & RBAC](users.md)** - Incident response roles

---

**Effective incident management is the key to maintaining high reliability. Master the incident lifecycle to minimize downtime and maximize learning!** 🚨
