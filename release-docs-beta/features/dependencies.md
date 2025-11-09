# Dependencies - Service Relationship Mapping

The Dependencies feature provides powerful visualization and analysis of service relationships across your infrastructure. By automatically discovering and manually documenting how services depend on each other, you can understand blast radius, identify single points of failure, and predict cascade failures before they impact your users.

---

## 🎯 **Overview**

Modern applications rarely exist in isolation. They depend on databases, APIs, message queues, and other services to function. Understanding these relationships is critical for incident response, architecture planning, and reliability engineering. Pulsimo's dependency mapping transforms implicit relationships into explicit, visual, actionable knowledge.

### **Key Benefits**

✅ **Automatic Discovery** - AI-powered detection of service dependencies  
✅ **Visual Mapping** - Interactive graph showing all relationships  
✅ **Impact Analysis** - Understand blast radius when services fail  
✅ **Critical Path** - Identify services on the critical path to user functionality  
✅ **SPOF Detection** - Find single points of failure automatically  
✅ **Cascade Prediction** - Anticipate downstream impacts  
✅ **Architecture Documentation** - Living diagram of your infrastructure  
✅ **Planning Support** - Inform maintenance windows and deployment strategies  

---

## 📊 **Dependencies Page Components**

### **1. Page Header**

**Page Title**
- **"Service Dependencies"** - Clear identification
- **Subtitle:** "Map and analyze service relationships"

**View Toggle** (Top-left)
- **Graph View** (default) - Visual dependency graph
- **List View** - Tabular dependency listing
- **Matrix View** - Grid showing all relationships

**Action Buttons** (Top-right)
- **Add Dependency** (blue-cyan gradient) - Manual creation
- **Auto-Discover** - Trigger automatic discovery
- **Export Graph** - Download as PNG, SVG, or JSON
- **Layout Options** - Choose graph layout algorithm

---

### **2. Graph Controls Panel**

**Zoom Controls:**
- **Zoom In** (+) button
- **Zoom Out** (-) button
- **Fit to Screen** - Auto-scale to fit all nodes
- **1:1 Reset** - Return to actual size
- Mouse wheel zoom support
- Pinch-to-zoom on touch devices

**Layout Algorithms:**
- **Force-Directed** (default) - Physics-based automatic layout
- **Hierarchical** - Top-down or left-right tree structure
- **Circular** - Nodes arranged in circle
- **Grid** - Organized grid layout
- **Custom** - Manual positioning (drag and drop)

**Filter Controls:**
- **Show All Dependencies** (default)
- **Show Strong Only** - Hide weak dependencies
- **Show Critical Path** - Highlight critical services
- **Show SPOFs** - Highlight single points of failure
- **Filter by Project** - Show only selected project(s)
- **Filter by Status** - Healthy, Down, or Both

**Legend:**
- Node colors explanation
- Edge types explanation
- Icon meanings
- Status indicators

---

### **3. Interactive Dependency Graph**

#### **Nodes (Services)**

Each service appears as a node with:

**Visual Representation:**
- **Circle or Box** shape
- **Color-coded by status:**
  - 🟢 **Green** - Service healthy (UP)
  - 🔴 **Red** - Service down
  - 🟡 **Yellow** - Service degraded
  - ⚫ **Gray** - Service disabled/not monitored
- **Size** - Proportional to importance or connection count
- **Icon** - Service type icon (database, API, queue, etc.)

**Node Label:**
- Service name (truncated if long)
- Full name on hover
- Optional URL display

**Node Badges:**
- **SPOF** badge - Single point of failure
- **Critical** badge - On critical path
- **Project** badge - Project color indicator
- **Alert** badge - Has active incident

**Node Interaction:**
- **Click** - Select node, show details panel
- **Double-click** - Navigate to service details
- **Right-click** - Context menu (add dependency, view incidents, etc.)
- **Drag** - Move node (custom layout mode)
- **Hover** - Show tooltip with quick info

---

#### **Edges (Dependencies)**

Lines connecting nodes represent dependencies:

**Visual Representation:**
- **Arrow** pointing from dependent → dependency
  - Example: API → Database means "API depends on Database"
- **Color-coded by dependency type:**
  - 🔵 **Blue/Solid** - STRONG dependency (cannot function without)
  - 🟡 **Yellow/Dashed** - WEAK dependency (degraded without)
  - ⚫ **Gray/Dotted** - MONITORING dependency (just tracking)

**Edge Labels:**
- Dependency type (STRONG/WEAK/MONITORING)
- Optional description
- Discovery method (auto/manual)

**Edge Interaction:**
- **Click** - Select edge, show details
- **Hover** - Show tooltip with dependency info
- **Right-click** - Edit or delete dependency

---

#### **Special Visual Indicators**

**Critical Path Highlighting:**
- When "Show Critical Path" enabled
- Nodes on path: **Bright orange** border
- Edges on path: **Thicker, orange** lines
- Visual chain from frontend to backend

**Single Point of Failure (SPOF):**
- When detected: **Red pulsing border**
- Badge overlay: "⚠️ SPOF"
- Tooltip explains why it's a SPOF

**Cascade Failure Prediction:**
- When a service goes down
- Potentially affected services: **Yellow** highlight
- Definitely affected services (strong dependency): **Orange** highlight
- Click to see impact analysis

**Orphaned Services:**
- Services with no dependencies
- **Dotted border**
- Can be filtered to show/hide

---

### **4. Node Details Panel**

**Appears when node is selected (right sidebar):**

#### **Service Information**

**Basic Details:**
- Service name (editable)
- Service type
- URL
- Project assignment
- Current status (real-time)

**Health Metrics:**
- Current response time
- 24-hour availability
- Recent incidents count
- Last check timestamp

---

#### **Upstream Dependencies**

**Services This Service Depends On:**

List showing:
- Dependency name
- Dependency type (STRONG/WEAK/MONITORING)
- Health status
- Response time
- Description
- Actions: Edit, Remove

**Impact Statement:**
- "If [dependency] goes down, this service will..."
  - **STRONG:** "...fail completely"
  - **WEAK:** "...operate with reduced functionality"
  - **MONITORING:** "...continue normally (no functional dependency)"

---

#### **Downstream Dependencies**

**Services That Depend on This Service:**

List showing:
- Dependent service name
- Dependency type
- Health status
- Description
- Quick link to that service

**Blast Radius:**
- Number of services directly affected
- Number of services indirectly affected (cascades)
- Total potential impact if this service fails

---

#### **Dependency Actions**

**Quick Actions:**
- **Add Upstream Dependency** - This service depends on...
- **Add Downstream Dependency** - Other service depends on this...
- **View All Incidents** - Historical incidents for this service
- **View Performance** - Service performance analytics
- **Edit Service** - Modify endpoint configuration

---

### **5. Auto-Discovery System**

#### **Automatic Dependency Detection**

**How It Works:**

**Traffic Analysis:**
- Monitors network calls between services
- Detects patterns of communication
- Infers dependencies from call frequency
- Uses correlation algorithms

**Detection Methods:**
- DNS query analysis
- HTTP request patterns
- Database connection tracking
- Message queue subscriptions
- Service mesh integration (if available)

**Discovery Triggers:**
- **Scheduled:** Runs daily (configurable)
- **Manual:** Click "Auto-Discover" button
- **Continuous:** Real-time detection (enterprise feature)

---

#### **Discovered Dependencies Queue**

**Review Before Adding:**

**Pending Discoveries Table:**
- **Source Service** - The dependent
- **Target Service** - The dependency
- **Confidence Score** - AI confidence (0-100%)
- **Evidence** - Why detected (call frequency, patterns)
- **Suggested Type** - STRONG/WEAK recommendation
- **Actions:** Approve, Reject, Edit

**Bulk Actions:**
- Approve all high-confidence (>90%)
- Reject all low-confidence (<50%)
- Approve selected

**Why Manual Review?**
- Prevents false positives
- Allows correction of dependency type
- Lets you add descriptions
- Maintains data quality

---

#### **Discovery Settings**

**Configuration Options:**
- **Auto-Approve Threshold** - Auto-approve if confidence > X%
- **Detection Sensitivity** - How aggressive to detect
- **Exclusions** - Services to ignore
- **Monitoring Period** - How long to analyze traffic
- **Schedule** - When to run discovery

---

### **6. Manual Dependency Creation**

#### **Add Dependency Dialog**

**Step 1: Select Source Service**
- Dropdown or search
- "The service that depends on..."
- Shows all monitored endpoints

**Step 2: Select Target Service**
- Dropdown or search
- "The service it depends on..."
- Can be external (not monitored)

**Step 3: Choose Dependency Type**

**STRONG (Critical Dependency):**
- Source CANNOT function without target
- Example: Web app → Authentication service
- If target down, source is effectively down
- Highest severity

**WEAK (Graceful Degradation):**
- Source can function without target, but degraded
- Example: Web app → Recommendation engine
- If target down, source works but with reduced features
- Medium severity

**MONITORING (Tracking Only):**
- No functional dependency
- Just tracking relationship for documentation
- Example: Mobile app → Analytics service
- If target down, source unaffected
- Lowest severity, informational

**Step 4: Add Description (Optional)**
- Explain the dependency
- Example: "Requires authentication tokens"
- Appears in tooltips and reports

**Step 5: Set Alerts (Optional)**
- Alert when this dependency fails
- Configure notification channel
- Set failure threshold

**Step 6: Create**
- Dependency added immediately
- Appears in graph
- Audit log entry created

---

### **7. Critical Path Analysis**

#### **What is the Critical Path?**

**Definition:**
The chain of services that, if any fail, will cause end-user-facing functionality to fail.

**Example:**
```
User Browser
    ↓
Load Balancer
    ↓
API Gateway (CRITICAL)
    ↓
Auth Service (CRITICAL)
    ↓
User Database (CRITICAL)
```

If ANY service in this chain fails, users cannot authenticate → critical failure.

---

#### **How Pulsimo Identifies Critical Path**

**Algorithm:**
1. Identify user-facing services (frontend, APIs)
2. Trace all STRONG dependencies recursively
3. Mark all services on these chains as "critical"
4. Highlight in graph visualization

**Visual Indicators:**
- Orange border on critical nodes
- Thicker orange lines for critical edges
- "CRITICAL" badge
- Priority sorting in lists

**Why It Matters:**
- Focus monitoring on what really matters
- Prioritize optimization efforts
- Plan redundancy for critical services
- Inform incident response priorities

---

### **8. Single Point of Failure (SPOF) Detection**

#### **What is a SPOF?**

**Definition:**
A service that, if it fails, causes multiple other services to fail, with no redundancy.

**Characteristics:**
- Many services depend on it
- No alternative/backup available
- High blast radius

**Example:**
- Single database with no replica
- Authentication service with no failover
- Payment gateway with no backup provider

---

#### **How Pulsimo Detects SPOFs**

**Detection Criteria:**
1. Service has ≥3 downstream dependencies
2. All dependencies are STRONG type
3. No redundancy detected (no parallel services)
4. No failover configuration

**Visual Indicators:**
- Red pulsing border
- "⚠️ SPOF" badge
- Listed in SPOF widget
- Highlighted in reports

**SPOF Dashboard Widget:**
- Lists all detected SPOFs
- Blast radius (number of affected services)
- Recommendations for mitigation
- Priority for adding redundancy

---

#### **SPOF Mitigation Recommendations**

**For Each SPOF:**
- **Add Redundancy** - Deploy backup instance
- **Implement Failover** - Automatic switching
- **Circuit Breakers** - Prevent cascade failures
- **Graceful Degradation** - Design services to handle dependency failures

---

### **9. Impact Analysis**

#### **Blast Radius Calculation**

**When a Service Fails:**

**Directly Affected:**
- Services with STRONG dependency on failed service
- Will fail immediately

**Indirectly Affected:**
- Services downstream of directly affected services
- Cascade failure prediction

**Partially Affected:**
- Services with WEAK dependency on failed service
- Degraded functionality

**Visual Representation:**
- Failed service: Red
- Directly affected: Dark orange
- Indirectly affected: Light orange
- Partially affected: Yellow
- Unaffected: Green

**Impact Report:**
- Total services affected: X
- Users potentially impacted: Y (if configured)
- Revenue impact: $Z (if configured)
- Recovery priority: High/Medium/Low

---

#### **Cascade Failure Scenarios**

**Simulation Tool:**
- Select any service
- Click "Simulate Failure"
- Shows predicted impact
- Helps with planning and testing

**Use Cases:**
- Maintenance window planning
- Disaster recovery planning
- Architecture review
- Capacity planning

---

### **10. List View**

**Alternative to Graph View:**

**Dependencies Table:**

**Columns:**
- **Source Service** - The dependent
- **Dependency Type** - STRONG/WEAK/MONITORING
- **Target Service** - The dependency
- **Status** - Both services' health
- **Description** - Explanation
- **Discovery Method** - Auto/Manual
- **Created Date** - When added
- **Actions** - Edit, Delete

**Features:**
- Sortable columns
- Filter by type, project, status
- Search by service name
- Export to CSV
- Bulk operations

**When to Use List View:**
- Need tabular format for reporting
- Searching for specific dependency
- Bulk editing
- Exporting data

---

### **11. Matrix View**

**Grid Visualization:**

**Rows:** Services (Source)  
**Columns:** Services (Target)  
**Cells:** Dependency indicators

**Cell Colors:**
- 🔵 **Blue** - STRONG dependency
- 🟡 **Yellow** - WEAK dependency
- ⚫ **Gray** - MONITORING dependency
- **White/Empty** - No dependency

**Features:**
- Quickly see all relationships
- Identify clusters
- Find missing dependencies
- Symmetry analysis

**Use Cases:**
- Architecture review
- Dependency audit
- Quick reference
- Pattern identification

---

## 🎯 **Best Practices**

### **Dependency Mapping Strategy**

**Start with Critical Services:**
1. Identify user-facing services first
2. Map their immediate dependencies
3. Work backwards through the stack
4. Use auto-discovery for gap finding

**Regular Reviews:**
- Monthly dependency audit
- Update descriptions
- Verify accuracy
- Remove obsolete dependencies

**Documentation:**
- Add descriptions to all dependencies
- Explain why the dependency exists
- Document known issues or limitations
- Link to architecture diagrams

---

### **Dependency Types Guidelines**

**Use STRONG When:**
- Service cannot function at all without dependency
- Example: API → Database (data required)
- Example: Frontend → Authentication (login required)
- Results in complete failure if dependency down

**Use WEAK When:**
- Service can work with reduced functionality
- Example: E-commerce → Recommendations (nice-to-have)
- Example: Website → Analytics (tracking not critical)
- Graceful degradation possible

**Use MONITORING When:**
- No functional dependency
- Just tracking for awareness
- Example: Service → Logging system
- Example: App → Metrics collector

---

### **Architecture Improvements**

**Reduce SPOFs:**
- Add redundancy to identified SPOFs
- Implement database replication
- Deploy services in HA mode
- Use load balancers

**Simplify Dependencies:**
- Reduce unnecessary dependencies
- Combine similar services
- Use caching to reduce dependency calls
- Implement circuit breakers

**Design for Failure:**
- Assume dependencies will fail
- Implement retry logic
- Use timeouts appropriately
- Build fallback mechanisms

---

## 💡 **Advanced Features**

### **Dependency Versioning**

**Track Changes Over Time:**
- Historical dependency graph snapshots
- Compare current vs. previous architecture
- Identify architecture evolution
- Rollback if needed

---

### **External Dependencies**

**Non-Monitored Services:**
- Add third-party APIs
- Document cloud services
- Track external SaaS dependencies
- Import from architecture tools

---

### **Dependency Health Score**

**Calculate Overall Health:**
- Based on uptime of all dependencies
- Weighted by dependency type
- Predictive health scoring
- Trend analysis

---

### **Integration with Incidents**

**Automatic Correlation:**
- When service fails, check dependencies
- Suggest root cause (upstream failure)
- Link related incidents
- Faster resolution

---

## 🆘 **Troubleshooting**

### **Graph Not Rendering**

**Possible Causes:**
- Too many nodes (performance)
- Browser compatibility
- JavaScript errors

**Solutions:**
- Filter to specific project
- Use List View instead
- Try different browser
- Clear browser cache

---

### **Auto-Discovery Finding Nothing**

**Possible Causes:**
- Not enough traffic data
- Services not communicating during analysis period
- Network monitoring not enabled

**Solutions:**
- Extend monitoring period
- Trigger some traffic manually
- Check network monitoring configuration
- Use manual dependency creation

---

### **Incorrect Dependencies Detected**

**Possible Causes:**
- Correlation not causation
- Test traffic included
- Shared infrastructure

**Solutions:**
- Review pending discoveries carefully
- Reject false positives
- Add to exclusion list
- Adjust detection sensitivity

---

## 📚 **Related Documentation**

- **[Dashboard](dashboard.md)** - Service status in dependency context
- **[Incidents](incidents.md)** - Impact analysis during incidents
- **[Service Performance](service-performance.md)** - Dependency performance tracking
- **[Projects](projects.md)** - Project-level dependencies
- **[Alerts](alerts.md)** - Dependency failure alerts

---

**Understanding your service dependencies is understanding your architecture. Map them well to build resilience, respond faster, and plan better!** 🔗
