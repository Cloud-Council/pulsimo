# Pulsimo Features Overview

This section provides comprehensive documentation for all Pulsimo features, organized by functional area.

---

## 📖 **Documentation Structure**

Each feature is documented in detail with:

✅ **Feature Overview** - What it does and why it matters  
✅ **User Interface Guide** - Visual walkthrough of the interface  
✅ **Common Workflows** - Step-by-step instructions for typical tasks  
✅ **Best Practices** - Recommendations for optimal usage  
✅ **Advanced Features** - Power-user capabilities  
✅ **Troubleshooting** - Common issues and solutions  

---

## 🎯 **Core Features**

### **[1. Dashboard](dashboard.md)**

Your central monitoring hub providing real-time visibility into all services.

**Key Capabilities:**
- Real-time status overview of all endpoints
- Live health check results with WebSocket updates
- Quick statistics (total, healthy, down, partial outage)
- Service cards with instant status, response time, and uptime
- Countdown timers showing next health check
- Quick-add endpoint functionality
- Manual refresh controls
- Project organization view
- Incident widget integration

**When to Use:** Daily monitoring, status at-a-glance, quick health checks

---

### **[2. Projects](projects.md)**

Organize and group your monitoring endpoints by application, team, or environment.

**Key Capabilities:**
- Create unlimited projects with custom metadata
- Assign endpoints to projects for organization
- Color-coding and visual identification
- Project-level statistics and health overview
- Tag-based categorization
- Priority levels (High, Medium, Low)
- SLA compliance tracking per project
- Quick actions panel for common tasks
- Project-filtered views across all features

**When to Use:** Managing multiple applications, team-based access control, environment separation

---

### **[3. Incidents](incidents.md)**

Complete incident lifecycle management from detection through resolution.

**Key Capabilities:**
- Automatic incident creation when endpoints fail
- Multi-state workflow (Open → Acknowledged → Investigating → Resolved)
- Incident acknowledgement to stop alert spam
- Investigation notes and collaboration
- Automatic downtime calculation
- Post-mortem report generation
- JSON export for external systems
- Full audit trail of all actions
- MTTR (Mean Time To Resolve) tracking
- Incident history and trends
- Escalation tracking

**When to Use:** Managing outages, post-incident analysis, compliance reporting

---

### **[4. Service Performance](service-performance.md)**

In-depth analytics and performance metrics for all monitored services.

**Key Capabilities:**
- Response time trends and analytics
- Availability percentage calculations (24h, 7d, 30d)
- Success and error rate tracking
- Slowest endpoint identification
- Most frequently failing services
- SLA compliance monitoring (99.9% uptime targets)
- Performance degradation alerts
- Historical trend analysis
- Comparative metrics across services
- Per-service health score

**When to Use:** Performance optimization, capacity planning, SLA reporting

---

### **[5. Dependencies](dependencies.md)**

Visual mapping and analysis of service dependencies with automatic discovery.

**Key Capabilities:**
- Interactive dependency graph visualization
- Automatic dependency discovery from traffic patterns
- Manual dependency creation and management
- Three dependency types (STRONG, WEAK, MONITORING)
- Critical path analysis
- Single point of failure (SPOF) detection
- Blast radius calculation
- Orphaned services identification
- Project-based filtering
- Dependency approval workflow
- Impact analysis when services fail
- Visual health status in graph

**When to Use:** Architecture planning, incident impact assessment, reliability engineering

---

### **[6. Alerts & Notifications](alerts.md)**

Multi-channel alerting system with intelligent routing and repeat controls.

**Key Capabilities:**
- Six notification channels: Email, Slack, Discord, Microsoft Teams, Google Chat, Custom Webhooks
- Per-endpoint alert policies
- Configurable failure thresholds (consecutive failures before alerting)
- First-failure warnings for critical services
- Repeat interval controls (prevent alert spam)
- Recovery notifications
- Channel testing and validation
- Multi-channel routing (send critical to PagerDuty, info to Slack)
- Alert history and audit trail
- Notification delivery tracking
- Retry logic for failed notifications

**When to Use:** Setting up on-call alerts, team notifications, stakeholder updates

---

### **[7. Users & RBAC](users.md)**

Comprehensive user management with role-based access control.

**Key Capabilities:**
- Three user roles: Admin, Member, Viewer
- Granular permission system
- User invitation and onboarding
- Password management and security
- User activity tracking
- Online/offline status indicators
- Per-user incident assignment
- Capacity management (prevent overload)
- Performance metrics per user
- Compliance and security scoring
- Profile customization
- API access control

**When to Use:** Team management, access control, compliance requirements

---

### **[8. Settings](settings.md)**

System-wide configuration and administrative controls.

**Key Capabilities:**
- Organization profile management
- Timezone and date format configuration
- API key generation and management
- SMTP configuration for email notifications
- Member permissions overview
- System health monitoring
- Audit log access
- Backup and restore controls
- Integration settings
- Branding customization (future)

**When to Use:** Initial setup, organization management, API integrations

---

## 🔄 **Feature Integration**

Pulsimo's features work seamlessly together:

### **Monitoring → Incidents → Alerts**

1. **Checker service** continuously monitors endpoints
2. When failures exceed threshold, **incident** is created automatically
3. **Alerts** are sent through configured notification channels
4. Team members see incident in **Incidents page**
5. Performance data flows to **Service Performance** analytics

### **Projects → Endpoints → Dependencies**

1. **Projects** organize endpoints logically
2. **Endpoints** are created within projects
3. **Dependencies** map relationships between endpoints
4. **Graph visualization** shows project-based service architecture

### **Users → RBAC → Incidents**

1. **Users** are created with specific roles
2. **RBAC** controls what each user can access
3. **Incidents** are assigned to appropriate team members
4. **Audit trail** tracks all user actions

---

## 🎯 **Feature Usage by Role**

### **Admin Users**

**Daily Tasks:**
- Monitor overall system health
- Manage user accounts and permissions
- Configure organization settings
- Generate API keys for integrations
- Review audit logs

**Key Features:**
- All features (full access)
- Settings page
- User management
- API key management

---

### **Member Users (DevOps/SRE)**

**Daily Tasks:**
- Monitor service health on dashboard
- Acknowledge and resolve incidents
- Configure endpoints and alert policies
- Create dependencies
- Analyze performance metrics

**Key Features:**
- Dashboard
- Incidents (full access)
- Projects (create/edit)
- Endpoints (create/edit)
- Dependencies
- Alerts (configure channels)

---

### **Viewer Users (Stakeholders)**

**Daily Tasks:**
- Check service status
- Review incident history
- Monitor SLA compliance
- View performance trends

**Key Features:**
- Dashboard (read-only)
- Incidents (view only)
- Projects (view only)
- Service Performance (view only)
- Dependencies (view only)

---

## 📊 **Feature Maturity**

| Feature | Status | Stability | Documentation |
|---------|--------|-----------|---------------|
| Dashboard | ✅ Production | Stable | Complete |
| Projects | ✅ Production | Stable | Complete |
| Incidents | ✅ Production | Stable | Complete |
| Service Performance | ✅ Production | Stable | Complete |
| Dependencies | ✅ Production | Stable | Complete |
| Alerts | ✅ Production | Stable | Complete |
| Users & RBAC | ✅ Production | Stable | Complete |
| Settings | ✅ Production | Stable | Complete |
| API Integration | ✅ Production | Stable | In Progress |
| Mobile App | 🚧 Planned | N/A | N/A |
| Advanced Analytics | 🚧 Planned | N/A | N/A |

---

## 🚀 **Getting Started**

**New Users:**
1. Start with **[Dashboard](dashboard.md)** to understand monitoring basics
2. Read **[Projects](projects.md)** to organize your endpoints
3. Learn **[Alerts](alerts.md)** to configure notifications
4. Explore **[Incidents](incidents.md)** to handle outages

**Experienced Users:**
1. Deep dive into **[Dependencies](dependencies.md)** for architecture mapping
2. Use **[Service Performance](service-performance.md)** for optimization
3. Configure **[Users & RBAC](users.md)** for team management
4. Customize **[Settings](settings.md)** for your organization

---

## 📚 **Additional Documentation**

- **[Installation Guide](../installation/README.md)** - Setup and deployment
- **[Getting Started](../getting-started.md)** - Quick start walkthrough
- **[API Reference](../api/README.md)** - API integration guide
- **[Best Practices](../best-practices.md)** - Production recommendations
- **[Troubleshooting](../troubleshooting.md)** - Common issues
- **[FAQ](../faq.md)** - Frequently asked questions

---

## 💡 **Feature Highlights**

### **Real-Time Updates**

All features use WebSocket connections for instant updates:
- Dashboard status changes appear immediately
- Incident status updates in real-time
- Performance metrics stream continuously
- Dependency graph reflects live service health

### **Cross-Feature Navigation**

Navigate seamlessly between related features:
- Click endpoint name on Dashboard → Opens endpoint details
- Click incident → View affected endpoint and dependencies
- Click project → Filter all views by that project
- Click user → View assigned incidents and performance

### **Consistent UI/UX**

All features share consistent design patterns:
- Blue-cyan gradient for primary actions
- Color-coded status indicators (green=up, red=down)
- Responsive layout for mobile and tablet
- Dark mode support throughout
- Intuitive form validation and error messages

---

## 🎓 **Learning Path**

### **Week 1: Fundamentals**
- Set up projects and endpoints
- Configure basic alert channels
- Understand dashboard metrics
- Practice incident acknowledgement

### **Week 2: Intermediate**
- Map service dependencies
- Analyze performance trends
- Customize alert policies
- Set up team members

### **Week 3: Advanced**
- Build complex dependency graphs
- Create custom API integrations
- Optimize performance thresholds
- Implement advanced RBAC strategies

### **Week 4: Mastery**
- Contribute to best practices
- Train team members
- Document runbooks
- Optimize for scale

---

## 🔍 **Feature Comparison**

| Need | Use This Feature | Alternative |
|------|------------------|-------------|
| Check if services are up | Dashboard | API endpoints |
| Organize by application | Projects | Tags |
| Handle outages | Incidents | Manual tracking |
| Understand architecture | Dependencies | External diagrams |
| Get notified | Alerts | Email only |
| Control access | Users & RBAC | Shared accounts |
| Analyze trends | Service Performance | External analytics |
| Configure system | Settings | Environment variables |

---

## 📞 **Feature Requests**

Missing a feature you need? We'd love to hear from you:

- **GitHub Issues:** Submit feature requests
- **Discussions:** Discuss ideas with the community
- **Contributions:** Build and contribute the feature

---

**Explore each feature in detail using the links above!** 🚀
