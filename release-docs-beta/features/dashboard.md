# Dashboard - Real-Time Service Monitoring

The Dashboard is your central command center for monitoring all services in real-time. It provides instant visibility into your entire infrastructure's health with live updates and intuitive visual indicators.

---

## 🎯 **Overview**

The Dashboard displays all monitored endpoints with their current health status, response times, and availability metrics. Built with WebSocket technology, it updates automatically without requiring page refreshes, ensuring you always see the latest state of your infrastructure.

### **Key Benefits**

✅ **Instant Visibility** - See all service statuses at a glance  
✅ **Real-Time Updates** - WebSocket-powered live data streaming  
✅ **Quick Actions** - Add endpoints and refresh data with one click  
✅ **Smart Organization** - Filter and group by projects, status, or tags  
✅ **Performance Metrics** - Response times and uptime percentages  
✅ **Visual Indicators** - Color-coded status badges and countdown timers  

---

## 📊 **Dashboard Components**

### **1. Header Section**

**Page Title**
- **"Service Dashboard"** - Clear identification
- **Subtitle:** "Monitor all your services in real-time"

**Action Buttons**
- **Refresh Button** (circular arrow icon)
  - Manually triggers data refresh
  - Useful after making configuration changes
  - Located top-right corner
  
- **Add Endpoint Button** (blue-cyan gradient)
  - Primary action button
  - Opens endpoint creation dialog
  - Located top-right, next to refresh

---

### **2. Stats Overview Cards**

Four summary cards displaying aggregate metrics:

#### **Total Endpoints**
- **What It Shows:** Total number of monitored services
- **Color Theme:** Blue gradient
- **Icon:** Server/grid icon
- **Updates:** Real-time as endpoints added/removed

#### **Healthy (UP)**
- **What It Shows:** Services currently passing health checks
- **Color Theme:** Green
- **Icon:** Checkmark
- **Calculation:** Endpoints with status "UP"

#### **Down**
- **What It Shows:** Services currently failing health checks
- **Color Theme:** Red
- **Icon:** Alert/X icon
- **Calculation:** Endpoints with status "DOWN"
- **Triggers:** Incident creation when threshold exceeded

#### **Partial Outage**
- **What It Shows:** Services with degraded performance
- **Color Theme:** Yellow/Orange
- **Icon:** Warning triangle
- **Calculation:** Endpoints with intermittent failures

**Visual Design:**
- Clean card layout with rounded corners
- Large numbers for quick scanning
- Icons provide visual context
- Hover effects for interactivity

---

### **3. Incident Widget**

**Location:** Below stats cards, above service grid

**Purpose:** Show active incidents requiring attention

**What You See:**
- Number of open incidents
- Critical incidents highlighted
- Recently acknowledged incidents
- Quick link to Incidents page

**States:**
- **No Incidents:** Green checkmark, "All systems operational"
- **Open Incidents:** Red alert icon, count of incidents
- **Acknowledged:** Yellow icon, showing ownership

---

### **4. Projects Section**

**When Visible:** If you have created projects

**Purpose:** Quick navigation to project-organized views

**Features:**
- **Project Cards** displaying:
  - Project name and color indicator
  - Number of endpoints in project
  - Number of healthy/down endpoints
  - Quick link to Projects page
  
- **Visual Design:**
  - Horizontal scrollable carousel
  - Color accent bar matching project theme
  - Hover effects revealing more details
  - "View All" link to Projects page

---

### **5. Service Cards Grid**

**The Main Dashboard Area**

Each monitored endpoint displays as an individual card showing:

#### **Service Identification**

**Service Name**
- Bold, prominent display
- Truncated if too long (hover to see full name)
- Clickable to open endpoint details

**Endpoint URL**
- Secondary text below name
- Shows full URL or truncated version
- Indicates the actual monitored endpoint

**Service Type Badge**
- Visual indicator of service type
- Examples: HTTP, Database, Kafka, Redis, Elasticsearch
- Color-coded by type

---

#### **Status Indicator**

**Status Badge** (Top-right of card)

Three possible states:

**🟢 UP (Green)**
- Service is healthy and responding
- Background: Green
- Text: "UP"
- Indicates last check was successful

**🔴 DOWN (Red)**
- Service is failing health checks
- Background: Red
- Text: "DOWN"
- Indicates failures exceeded threshold

**🔵 CHECKING (Blue)**
- Health check currently in progress
- Background: Blue with pulse animation
- Text: "CHECKING"
- Typically visible for 1-3 seconds

---

#### **Response Time Metrics**

**Current Response Time**
- Displayed in milliseconds (ms)
- Large, prominent number
- Example: "145 ms"

**Color Coding:**
- **Green (< 200ms):** Excellent performance
- **Yellow (200-500ms):** Acceptable performance
- **Orange (500-1000ms):** Slow, needs attention
- **Red (> 1000ms):** Very slow, investigate

**Trend Indicator**
- Small arrow showing if response time improving or degrading
- ↗️ Getting slower (red arrow)
- ↘️ Getting faster (green arrow)

---

#### **Availability Metrics**

**Uptime Percentage**
- Shows 24-hour availability
- Format: "99.9%" or "100%"
- Calculated from successful checks / total checks

**Uptime Bar**
- Visual representation of uptime
- Green bar fills based on percentage
- Segments show recent check results
- Hover to see details

---

#### **Check Information**

**Check Interval**
- How often the endpoint is checked
- Format: "Every 10 seconds" or "Every 1 minute"
- Configurable per endpoint

**Last Checked**
- Timestamp of most recent health check
- Format: "2 seconds ago" or "5 minutes ago"
- Updates in real-time

**Next Check Countdown**
- Live countdown timer to next check
- Format: "Next check in 8s"
- Animates down to zero, then resets
- Changes to "Checking..." during health check
- Resumes countdown after check completes

---

#### **Additional Indicators**

**Project Badge**
- Shows which project this endpoint belongs to
- Color matches project theme
- Click to filter by project

**Tags**
- Keyword labels for categorization
- Examples: production, api, critical
- Click to filter by tag

**Alert Policy Indicator**
- Small icon showing if alerts configured
- Bell icon with badge showing failure threshold
- Example: "🔔 3" means alert after 3 failures

---

### **6. Service Card Actions**

**Hover State**
- Card elevation increases (shadow effect)
- Action buttons become visible
- Subtle highlight effect

**Click Actions**
- **Click Card:** Opens detailed endpoint view
- **Click URL:** Opens endpoint in new tab (if public)
- **Quick Actions:**
  - **View History:** See past health checks
  - **Edit:** Modify endpoint configuration
  - **Test Now:** Trigger immediate health check

---

## 🔄 **Real-Time Update Mechanism**

### **WebSocket Connection**

The Dashboard maintains a persistent WebSocket connection for live updates:

**What Updates Automatically:**
- ✅ Status badge changes (UP/DOWN/CHECKING)
- ✅ Response time values
- ✅ Last checked timestamps
- ✅ Countdown timers
- ✅ Stats overview numbers
- ✅ Incident widget counts

**Update Frequency:**
- **Instant:** Status changes appear immediately
- **Live:** Countdown timers update every second
- **Real-Time:** Response times update after each check

**Connection Indicators:**
- **Green dot:** WebSocket connected
- **Yellow dot:** Connecting/reconnecting
- **Red dot:** Connection lost (manual refresh required)

---

## 🎨 **Visual Feedback**

### **Status Color System**

Consistent color coding throughout the dashboard:

**Green** (Success)
- Service UP and healthy
- Response time < 200ms
- 99%+ uptime

**Yellow** (Warning)
- Response time slow (200-500ms)
- Uptime 95-99%
- Degraded performance

**Red** (Critical)
- Service DOWN
- Response time > 1000ms
- Uptime < 95%

**Blue** (In Progress)
- Health check currently running
- Data loading

**Gray** (Inactive)
- Endpoint paused/disabled
- No recent checks

---

### **Animation Effects**

**Pulse Animation**
- Applied to "CHECKING" status badge
- Indicates active health check
- Smooth fade in/out effect

**Countdown Animation**
- Timer decreases smoothly
- Changes color approaching zero
- Briefly highlights when reaching zero

**Transition Effects**
- Status changes fade between states
- Card hover elevates with shadow
- Buttons scale slightly on hover

---

## 🔍 **Filtering and Search**

### **Filter Bar** (Top of service grid)

**Filter Options:**

**By Status**
- All Services
- UP Only
- DOWN Only
- Partial Outage

**By Service Type**
- All Types
- HTTP/HTTPS
- Database
- Message Queue
- Custom

**By Project**
- All Projects
- Select specific project
- No Project (unassigned)

**By Tags**
- Select one or multiple tags
- Shows endpoints with ANY selected tag
- Clear all tags option

---

### **Search Bar**

**Location:** Top of service grid, left side

**Search Capabilities:**
- **By Name:** Searches endpoint names
- **By URL:** Searches endpoint URLs
- **Fuzzy Matching:** Tolerant of typos
- **Live Results:** Updates as you type

**Example Searches:**
- "api" - Finds all API endpoints
- "production" - Finds tagged with production
- "health" - Finds endpoints with "health" in URL

---

## 📱 **Responsive Design**

### **Desktop View (> 1200px)**

- **Grid Layout:** 3-4 cards per row
- **Full Stats:** All metrics visible
- **Sidebar:** Projects sidebar always visible
- **Hover Actions:** Visible on hover

### **Tablet View (768px - 1200px)**

- **Grid Layout:** 2 cards per row
- **Condensed Stats:** Priority metrics only
- **Collapsible Sidebar:** Projects menu collapsed
- **Touch Actions:** Buttons always visible

### **Mobile View (< 768px)**

- **Stack Layout:** 1 card per row
- **Compact Stats:** Essential metrics only
- **Hamburger Menu:** Navigation in drawer
- **Touch Optimized:** Large touch targets

---

## ⚡ **Quick Actions**

### **Bulk Operations**

**Select Multiple Endpoints:**
1. Enable selection mode (checkbox icon)
2. Click checkboxes on desired endpoint cards
3. Action bar appears with options:
   - Pause All Selected
   - Test All Selected
   - Tag All Selected
   - Delete All Selected

### **Right-Click Context Menu**

Right-click any service card for quick actions:
- Open Endpoint Details
- Test Now
- View Health History
- Edit Configuration
- Pause Monitoring
- Create Dependency
- View Dependencies
- Copy Endpoint ID

---

## 📊 **Status Interpretation Guide**

### **Understanding the Dashboard**

**Scenario 1: All Green**
- ✅ **Meaning:** All services healthy
- 🎯 **Action:** No action required, routine monitoring
- 📈 **Indicator:** High confidence in system health

**Scenario 2: Mixed Status**
- ⚠️ **Meaning:** Some services degraded
- 🎯 **Action:** Investigate DOWN services immediately
- 📈 **Indicator:** Check dependencies for cascade effects

**Scenario 3: Multiple DOWN**
- 🚨 **Meaning:** Potential widespread issue
- 🎯 **Action:** Check infrastructure, network, or platform issue
- 📈 **Indicator:** Look for common dependencies

**Scenario 4: Flickering Status**
- 🔄 **Meaning:** Intermittent failures
- 🎯 **Action:** Check network stability, adjust timeout settings
- 📈 **Indicator:** May indicate capacity or performance issues

---

## 🎯 **Best Practices**

### **Dashboard Usage**

**Daily Monitoring:**
- ✅ Check dashboard first thing each morning
- ✅ Keep dashboard open during work hours
- ✅ Set up secondary display dedicated to dashboard
- ✅ Enable browser notifications for status changes

**Alert Response:**
- ✅ Acknowledge incidents from dashboard
- ✅ Check dependencies before diving into single service
- ✅ Use filters to isolate affected project/type
- ✅ Document observations in incident notes

**Organization:**
- ✅ Use consistent naming conventions for endpoints
- ✅ Tag endpoints by criticality (critical, high, medium, low)
- ✅ Organize by project for team ownership
- ✅ Remove or archive unused endpoints

---

### **Performance Optimization**

**For Large Deployments (100+ endpoints):**

1. **Use Filtering Aggressively**
   - Filter by project for focused monitoring
   - Create saved filter views
   - Use tags for quick categorization

2. **Adjust Check Intervals**
   - 10s for critical services only
   - 30-60s for standard services
   - 5min for non-critical services

3. **Pagination**
   - Dashboard auto-paginates at 50 endpoints
   - Use "Show More" to load additional cards
   - Improves browser performance

---

## 🆘 **Troubleshooting**

### **Dashboard Not Updating**

**Symptom:** Status stuck, counters not moving

**Causes:**
- WebSocket connection lost
- Browser tab inactive too long
- Network connectivity issue

**Solutions:**
1. Click Refresh button (top-right)
2. Check connection indicator (should be green)
3. Reload the page (Ctrl+R / Cmd+R)
4. Check browser console for errors

---

### **Incorrect Status Shown**

**Symptom:** Service shows DOWN but is actually UP

**Causes:**
- Authentication not configured
- Firewall blocking health checks
- Wrong expected status code
- Timeout too short

**Solutions:**
1. Click the service card to view details
2. Check "Recent Health Check Results"
3. Look for error messages
4. Verify authentication configuration
5. Test endpoint manually with curl

---

### **Slow Dashboard Loading**

**Symptom:** Cards take long time to appear

**Causes:**
- Too many endpoints (100+)
- Slow network connection
- Browser performance issues

**Solutions:**
1. Use project filters to reduce visible endpoints
2. Enable pagination in settings
3. Close other browser tabs
4. Clear browser cache
5. Use Chrome/Firefox for best performance

---

## 💡 **Advanced Features**

### **Keyboard Shortcuts**

- **`R`** - Refresh dashboard
- **`A`** - Add new endpoint
- **`F`** - Focus search bar
- **`ESC`** - Clear search/filters
- **`↑/↓`** - Navigate between cards
- **`Enter`** - Open selected card details

### **URL Parameters**

Bookmark custom filtered views:

- `/dashboard?status=down` - Show only DOWN services
- `/dashboard?project=prod` - Filter by project
- `/dashboard?tag=critical` - Show critical tagged only
- `/dashboard?type=http` - HTTP endpoints only

### **Custom Views**

**Future Feature:** Save custom dashboard layouts
- Pin important services to top
- Create multiple dashboard tabs
- Share views with team members

---

## 📈 **Metrics Explained**

### **Response Time**

**What It Measures:** Time from request sent to response received

**Factors Affecting Response Time:**
- Network latency
- Server processing time
- Database query speed
- External API calls
- Geographic distance

**Interpretation:**
- **< 50ms:** Excellent (local/cached)
- **50-200ms:** Very good (typical API)
- **200-500ms:** Acceptable (complex queries)
- **500-1000ms:** Slow (needs optimization)
- **> 1000ms:** Very slow (investigate immediately)

### **Uptime Percentage**

**What It Measures:** Successful checks / Total checks (24 hours)

**Calculation Example:**
- 1440 checks per day (every minute)
- 1430 successful
- Uptime = 99.3%

**SLA Targets:**
- **99.9% (Three nines):** ~8.6 hours downtime/year
- **99.99% (Four nines):** ~52 minutes downtime/year
- **99.999% (Five nines):** ~5 minutes downtime/year

---

## 🎓 **Training Guide**

### **For New Team Members**

**Week 1:** Dashboard Basics
- Learn to read status indicators
- Understand what UP/DOWN means
- Practice using search and filters
- Recognize normal vs. abnormal patterns

**Week 2:** Responding to Alerts
- Acknowledge incidents from dashboard
- Investigate DOWN services
- Check dependencies for impact
- Document findings

**Week 3:** Advanced Usage
- Use keyboard shortcuts
- Create custom filters
- Optimize for your workflow
- Share knowledge with team

---

## 📚 **Related Documentation**

- **[Projects](projects.md)** - Organize endpoints
- **[Incidents](incidents.md)** - Handle outages
- **[Service Performance](service-performance.md)** - Analyze trends
- **[Dependencies](dependencies.md)** - Understand impact

---

**The Dashboard is your first line of defense in maintaining system reliability. Master it to ensure nothing escapes your attention!** 🎯
