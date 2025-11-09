# API Metrics - Request Analytics & Performance Tracking

API Metrics provides comprehensive visibility into all API requests flowing through Pulsimo's API Gateway. Track request volumes, response times, error rates, endpoint usage patterns, and client behavior to optimize performance, identify bottlenecks, and ensure API reliability at scale.

---

## 🎯 **Overview**

Every interaction with Pulsimo—whether from the web UI, mobile apps, CLI tools, or third-party integrations—flows through the API Gateway. API Metrics captures, analyzes, and visualizes this traffic, providing insights into how your monitoring platform is being used, where performance issues exist, and how to optimize the API for better user experience.

### **Key Benefits**

✅ **Request Analytics** - Track all API calls with full details  
✅ **Performance Monitoring** - Response time analysis and optimization  
✅ **Error Tracking** - Identify and troubleshoot API errors  
✅ **Usage Patterns** - Understand how clients use the API  
✅ **Rate Limiting** - Monitor and manage API consumption  
✅ **Security Insights** - Detect suspicious patterns and abuse  
✅ **Client Analytics** - Track usage by user, API key, or IP  
✅ **Optimization Guidance** - Identify slow endpoints and caching opportunities  

---

## 📊 **API Metrics Dashboard**

### **1. Page Overview**

**Location:** Settings → API Metrics (or dedicated Observability → API Metrics)  
**Access:** Admin and Member roles  
**Refresh Rate:** Auto-updates every 10 seconds

**Page Title**
- **"API Metrics"** - Clear identification
- **Subtitle:** "Monitor API performance and usage patterns"

**Time Range Selector** (Top-right)
- Last 1 hour (default)
- Last 6 hours
- Last 24 hours
- Last 7 days
- Custom range (date picker)

---

### **2. Key Performance Indicators (KPIs)**

**Four Primary Metric Cards:**

#### **Total Requests**

**What It Shows:**
- Total API requests in selected time period
- Formatted with K/M suffix (e.g., 1.2M)
- Comparison to previous period (e.g., +15%)

**Breakdown:**
- Successful requests (2xx status codes)
- Client errors (4xx status codes)
- Server errors (5xx status codes)
- Total request count with trend arrow

**Visual:**
- Large number display
- Sparkline showing request volume over time
- Color: Blue (neutral), Green (increase), Red (decrease)

**Example:**
```
Total Requests
1,234,567
↑ 12% vs. previous period
```

---

#### **Average Response Time**

**What It Shows:**
- Mean response time across all requests
- In milliseconds
- Trend indicator

**Breakdown:**
- P50 (Median): 85ms
- P95: 250ms
- P99: 580ms
- Max: 2,450ms

**Visual:**
- Large number with "ms" unit
- Color-coded: Green (<100ms), Yellow (100-500ms), Red (>500ms)
- Trend arrow showing improvement/degradation

**Example:**
```
Average Response Time
142 ms
↓ 8% faster than previous period
```

---

#### **Error Rate**

**What It Shows:**
- Percentage of failed requests (4xx + 5xx)
- Comparison to previous period
- Target threshold indicator

**Calculation:**
```
Error Rate = (Failed Requests / Total Requests) × 100
```

**Visual:**
- Large percentage display
- Color: Green (<1%), Yellow (1-5%), Red (>5%)
- Progress ring showing error rate vs. target

**Breakdown:**
- 4xx errors: Client errors (authentication, validation, not found)
- 5xx errors: Server errors (crashes, timeouts, database errors)
- Total error count

**Example:**
```
Error Rate
0.42%
✓ Below 1% target
```

---

#### **Requests per Second (RPS)**

**What It Shows:**
- Current throughput rate
- Average RPS for selected period
- Peak RPS (maximum burst)

**Visual:**
- Real-time updating number
- Sparkline showing RPS over time
- Peak indicator

**Capacity Indicator:**
- Current RPS vs. capacity limit
- Example: "850 / 5,000 RPS (17% capacity)"
- Warning if approaching limit

**Example:**
```
Requests per Second
847 RPS
Peak: 1,523 RPS
Average: 692 RPS
```

---

### **3. Request Volume Chart**

**Time Series Graph:**

**X-Axis:** Time (granularity adjusts based on range)
- 1 hour view: 1-minute buckets
- 24 hour view: 5-minute buckets
- 7 day view: 1-hour buckets

**Y-Axis:** Request count

**Multiple Lines/Areas:**
- **Total Requests** (blue line, bold)
- **Successful (2xx)** (green area, stacked)
- **Client Errors (4xx)** (yellow area, stacked)
- **Server Errors (5xx)** (red area, stacked)

**Interactive Features:**
- Hover to see exact counts at point in time
- Click legend to show/hide categories
- Zoom into time range (drag selection)
- Click point to see detailed breakdown

**Annotations:**
- Deployment markers (if CI/CD integrated)
- Incident markers (red dots)
- Maintenance windows (shaded regions)
- Traffic spikes with automatic detection

**Use Cases:**
- Identify traffic patterns (daily peaks, weekend drops)
- Spot anomalies (unusual spikes or drops)
- Correlate errors with deployments
- Understand load distribution

---

### **4. Response Time Distribution**

**Multi-Line Chart:**

**Lines Shown:**
- **P50 (Median)** - Middle value, 50% faster
- **P75** - 75% of requests faster than this
- **P95** - 95% of requests faster than this
- **P99** - 99% of requests faster than this
- **Max** - Slowest request

**Why Multiple Percentiles Matter:**
- Average can hide problems (few very slow requests skew it)
- P50 shows typical user experience
- P95 shows most users' experience
- P99 captures tail latency (worst case)

**Color Coding:**
- P50: Green (fast)
- P75: Light blue
- P95: Orange (optimization target)
- P99: Red (worst case monitoring)
- Max: Dark red (outliers)

**Threshold Lines:**
- SLA target line (e.g., 200ms for P95)
- Warning threshold
- Critical threshold

**Analysis:**
- If P50 and P95 close: Consistent performance (good)
- If P95/P99 much higher: Tail latency issues (investigate)
- If Max extremely high: Outlier requests (timeouts, slow queries)

---

### **5. Endpoint Analytics**

**Top Endpoints Table:**

**Table showing most-used API endpoints:**

#### **Columns:**

**Endpoint Path**
- HTTP method + path
- Examples:
  - `GET /api/endpoints`
  - `POST /api/incidents/{id}/acknowledge`
  - `PUT /api/projects/{id}`
  - `DELETE /api/dependencies/{id}`

**Request Count**
- Total requests to this endpoint
- Percentage of total traffic
- Trend arrow (↑↓→)

**Average Response Time**
- Mean latency for this endpoint
- Color-coded by speed
- Comparison to overall average

**P95 Response Time**
- 95th percentile latency
- SLA compliance indicator
- Optimization priority

**Error Rate**
- Percentage of failed requests
- Color: Green (<1%), Yellow (1-5%), Red (>5%)
- Error type breakdown on hover

**RPS**
- Requests per second to this endpoint
- Peak RPS
- Traffic share percentage

**Slowest Request**
- Maximum response time observed
- When it occurred
- Request ID for investigation

---

#### **Table Features:**

**Sorting:**
- Click column headers to sort
- Default: Sort by request count (descending)
- Multi-column sort (hold Shift)

**Filtering:**
- Filter by HTTP method (GET, POST, PUT, DELETE, PATCH)
- Filter by status code range (2xx, 4xx, 5xx)
- Search by endpoint path
- Show only slow endpoints (P95 > threshold)
- Show only high-error endpoints

**Actions:**
- **View Details** - Open endpoint detail page
- **View Logs** - See request logs for this endpoint
- **View Errors** - Filter to error requests only
- **Optimize** - Get optimization recommendations

---

### **6. Error Analysis Dashboard**

**Understanding API Errors:**

#### **Error Count by Status Code**

**Bar Chart:**
- X-axis: HTTP status codes (400, 401, 403, 404, 500, 502, 503, 504)
- Y-axis: Error count
- Color-coded: Yellow (4xx), Red (5xx)

**Common Status Codes:**

**4xx Client Errors:**
- **400 Bad Request** - Invalid request format or parameters
- **401 Unauthorized** - Missing or invalid authentication token
- **403 Forbidden** - Authenticated but insufficient permissions
- **404 Not Found** - Resource doesn't exist
- **422 Unprocessable Entity** - Validation errors
- **429 Too Many Requests** - Rate limit exceeded

**5xx Server Errors:**
- **500 Internal Server Error** - Unhandled exception
- **502 Bad Gateway** - Upstream service failure
- **503 Service Unavailable** - Service temporarily down
- **504 Gateway Timeout** - Upstream timeout

**Analysis Tips:**
- High 401s: Authentication issues, expired tokens
- High 403s: Permission misconfiguration
- High 404s: Broken links or deleted resources
- High 500s: Application bugs, need investigation
- High 503s: Service overload, scale up

---

#### **Error Timeline**

**Time Series of Errors:**
- Shows when errors occurred over time
- Separate lines for 4xx and 5xx
- Identify error patterns (spikes, sustained periods)
- Correlate with deployments or traffic spikes

**Error Clustering:**
- Group similar errors together
- Example: "10 instances of 500 error on POST /api/endpoints"
- Click to see all occurrences

---

#### **Top Errors Table**

**Most Frequent Errors:**

**Columns:**
- **Error Message** - Brief description or exception
- **Status Code** - HTTP status
- **Endpoint** - Which endpoint caused error
- **Count** - Number of occurrences
- **Last Seen** - Most recent occurrence
- **Affected Users** - How many users impacted
- **Actions** - View details, mark as resolved

**Example Entries:**
```
500 Internal Server Error - Database connection failed
Endpoint: POST /api/endpoints
Count: 47 occurrences
Last Seen: 2 minutes ago
Affected Users: 12
```

**Drill-Down:**
- Click error to see detailed stack trace
- View all request IDs with this error
- See which users affected
- Link to related incidents

---

### **7. Client Analytics**

**Understanding API Consumers:**

#### **By User**

**Top API Users:**
- User name/email
- Total requests
- Error rate
- Average response time
- Most-used endpoints

**Use Cases:**
- Identify power users
- Detect unusual usage patterns
- Provide usage reports to users
- Optimize for common use cases

---

#### **By API Key**

**API Key Usage:**
- API key name/ID (partially masked)
- Owner (user who created key)
- Request count
- Error rate
- Last used timestamp
- Rate limit status

**Monitoring:**
- Track usage per API key
- Identify compromised or leaked keys (unusual patterns)
- Enforce rate limits
- Revoke abusive keys

**Key Performance:**
```
Key: sk_live_abc...xyz
Owner: admin@company.com
Requests: 125,450
Error Rate: 0.2%
Last Used: 5 minutes ago
Rate Limit: 80% (800/1000 req/hour)
```

---

#### **By Client IP**

**Geographic and Network Analysis:**

**Top Client IPs:**
- IP address
- Request count
- Geographic location (city, country)
- ISP/Organization
- Error rate
- Suspicious activity indicator

**Security Monitoring:**
- Detect brute force attempts (many 401s)
- Identify scraping or abuse (excessive requests)
- Rate limiting enforcement
- IP blocklist candidates

**Geo-Distribution:**
- Requests by country (map visualization)
- Identify where users are located
- Optimize CDN or regional deployments
- Comply with data residency requirements

---

#### **By User Agent**

**Client Application Analysis:**

**User Agent Breakdown:**
- Browser/application name and version
- Request count
- Platform (Windows, macOS, Linux, iOS, Android)
- Percentage of traffic

**Examples:**
- "Mozilla/5.0 ... Chrome/120.0" (Web UI)
- "Pulsimo-CLI/1.2.0" (Command-line tool)
- "Python-requests/2.31.0" (Automation script)
- "Pulsimo-Mobile/1.0" (Mobile app)

**Use Cases:**
- Identify most popular clients
- Prioritize support for common platforms
- Detect outdated client versions
- Track adoption of new features

---

### **8. Rate Limiting Dashboard**

**Managing API Consumption:**

#### **Rate Limit Overview**

**Global Rate Limits:**
- Requests per second: 5,000 (current: 850)
- Requests per minute: 100,000 (current: 51,000)
- Requests per hour: 1,000,000 (current: 420,000)

**Per-User Rate Limits:**
- Authenticated users: 1,000 req/hour
- API keys: Configurable per key
- Anonymous (if allowed): 100 req/hour

**Per-IP Rate Limits:**
- 100 requests per minute
- 5,000 requests per hour
- Prevents abuse and DDoS

---

#### **Rate Limit Violations**

**Recent Throttled Requests:**

**Table showing rate limit hits:**
- Timestamp
- Client (user, API key, or IP)
- Current rate (req/hour)
- Limit exceeded
- Blocked requests count
- Actions (temporary block, notify user)

**Example:**
```
User: automation@company.com
Rate: 1,250 req/hour
Limit: 1,000 req/hour
Blocked: 47 requests
Action: 429 Too Many Requests returned
```

**Auto-Actions:**
- Return 429 status code
- Include Retry-After header
- Temporary block (5 minutes)
- Email notification to user (optional)

---

### **9. Endpoint Detail Page**

**Deep Dive into Single Endpoint:**

**Click any endpoint to see detailed view:**

#### **Endpoint Information**

**Basic Details:**
- Full path with parameters
- HTTP method(s) supported
- Description (if documented)
- Authentication required
- RBAC permissions needed
- Rate limit specific to endpoint

---

#### **Performance Metrics**

**Response Time Statistics:**
- Min, Max, Mean, Median
- P50, P75, P90, P95, P99
- Standard deviation
- Trend over time

**Response Time Distribution:**
- Histogram showing distribution
- Most requests in which bucket?
- Identify bimodal distributions (fast cache hits vs. slow database queries)

**Time Breakdown:**
- Authentication time
- Database query time
- External API calls time
- Response serialization time
- Network time

---

#### **Request Examples**

**Sample Requests:**
- Recent successful requests (last 10)
- Recent failed requests (last 10)
- Slowest requests (P99, outliers)

**Request Details:**
- Request ID (for tracing)
- Timestamp
- User/API key
- Request headers
- Request body (if applicable)
- Query parameters
- Response status
- Response time
- Response size

**Replay Request:**
- Button to replay request (for debugging)
- Useful for reproducing errors
- Test performance improvements

---

#### **Error Patterns**

**Errors for This Endpoint:**
- Error count by type
- Common error messages
- Stack traces (if available)
- Fix recommendations

**Validation Errors:**
- Most common validation failures
- Which fields causing issues
- Improve API documentation

---

### **10. Query Performance Analysis**

**Database Query Insights:**

#### **Slowest Database Queries**

**Table of Slow Queries:**
- Query text (parameterized)
- Execution count
- Average time
- P95 time
- Max time
- Which endpoint triggered it
- Optimization suggestions

**Example:**
```
SELECT * FROM endpoints WHERE project_id = $1 AND status = $2
Executions: 12,450
Avg Time: 125ms
P95 Time: 340ms
Max Time: 2,100ms
Triggered By: GET /api/endpoints
Recommendation: Add index on (project_id, status)
```

---

#### **N+1 Query Detection**

**Identify N+1 Problems:**
- Endpoint makes 1 query, then N additional queries in loop
- Example: Get projects, then query endpoints for each project (N times)
- Should be: 1 query with JOIN or aggregation

**Detected N+1 Queries:**
- Endpoint path
- Number of individual queries
- Total time wasted
- Fix recommendation (use JOIN or batch query)

---

#### **Query Optimization Recommendations**

**Automated Suggestions:**
- Add missing indexes
- Replace SELECT * with specific columns
- Use EXISTS instead of COUNT
- Batch queries instead of loops
- Add caching for frequently accessed data
- Use materialized views for complex aggregations

---

## 🎯 **Advanced Analytics**

### **Traffic Pattern Analysis**

**Identify Usage Patterns:**

**Time-of-Day Analysis:**
- Heatmap showing requests by hour of day
- Identify peak hours (plan scaling)
- Schedule maintenance during low-traffic hours
- Optimize caching for peak periods

**Day-of-Week Analysis:**
- Traffic by day (Monday-Sunday)
- Weekday vs. weekend patterns
- Holiday traffic patterns

**Seasonal Trends:**
- Month-over-month growth
- Seasonal variations
- Capacity planning for growth

---

### **Anomaly Detection**

**Automatic Anomaly Identification:**

**Traffic Anomalies:**
- Unusual spikes (>2x normal traffic)
- Unexpected drops (< 50% normal traffic)
- Alert admin when detected

**Performance Anomalies:**
- Response time suddenly increased
- Error rate spike
- Endpoint that's normally fast becomes slow

**Security Anomalies:**
- Unusual authentication failure rate
- Suspicious IP patterns
- Potential DDoS attack
- Data scraping attempts

---

### **API Versioning Metrics**

**Track API Version Usage:**

**Version Distribution:**
- v1: 45% of traffic
- v2: 50% of traffic
- v3 (beta): 5% of traffic

**Deprecation Planning:**
- Which users still on old versions
- Contact them for migration
- Set sunset date for v1

---

## 💡 **Optimization Recommendations**

### **Caching Opportunities**

**Identify Cacheable Endpoints:**
- High request volume
- Low write frequency
- Same response for multiple requests
- Examples: GET endpoints for reference data

**Cache Hit Rate:**
- Current cache hit percentage
- Cache effectiveness
- Recommendations to improve

**Cache Strategy:**
- TTL recommendations
- Cache key design
- Invalidation strategy

---

### **Database Optimization**

**Query Optimization:**
- Slow query identification
- Index recommendations
- Query refactoring suggestions

**Connection Pooling:**
- Optimize pool size
- Reduce connection overhead
- Monitor pool utilization

---

### **Code Optimization**

**Slow Endpoints:**
- Profiling results
- Hot code paths
- Algorithmic improvements
- Lazy loading opportunities

---

## 🔐 **Security & Compliance**

### **Security Monitoring**

**Authentication Tracking:**
- Failed login attempts
- Brute force detection
- Suspicious patterns

**Authorization Errors:**
- Unauthorized access attempts
- Permission escalation attempts
- Track 403 errors

**Data Access Auditing:**
- Who accessed what data
- Sensitive endpoint access
- Compliance reporting

---

### **API Abuse Prevention**

**Throttling & Blocking:**
- Automatic rate limiting
- IP blocking for abuse
- API key revocation

**DDoS Protection:**
- Request spike detection
- Automatic throttling
- Upstream protection (CloudFlare, etc.)

---

## 🆘 **Troubleshooting**

### **High Error Rate**

**Investigation:**
- Check error breakdown (4xx vs. 5xx)
- Identify most common errors
- Check recent deployments
- Review system health

**Solutions:**
- Fix bugs causing 500 errors
- Improve validation for 400 errors
- Update documentation for 404 errors
- Scale if 503 errors

---

### **Slow Response Times**

**Investigation:**
- Check database query performance
- Look for N+1 queries
- Identify slow endpoints
- Review system resources

**Solutions:**
- Optimize queries
- Add caching
- Scale horizontally
- Upgrade resources

---

## 📚 **Related Documentation**

- **[System Health](system-health.md)** - Internal service monitoring
- **[Database Health](database-health.md)** - Database performance
- **[Event Trails](event-trails.md)** - Audit logging
- **[Settings](../settings.md)** - API key management

---

**API Metrics transforms raw request data into actionable insights. Monitor closely, optimize continuously, and your API will scale reliably to serve thousands of clients!** 📊
