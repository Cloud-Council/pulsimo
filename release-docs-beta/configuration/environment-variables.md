# 🔧 Environment Variables - Complete Guide

**Comprehensive reference for configuring Pulsimo using environment variables.**

---

## 📋 Quick Navigation

- **[Quick Start](#-quick-start)** - Get running in 5 minutes
- **[All Variables Reference](#-all-variables-reference)** - Complete list
- **[Detailed Explanations](#-detailed-explanations)** - Deep dive into each variable
- **[Configuration Examples](#-configuration-examples)** - Real-world scenarios
- **[Best Practices](#-best-practices)** - Production recommendations
- **[Troubleshooting](#-troubleshooting)** - Common issues

---

## 🚀 Quick Start

**Minimum configuration to deploy Pulsimo:**

```bash
# 1. Copy template
cp .env.example .env

# 2. Edit .env - Set these 3 variables:
HOST_IP=192.168.1.100                        # Your server IP
POSTGRES_PASSWORD=$(openssl rand -base64 24) # Generate secure password
JWT_SECRET=$(openssl rand -base64 32)        # Generate secure secret

# 3. Deploy
./setup-prod.sh
```

**That's it!** All other variables have sensible defaults.

---

## 📊 All Variables Reference

### **Essential Variables** (Must Configure)

| Variable | Default | Description |
|----------|---------|-------------|
| `HOST_IP` | `localhost` | Server IP or domain name |
| `POSTGRES_PASSWORD` | ⚠️ Must change! | Database password |
| `JWT_SECRET` | ⚠️ Must change! | Authentication secret |

### **Optional Variables** (Have Defaults)

| Category | Variables | Default Values |
|----------|-----------|----------------|
| **Database** | `POSTGRES_DB`, `POSTGRES_USER`, `POSTGRES_PORT` | `monitoring_system`, `monitoring`, `5432` |
| **Redis** | `REDIS_URL`, `REDIS_PORT` | `redis://redis:6379`, `6379` |
| **API Gateway** | `API_HOST`, `API_PORT`, `API_LOG_LEVEL` | `0.0.0.0`, `8080`, `info` |
| **Checker** | `CHECK_INTERVAL_SECONDS`, `MAX_CONCURRENT_CHECKS`, `CHECK_TIMEOUT_SECONDS` | `30`, `100`, `30` |
| **Notification** | `NOTIFICATION_LOG_LEVEL` | `info` |
| **Dependency** | `DISCOVERY_INTERVAL_SECONDS`, `IMPACT_CALCULATION_INTERVAL_SECONDS` | `300`, `600` |
| **Maintenance** | `TZ`, `MAINTENANCE_PORT` | `UTC`, `3007` |
| **Ports** | `EXPOSE_*_PORT` variables | `3000`, `8080`, `5432`, `6379` |

### **SMTP Variables** (Optional - For Email Notifications)

| Variable | Default | Required For Email |
|----------|---------|-------------------|
| `SMTP_HOST` | `smtp.gmail.com` | Yes |
| `SMTP_PORT` | `587` | Yes |
| `SMTP_USERNAME` | - | Yes |
| `SMTP_PASSWORD` | - | Yes |
| `FROM_EMAIL` | - | Yes |
| `FROM_NAME` | `Pulsimo Monitoring` | No |

---

## 📖 Detailed Explanations

### **1. HOST_IP** ⭐ CRITICAL

**What it does:** Your server's IP address or domain where Pulsimo is accessible.

```bash
# Examples:
HOST_IP=localhost            # Local development only
HOST_IP=192.168.1.100       # Server on local network
HOST_IP=203.0.113.45        # Public IP address
HOST_IP=monitoring.company.com  # Domain name
```

**How it's used:**
- Frontend constructs API URL: `http://${HOST_IP}:8080`
- Frontend constructs WebSocket URL: `ws://${HOST_IP}:8080`
- Access URLs: `http://${HOST_IP}:3000` (frontend), `http://${HOST_IP}:8080` (API)

**Important:**
- ⚠️ `localhost` only works if accessing from same machine
- ✅ Use actual server IP for network access
- ✅ Can be changed anytime (restart containers after)

---

### **2. POSTGRES_PASSWORD** ⭐ CRITICAL

**What it does:** PostgreSQL database password.

**Security:** **MUST CHANGE before production!**

```bash
# Generate secure password:
POSTGRES_PASSWORD=$(openssl rand -base64 24)

# Example result:
POSTGRES_PASSWORD=generated_password
```

**Requirements:**
- ⚠️ Never use default password
- ✅ Use 24+ random characters
- ✅ Include letters, numbers, special characters
- ✅ Store securely

---

### **3. JWT_SECRET** ⭐ CRITICAL

**What it does:** Secret key for signing authentication tokens.

**Security:** **MUST be random and secret!**

```bash
# Generate:
JWT_SECRET=$(openssl rand -base64 32)

# Example result:
JWT_SECRET=generated_secrets

**What happens if compromised:**
- Attackers can create fake tokens
- Can impersonate any user
- Full system access

**Requirements:**
- ⚠️ Must be random (not dictionary words)
- ⚠️ Must be kept secret (never commit to git)
- ⚠️ Must be 32+ characters
- ⚠️ Changing it logs out all users

---

### **4. CHECK_INTERVAL_SECONDS** ⭐ IMPORTANT

**What it does:** How often Checker Service wakes up to check endpoints.

```bash
CHECK_INTERVAL_SECONDS=30  # Default
```

**How it works:**
```
Every 30 seconds:
  1. Checker wakes up
  2. Finds endpoints that need checking
  3. Performs health checks
  4. Saves results
  5. Sleeps again
```

**Critical concept:** This sets the **minimum** check frequency!

```bash
# If you have endpoints with 10s intervals:
CHECK_INTERVAL_SECONDS=10  # ✅ Good - can check every 10s
CHECK_INTERVAL_SECONDS=30  # ⚠️ Bad - endpoints checked every 30s (not 10s!)
```

**Rule:** Set to smallest endpoint interval you need.

**Recommendations:**

| Value | Use Case | Resources |
|-------|----------|-----------|
| `10` | Critical services (payment, finance) | High CPU/DB |
| `30` | Standard monitoring (recommended) | Moderate |
| `60` | Non-critical, cost-sensitive | Low |
| `300` | Background services, dev/test | Minimal |

---

### **5. MAX_CONCURRENT_CHECKS**

**What it does:** How many endpoints checked simultaneously.

```bash
MAX_CONCURRENT_CHECKS=100  # Default
```

**How it works:**
- 500 endpoints with `MAX_CONCURRENT_CHECKS=100`
- Checks in 5 batches of 100

**Recommendations:**

| Your Setup | Recommended Value |
|------------|------------------|
| < 50 endpoints | `50` |
| < 500 endpoints | `100` |
| 500-1000 endpoints | `200` |
| 1000+ endpoints | `500` |

---

### **6. CHECK_TIMEOUT_SECONDS**

**What it does:** Max time to wait for endpoint response.

```bash
CHECK_TIMEOUT_SECONDS=30  # Default
```

**Examples:**
- Endpoint responds in 25s → ✅ UP (within timeout)
- Endpoint responds in 35s → ❌ DOWN (timeout exceeded)

**Recommendations:**

| Endpoint Type | Timeout |
|---------------|---------|
| Fast APIs | `10` |
| Standard services | `30` |
| Databases with queries | `60` |
| Batch jobs | `120` |

---

### **7. SMTP Configuration** (Email Notifications)

Required only if you want email alerts.

**Gmail Example:**
```bash
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your-email@gmail.com
SMTP_PASSWORD=abcd efgh ijkl mnop  # App Password from Google
FROM_EMAIL=your-email@gmail.com
FROM_NAME=Pulsimo Monitoring
```

**Gmail Setup:**
1. Enable 2FA on Google account
2. Generate App Password: https://myaccount.google.com/apppasswords
3. Use 16-character app password (NOT your Gmail password)

**AWS SES Example:**
```bash
SMTP_HOST=email-smtp.us-east-1.amazonaws.com
SMTP_PORT=587
SMTP_USERNAME=AKIAIOSFODNN7EXAMPLE  # SMTP credentials
SMTP_PASSWORD=yourSMTPpasswords
FROM_EMAIL=alerts@yourcompany.com
FROM_NAME=Company Monitoring
```

**SendGrid Example:**
```bash
SMTP_HOST=smtp.sendgrid.net
SMTP_PORT=587
SMTP_USERNAME=apikey  # Literally "apikey"
SMTP_PASSWORD=Sgsmtppassword
FROM_EMAIL=alerts@yourcompany.com
FROM_NAME=Pulsimo Alerts
```

---

### **8. Frontend Configuration**

**Two options:**

**Option 1: Simple (Recommended)**
```bash
# Just set HOST_IP
HOST_IP=192.168.1.100

# Frontend auto-constructs:
# API: http://192.168.1.100:8080
# WS:  ws://192.168.1.100:8080
```

**Option 2: Explicit URLs**
```bash
# Override with specific URLs
NEXT_PUBLIC_API_URL=http://monitoring.company.com:8080
NEXT_PUBLIC_WS_URL=ws://monitoring.company.com:8080
```

---

### **9. Port Configuration**

```bash
EXPOSE_FRONTEND_PORT=3000  # Web UI
EXPOSE_API_PORT=8080       # Backend API
EXPOSE_POSTGRES_PORT=5432  # Database (usually don't expose)
EXPOSE_REDIS_PORT=6379     # Cache (usually don't expose)
```

**Security:** Only expose frontend and API ports. Keep database/redis internal unless needed.

---

## 📚 Configuration Examples

### **Example 1: Local Development**

```bash
HOST_IP=localhost
POSTGRES_PASSWORD=dev_password
JWT_SECRET=dev_secret_not_for_production
CHECK_INTERVAL_SECONDS=30
API_LOG_LEVEL=debug
# No SMTP needed
```

---

### **Example 2: Small Production (Single Server)**

```bash
HOST_IP=192.168.1.100
POSTGRES_PASSWORD=$(openssl rand -base64 24)
JWT_SECRET=$(openssl rand -base64 32)
CHECK_INTERVAL_SECONDS=30
MAX_CONCURRENT_CHECKS=100
CHECK_TIMEOUT_SECONDS=30

# Email notifications
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=alerts@company.com
SMTP_PASSWORD=abcd efgh ijkl mnop
FROM_EMAIL=alerts@company.com
FROM_NAME=Company Monitoring

# Standard ports
EXPOSE_FRONTEND_PORT=3000
EXPOSE_API_PORT=8080
```

---

### **Example 3: High-Traffic Production**

```bash
HOST_IP=monitoring.company.com
POSTGRES_PASSWORD=<very-secure-password>
JWT_SECRET=<very-secure-secret>

# Aggressive monitoring
CHECK_INTERVAL_SECONDS=10
MAX_CONCURRENT_CHECKS=200
CHECK_TIMEOUT_SECONDS=15

# AWS SES for email
SMTP_HOST=email-smtp.us-east-1.amazonaws.com
SMTP_PORT=587
SMTP_USERNAME=<aws-smtp-user>
SMTP_PASSWORD=<aws-smtp-password>
FROM_EMAIL=alerts@company.com

# Standard ports
EXPOSE_FRONTEND_PORT=3000
EXPOSE_API_PORT=8080
```

---

### **Example 4: Cloud Deployment (AWS/Azure/GCP)**

```bash
# Use public IP or domain
HOST_IP=ec2-52-123-45-67.compute-1.amazonaws.com

# Or domain name
# HOST_IP=monitoring.company.com

POSTGRES_PASSWORD=<generated-secure-password>
JWT_SECRET=<generated-secure-secret>

# Standard monitoring
CHECK_INTERVAL_SECONDS=30
MAX_CONCURRENT_CHECKS=150

# Cloud email service
SMTP_HOST=smtp.sendgrid.net
SMTP_PORT=587
SMTP_USERNAME=apikey
SMTP_PASSWORD=SG.xxx
FROM_EMAIL=noreply@company.com

EXPOSE_FRONTEND_PORT=3000
EXPOSE_API_PORT=8080
```

---

## ✅ Best Practices

### **Security**

1. **Always change these before production:**
   ```bash
   POSTGRES_PASSWORD=$(openssl rand -base64 24)
   JWT_SECRET=$(openssl rand -base64 32)
   ```

2. **Never commit `.env` to git:**
   ```bash
   echo ".env" >> .gitignore
   ```

3. **Use strong SMTP passwords:**
   - Gmail: App Passwords (not account password)
   - AWS SES: IAM-generated SMTP credentials
   - SendGrid: API keys

4. **Don't expose database ports publicly:**
   - Comment out `EXPOSE_POSTGRES_PORT` in production
   - Use SSH tunnels or VPN for database access

### **Performance**

1. **Match checker interval to needs:**
   ```bash
   # Most endpoints need 30s checks:
   CHECK_INTERVAL_SECONDS=30
   
   # Some critical endpoints need 10s checks:
   CHECK_INTERVAL_SECONDS=10
   ```

2. **Size concurrent checks appropriately:**
   ```bash
   # Formula: MIN(total_endpoints/2, vCPU * 25)
   # 200 endpoints, 4 vCPU: MAX_CONCURRENT_CHECKS=100
   ```

3. **Use appropriate timeouts:**
   ```bash
   # Fast APIs: 10s
   # Standard: 30s
   # Slow services: 60s
   CHECK_TIMEOUT_SECONDS=30
   ```

### **Reliability**

1. **Use UTC timezone for consistency:**
   ```bash
   TZ=UTC  # Maintenance jobs run at consistent times
   ```

2. **Enable appropriate logging:**
   ```bash
   # Production
   API_LOG_LEVEL=info
   CHECKER_LOG_LEVEL=info
   
   # Troubleshooting
   API_LOG_LEVEL=debug
   CHECKER_LOG_LEVEL=debug
   ```

3. **Keep ports standard unless conflicts:**
   ```bash
   EXPOSE_FRONTEND_PORT=3000
   EXPOSE_API_PORT=8080
   ```

---

## 🐛 Troubleshooting

### **Frontend shows "localhost" instead of server IP**

**Problem:** Frontend connecting to wrong URL

**Solution:**
```bash
# Check .env file
grep HOST_IP .env

# Should show your actual IP, not localhost
HOST_IP=192.168.1.100

# Restart frontend
docker compose restart frontend
```

---

### **Endpoints not being checked**

**Problem:** CHECK_INTERVAL_SECONDS too high

**Diagnosis:**
```bash
# Check current interval
grep CHECK_INTERVAL_SECONDS .env

# Check endpoint interval in UI
# If endpoint interval < CHECK_INTERVAL_SECONDS, that's the issue
```

**Solution:**
```bash
# Lower CHECK_INTERVAL_SECONDS to match smallest endpoint interval
CHECK_INTERVAL_SECONDS=10

# Restart checker
docker compose restart checker
```

---

### **Email notifications not working**

**Gmail Issues:**
```bash
# Are you using App Password (not account password)?
# Is 2FA enabled on your Google account?
# Generated App Password at: https://myaccount.google.com/apppasswords

# Test SMTP connection:
docker compose logs notification | grep -i smtp
```

**AWS SES Issues:**
```bash
# Are you using SMTP credentials (not AWS access keys)?
# Is sender email verified in SES?
# Check SES sending limits

# Verify FROM_EMAIL is verified in SES console
```

---

### **High CPU usage from checker**

**Problem:** Too frequent checking or too many concurrent checks

**Solution:**
```bash
# Option 1: Reduce frequency
CHECK_INTERVAL_SECONDS=60  # Up from 30

# Option 2: Reduce concurrency
MAX_CONCURRENT_CHECKS=50  # Down from 100

# Option 3: Both
CHECK_INTERVAL_SECONDS=60
MAX_CONCURRENT_CHECKS=50

# Restart checker
docker compose restart checker
```

---

## 📞 Need Help?

**Configuration not working?**

1. **Validate syntax:**
   ```bash
   docker compose -f docker-compose.prod.yml config
   ```

2. **Check logs:**
   ```bash
   docker compose logs [service-name]
   ```

3. **Verify environment variables:**
   ```bash
   docker compose exec [service-name] env
   ```

4. **Review this guide** for specific variable documentation

5. **Check deployment guide:** `release-docs/installation/README.md`

---

**Configuration complete? Deploy with:**
```bash
./setup-prod.sh
```

**Happy monitoring!** 🎉
