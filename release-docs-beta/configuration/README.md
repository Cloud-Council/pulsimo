# ⚙️ Configuration Guide

**Complete configuration documentation for Pulsimo Monitoring System.**

---

## 📚 Configuration Documentation

### **[Environment Variables Guide](environment-variables.md)** ⭐ START HERE

Complete reference for all `.env` configuration options:
- **Quick Start** - Get running in 5 minutes
- **All Variables Reference** - Complete list with defaults
- **Detailed Explanations** - Deep dive into each variable
- **Configuration Examples** - Real-world scenarios
- **Best Practices** - Production recommendations  
- **Troubleshooting** - Common configuration issues

**Topics covered:**
- Host & Network Configuration
- Database & Redis Setup
- Authentication & Security
- Email Notifications (SMTP)
- Monitoring Configuration (Checker Service)
- Resource Limits & Performance
- Frontend Configuration
- Port Mapping

---

## 🎯 Quick Configuration Guide

### **Essential Variables (Must Configure)**

```bash
# 1. Set your server IP
HOST_IP=192.168.1.100

# 2. Generate secure database password
POSTGRES_PASSWORD=$(openssl rand -base64 24)

# 3. Generate secure JWT secret
JWT_SECRET=$(openssl rand -base64 32)
```

### **Optional Email Notifications**

```bash
# Gmail example
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your-email@gmail.com
SMTP_PASSWORD=your-app-password
FROM_EMAIL=your-email@gmail.com
```

### **Monitoring Configuration**

```bash
# How often to check endpoints
CHECK_INTERVAL_SECONDS=30

# How many endpoints to check simultaneously  
MAX_CONCURRENT_CHECKS=100

# Max wait time for response
CHECK_TIMEOUT_SECONDS=30
```

---

## 📖 Configuration Topics

### **1. Network & Access**
- Setting `HOST_IP` for your environment
- Port configuration and conflicts
- Domain name setup
- Firewall configuration

### **2. Security**
- Generating strong passwords
- JWT secret management
- SMTP authentication
- Database security

### **3. Performance Tuning**
- Checker interval optimization
- Concurrent check limits
- Timeout configuration
- Resource allocation

### **4. Email Notifications**
- SMTP provider setup (Gmail, AWS SES, SendGrid)
- Troubleshooting email delivery
- Email configuration examples

### **5. Advanced Configuration**
- Multiple environments (dev/staging/prod)
- Custom port mappings
- Timezone configuration
- Log levels

---

## 🔗 Related Documentation

- **[Installation Guide](../installation/README.md)** - How to deploy Pulsimo
- **[Getting Started](../getting-started.md)** - First steps after installation
- **[Features Documentation](../features/)** - Using Pulsimo features
- **[Deployment Guide](/DEPLOYMENT.md)** - Production deployment strategies

---

## 💡 Configuration Examples

### **Local Development**
```bash
HOST_IP=localhost
POSTGRES_PASSWORD=dev_password
JWT_SECRET=dev_secret
CHECK_INTERVAL_SECONDS=30
```

### **Small Production**
```bash
HOST_IP=192.168.1.100
POSTGRES_PASSWORD=$(openssl rand -base64 24)
JWT_SECRET=$(openssl rand -base64 32)
CHECK_INTERVAL_SECONDS=30
# + SMTP configuration
```

### **High-Traffic Production**
```bash
HOST_IP=monitoring.company.com
POSTGRES_PASSWORD=<secure>
JWT_SECRET=<secure>
CHECK_INTERVAL_SECONDS=10
MAX_CONCURRENT_CHECKS=200
# + SMTP configuration
```

---

## 🆘 Need Help?

**Configuration not working?**

1. **Read the [Environment Variables Guide](environment-variables.md)**
2. **Check example configurations** above
3. **Validate your configuration:**
   ```bash
   docker compose -f docker-compose.prod.yml config
   ```
4. **Review deployment guide** for step-by-step instructions
5. **Check service logs:**
   ```bash
   docker compose logs [service-name]
   ```

---

**Ready to deploy? See [Installation Guide](../installation/README.md)**
