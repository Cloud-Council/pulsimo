# Observability - Internal Monitoring & Analytics

The Observability suite provides deep visibility into Pulsimo's internal operations. Monitor the monitoring system itself—ensuring your infrastructure remains healthy, performant, secure, and compliant through comprehensive system metrics, API analytics, database management, and complete audit trails.

---

## 🎯 **Overview**

Observability in Pulsimo follows the principle: **"A monitoring system must monitor itself."** These features provide the insights needed to ensure Pulsimo operates reliably, scales efficiently, and maintains the trust of your teams and stakeholders.

### **Why Observability Matters**

**Reliability:** Know your monitoring platform is working before relying on it  
**Performance:** Identify bottlenecks before they impact operations  
**Security:** Detect and respond to threats immediately  
**Compliance:** Meet audit and regulatory requirements  
**Optimization:** Make data-driven decisions about scaling and tuning  

---

## 📚 **Observability Features**

### **[1. System Health](system-health.md)**

**Monitor Pulsimo Infrastructure**

Track the health and performance of all Pulsimo components—from microservices to databases—ensuring your monitoring platform remains reliable and performant.

**Key Capabilities:**
- ✅ Service status monitoring (Frontend, API Gateway, Checker, Notification)
- ✅ Resource utilization (CPU, memory, disk, network)
- ✅ PostgreSQL database health and performance
- ✅ Redis cache monitoring and hit rates
- ✅ Real-time service logs and error tracking
- ✅ Health score calculation and trends
- ✅ Capacity planning and scaling recommendations
- ✅ Auto-remediation for common issues

**Use Cases:**
- Ensure monitoring system uptime
- Identify resource constraints
- Plan infrastructure scaling
- Troubleshoot performance issues
- Prevent service failures

**Access:** Admin only  
**Update Frequency:** Real-time (5-second refresh)

[**Read Full Documentation →**](system-health.md)

---

### **[2. API Metrics](api-metrics.md)**

**Request Analytics & Performance**

Comprehensive visibility into all API requests flowing through Pulsimo's API Gateway—track performance, identify errors, understand usage patterns, and optimize API reliability.

**Key Capabilities:**
- ✅ Request volume and throughput tracking
- ✅ Response time analysis (P50, P95, P99 percentiles)
- ✅ Error rate monitoring and analysis
- ✅ Endpoint performance breakdown
- ✅ Client analytics (by user, API key, IP)
- ✅ Rate limiting and quota management
- ✅ Query performance analysis
- ✅ Security and abuse detection

**Use Cases:**
- Optimize slow API endpoints
- Identify and fix errors
- Monitor API abuse or misuse
- Plan capacity and rate limits
- Analyze usage patterns
- Generate API reports

**Access:** Admin and Member roles  
**Update Frequency:** 10-second refresh

[**Read Full Documentation →**](api-metrics.md)

---

### **[3. Database Health](database-health.md)**

**PostgreSQL Monitoring & Maintenance**

Deep visibility into database performance, automated cleanup, vacuum management, and optimization tools—ensuring your data layer scales reliably.

**Key Capabilities:**
- ✅ Query performance analysis and slow query detection
- ✅ Connection pool monitoring and management
- ✅ Table and index statistics
- ✅ Automated data cleanup with retention policies
- ✅ VACUUM operations (manual and automatic)
- ✅ Disk space monitoring and growth tracking
- ✅ Backup status and restore operations
- ✅ Performance tuning recommendations

**Key Features:**

**Automated Cleanup:**
- Health check data: Configurable retention (7-365 days)
- Incident data: Long-term retention (365+ days)
- Audit logs: Compliance-grade retention (2+ years)
- Session cleanup: Automatic expired session removal
- Scheduled cleanup jobs with progress tracking

**Maintenance Tools:**
- One-click VACUUM operations
- Index optimization recommendations
- Bloat detection and remediation
- Query optimization suggestions
- Backup and restore management

**Use Cases:**
- Optimize database performance
- Manage disk space efficiently
- Schedule maintenance windows
- Troubleshoot slow queries
- Plan database scaling
- Ensure backup health

**Access:** Admin only  
**Update Frequency:** 30-second refresh

[**Read Full Documentation →**](database-health.md)

---

### **[4. Event Trails](event-trails.md)**

**Comprehensive Audit Logging**

Complete audit trail of all actions within Pulsimo—track who did what, when, and from where for security, compliance, and troubleshooting.

**Key Capabilities:**
- ✅ Complete event logging (authentication, changes, operations)
- ✅ User action tracking with full context
- ✅ Security event monitoring (failed logins, permission denials)
- ✅ Configuration change history with before/after values
- ✅ Advanced filtering and full-text search
- ✅ Compliance reporting (SOC 2, GDPR, HIPAA, PCI-DSS)
- ✅ Long-term retention and archival
- ✅ SIEM integration and real-time forwarding

**Event Categories:**
- **Authentication:** Login, logout, password changes
- **Resource Management:** Create, update, delete operations
- **Configuration:** Settings changes, API key management
- **Data Operations:** Exports, imports, cleanup jobs
- **Security:** Permission denials, suspicious activity
- **System:** Automated tasks, background jobs

**Use Cases:**
- Security incident investigation
- Compliance auditing and reporting
- Troubleshooting (what changed?)
- User accountability tracking
- Forensic analysis
- Regulatory compliance

**Access:** Admin only  
**Retention:** 2 years (default), 7 years (compliance)

[**Read Full Documentation →**](event-trails.md)

---

## 🔗 **Feature Integration**

Observability features work together to provide complete visibility:

### **System Health → API Metrics**
- System health impacts API performance
- High CPU usage → slower API responses
- Monitor both to understand full picture

### **API Metrics → Database Health**
- Slow API endpoints often caused by slow database queries
- Optimize database to improve API performance
- Track database impact on API response times

### **Event Trails → All Features**
- Every action logged in Event Trails
- Audit who changed configurations
- Track when maintenance performed
- Security monitoring across all features

### **Database Health → System Health**
- Database is critical system component
- Database performance impacts overall system health
- Cleanup operations free resources for system

---

## 🎯 **Observability Best Practices**

### **1. Monitor Continuously**

**Check Observability Features:**
- **Daily:** System Health, API error rates
- **Weekly:** Database size and performance, Event Trails for security
- **Monthly:** Compliance reports, capacity planning
- **Quarterly:** Full audit of all observability data

---

### **2. Set Up Alerts**

**Critical Alerts:**
- System health below 85%
- API error rate above 5%
- Database disk space above 80%
- Security events (failed logins, permission denials)

**Warning Alerts:**
- System health 85-90%
- API error rate 1-5%
- Database disk space 70-80%
- Unusual usage patterns

---

### **3. Regular Maintenance**

**Weekly Tasks:**
- Review slow queries and optimize
- Check cleanup job execution
- Verify backup health
- Review security events

**Monthly Tasks:**
- Capacity planning review
- Database VACUUM operations
- Compliance report generation
- Archive old audit logs

---

### **4. Capacity Planning**

**Use Observability Data For:**
- Predict when resources will be exhausted
- Plan scaling before issues occur
- Optimize resource allocation
- Budget for infrastructure growth

**Key Metrics:**
- Database growth rate (MB/day)
- API request growth (% per month)
- Peak resource utilization (CPU, memory)
- Storage growth projections

---

### **5. Security Vigilance**

**Monitor Security Events:**
- Failed login attempts (brute force detection)
- Permission denials (unauthorized access attempts)
- Unusual data exports (data exfiltration)
- API abuse (rate limit violations)
- Suspicious IP addresses (geographic anomalies)

**Respond Quickly:**
- Investigate security alerts within 15 minutes
- Block suspicious IPs immediately
- Revoke compromised API keys
- Reset passwords if accounts compromised
- Document and report incidents

---

## 📊 **Observability Dashboard Layout**

**Recommended Admin Dashboard:**

**Top Section:**
- System Health Score (large, prominent)
- API Error Rate (real-time)
- Database Health Status
- Security Events (last 24h)

**Middle Section:**
- Service status cards (Frontend, API, Checker, DB, Redis)
- API request volume chart
- Database size and growth
- Recent security events

**Bottom Section:**
- Recent audit log entries
- Upcoming maintenance tasks
- Capacity planning alerts
- Quick actions (manual VACUUM, test alerts, etc.)

---

## 🔧 **Common Workflows**

### **Workflow 1: Investigating Performance Degradation**

1. **Check System Health**
   - Identify which service is slow
   - Check CPU, memory, disk usage

2. **Review API Metrics**
   - Which endpoints are slow?
   - Error rate increased?

3. **Analyze Database Health**
   - Slow queries identified?
   - Connection pool exhausted?
   - Database needs VACUUM?

4. **Check Event Trails**
   - What changed recently?
   - Configuration changes?
   - Deployment activity?

5. **Take Action**
   - Optimize slow queries
   - VACUUM database
   - Scale resources
   - Rollback changes if needed

---

### **Workflow 2: Security Incident Response**

1. **Detect in Event Trails**
   - Multiple failed logins alert
   - Suspicious activity detected

2. **Investigate**
   - Review all events from suspect IP
   - Check user account activity
   - Correlate with API metrics

3. **Contain**
   - Block IP address
   - Disable user account if compromised
   - Revoke API keys if leaked

4. **Analyze**
   - Full forensic analysis in Event Trails
   - Determine scope and impact
   - Identify vulnerabilities

5. **Report**
   - Generate compliance report
   - Document incident
   - Implement preventive measures

---

### **Workflow 3: Monthly Maintenance**

1. **Review System Health**
   - All services healthy?
   - Resource utilization trends?

2. **Optimize Database**
   - Run VACUUM on large tables
   - Apply index recommendations
   - Update statistics (ANALYZE)

3. **Clean Up Data**
   - Verify cleanup jobs ran
   - Manual cleanup if needed
   - Archive old audit logs

4. **Check Security**
   - Review security events
   - Update security policies
   - Rotate API keys

5. **Generate Reports**
   - Compliance reports
   - Capacity planning report
   - Share with stakeholders

---

## 📈 **Observability Metrics**

**Track These Key Metrics:**

### **System Health:**
- Overall health score: Target >95%
- Service uptime: Target 99.9%
- Resource utilization: Keep <70% average
- Error rate: Target <0.1%

### **API Performance:**
- Average response time: Target <100ms
- P95 response time: Target <200ms
- Error rate: Target <1%
- Request volume: Monitor growth

### **Database Health:**
- Query performance: Average <50ms
- Connection utilization: Keep <70%
- Disk space: Keep <70% used
- Dead tuples: Keep <10%

### **Security:**
- Failed login rate: Target <0.1%
- Security events: Investigate all
- Compliance: 100% audit coverage
- Event retention: Meet compliance requirements

---

## 🆘 **Troubleshooting**

### **Observability Features Not Accessible**

**Issue:** Cannot access System Health, API Metrics, etc.

**Possible Causes:**
- Not logged in as Admin
- Services not running
- Permission configuration error

**Solutions:**
- Verify Admin role
- Check service status: `docker compose ps`
- Review RBAC configuration

---

### **Metrics Not Updating**

**Issue:** Stale data, no real-time updates

**Possible Causes:**
- WebSocket connection lost
- Metrics collection service down
- Browser issue

**Solutions:**
- Refresh page
- Check System Health status
- Try different browser
- Check network connectivity

---

### **High Data Volume**

**Issue:** Too many events, slow queries

**Possible Causes:**
- Retention policies too long
- Cleanup jobs not running
- Database needs optimization

**Solutions:**
- Reduce retention periods
- Run manual cleanup
- VACUUM database
- Archive old data

---

## 🔐 **Security Considerations**

### **Access Control**

**Admin-Only Access:**
- All observability features restricted to Admins
- Contains sensitive system information
- Audit access to these features
- Limit number of Admin users

### **Data Sensitivity**

**Sensitive Information:**
- Audit logs contain user actions
- API metrics reveal usage patterns
- System health exposes infrastructure
- Database details show data structure

**Protection:**
- Mask sensitive values (passwords, API keys)
- Control export capabilities
- Monitor who accesses observability features
- Secure exported data

---

## 📚 **Related Documentation**

### **Core Features:**
- [Dashboard](../dashboard.md) - Monitor external services
- [Incidents](../incidents.md) - Incident management
- [Service Performance](../service-performance.md) - Service metrics
- [Settings](../settings.md) - System configuration

### **Observability Features:**
- [System Health](system-health.md) - Internal monitoring
- [API Metrics](api-metrics.md) - Request analytics
- [Database Health](database-health.md) - Database management
- [Event Trails](event-trails.md) - Audit logging

---

## 🎓 **Learning Path**

### **Week 1: Basics**
- Explore System Health dashboard
- Understand key metrics
- Set up health alerts
- Review daily statistics

### **Week 2: Performance**
- Analyze API metrics
- Identify slow endpoints
- Optimize database queries
- Monitor resource usage

### **Week 3: Security**
- Review Event Trails
- Understand event categories
- Set up security alerts
- Practice incident investigation

### **Week 4: Advanced**
- Capacity planning with observability data
- Create compliance reports
- Optimize cleanup schedules
- Implement best practices

---

## 🎉 **Summary**

Observability features provide the foundation for **reliable, secure, and compliant** Pulsimo operations:

✅ **System Health** - Know your infrastructure is healthy  
✅ **API Metrics** - Optimize performance and reliability  
✅ **Database Health** - Ensure data layer scales efficiently  
✅ **Event Trails** - Maintain accountability and compliance  

**Together, these features ensure Pulsimo remains the reliable monitoring platform your team can trust!**

---

**Master observability to master your monitoring infrastructure. What gets measured gets managed—and what gets monitored stays reliable!** 📊🔍
