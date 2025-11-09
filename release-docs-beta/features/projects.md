# Projects - Service Organization & Management

Projects provide a powerful way to organize your monitoring endpoints by application, team, environment, or any logical grouping that matches your infrastructure. This feature enables better collaboration, clearer ownership, and more efficient monitoring at scale.

---

## 🎯 **Overview**

Projects act as containers for related endpoints, allowing you to group services that belong together and manage them as a cohesive unit. Whether you're organizing by product line, development team, geographic region, or deployment environment, projects provide the structure needed for enterprise-scale monitoring.

### **Key Benefits**

✅ **Logical Organization** - Group endpoints by any criteria that makes sense  
✅ **Team Ownership** - Assign projects to specific teams for clear responsibility  
✅ **Filtered Views** - See only what matters to your current context  
✅ **Aggregate Metrics** - Track SLA and performance at project level  
✅ **Access Control** - Control visibility with role-based permissions  
✅ **Visual Identification** - Color-coded projects for quick recognition  
✅ **Scalability** - Manage hundreds of endpoints without confusion  

---

## 📊 **Projects Page Components**

### **1. Page Header**

**Page Title**
- **"Projects"** - Clear identification
- **Subtitle:** "Organize and manage your monitoring endpoints"

**Action Buttons**
- **New Project Button** (blue-cyan gradient, top-right)
  - Opens project creation dialog
  - Primary action for the page
  - Accessible to Admin and Member roles

**Stats Summary Bar**
- **Total Projects** - Number of projects created
- **Active Endpoints** - Total endpoints across all projects
- **Healthy Projects** - Projects with 100% endpoints UP
- **Projects with Issues** - Projects with one or more endpoints DOWN

---

### **2. Projects Grid View**

The main content area displays all projects as cards in a responsive grid layout.

#### **Project Card Components**

Each project card shows:

**Visual Header**
- **Color Accent Bar** - Top border matching project color theme
- **Project Icon** - Visual identifier (folder, app, server icons)
- **Project Name** - Bold, prominent display
- **Description** - Brief project overview (2-3 lines)

**Status Overview**
- **Total Endpoints** - Count of services in this project
- **Health Status Breakdown:**
  - 🟢 **Healthy** - Number of UP endpoints
  - 🔴 **Down** - Number of DOWN endpoints
  - 🟡 **Degraded** - Number of partially failing endpoints

**Performance Metrics**
- **Overall Uptime** - Project-wide availability percentage
- **Response Time** - Average across all endpoints
- **SLA Compliance** - Whether meeting 99.9% target

**Metadata Display**
- **Priority Badge** - High, Medium, or Low
- **Tags** - Keyword labels for categorization
- **Created Date** - When project was created
- **Last Updated** - Most recent modification

**Quick Actions**
- **View Details** - Navigate to project detail page
- **Add Endpoint** - Create new endpoint in this project
- **Edit** - Modify project configuration
- **Archive** - Hide inactive projects

---

### **3. Project Statistics Dashboard**

**Aggregate View Section** (above project grid)

**Overall Health Score**
- Calculated across all projects
- Visual progress ring showing percentage
- Color-coded (green > 95%, yellow 90-95%, red < 90%)

**Top Performing Projects**
- List of projects with highest uptime
- Shows top 3-5 projects
- Links to project details

**Projects Requiring Attention**
- Projects with incidents
- Projects below SLA threshold
- Recently degraded projects
- Quick action links to investigate

**Trends Graph**
- 7-day or 30-day project health trends
- Line chart showing health percentage over time
- Filter by individual project or view all

---

### **4. Filter and Search Controls**

**Search Bar**
- Search projects by name
- Search by tags or description
- Fuzzy matching support
- Real-time results as you type

**Filter Options**

**By Health Status**
- All Projects
- Healthy Only (100% uptime)
- With Issues (any endpoints down)
- Critical Only (multiple endpoints down)

**By Priority**
- All Priorities
- High Priority
- Medium Priority
- Low Priority

**By SLA Status**
- Meeting SLA (>99.9%)
- Below SLA
- At Risk (95-99.9%)

**Sort Options**
- Alphabetical (A-Z, Z-A)
- Health Status (best to worst)
- Number of Endpoints (most to least)
- Last Updated (newest first)
- Created Date (oldest/newest)

---

### **5. Project Detail View**

Click any project card to open the detailed project view.

#### **Project Overview Section**

**Header Area**
- **Project Name** (editable inline)
- **Edit Button** - Modify project details
- **Archive Button** - Deactivate project
- **Share Button** - Share project view URL
- **Color Selector** - Change project theme color

**Metadata Panel**
- **Description** (full text, editable)
- **Priority Level** (dropdown to change)
- **Tags** (add/remove keywords)
- **Created By** - User who created it
- **Created Date** - Timestamp
- **Last Modified** - Recent update timestamp

---

#### **Endpoints List**

**Endpoints in This Project** section

Shows all endpoints assigned to this project in a detailed table:

**Columns:**
- **Name** - Endpoint friendly name
- **URL** - Monitored endpoint
- **Type** - Service type (HTTP, Database, etc.)
- **Status** - Current health status (UP/DOWN/CHECKING)
- **Response Time** - Latest check response time
- **Uptime** - 24-hour availability percentage
- **Last Check** - Timestamp of most recent check
- **Actions** - Quick actions (edit, test, remove from project)

**Table Features:**
- Sortable columns (click header to sort)
- Inline status updates (real-time)
- Bulk selection for operations
- Export to CSV functionality

**Bulk Actions:**
- Move selected endpoints to another project
- Test all selected endpoints now
- Change alert policies for selected
- Remove from project

---

#### **Project Performance Analytics**

**Performance Dashboard** (tab within project detail)

**Availability Trends**
- 7-day, 30-day, 90-day views
- Line chart showing project-wide uptime
- Target SLA line overlay (99.9%)
- Highlight periods below threshold

**Response Time Analysis**
- Average response time over time
- Breakdown by endpoint
- Identify slowest services
- Compare against baselines

**Incident History**
- All incidents affecting this project
- Timeline view of outages
- Impact analysis (how many endpoints affected)
- MTTR for this project
- Trends (increasing or decreasing incidents)

**SLA Compliance Report**
- Monthly compliance percentage
- Days meeting SLA vs. days below
- Total downtime minutes
- Financial impact (if configured)
- Export compliance report

---

#### **Project Dependencies**

**Dependencies Tab** within project detail

**Services This Project Depends On**
- Upstream dependencies
- Services outside this project that this project needs
- Dependency type (STRONG, WEAK, MONITORING)
- Health status of each dependency

**Services Depending on This Project**
- Downstream consumers
- Other projects/services that rely on this project
- Impact radius if this project goes down

**Dependency Graph**
- Visual representation of project relationships
- Click to navigate to dependency details
- Highlight critical paths
- Show single points of failure

---

## 🔄 **Creating and Managing Projects**

### **Creating a New Project**

**Step 1: Open Creation Dialog**
1. Navigate to Projects page
2. Click **"New Project"** button (top-right)
3. Dialog opens with project creation form

**Step 2: Basic Information**

**Project Name** (Required)
- Descriptive name for the project
- Examples: "Production Web Services", "Mobile API Backend", "Payment Processing"
- Should be unique and meaningful
- 3-100 characters

**Description** (Optional)
- Detailed overview of what this project monitors
- Explain purpose, scope, and ownership
- 0-500 characters
- Supports markdown formatting

**Step 3: Visual Configuration**

**Project Color**
- Choose from predefined color palette
- Or use custom color picker
- Colors help with visual identification
- Used in cards, badges, and graphs

**Project Icon** (Optional)
- Select from icon library
- Upload custom icon (SVG, PNG)
- Default: Folder icon
- Used in project cards and navigation

**Step 4: Organizational Details**

**Priority Level**
- **High** - Critical business services
- **Medium** - Important but not critical
- **Low** - Nice-to-have monitoring
- Affects sorting and filtering

**Tags**
- Add relevant keywords
- Examples: production, api, customer-facing, internal
- Used for filtering and organization
- Multiple tags supported

**Owner/Team** (if RBAC enabled)
- Assign project ownership to specific users
- Define which team is responsible
- Used for access control and notifications

**Step 5: SLA Configuration**

**Target Uptime**
- Default: 99.9% (Three nines)
- Options: 99%, 99.5%, 99.9%, 99.95%, 99.99%
- Used for compliance tracking

**Alert on SLA Breach**
- Enable/disable alerts when falling below SLA
- Configure notification channel
- Set breach threshold (e.g., alert when < 99.5%)

**Step 6: Initial Endpoints** (Optional)

- Add endpoints immediately
- Or add them later from Dashboard
- Bulk import from CSV (if available)

**Step 7: Review and Create**

- Review all settings
- Click **"Create Project"** button
- Project created immediately
- Redirected to project detail view

---

### **Editing a Project**

**Access Edit Mode:**
- From Projects page: Click project card → Click Edit button
- From Project detail view: Click Edit button (top-right)

**Editable Fields:**
- Project name
- Description
- Color theme
- Icon
- Priority level
- Tags
- SLA target
- Owner/team assignment

**Changes Apply Immediately:**
- No need to save separately
- Visual updates reflect in real-time
- History tracked in audit log

---

### **Archiving Projects**

**When to Archive:**
- Project no longer active
- Application decommissioned
- Temporary monitoring completed
- Reorganizing project structure

**Archive Process:**
1. Open project detail view
2. Click **"Archive"** button
3. Confirm archival
4. Project hidden from main view
5. Endpoints remain active (or bulk pause option)

**Archived Project Behavior:**
- Not shown in default project list
- Accessible via "Show Archived" filter
- Can be restored anytime
- Historical data preserved
- Endpoints can be moved to other projects

**Restoring Archived Projects:**
- Navigate to Projects page
- Enable "Show Archived" filter
- Find archived project
- Click "Restore" button
- Project returns to active state

---

### **Deleting Projects**

**Delete vs. Archive:**
- **Archive** - Recommended, reversible, preserves data
- **Delete** - Permanent, cannot be undone, removes project metadata

**Delete Process:**
1. Must archive first (safety measure)
2. From archived state, click "Delete Permanently"
3. Confirm deletion with project name
4. Warning about endpoints (orphaned or deleted)
5. Final confirmation required

**What Happens to Endpoints:**
- Option 1: Move to another project
- Option 2: Leave without project (orphaned)
- Option 3: Delete all endpoints in project
- User must choose before deletion proceeds

**Permanent Deletion:**
- Project metadata removed
- Historical data retained (for compliance)
- Cannot be recovered
- Audit log entry created

---

## 📊 **Project Organization Strategies**

### **By Environment**

Organize projects by deployment stage:

**Production Project**
- All customer-facing services
- High priority
- Strictest SLA targets (99.99%)
- Critical alert channels

**Staging Project**
- Pre-production testing environment
- Medium priority
- More relaxed SLA (99.5%)
- Team notifications only

**Development Project**
- Developer sandbox services
- Low priority
- No SLA targets
- Optional monitoring

**Benefits:**
- Clear separation of concerns
- Different alerting strategies per environment
- Easy to see production health at a glance

---

### **By Application/Product**

Organize by business application:

**Web Application Project**
- Frontend services
- API gateway
- CDN endpoints

**Mobile Backend Project**
- Mobile-specific APIs
- Push notification service
- Authentication service

**Payment Processing Project**
- Payment gateway
- Fraud detection
- Transaction database

**Benefits:**
- Team ownership alignment
- Product-specific metrics
- Business impact analysis

---

### **By Technology Stack**

Organize by technical architecture:

**Microservices Project**
- All microservice endpoints
- Service mesh monitoring
- Inter-service dependencies

**Databases Project**
- PostgreSQL instances
- Redis clusters
- MongoDB databases

**Message Queues Project**
- Kafka brokers
- RabbitMQ nodes
- Redis pub/sub

**Benefits:**
- Technology-specific monitoring
- Specialized alert policies
- Infrastructure team ownership

---

### **By Geographic Region**

Organize by deployment location:

**US-East Project**
- Services in AWS us-east-1
- Low latency for US customers

**EU-West Project**
- Services in AWS eu-west-1
- GDPR-compliant services

**Asia-Pacific Project**
- Services in AWS ap-southeast-1
- Local compliance requirements

**Benefits:**
- Region-specific performance tracking
- Compliance and data sovereignty
- Regional incident management

---

### **By Customer Tier**

Organize by customer segment:

**Enterprise Customers Project**
- Dedicated infrastructure
- Highest SLA (99.99%)
- Immediate escalation

**Standard Customers Project**
- Shared infrastructure
- Standard SLA (99.9%)
- Normal alert flow

**Free Tier Project**
- Best-effort monitoring
- No SLA guarantees
- Low-priority alerts

**Benefits:**
- Customer-centric monitoring
- Prioritized incident response
- Revenue-aligned reliability

---

## 🎯 **Best Practices**

### **Project Naming Conventions**

**Recommended Patterns:**
- `[Environment]-[Application]` - Example: "Prod-WebApp"
- `[Team]-[Service]` - Example: "Platform-AuthService"
- `[Region]-[Stack]` - Example: "USEast-Databases"

**Avoid:**
- Generic names like "Project 1", "Test"
- Overly long names (keep under 30 characters)
- Special characters that don't render well
- Names that will change frequently

---

### **Endpoint Assignment**

**One Project per Endpoint:**
- Assign each endpoint to exactly one project
- Avoid duplicating endpoints across projects
- Use tags for cross-cutting concerns

**Logical Grouping:**
- Group endpoints that share fate
- Keep related services together
- Consider dependency relationships

**Size Guidelines:**
- **Small projects:** 5-15 endpoints (typical microservice)
- **Medium projects:** 15-50 endpoints (larger application)
- **Large projects:** 50-200 endpoints (full platform)
- **Very large:** Consider splitting into sub-projects

---

### **Color and Visual Organization**

**Color Strategy:**
- **Red/Orange** - Production or critical services
- **Blue/Cyan** - Standard applications
- **Green** - Development or test environments
- **Purple** - Infrastructure or platform services
- **Yellow** - Monitoring or observability

**Consistent Palette:**
- Use same colors for similar project types
- Create visual rhythm in project grid
- Make important projects stand out
- Avoid too many different colors (limit to 5-7)

---

### **SLA Configuration**

**Target Selection:**
- **99.9% (Three nines)** - Standard for production services
- **99.95%** - Critical business services
- **99.99% (Four nines)** - Financial or healthcare applications
- **99.5%** - Non-critical services

**Realistic Targets:**
- Don't set unrealistic SLA targets
- Consider dependencies (can't exceed weakest link)
- Allow for planned maintenance windows
- Review and adjust based on actual performance

---

### **Regular Review**

**Monthly Project Review:**
- Review active projects list
- Archive completed or obsolete projects
- Update descriptions and metadata
- Verify endpoint assignments
- Check SLA compliance

**Quarterly Reorganization:**
- Evaluate if project structure still makes sense
- Merge or split projects as needed
- Update priorities based on business changes
- Clean up orphaned endpoints

---

## 📱 **Responsive Design**

### **Desktop View** (> 1200px)
- **Grid:** 3-4 project cards per row
- **Full details:** All metrics visible on cards
- **Sidebar navigation:** Always visible
- **Hover effects:** Rich interactions

### **Tablet View** (768px - 1200px)
- **Grid:** 2 project cards per row
- **Condensed metrics:** Priority info only
- **Collapsible sidebar:** More screen space
- **Touch-friendly:** Larger tap targets

### **Mobile View** (< 768px)
- **Stack:** 1 project card per row
- **Essential info:** Name, status, endpoints count
- **Bottom sheet:** Project details slide up
- **Swipe actions:** Quick edit/archive

---

## 🔍 **Search and Discovery**

### **Full-Text Search**

Search across:
- Project names
- Descriptions
- Tags
- Endpoint names within projects

**Search Examples:**
- "production" - Finds all production projects
- "api" - Finds projects containing APIs
- "payment" - Finds payment-related projects

---

### **Advanced Filtering**

**Combine Multiple Filters:**
- Priority = High AND Status = With Issues
- Environment = Production AND SLA < 99.9%
- Team = Platform AND Endpoints > 20

**Saved Filters:**
- Save commonly used filter combinations
- Quick access to saved views
- Share filter URLs with team

---

## 💡 **Advanced Features**

### **Project Templates**

**Create Templates:**
- Define standard project structures
- Pre-configure SLA targets
- Set default alert policies
- Include common tags

**Use Templates:**
- Select template when creating project
- All settings auto-populated
- Customize as needed
- Ensures consistency

---

### **Bulk Operations**

**Select Multiple Projects:**
- Checkbox selection mode
- Select all/none/inverse
- Filter then select all visible

**Bulk Actions:**
- Change priority
- Add/remove tags
- Archive multiple projects
- Export data
- Assign to team/owner

---

### **Project Cloning**

**Clone Existing Project:**
- Copy all settings
- Option to copy endpoints
- Useful for creating similar environments
- Saves configuration time

**Clone Options:**
- Clone with endpoints (exact copy)
- Clone structure only (no endpoints)
- Clone and modify (wizard-based)

---

### **Access Control Integration**

**Project-Level Permissions:**
- Admin: Full control over project
- Member: Can view and add endpoints
- Viewer: Read-only access

**Team Assignment:**
- Assign projects to specific teams
- Team members auto-granted access
- Inherit from organization structure

---

## 🆘 **Troubleshooting**

### **Projects Not Showing**

**Possible Causes:**
- Filters active (check filter bar)
- Projects archived
- Permission issues (viewer role)

**Solutions:**
1. Clear all filters
2. Check "Show Archived" option
3. Verify your role permissions
4. Ask admin for access

---

### **Cannot Create Project**

**Possible Causes:**
- Insufficient permissions (viewer/member role)
- Organization limit reached
- Network connectivity issue

**Solutions:**
1. Verify you have Admin or Member role
2. Check organization plan limits
3. Contact admin to increase project limit
4. Retry after refreshing page

---

### **Endpoints Not Appearing in Project**

**Possible Causes:**
- Endpoint not assigned to project
- Endpoint deleted
- Filter hiding endpoints

**Solutions:**
1. Edit endpoint and verify project assignment
2. Check if endpoint exists in Dashboard
3. Clear filters in project detail view
4. Refresh page to sync data

---

### **SLA Metrics Incorrect**

**Possible Causes:**
- Calculation period mismatch
- Recent endpoint additions/removals
- Maintenance windows not excluded
- Data sync delay

**Solutions:**
1. Verify calculation period setting
2. Wait for metrics to stabilize (24 hours for new endpoints)
3. Configure maintenance windows properly
4. Check if planned downtime is excluded from SLA

---

## 📊 **Understanding Project Metrics**

### **Overall Uptime Calculation**

**Formula:**
```
Project Uptime = (Sum of all endpoint successful checks) / (Sum of all endpoint total checks)
```

**Example:**
- Endpoint A: 1440/1440 checks = 100%
- Endpoint B: 1430/1440 checks = 99.3%
- Endpoint C: 1440/1440 checks = 100%
- **Project Uptime:** (4310/4320) = **99.77%**

**Factors:**
- All endpoints weighted equally
- Calculated over selected time period
- Excludes maintenance windows
- Real-time updates

---

### **Health Score**

**Components:**
- Availability (50% weight)
- Response time performance (30% weight)
- Incident frequency (20% weight)

**Score Range:**
- **90-100:** Excellent (Green)
- **75-90:** Good (Light Green)
- **60-75:** Fair (Yellow)
- **Below 60:** Poor (Red)

**Use Cases:**
- Quick health assessment
- Compare projects
- Track improvement trends
- Set alert thresholds

---

### **SLA Compliance**

**Meeting SLA:**
- Actual uptime >= Target uptime
- Example: 99.92% actual vs. 99.9% target = **Compliant**

**Below SLA:**
- Actual uptime < Target uptime
- Example: 99.85% actual vs. 99.9% target = **Non-Compliant**

**At Risk:**
- Within 0.5% of target
- Example: 99.91% actual vs. 99.9% target = **At Risk**

---

## 🎓 **Training Guide**

### **For New Users**

**Week 1: Understanding Projects**
- Learn what projects are and why they matter
- Explore existing projects
- Understand project cards and metrics
- Practice filtering and searching

**Week 2: Creating Projects**
- Create your first project
- Assign endpoints to project
- Configure SLA targets
- Set up project colors and tags

**Week 3: Project Management**
- Review project health regularly
- Update project descriptions
- Archive old projects
- Use project filters effectively

**Week 4: Advanced Usage**
- Set up project templates
- Use bulk operations
- Configure team access
- Export project reports

---

## 📚 **Related Documentation**

- **[Dashboard](dashboard.md)** - View endpoints by project
- **[Incidents](incidents.md)** - Project-level incident tracking
- **[Service Performance](service-performance.md)** - Project analytics
- **[Dependencies](dependencies.md)** - Cross-project dependencies
- **[Users & RBAC](users.md)** - Project access control

---

**Projects are the foundation of organized monitoring. Master them to scale your observability efforts effectively!** 🎯
