# Database Health - PostgreSQL Monitoring & Maintenance

Database Health provides comprehensive monitoring, maintenance, and optimization tools for Pulsimo's PostgreSQL database. Track query performance, manage connections, automate cleanup tasks, and ensure your data layer remains fast, efficient, and reliable as your monitoring infrastructure scales.

---

## 🎯 **Overview**

The database is the heart of Pulsimo—storing endpoints, incidents, performance metrics, user data, and all historical information. Database Health ensures this critical component operates at peak efficiency through automated maintenance, intelligent monitoring, proactive cleanup, and performance optimization.

### **Key Benefits**

✅ **Performance Monitoring** - Track query speed, connection usage, and throughput  
✅ **Automated Cleanup** - Scheduled jobs to remove old data and free space  
✅ **Vacuum Management** - Automatic and manual VACUUM operations  
✅ **Query Optimization** - Identify and fix slow queries  
✅ **Space Management** - Monitor disk usage and prevent exhaustion  
✅ **Connection Pooling** - Optimize database connections  
✅ **Backup Status** - Track backup health and schedule  
✅ **Index Health** - Monitor index usage and bloat  

---

## 📊 **Database Health Dashboard**

### **1. Page Overview**

**Location:** Settings → Database Health (or Observability → Database)  
**Access:** Admin only (sensitive database operations)  
**Refresh Rate:** Auto-updates every 30 seconds

**Page Title**
- **"Database Health"** - Clear identification
- **Subtitle:** "Monitor and maintain PostgreSQL database"

**Overall Health Score**
- Large circular indicator (0-100%)
- Calculated from: Query performance, connection availability, disk space, replication lag
- Color: Green (90-100%), Yellow (75-90%), Red (<75%)

---

### **2. Database Status Cards**

**Four Primary Metrics:**

#### **Database Size**

**What It Shows:**
- Total database size on disk
- Growth rate (MB per day)
- Projected growth (next 30 days)
- Disk capacity remaining

**Visual:**
- Large size display (e.g., "24.5 GB")
- Progress bar showing disk usage
- Trend arrow (growing/stable/shrinking)

**Breakdown by Component:**
- Tables: 18.2 GB (74%)
- Indexes: 4.8 GB (20%)
- TOAST: 1.1 GB (4%)
- Other: 0.4 GB (2%)

**Example:**
```
Database Size
24.5 GB
↑ Growing 450 MB/day
Disk: 32% used (75 GB remaining)
```

---

#### **Active Connections**

**What It Shows:**
- Current active connections to database
- Max connections allowed
- Connection pool utilization

**Visual:**
- Large number: "45 / 200"
- Percentage: 22.5% utilized
- Color: Green (<70%), Yellow (70-90%), Red (>90%)

**Connection Breakdown:**
- Active (executing queries): 8
- Idle: 32
- Idle in transaction: 3
- Waiting: 0
- Backend processes: 2

**Warning Indicators:**
- "Connection pool nearing limit" if >80%
- "Long-running idle transactions" if detected

**Example:**
```
Active Connections
45 / 200
22.5% utilized
✓ Healthy capacity
```

---

#### **Query Performance**

**What It Shows:**
- Average query execution time
- Slow query count (last hour)
- Transaction throughput

**Visual:**
- Average time: "18ms"
- Color: Green (<50ms), Yellow (50-200ms), Red (>200ms)
- Sparkline showing trend

**Metrics:**
- Queries per second: 450
- Transactions per second: 120
- Slow queries (>1s): 3 in last hour

**Example:**
```
Query Performance
Avg: 18ms
450 queries/sec
3 slow queries (last hour)
```

---

#### **Vacuum Status**

**What It Shows:**
- Last autovacuum timestamp
- Tables needing vacuum
- Current vacuum operations
- Dead tuple percentage

**Visual:**
- Last vacuum: "2 hours ago"
- Status: "Healthy" (green) or "Needs Attention" (yellow/red)
- Progress bar if vacuum running

**Details:**
- Tables needing vacuum: 2
- Dead tuples: 3.5% (healthy if <10%)
- Vacuum running: No
- Next autovacuum: In 4 hours

**Example:**
```
Vacuum Status
Last run: 2 hours ago
Dead tuples: 3.5%
✓ Healthy
```

---

### **3. Connection Analysis**

**Active Connections Table:**

**Shows all current database connections:**

#### **Columns:**

**Process ID (PID)**
- PostgreSQL backend process ID
- Used to kill connections if needed

**Database**
- Which database (usually "monitoring_system")

**User**
- Database username
- Example: "monitoring", "postgres"

**Client IP**
- Source IP address
- Helps identify which service/container

**Application Name**
- Client application identifier
- Examples: "api-gateway", "checker-service", "pgAdmin"

**State**
- **active** - Currently executing query
- **idle** - Connection open, no query running
- **idle in transaction** - Transaction started but not committed (potential issue)
- **waiting** - Waiting for lock
- **disabled** - Background worker

**Duration**
- How long connection has been open
- Or how long current query running
- Warning if >30 minutes idle in transaction

**Current Query**
- SQL being executed (truncated)
- Or last query if idle
- Click to see full query text

**Actions**
- **View Full Query** - See complete SQL
- **Kill Connection** - Terminate (pg_terminate_backend)
- **Cancel Query** - Stop current query (pg_cancel_backend)

---

#### **Connection Pool Statistics**

**Connection Pool Health:**

**Pool Configuration:**
- Min connections: 10
- Max connections: 200
- Pool timeout: 30 seconds
- Idle timeout: 10 minutes

**Current State:**
- Total connections: 45
- Active: 8
- Idle: 32
- Waiting: 0
- Created: 2,340 (lifetime)
- Destroyed: 2,295 (lifetime)
- Errors: 3 (lifetime)

**Performance Metrics:**
- Average wait time: 5ms
- Max wait time: 450ms
- Pool exhaustion events: 0 (last 24h)

**Recommendations:**
- "Pool size optimal for current load"
- Or "Consider increasing max connections to 250"
- Or "Reduce idle timeout to 5 minutes to free connections faster"

---

### **4. Query Performance Analysis**

**Slow Query Log:**

**Table of slowest queries (last 24 hours):**

#### **Columns:**

**Query Text**
- SQL query (parameterized)
- Hover or click to see full text
- Syntax highlighted

**Execution Count**
- How many times executed
- Higher count = optimization opportunity

**Total Time**
- Cumulative time across all executions
- Indicates overall impact

**Average Time**
- Mean execution time
- Target: <50ms for most queries

**Min Time**
- Fastest execution (best case)
- Often cached or simple data

**Max Time**
- Slowest execution (worst case)
- Identify outliers

**Standard Deviation**
- Variation in execution time
- High = inconsistent performance

**Optimization Priority**
- High, Medium, Low
- Based on impact score (count × avg time)

**Actions**
- **Explain Query** - View execution plan
- **Suggest Indexes** - Get recommendations
- **View History** - See query performance over time

---

#### **Query Examples**

**Top 3 Slow Queries:**

**Example 1:**
```sql
SELECT e.*, p.name as project_name 
FROM endpoints e 
LEFT JOIN projects p ON e.project_id = p.id 
WHERE e.status = 'DOWN'
ORDER BY e.updated_at DESC
```
- Executions: 8,450
- Avg Time: 185ms
- Total Impact: 26 minutes
- Recommendation: Add composite index on (status, updated_at)

**Example 2:**
```sql
SELECT * FROM health_checks 
WHERE endpoint_id = $1 
ORDER BY checked_at DESC 
LIMIT 100
```
- Executions: 12,300
- Avg Time: 92ms
- Total Impact: 19 minutes
- Recommendation: Index exists but table needs VACUUM

**Example 3:**
```sql
SELECT COUNT(*) FROM incidents 
WHERE status IN ('OPEN', 'ACKNOWLEDGED') 
AND created_at > NOW() - INTERVAL '7 days'
```
- Executions: 15,600
- Avg Time: 65ms
- Total Impact: 17 minutes
- Recommendation: Create partial index on status WHERE status IN ('OPEN', 'ACKNOWLEDGED')

---

### **5. Table Statistics**

**Database Tables Overview:**

**Table showing all tables with statistics:**

#### **Columns:**

**Table Name**
- Name of table
- Example: endpoints, incidents, health_checks, users, projects

**Row Count**
- Estimated number of rows
- Updated after ANALYZE

**Table Size**
- Disk space used by table data
- Example: "8.4 GB"

**Index Size**
- Disk space used by all indexes on table
- Example: "2.1 GB"

**Total Size**
- Table + Indexes + TOAST
- Example: "10.5 GB"

**Dead Tuples**
- Number of deleted/updated rows not yet removed
- Percentage: dead / total rows
- Warning if >10%

**Last Vacuum**
- Timestamp of last VACUUM operation
- "2 hours ago" or "Never"

**Last Analyze**
- Timestamp of last ANALYZE operation
- Critical for query optimizer

**Bloat Estimate**
- Estimated wasted space
- Percentage: bloat / total size
- Warning if >30%

**Actions**
- **VACUUM** - Manual vacuum operation
- **ANALYZE** - Update statistics
- **REINDEX** - Rebuild indexes
- **View Schema** - See table structure

---

#### **Largest Tables**

**Top 10 by total size:**
1. health_checks - 12.5 GB (54%)
2. incidents - 4.2 GB (18%)
3. health_check_logs - 3.1 GB (13%)
4. audit_logs - 1.8 GB (8%)
5. dependencies - 0.9 GB (4%)
6. endpoints - 0.5 GB (2%)
7. users - 0.2 GB (1%)
8. projects - 0.1 GB (0.4%)
9. alert_channels - 50 MB (0.2%)
10. sessions - 20 MB (0.1%)

**Use Cases:**
- Identify cleanup targets (old health_checks)
- Plan archival strategy
- Focus optimization on largest tables

---

### **6. Index Health**

**Index Management Dashboard:**

**Index Statistics Table:**

#### **Columns:**

**Index Name**
- Name of index
- Example: idx_endpoints_status, pk_users_id

**Table**
- Which table index belongs to

**Size**
- Disk space used by index
- Example: "450 MB"

**Index Scans**
- Number of times index used in queries
- Higher = more useful

**Tuples Read**
- Rows accessed via this index

**Tuples Fetched**
- Rows actually returned

**Efficiency**
- Fetched / Read ratio
- 100% = perfectly selective
- Low % = index not selective enough

**Bloat**
- Estimated wasted space in index
- Percentage
- High bloat = needs REINDEX

**Last Used**
- Timestamp of last use
- "Never used" = candidate for removal

**Actions**
- **REINDEX** - Rebuild index
- **Drop Index** - Remove unused index
- **Analyze Usage** - Detailed query patterns

---

#### **Index Recommendations**

**Missing Indexes:**

Pulsimo automatically analyzes query patterns and suggests indexes:

**Example Recommendations:**

**Recommendation 1:**
```
Table: incidents
Query Pattern: WHERE status = $1 AND created_at > $2
Current: Sequential scan (slow)
Suggested Index: CREATE INDEX idx_incidents_status_created 
                 ON incidents(status, created_at);
Estimated Improvement: 12x faster (from 180ms to 15ms)
Affected Queries: 450 queries/hour
```

**Recommendation 2:**
```
Table: health_checks
Query Pattern: WHERE endpoint_id = $1 ORDER BY checked_at DESC LIMIT 100
Current: Using index on endpoint_id, then sorting (slow)
Suggested Index: CREATE INDEX idx_health_checks_endpoint_checked_desc
                 ON health_checks(endpoint_id, checked_at DESC);
Estimated Improvement: 5x faster (from 90ms to 18ms)
Affected Queries: 800 queries/hour
```

**One-Click Creation:**
- Review recommendation
- Click "Create Index"
- Index created in background
- Monitor creation progress

---

#### **Unused Indexes**

**Identify candidates for removal:**

Table showing indexes never used in queries:
- Takes up disk space
- Slows down INSERT/UPDATE operations
- Safe to drop if truly unused

**Verification Steps:**
1. Confirm index never used (check stats)
2. Check if used in application code
3. Drop index (can recreate if needed)
4. Monitor performance after removal

---

### **7. Data Cleanup & Retention**

**Automated Data Management:**

#### **Cleanup Configuration**

**Retention Policies:**

**Health Check Data:**
- **Retain Duration:** 90 days (configurable: 7, 30, 90, 180, 365 days, Forever)
- **Cleanup Schedule:** Daily at 2:00 AM UTC
- **Status:** Enabled ✓
- **Last Cleanup:** 18 hours ago
- **Deleted Records:** 125,340 records
- **Space Freed:** 2.4 GB

**Purpose:**
- Health checks generate massive data (every 10 seconds)
- Old data not needed for day-to-day operations
- Retain enough for trend analysis
- Free disk space

**Configuration:**
- Slider to select retention days
- Schedule picker (time and timezone)
- Enable/disable toggle
- Test run button (dry run to see what would be deleted)

---

**Incident Data:**
- **Retain Duration:** 365 days (1 year)
- **Cleanup Schedule:** Weekly on Sunday at 3:00 AM
- **Status:** Enabled ✓
- **Exceptions:** Keep all incidents from last 90 days regardless

**Purpose:**
- Incidents important for compliance and post-mortems
- Longer retention than health checks
- Annual review of old incidents

---

**Audit Logs:**
- **Retain Duration:** 2 years (730 days)
- **Cleanup Schedule:** Monthly on 1st at 1:00 AM
- **Status:** Enabled ✓
- **Compliance:** Required by regulations

**Purpose:**
- Audit logs for security and compliance
- Longer retention for regulatory requirements
- Compressed after 90 days

---

**User Sessions:**
- **Retain Duration:** 7 days
- **Cleanup Schedule:** Daily at 1:00 AM
- **Status:** Enabled ✓

**Purpose:**
- Expired sessions cleaned up
- Frees session storage
- Improves session lookup performance

---

#### **Cleanup Scheduler**

**Visual Schedule Display:**

**Weekly Calendar View:**
```
Monday    2:00 AM  Health Checks Cleanup
Tuesday   2:00 AM  Health Checks Cleanup  
Wednesday 2:00 AM  Health Checks Cleanup
Thursday  2:00 AM  Health Checks Cleanup
Friday    2:00 AM  Health Checks Cleanup
Saturday  2:00 AM  Health Checks Cleanup
Sunday    2:00 AM  Health Checks Cleanup
          3:00 AM  Incidents Cleanup (Weekly)

Monthly   1st      Audit Logs Cleanup
```

**Edit Schedule:**
- Click any cleanup job
- Modify time, frequency, retention
- Save changes
- Immediate effect

---

#### **Cleanup History**

**Log of Past Cleanup Operations:**

**Table showing recent cleanups:**

**Columns:**
- **Timestamp** - When cleanup ran
- **Job Type** - Health Checks, Incidents, Audit Logs, Sessions
- **Records Deleted** - Number of rows removed
- **Space Freed** - Disk space reclaimed
- **Duration** - How long cleanup took
- **Status** - Success, Failed, Partial
- **Error Message** - If failed

**Example Entries:**
```
2024-11-07 02:00:15  Health Checks  125,340 records  2.4 GB  8m 32s  Success
2024-11-06 02:00:12  Health Checks  122,890 records  2.3 GB  8m 18s  Success
2024-11-05 02:00:09  Health Checks  119,450 records  2.2 GB  7m 55s  Success
2024-11-03 03:00:00  Incidents      1,245 records    45 MB   2m 10s  Success
```

---

#### **Manual Cleanup**

**On-Demand Cleanup Operations:**

**Cleanup Options:**
1. **Clean Health Checks Older Than...**
   - Date picker
   - Dry run to preview
   - Execute cleanup button
   - Progress bar during execution

2. **Clean All Resolved Incidents Older Than...**
   - Date picker (default: 1 year ago)
   - Confirm before delete
   - Keep critical incidents option

3. **Clean Audit Logs Older Than...**
   - Date picker
   - Compliance warning if <2 years
   - Admin password required

4. **Clean Expired Sessions**
   - One-click cleanup
   - Safe operation
   - Immediate effect

---

### **8. VACUUM Operations**

**PostgreSQL VACUUM Management:**

#### **What is VACUUM?**

**Purpose:**
- Removes dead tuples (deleted/updated rows)
- Frees space for reuse
- Updates table statistics for query planner
- Prevents transaction ID wraparound

**Types:**
- **VACUUM** - Standard cleanup
- **VACUUM ANALYZE** - Cleanup + update statistics
- **VACUUM FULL** - Aggressive cleanup (locks table)

---

#### **Autovacuum Status**

**Automatic VACUUM Operations:**

**Configuration:**
- Autovacuum: Enabled ✓
- Naptime: 1 minute (how often to check)
- Threshold: 50 rows + 20% of table
- Scale Factor: 0.2

**Current Status:**
- Last autovacuum: 15 minutes ago
- Next autovacuum: In 45 minutes
- Tables needing vacuum: 2 (endpoints, health_checks)
- Autovacuum running: No

**Autovacuum Workers:**
- Max workers: 3
- Currently active: 0
- Queue: 0 tables waiting

---

#### **Manual VACUUM Controls**

**VACUUM All Tables:**
- **VACUUM** button - Standard vacuum
- **VACUUM ANALYZE** button - Vacuum + update stats (recommended)
- **VACUUM FULL** button - Aggressive (locks tables, use carefully)

**Warnings:**
- VACUUM FULL locks tables (read-only during operation)
- Schedule during maintenance window
- Can take hours on large tables

---

#### **Per-Table VACUUM**

**From Table Statistics view:**
- Select individual table
- Click **VACUUM** button
- Choose type: VACUUM, VACUUM ANALYZE, VACUUM FULL
- Confirm operation
- Monitor progress

**Progress Monitoring:**
- Progress bar
- Current phase (scanning, cleaning, analyzing)
- Estimated time remaining
- Cancel button (for long operations)

---

#### **VACUUM History**

**Log of Past VACUUM Operations:**

**Table:**
- Timestamp
- Table name
- Operation type (VACUUM, ANALYZE, FULL)
- Duration
- Dead tuples removed
- Space freed
- Pages removed
- Status

**Example:**
```
2024-11-07 02:30:00  health_checks  VACUUM ANALYZE  12m 45s  1.2M tuples  850 MB  Success
2024-11-06 02:30:00  health_checks  VACUUM ANALYZE  12m 32s  1.1M tuples  820 MB  Success
```

---

### **9. Backup & Recovery**

**Backup Status Monitoring:**

#### **Backup Configuration**

**Backup Settings:**
- Backup enabled: Yes ✓
- Backup type: Continuous WAL archiving
- Backup frequency: Daily full, continuous incremental
- Backup retention: 30 days
- Backup location: /var/lib/postgresql/backups
- Remote backup: Enabled (S3 bucket)

---

#### **Backup Status**

**Last Backup:**
- **Full Backup:** 18 hours ago (2024-11-06 02:00:00)
- **Size:** 24.8 GB (compressed)
- **Duration:** 28 minutes
- **Status:** Success ✓
- **Location:** s3://company-backups/pulsimo/2024-11-06/

**WAL Archiving:**
- **Last WAL Archived:** 2 minutes ago
- **WAL Archive Size:** 1.2 GB (last 24 hours)
- **Status:** Healthy ✓

**Point-in-Time Recovery:**
- **Recovery Window:** Last 30 days
- **Can restore to any point within window**

---

#### **Backup History**

**Recent Backups:**

Table showing all backups:
- Date/time
- Type (Full, Incremental)
- Size
- Duration
- Status
- Location
- Actions (Download, Restore, Delete)

**Example:**
```
2024-11-06 02:00:00  Full  24.8 GB  28m  Success  S3  [Download] [Restore] [Delete]
2024-11-05 02:00:00  Full  24.5 GB  27m  Success  S3  [Download] [Restore] [Delete]
2024-11-04 02:00:00  Full  24.1 GB  26m  Success  S3  [Download] [Restore] [Delete]
```

---

#### **Manual Backup**

**On-Demand Backup:**
- **Create Backup Now** button
- Options:
  - Full backup
  - Incremental (since last full)
- Confirm and execute
- Progress monitoring
- Notification on completion

---

#### **Restore Operations**

**Database Restore:**

**Warning:**
- Restore will stop all services
- All current data will be replaced
- Downtime: Typically 30-60 minutes
- Recommend testing in separate environment first

**Restore Steps:**
1. Select backup from history
2. Click **Restore** button
3. Admin authentication required
4. Confirm understanding of data loss
5. Services stop automatically
6. Restore executes
7. Services restart
8. Verification tests run

---

### **10. Performance Tuning**

**PostgreSQL Configuration Optimization:**

#### **Current Configuration**

**Key Settings:**
- **shared_buffers:** 4 GB (recommended: 25% of RAM)
- **effective_cache_size:** 12 GB (recommended: 50-75% of RAM)
- **work_mem:** 64 MB
- **maintenance_work_mem:** 512 MB
- **max_connections:** 200
- **checkpoint_timeout:** 5 minutes
- **wal_buffers:** 16 MB

---

#### **Tuning Recommendations**

**Automated Suggestions:**

**Based on Workload Analysis:**
1. **Increase shared_buffers to 6 GB**
   - Current: 4 GB
   - Recommended: 6 GB
   - Reason: High cache miss rate (85% hit ratio, target 95%+)
   - Impact: Improved query performance by 15-20%

2. **Increase work_mem to 128 MB**
   - Current: 64 MB
   - Recommended: 128 MB
   - Reason: Sort operations spilling to disk
   - Impact: Faster complex queries with sorting

3. **Reduce max_connections to 150**
   - Current: 200
   - Recommended: 150
   - Reason: Rarely use >100 connections
   - Impact: More memory per connection

**Apply Recommendations:**
- One-click apply button
- Requires service restart
- Schedule during maintenance window
- Rollback option if issues

---

## 🔧 **Maintenance Tools**

### **Database Maintenance Wizard**

**Guided Maintenance Process:**

**Step 1: Health Check**
- Run comprehensive database health check
- Identify issues (bloat, missing indexes, slow queries)
- Generate report

**Step 2: Optimize**
- Apply recommended indexes
- VACUUM tables with high dead tuple percentage
- Update statistics (ANALYZE)

**Step 3: Cleanup**
- Run data retention policies
- Remove old data
- Free disk space

**Step 4: Verify**
- Rerun health check
- Compare before/after metrics
- Generate summary report

**One-Click Maintenance:**
- **Run Full Maintenance** button
- Executes all steps automatically
- Schedule for off-hours
- Email report on completion

---

## 🆘 **Troubleshooting**

### **Connection Pool Exhausted**

**Symptoms:**
- "Connection pool exhausted" errors
- "Too many connections" errors
- Services timing out

**Investigation:**
- Check active connections (all at max?)
- Identify long-running idle transactions
- Look for connection leaks

**Solutions:**
- Increase max_connections (if resources allow)
- Kill idle connections
- Fix connection leaks in code
- Reduce connection timeout

---

### **Slow Queries**

**Symptoms:**
- High average query time
- Slow page loads
- Timeout errors

**Investigation:**
- Check slow query log
- Run EXPLAIN on slow queries
- Check for missing indexes
- Look for table bloat

**Solutions:**
- Add recommended indexes
- VACUUM tables
- Optimize query structure
- Add caching layer

---

### **Disk Space Low**

**Symptoms:**
- Database size approaching disk capacity
- "No space left on device" errors
- Write failures

**Investigation:**
- Check table sizes (largest tables)
- Review data retention policies
- Look for bloat
- Check backup sizes

**Solutions:**
- Run cleanup jobs immediately
- VACUUM FULL to reclaim space
- Reduce retention periods
- Archive old data
- Add more disk storage

---

## 📚 **Related Documentation**

- **[System Health](system-health.md)** - Overall system monitoring
- **[API Metrics](api-metrics.md)** - API performance
- **[Event Trails](event-trails.md)** - Audit logging
- **[Settings](../settings.md)** - Database configuration

---

**A healthy database is a happy database. Monitor closely, maintain regularly, and your data layer will scale reliably for years to come!** 🗄️
