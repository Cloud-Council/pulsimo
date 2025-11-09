# Users & RBAC - Role-Based Access Control

The Users feature provides comprehensive user management with a robust Role-Based Access Control (RBAC) system. Control who can view, edit, and manage your monitoring infrastructure with three distinct roles, ensuring security, compliance, and appropriate access levels for every team member.

---

## 🎯 **Overview**

In production environments, not everyone needs (or should have) full access to monitoring systems. The RBAC system in Pulsimo allows you to grant appropriate permissions based on job function, ensuring security while maintaining operational efficiency. From read-only stakeholder views to full administrative control, users can be precisely configured for their needs.

### **Key Benefits**

✅ **Three Role Levels** - Admin, Member, Viewer with distinct permissions  
✅ **Granular Control** - Fine-grained permissions for every action  
✅ **User Management** - Easy invitation and profile management  
✅ **Activity Tracking** - Audit trail of all user actions  
✅ **Team Collaboration** - Multiple users working together efficiently  
✅ **Security** - Principle of least privilege enforced  
✅ **Compliance** - Meet audit requirements for access control  
✅ **Scalable** - Support teams from 2 to 200+ users  

---

## 👥 **The Three Roles**

### **Admin Role** 🔴

**Full System Access - Use with Caution**

**Who Should Be Admin:**
- DevOps leads
- SRE managers  
- Platform team leads
- IT directors
- System owners

**Capabilities:**
- ✅ **Everything Members can do, PLUS:**
- ✅ Create, edit, delete users
- ✅ Change user roles
- ✅ Access Settings page
- ✅ Generate API keys
- ✅ Configure organization settings
- ✅ View audit logs
- ✅ Manage billing (if applicable)
- ✅ Delete projects
- ✅ Delete critical resources
- ✅ Configure SMTP and integrations
- ✅ Export all data

**Restrictions:**
- None - Full access to everything

**Typical Count:**
- Small teams: 1-2 admins
- Medium teams: 2-3 admins
- Large teams: 3-5 admins
- Keep minimal for security

---

### **Member Role** 🟡

**Operational Access - Most Engineers**

**Who Should Be Member:**
- DevOps engineers
- SRE engineers
- Backend developers
- On-call engineers
- Platform engineers
- Anyone responding to incidents

**Capabilities:**
- ✅ View all dashboards and metrics
- ✅ Create, edit, delete endpoints
- ✅ Create, edit, delete projects
- ✅ Acknowledge incidents
- ✅ Resolve incidents
- ✅ Add investigation notes
- ✅ Generate post-mortems
- ✅ Configure alert channels
- ✅ Test notification channels
- ✅ Create, edit, delete dependencies
- ✅ View and use dependency graph
- ✅ Export incident reports
- ✅ Access performance analytics
- ✅ Edit own profile

**Restrictions:**
- ❌ Cannot manage users
- ❌ Cannot change user roles
- ❌ Cannot access Settings page
- ❌ Cannot generate API keys
- ❌ Cannot delete accounts
- ❌ Cannot view audit logs
- ❌ Cannot configure organization settings

**Typical Count:**
- Most of your team should be Members
- 5-20 members in typical teams
- Anyone needing operational access

---

### **Viewer Role** 🟢

**Read-Only Access - Stakeholders**

**Who Should Be Viewer:**
- Product managers
- Engineering managers
- Executives
- Customer success teams
- Sales engineering
- External stakeholders
- Auditors

**Capabilities:**
- ✅ View Dashboard (all service statuses)
- ✅ View Projects (all projects and their health)
- ✅ View Incidents (current and historical)
- ✅ View Service Performance metrics
- ✅ View Dependencies graph
- ✅ View Alerts configuration (cannot modify)
- ✅ Export reports for viewing
- ✅ View endpoint details
- ✅ View user list (no actions)
- ✅ Edit own profile only

**Restrictions:**
- ❌ Cannot create, edit, or delete anything
- ❌ Cannot acknowledge or resolve incidents
- ❌ Cannot add notes to incidents
- ❌ Cannot test alert channels
- ❌ Cannot configure endpoints
- ❌ Cannot create dependencies
- ❌ Cannot access Settings
- ❌ Cannot invite users
- ❌ **Read-only throughout the system**

**Typical Count:**
- Unlimited viewers
- Stakeholders who need visibility
- Audit and compliance staff
- Management and leadership

---

## 📊 **Users Page Components**

### **1. Page Header**

**Page Title**
- **"Users"** or **"Team Members"** - Clear identification
- **Subtitle:** "Manage team access and permissions"

**Quick Stats Bar:**
- **Total Users** - Count of all users
- **Admins** - Count with admin role (red badge)
- **Members** - Count with member role (yellow badge)
- **Viewers** - Count with viewer role (green badge)
- **Online Now** - Currently active users

**Action Buttons** (Top-right, Admin only)
- **Add User** (blue-cyan gradient) - Invite new user
- **Bulk Actions** - Multi-select operations
- **Export Users** - Download user list (CSV)

---

### **2. Users Table**

**List View of All Users:**

#### **Table Columns:**

**Avatar & Name**
- Profile picture (if uploaded) or initials
- Full name (primary)
- Username/Email (secondary, lighter text)

**Role Badge**
- **Admin** - Red badge
- **Member** - Yellow badge
- **Viewer** - Green badge
- Click to change role (Admin only)

**Status Indicator**
- 🟢 **Online** - Currently active in system
- ⚫ **Offline** - Not currently active
- Last seen timestamp

**Activity Stats**
- **Incidents Handled** - Count of incidents acknowledged/resolved
- **Active Incidents** - Currently assigned incidents
- **MTTR** - Average time to resolve incidents
- Helps identify workload distribution

**Contact Information**
- Email address
- Phone number (if provided)
- Preferred notification method

**Join Date**
- When user was created
- Example: "Joined 3 months ago"

**Last Active**
- Most recent login or activity
- Example: "Active 2 hours ago"

**Actions Column** (Admin/Member actions differ)
- **View Profile** - See full user details
- **Edit** (Admin only) - Modify user settings
- **Change Role** (Admin only) - Promote/demote user
- **Disable** (Admin only) - Suspend account
- **Delete** (Admin only) - Remove user permanently
- **Assign Incidents** (Admin/Member) - Manual assignment
- **View Activity** - See audit log for this user

---

#### **Table Features:**

**Sorting:**
- Sort by name, role, join date, activity
- Ascending/descending toggle

**Filtering:**
- Filter by role (Admin/Member/Viewer)
- Filter by status (Online/Offline)
- Filter by activity (Active/Inactive last 30 days)

**Search:**
- Search by name or email
- Real-time filtering
- Fuzzy matching support

**Pagination:**
- 25/50/100 users per page
- Jump to page
- Total user count displayed

---

### **3. Add User Dialog**

**Click "Add User" to open (Admin only):**

#### **User Creation Form**

**Personal Information:**

**Full Name** (Required)
- User's complete name
- Used in UI, notifications, audit logs
- Example: "Jane Smith"

**Email Address** (Required)
- Used for login
- Must be unique
- Receives invitation email
- Example: jane.smith@company.com

**Phone Number** (Optional)
- For SMS alerts (future feature)
- Contact information
- Format: +1-555-123-4567

---

**Account Configuration:**

**Initial Password** (Required)
- Temporary password for first login
- User prompted to change on first login
- Minimum 8 characters
- Must include: uppercase, lowercase, number
- Or send invitation email for user to set password

**Role** (Required)
- Select: Admin, Member, or Viewer
- Default: Member (safest option)
- Can be changed later

**Force Password Change**
- Checkbox: Require password change on first login
- Recommended: Enabled (security best practice)

---

**Notifications Settings:**

**Send Invitation Email**
- Checkbox: Send email with login link
- Recommended: Enabled
- Email contains:
  - Welcome message
  - Login URL
  - Temporary password or setup link
  - Getting started guide link

**Default Notification Channels**
- Opt-in user to alert channels
- Can customize later in own profile

---

**Project Assignment** (Optional):
- Assign user to specific projects
- Useful for project-based teams
- Can add more later

**Team/Department** (Optional):
- Organizational unit
- For reporting and filtering
- Example: "Platform Engineering", "SRE Team"

---

**Create Button:**
- Validates all fields
- Creates user account
- Sends invitation (if enabled)
- Redirects to user list
- Confirmation message displayed

---

### **4. User Profile View**

**Click any user to see detailed profile:**

#### **Profile Header**

**Avatar Section:**
- Large profile picture or initials
- **Upload Photo** button (own profile or Admin)
- Supports JPG, PNG (max 5MB)
- Auto-crops to circle

**Basic Info:**
- Full name (editable)
- Email address (editable)
- Phone number (editable)
- Role badge (large, prominent)
- Account status (Active/Disabled)

**Quick Actions:**
- **Edit Profile** (own profile or Admin)
- **Change Password** (own profile)
- **Change Role** (Admin only)
- **Disable Account** (Admin only)
- **View Activity Log** (Admin only)

---

#### **Activity Statistics**

**Incident Response Metrics:**

**Total Incidents:**
- All-time incidents handled
- Breakdown: Acknowledged, Investigated, Resolved

**Currently Active:**
- Number of open incidents assigned to user
- Link to each incident
- Workload indicator

**Average MTTR:**
- Mean time to resolve for this user
- Compare to team average
- Trend over time (improving/degrading)

**Response Performance:**
- Average time to acknowledge (MTTA)
- Success rate (incidents resolved vs. escalated)
- Fastest resolution time
- Longest resolution time

---

#### **Recent Activity**

**Activity Timeline:**
- Last 50 actions by user
- Chronological (newest first)
- Shows:
  - Action type (login, acknowledge incident, create endpoint, etc.)
  - Timestamp (relative time)
  - Resource affected
  - IP address (security)
  - Device/browser (if available)

**Activity Categories:**
- Authentication (login, logout)
- Incidents (acknowledge, resolve, note)
- Endpoints (create, edit, delete)
- Projects (create, edit, archive)
- Dependencies (add, remove)
- Alerts (configure, test)
- Settings (if admin)

**Export Activity:**
- Download user activity log
- For audit or review purposes

---

#### **Permissions Summary**

**Visual Permission Matrix:**

Shows what this user can and cannot do:

**Feature Access:**
```
Dashboard:          ✅ View, ✅ Refresh
Projects:           ✅ View, ✅ Create, ✅ Edit
Incidents:          ✅ View, ✅ Acknowledge, ✅ Resolve
Service Performance: ✅ View, ✅ Export
Dependencies:       ✅ View, ✅ Create, ✅ Edit
Alerts:             ✅ View, ✅ Configure, ✅ Test
Users:              ❌ View, ❌ Create, ❌ Edit
Settings:           ❌ Access
```

*Example for Member role*

**Helpful for:**
- User understanding their capabilities
- Admin reviewing access levels
- Audit and compliance checks

---

### **5. Edit User Dialog**

**Admin can edit any user, users can edit own profile:**

**Editable Fields:**
- Full name
- Email address (with verification)
- Phone number
- Role (Admin only)
- Project assignments
- Team/department
- Profile picture

**Password Management:**
- **Change Password** button
- User changes own password (current password required)
- Admin can reset password (bypass current password)
- Force password change on next login

**Account Status:**
- Active (default)
- Disabled (admin only)
- Disabled users cannot log in
- Can be re-enabled anytime

**Notification Preferences:**
- Opt-in/out of alert channels
- Email notification frequency
- Desktop notification settings

---

### **6. Role Change Workflow**

**Admin-Only Feature:**

**Change User Role:**
1. Open user profile or click role badge in table
2. Select new role from dropdown
3. Confirmation dialog shows permission changes
4. Review changes carefully
5. Click "Confirm Role Change"

**Confirmation Dialog:**
```
Change Role for Jane Smith?

Current: Member
New: Admin

⚠️ This will grant the following additional permissions:
- User management (create, edit, delete users)
- Access to Settings page
- API key generation
- Organization configuration
- View audit logs

Are you sure?
[Cancel] [Confirm Change]
```

**What Happens:**
- User's role updated immediately
- User sees new UI options on next page load
- Audit log entry created
- Optional: Send notification to user
- Optional: Notify other admins

**Demotion Warning:**
If changing from Admin to Member/Viewer:
```
⚠️ This will remove the following permissions:
- User management
- Settings access
- API key generation

This user will lose access to administrative features.
Consider reassigning any critical tasks first.
```

---

## 🔐 **Security Features**

### **Password Policy**

**Requirements:**
- Minimum 8 characters
- At least one uppercase letter
- At least one lowercase letter
- At least one number
- At least one special character (optional but recommended)

**Password Strength Indicator:**
- Weak (red) - Doesn't meet requirements
- Fair (yellow) - Meets minimum requirements
- Strong (green) - Good password practices
- Very Strong (dark green) - Excellent password

**Password History:**
- Cannot reuse last 5 passwords
- Prevents password cycling

**Password Expiration:**
- Optional: Require password change every 90 days
- Configurable in Settings (Admin only)
- User prompted before expiration

---

### **Two-Factor Authentication (2FA)**

**Future Feature:**
- TOTP-based 2FA (Google Authenticator, Authy)
- Backup codes
- Optional or mandatory (org-wide setting)

---

### **Session Management**

**Session Duration:**
- Default: 24 hours
- Configurable: 1h, 4h, 8h, 24h, 7d

**Concurrent Sessions:**
- Allow multiple sessions (different devices)
- Or enforce single session only

**Session Termination:**
- User logout (immediate)
- Inactivity timeout (configurable)
- Admin can force logout (security)

---

### **Account Lockout**

**After Failed Login Attempts:**
- Lock account after 5 failed attempts (configurable)
- Lockout duration: 15 minutes (configurable)
- Or admin unlock required
- Email notification to user
- Security alert to admins

---

### **Audit Logging**

**Track All User Actions:**
- User login/logout
- Permission changes
- Resource creation/modification/deletion
- Configuration changes
- Data exports
- Failed actions (attempted access to unauthorized resources)

**Audit Log Details:**
- User name and ID
- Action performed
- Timestamp (precise)
- IP address
- User agent (browser/device)
- Resource affected
- Before/after values (for changes)

**Audit Log Access:**
- Admin only
- Cannot be modified or deleted
- Retained for compliance (configurable period)
- Exportable for external analysis

---

## 🎯 **Best Practices**

### **Role Assignment Strategy**

**Follow Principle of Least Privilege:**
- Give minimum access needed for job function
- Start with Viewer, escalate as needed
- Regularly review and demote if necessary

**Admin Role Guidelines:**
- Limit to 2-5 people maximum
- DevOps leads and managers only
- Not for regular engineers (use Member instead)
- Rotate if person leaves that role

**Member Role Guidelines:**
- Anyone who needs to respond to incidents
- DevOps engineers, SREs, platform team
- Most of your technical team

**Viewer Role Guidelines:**
- Stakeholders, managers, executives
- Anyone needing visibility without operational access
- External auditors or contractors
- Customer success wanting status visibility

---

### **User Onboarding**

**New Employee Checklist:**
1. Create user account with appropriate role
2. Assign to relevant projects
3. Send invitation email
4. Schedule onboarding session
5. Provide access to documentation
6. Add to relevant alert channels
7. Verify account setup and access

**Initial Role:**
- Start as Viewer for first week (learn system)
- Promote to Member after onboarding
- Grant Admin only after demonstrated need

---

### **User Offboarding**

**When Employee Leaves:**
1. **Immediately disable account** (don't delete yet)
2. Remove from all alert channels
3. Reassign their active incidents
4. Transfer ownership of created resources
5. Review audit logs for their activity
6. After 30-90 days, delete account (retain logs)

**Disable vs. Delete:**
- **Disable:** Temporary, reversible, retains data
- **Delete:** Permanent, for compliance or clean-up

---

### **Access Reviews**

**Quarterly Review:**
- Review all user accounts
- Verify roles are still appropriate
- Remove inactive accounts
- Check for privilege creep
- Update based on org changes

**Review Questions:**
- Does this person still need access?
- Is their role still appropriate?
- Have their responsibilities changed?
- Are they actively using the system?

---

## 📊 **User Analytics**

### **Team Performance Dashboard**

**Aggregate Metrics:**
- Total incidents handled by team
- Average MTTR across all users
- Workload distribution (who handles most?)
- Response time statistics
- Top performers

**Individual Comparisons:**
- Incidents per user
- MTTR per user
- Acknowledgement speed
- Resolution rate
- Identify training needs

---

### **Workload Balancing**

**Identify Imbalances:**
- One person handling 80% of incidents?
- Some users never acknowledging?
- Burnout risk indicators
- Need for rotation policy

**Recommendations:**
- Distribute workload more evenly
- Create on-call rotation schedule
- Cross-train team members
- Consider capacity and hiring needs

---

## 🆘 **Troubleshooting**

### **Cannot Log In**

**Possible Causes:**
- Incorrect password
- Account disabled
- Account locked (failed attempts)
- Email not verified
- Browser cookies disabled

**Solutions:**
- Reset password via "Forgot Password"
- Contact admin to re-enable account
- Wait for lockout period to expire (15 min)
- Check email for verification link
- Clear browser cache and cookies

---

### **Permission Denied Errors**

**User sees "You don't have permission":**
- Verify their role (might be Viewer trying to edit)
- Check if account disabled
- Verify not trying to access Admin-only features
- Contact admin for role upgrade if legitimate need

---

### **Missing User in List**

**Cannot find user:**
- Check if account disabled (enable "Show Disabled")
- Search by email address (might have different name)
- Check if accidentally deleted
- Verify you have permission to see all users

---

## 📚 **Related Documentation**

- **[Settings](settings.md)** - Organization and security settings
- **[Incidents](incidents.md)** - User assignment and incident handling
- **[Projects](projects.md)** - Project-based access control
- **[Alerts](alerts.md)** - User notification preferences
- **[Getting Started](../getting-started.md)** - Initial user setup

---

**Effective user management is the foundation of secure and efficient operations. Define roles clearly, assign appropriately, and review regularly. Your system's security depends on it!** 👥
