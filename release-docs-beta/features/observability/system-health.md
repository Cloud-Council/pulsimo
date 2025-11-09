# System Health - Internal Monitoring & Diagnostics

System Health provides deep visibility into Pulsimo's own infrastructure health. Unlike endpoint monitoring which tracks your external services, System Health monitors the Pulsimo platform itself—ensuring the monitoring system remains reliable, performant, and operational at all times.

---

## 🎯 **Overview**

A monitoring system must monitor itself. System Health tracks all internal components of Pulsimo, from service uptime to resource utilization, ensuring that your monitoring infrastructure never becomes a single point of failure. By continuously analyzing system metrics, you can proactively identify performance bottlenecks, capacity constraints, and potential failures before they impact your monitoring capabilities.

### **Key Benefits**

✅ **Self-Monitoring** - Monitor the monitoring system itself  
✅ **Early Warning** - Detect issues before they impact operations  
✅ **Resource Tracking** - CPU, memory, disk, network utilization  
✅ **Service Health** - Status of all Pulsimo microservices  
✅ **Performance Metrics** - Response times, throughput, latency  
✅ **Capacity Planning** - Understand growth and scaling needs  
✅ **Reliability Assurance** - Ensure 99.9%+ uptime of monitoring platform  
✅ **Troubleshooting** - Diagnose system issues quickly  

---

## 📊 **System Health Dashboard**

### **1. Page Overview**

**Location:** Settings → System Health (or dedicated System Health tab)  
**Access:** Admin only (sensitive internal metrics)  
**Refresh Rate:** Auto-updates every 5 seconds (WebSocket)

**Page Title**
- **"System Health"** - Clear identification
- **Subtitle:** "Monitor Pulsimo infrastructure health and performance"

**Overall Health Score**
- Large circular indicator (0-100%)
- Color-coded: Green (90-100%), Yellow (75-90%), Red (<75%)
- Aggregated from all component health scores
- Click to see breakdown

---

### **2. Component Status Grid**

**All Pulsimo Services Monitored:**

#### **Frontend Service**

**Status Indicator:**
- 🟢 **Healthy** - Service running normally
- 🟡 **Degraded** - High response times or errors
- 🔴 **Down** - Service unreachable
- 🔵 **Restarting** - Service in restart process

**Key Metrics:**
- **Uptime:** Duration since last restart (e.g., "15 days 8 hours")
- **Memory Usage:** Current / Total (e.g., "2.1 GB / 4 GB") - 52%
- **CPU Usage:** Percentage (e.g., "23%")
- **Active Connections:** WebSocket connections (e.g., "47 active users")
- **Request Rate:** Requests per second (e.g., "120 req/s")
- **Error Rate:** Percentage of failed requests (e.g., "0.02%")

**Resource Visualization:**
- Progress bars for memory and CPU
- Sparkline graphs showing 1-hour trend
- Color coding: Green (<70%), Yellow (70-85%), Red (>85%)

**Actions:**
- View detailed logs
- Restart service (with confirmation)
- View container stats (if Docker)

---

#### **API Gateway Service**

**Status Indicator:**
- Same color coding as frontend

**Key Metrics:**
- **Uptime:** Service availability duration
- **Memory Usage:** Current heap and total
- **CPU Usage:** Process CPU percentage
- **Request Volume:** Total requests processed
- **Average Response Time:** Mean latency (e.g., "45ms")
- **P95 Response Time:** 95th percentile (e.g., "120ms")
- **Active Endpoints:** Number of registered API routes
- **Error Rate:** Failed API calls percentage

**API-Specific Metrics:**
- Requests by endpoint (top 10)
- Requests by HTTP method (GET, POST, PUT, DELETE)
- Status code distribution (2xx, 4xx, 5xx)
- Authentication success rate

**Health Checks:**
- Database connectivity: ✓ Connected
- Redis connectivity: ✓ Connected
- Service dependencies: All healthy

---

#### **Checker Service**

**Critical Component - Performs Health Checks**

**Status Indicator:**
- Color-coded health status

**Key Metrics:**
- **Uptime:** Continuous operation time
- **Active Checks:** Currently running health checks (e.g., "23 active")
- **Checks per Minute:** Throughput (e.g., "450 checks/min")
- **Queue Length:** Pending health checks (e.g., "0 queued")
- **Worker Threads:** Active workers (e.g., "8 / 10 workers")
- **Memory Usage:** Rust process memory
- **CPU Usage:** Process CPU

**Performance Metrics:**
- **Average Check Duration:** Mean time per check (e.g., "1.2s")
- **Fastest Check:** Best case (e.g., "0.05s")
- **Slowest Check:** Worst case (e.g., "29.8s")
- **Timeout Rate:** Checks exceeding timeout (e.g., "0.5%")

**Capacity Metrics:**
- **Max Concurrent Checks:** Configured limit (e.g., "150")
- **Current Utilization:** Percentage of capacity (e.g., "15%")
- **Peak Utilization (24h):** Maximum reached (e.g., "78%")
- **Recommended Capacity:** System recommendation based on load

**Health Check Statistics:**
- Total checks performed (lifetime)
- Success rate (last 24 hours)
- Failure rate by type (timeout, connection, error)
- Average checks per endpoint

---

#### **Notification Service**

**Status Indicator:**
- Color-coded health

**Key Metrics:**
- **Uptime:** Service uptime duration
- **Memory Usage:** Current memory consumption
- **CPU Usage:** Processing percentage
- **Alerts Sent (24h):** Count of notifications delivered
- **Queue Length:** Pending notifications (e.g., "0 queued")
- **Delivery Rate:** Successful delivery percentage (e.g., "99.8%")

**Channel Performance:**
- Email delivery rate and latency
- Slack webhook success rate
- Discord webhook success rate
- Teams webhook success rate
- Google Chat webhook success rate
- Custom webhook success rate

**Alert Statistics:**
- Average delivery latency (time from trigger to send)
- Retry attempts (failed deliveries retried)
- Permanent failures (gave up after max retries)
- Rate limiting hits (by channel)

---

#### **PostgreSQL Database**

**Primary Data Store**

**Status Indicator:**
- Color-coded connection health

**Key Metrics:**
- **Uptime:** Database uptime
- **Connections:** Active / Max (e.g., "45 / 200")
- **Connection Pool:** Available connections (e.g., "155 idle")
- **Database Size:** Total disk usage (e.g., "8.4 GB")
- **Transactions per Second:** TPS rate (e.g., "120 tps")
- **Cache Hit Ratio:** Buffer cache efficiency (e.g., "99.2%")

**Performance Metrics:**
- **Average Query Time:** Mean query duration (e.g., "12ms")
- **Slowest Query (1h):** Worst performing query
- **Lock Waits:** Queries waiting for locks (e.g., "0")
- **Deadlocks:** Deadlock count (last 24h)

**Resource Usage:**
- CPU usage by database process
- Memory usage (shared buffers, work mem)
- Disk I/O rate (read/write MB/s)
- WAL (Write-Ahead Log) size and growth

**Table Statistics:**
- Largest tables (top 5 by size)
- Most queried tables (by frequency)
- Index usage and effectiveness
- Bloat detection and recommendations

**Vacuum Status:**
- Last autovacuum run time
- Vacuum progress (if running)
- Tables requiring vacuum
- Dead tuple percentage

---

#### **Redis Cache**

**In-Memory Data Store**

**Status Indicator:**
- Color-coded health

**Key Metrics:**
- **Uptime:** Redis server uptime
- **Memory Usage:** Used / Max (e.g., "1.2 GB / 4 GB") - 30%
- **Hit Rate:** Cache hit ratio (e.g., "94.5%")
- **Keys:** Total keys in database (e.g., "12,450")
- **Evictions:** Keys evicted due to memory (e.g., "0")
- **Connections:** Active clients (e.g., "8")

**Performance Metrics:**
- **Operations per Second:** Redis ops/s (e.g., "2,500 ops/s")
- **Average Latency:** Command execution time (e.g., "0.8ms")
- **Slowlog:** Slow commands detected
- **Key Expiration Rate:** TTL expirations/s

**Memory Breakdown:**
- Dataset memory (actual data)
- Overhead memory (Redis internals)
- Fragmentation ratio
- Peak memory usage (24h)

**Persistence Status:**
- AOF (Append-Only File) enabled/disabled
- Last save timestamp
- Background save in progress
- RDB file size

---

### **3. Resource Utilization Charts**

#### **CPU Usage Over Time**

**Multi-Line Chart:**
- X-axis: Time (last 1h, 6h, 24h, 7d - selectable)
- Y-axis: CPU percentage (0-100%)
- Lines for each service:
  - Frontend (blue)
  - API Gateway (green)
  - Checker (orange)
  - Notification (purple)
  - PostgreSQL (red)
  - Redis (cyan)
  - System total (black, bold)

**Interactive Features:**
- Hover to see exact values
- Click legend to show/hide services
- Zoom into time range
- Export as PNG

**Alert Thresholds:**
- Yellow line at 70% (warning)
- Red line at 85% (critical)
- Annotations for threshold breaches

---

#### **Memory Usage Over Time**

**Stacked Area Chart:**
- X-axis: Time period
- Y-axis: Memory in GB
- Colored areas for each service
- Total system memory line overlay

**Memory Types:**
- Application heap
- Cache memory
- Buffer memory
- Free memory

**Trend Analysis:**
- Identify memory leaks (steady upward trend)
- Peak usage times
- Capacity projections

---

#### **Network Traffic**

**Dual-Axis Chart:**
- X-axis: Time
- Y-axis Left: Incoming traffic (MB/s)
- Y-axis Right: Outgoing traffic (MB/s)

**Metrics:**
- Total bytes received
- Total bytes sent
- Packets per second
- Connection count

**Breakdown by Service:**
- Frontend bandwidth usage
- API bandwidth usage
- Database replication traffic (if applicable)
- Health check traffic

---

#### **Disk I/O**

**Line Chart:**
- Read operations per second
- Write operations per second
- Read MB/s
- Write MB/s

**Disk Space:**
- Total disk capacity
- Used space
- Free space
- Growth rate (MB per day)

**Warning Indicators:**
- Alert when disk >80% full
- Predict when disk will be full
- Highlight I/O bottlenecks

---

### **4. Service Logs Viewer**

**Real-Time Log Streaming:**

**Log Panel (Bottom of Page):**
- Scrollable log viewer
- Auto-scroll toggle
- Log level filter (DEBUG, INFO, WARN, ERROR, FATAL)
- Service filter (select which service logs to show)
- Search/filter by text
- Timestamp display

**Log Entry Format:**
```
[2024-11-07 14:30:22.123] [API-GATEWAY] [INFO] GET /api/endpoints - 200 OK - 45ms
[2024-11-07 14:30:23.456] [CHECKER] [WARN] Health check timeout: endpoint-123 (30s)
[2024-11-07 14:30:24.789] [DATABASE] [ERROR] Connection pool exhausted, waiting...
```

**Log Features:**
- Color-coded by level (INFO=blue, WARN=yellow, ERROR=red)
- Click to expand full details
- Copy log line
- Export logs (last 1000 lines or time range)

**Quick Filters:**
- Show errors only
- Show warnings and above
- Last 5 minutes
- Custom time range

---

### **5. Health Check History**

**System Health Over Time:**

**Calendar Heatmap:**
- Last 90 days
- Each day colored by health score:
  - Dark green: 100% health
  - Light green: 95-99%
  - Yellow: 90-95%
  - Orange: 85-90%
  - Red: <85%
- Click day to see detailed breakdown
- Identify patterns (day of week, time of month)

**Uptime Percentage:**
- Last 24 hours: 99.99%
- Last 7 days: 99.95%
- Last 30 days: 99.87%
- Last 90 days: 99.82%

**Downtime Events:**
- List of system outages or degradations
- Date/time, duration, affected services
- Root cause (if known)
- Resolution notes

---

### **6. Alerts and Notifications**

**System Health Alerts:**

**Alert Conditions:**
- CPU >85% for 5 minutes
- Memory >90% for 5 minutes
- Disk >85% full
- Service down or unreachable
- Database connection errors
- Redis unavailable
- High error rate (>5% in 5 minutes)
- Queue backlog (>100 items for 10 minutes)

**Notification Channels:**
- Admin email alerts
- Slack system channel
- PagerDuty integration (if critical)
- WebSocket to admin users (in-app notification)

**Alert History:**
- When alert fired
- Which condition triggered
- Who acknowledged
- Resolution time
- Actions taken

---

## 🔍 **Detailed Component Views**

### **Service Detail Page**

**Click any service to open detailed view:**

#### **Service Information**

**Basic Details:**
- Service name
- Container/process ID
- Image version/Git commit
- Start time and uptime
- Restart count (with history)
- Configuration summary

**Environment Variables:**
- List of env vars (sensitive values masked)
- Configuration file location
- Override settings

---

#### **Performance Metrics**

**Request Analysis (API Gateway):**
- Requests per endpoint (top 20)
- Response time distribution
- Error rate by endpoint
- Slowest endpoints (P95, P99)

**Throughput Graphs:**
- Requests per second (5-minute window)
- Data transfer rate (MB/s)
- Concurrent requests

**Error Analysis:**
- Error count by type
- Stack traces for recent errors
- Error rate trend
- Common error patterns

---

#### **Resource Graphs**

**CPU Usage:**
- Detailed CPU percentage over time
- User CPU vs. System CPU
- Context switches
- CPU throttling events

**Memory Breakdown:**
- Heap usage
- Stack usage
- GC (Garbage Collection) activity
- Memory allocations and deallocations

**Thread/Process Info:**
- Thread count
- Thread states (running, waiting, blocked)
- Goroutines (for Go services)
- Event loop lag (for Node.js services)

---

#### **Dependencies Health**

**Service Dependencies:**
- Database connection status
- Redis connection status
- External API dependencies
- Inter-service communication health

**Dependency Latency:**
- Average latency to each dependency
- Timeout rate
- Retry attempts
- Circuit breaker state

---

### **Database Detail View**

**PostgreSQL Insights:**

#### **Connection Analysis**

**Active Connections:**
- Connection list with details:
  - Client IP address
  - Database name
  - Username
  - Query currently executing
  - Connection duration
  - State (active, idle, idle in transaction)

**Long-Running Queries:**
- Queries running >30 seconds
- Kill query option (with confirmation)
- Query text and parameters
- Execution plan (EXPLAIN output)

**Connection Pool Stats:**
- Pool size configuration
- Active connections
- Idle connections
- Waiting connections (queue)

---

#### **Query Performance**

**Slow Query Log:**
- Top 20 slowest queries (last 24 hours)
- Execution time
- Number of executions
- Average time
- Query text
- Recommendations for optimization

**Query Statistics:**
- Total queries executed
- Queries per second
- Read vs. Write ratio
- Transaction rate

**Index Usage:**
- Index hit rate
- Unused indexes (candidates for removal)
- Missing indexes (recommendations)
- Index bloat

---

#### **Database Size and Growth**

**Size Breakdown:**
- Tables (sorted by size)
- Indexes (sorted by size)
- TOAST tables
- Temporary tables

**Growth Trends:**
- Database size over time (7d, 30d, 90d)
- Growth rate (MB per day)
- Projected size (forecast)
- Capacity planning recommendations

---

#### **Vacuum and Maintenance**

**Autovacuum Activity:**
- Last autovacuum timestamp per table
- Tables needing vacuum
- Vacuum progress (if running)
- Dead tuple count and percentage

**Manual Maintenance:**
- **Run Vacuum** button (per table or all)
- **Analyze** button (update statistics)
- **Reindex** button (rebuild indexes)
- Schedule maintenance window

**Bloat Detection:**
- Table bloat percentage
- Index bloat percentage
- Recommendations to reduce bloat

---

### **Redis Detail View**

**Cache Insights:**

#### **Key Analysis**

**Key Statistics:**
- Total keys in database
- Keys by pattern (prefix grouping)
- Key size distribution
- TTL distribution (expiring soon vs. persistent)

**Largest Keys:**
- Top 20 keys by memory usage
- Key name, type, size
- Options to inspect or delete

**Key Patterns:**
- Common key prefixes
- Memory usage by pattern
- Hit rate by pattern

---

#### **Cache Performance**

**Hit/Miss Ratio:**
- Overall hit rate percentage
- Hit rate trend over time
- Hits per second
- Misses per second

**Eviction Metrics:**
- Eviction count (last 24h)
- Eviction rate
- Which keys were evicted (if logged)
- Memory pressure indicators

**Command Statistics:**
- Most executed commands
- Command latency by type
- Slow commands log

---

## 🎯 **Capacity Planning**

### **Resource Projections**

**Automatic Forecasting:**

**CPU Capacity:**
- Current average utilization
- Peak utilization
- Growth trend
- Projected capacity exhaustion date
- Recommendation: "Add 2 CPU cores by Q2 2025"

**Memory Capacity:**
- Current usage vs. total
- Memory growth rate
- Projected exhaustion
- Recommendation: "Increase memory to 16 GB within 60 days"

**Disk Capacity:**
- Current usage and growth rate
- Time until disk full
- Recommendation: "Add 100 GB storage within 90 days"

**Database Capacity:**
- Row count growth rate
- Query complexity trends
- Recommend optimization or scaling

---

### **Scaling Recommendations**

**Horizontal Scaling:**
- When to add more checker service instances
- Load balancing recommendations
- Service mesh considerations

**Vertical Scaling:**
- When to increase CPU/memory
- Database resource tuning
- Redis memory sizing

**Optimization First:**
- Identify optimization opportunities before scaling
- Query optimization suggestions
- Caching strategy improvements
- Index recommendations

---

## 💡 **Advanced Features**

### **Health Check Customization**

**Configure Health Thresholds:**
- CPU warning/critical thresholds
- Memory warning/critical thresholds
- Disk warning/critical thresholds
- Response time thresholds
- Error rate thresholds

**Custom Health Checks:**
- Define custom health check scripts
- Schedule periodic checks
- Alert on custom conditions

---

### **Auto-Remediation**

**Automated Actions:**
- Auto-restart service if unhealthy for X minutes
- Auto-scale checker workers based on queue length
- Clear Redis cache if memory >90%
- Kill long-running queries automatically

**Safety Controls:**
- Maximum restart attempts
- Cool-down period between actions
- Require manual approval for critical actions
- Audit log of all auto-remediation

---

### **Performance Profiling**

**CPU Profiling:**
- Generate CPU profile for service
- Flame graph visualization
- Identify hot code paths
- Optimization recommendations

**Memory Profiling:**
- Heap dump generation
- Memory leak detection
- Object allocation analysis

---

## 🆘 **Troubleshooting**

### **High CPU Usage**

**Symptoms:**
- Service CPU >85%
- System sluggish
- Increased response times

**Investigation:**
- Check which service consuming CPU
- Review process list and threads
- Look for CPU-intensive queries
- Check for infinite loops or runaway processes

**Solutions:**
- Restart affected service
- Optimize expensive operations
- Scale horizontally (add instances)
- Upgrade CPU resources

---

### **Memory Issues**

**Symptoms:**
- Memory usage >90%
- Out of memory errors
- Service crashes
- Swap usage high

**Investigation:**
- Identify service with memory leak
- Check for large objects in memory
- Review cache sizes
- Look for memory not being released

**Solutions:**
- Restart service to reclaim memory
- Reduce cache sizes
- Fix memory leaks in code
- Increase available memory

---

### **Database Connection Exhaustion**

**Symptoms:**
- "Connection pool exhausted" errors
- Queries timing out
- API requests failing

**Investigation:**
- Check active connection count
- Identify long-running queries
- Look for connection leaks

**Solutions:**
- Kill idle connections
- Increase connection pool size
- Optimize slow queries
- Fix connection leak in code

---

### **Disk Space Low**

**Symptoms:**
- Disk >85% full
- "No space left on device" errors
- Database write failures

**Investigation:**
- Identify what's consuming space
- Check log file sizes
- Review database size and growth
- Look for temporary files

**Solutions:**
- Rotate and compress logs
- Vacuum database (reclaim space)
- Archive old data
- Add more disk storage

---

## 📚 **Related Documentation**

- **[Database Health](database-health.md)** - Detailed database monitoring
- **[API Metrics](api-metrics.md)** - API performance tracking
- **[Event Trails](event-trails.md)** - Audit logging
- **[Settings](../settings.md)** - System configuration

---

**System Health is your insurance policy for monitoring infrastructure reliability. Monitor it closely, act on alerts promptly, and your Pulsimo platform will serve you reliably 24/7!** 🏥
