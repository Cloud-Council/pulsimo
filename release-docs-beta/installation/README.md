# Installation Guide - Pulsimo

Welcome to the Pulsimo installation guide. This document will walk you through the complete setup process for deploying Pulsimo on your infrastructure.

---

## 📋 **System Requirements**

### **Minimum Requirements**

| Component | Specification | Notes |
|-----------|---------------|-------|
| **CPU** | 2 cores (4 recommended) | For handling concurrent health checks |
| **RAM** | 4 GB (8 GB recommended) | Supports up to 200 endpoints |
| **Storage** | 20 GB SSD | For database and logs |
| **OS** | Linux (Ubuntu 20.04+, CentOS 8+, Debian 11+) | Docker-compatible distribution |
| **Network** | Stable internet connection | For pulling Docker images and monitoring external endpoints |

### **Recommended Production Requirements**

| Component | Specification | Notes |
|-----------|---------------|-------|
| **CPU** | 4-8 cores | For 500+ endpoints with optimal performance |
| **RAM** | 16 GB | Supports up to 1000 endpoints comfortably |
| **Storage** | 100 GB SSD | Recommended for production with extended retention |
| **OS** | Ubuntu 22.04 LTS or RHEL 8+ | Long-term support versions |
| **Network** | 100 Mbps+ dedicated bandwidth | For reliable health checks |

### **Supported Platforms**

✅ **Linux Distributions**
- Ubuntu 24.04 LTS, 22.04 LTS
- Debian 11, 12
- CentOS 8, 9
- RHEL 8, 9
- Fedora 37+
- Amazon Linux 2

✅ **Cloud Providers**
- AWS EC2
- Google Cloud Compute Engine
- Microsoft Azure Virtual Machines
- DigitalOcean Droplets
- Linode
- Any VPS provider with Docker support

⚠️ **Windows & macOS**
- Supported for development only
- Production deployment on Linux strongly recommended

### **Software Prerequisites**

Before installing Pulsimo, ensure you have:

1. **Docker Engine** - Version 20.10.0 or higher
2. **Docker Compose** - Version 2.0.0 or higher
3. **Git** - For cloning the repository
4. **Ports Available** - 80 (HTTP), 443 (HTTPS optional), 5432 (PostgreSQL), 6379 (Redis), 3000 (Frontend), 8080 (API Gateway)

---

## 🐳 **Docker Installation**

### **Installing Docker on Ubuntu/Debian**

If you don't have Docker installed, follow these steps:

**Step 1: Update Package Index**

```bash
sudo apt-get update
```

**Step 2: Install Required Packages**

```bash
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```

**Step 3: Add Docker's Official GPG Key**

```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

**Step 4: Set Up Docker Repository**

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

**Step 5: Install Docker Engine**

```bash
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

**Step 6: Verify Installation**

```bash
sudo docker --version
sudo docker compose version
```

**Step 7: Enable Docker to Start on Boot**

```bash
sudo systemctl enable docker
sudo systemctl start docker
```

**Step 8: Add Your User to Docker Group (Optional)**

```bash
sudo usermod -aG docker $USER
newgrp docker
```

### **Installing Docker on CentOS/RHEL**

**Step 1: Install Required Packages**

```bash
sudo yum install -y yum-utils
```

**Step 2: Add Docker Repository**

```bash
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```

**Step 3: Install Docker**

```bash
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

**Step 4: Start Docker**

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

### **Official Docker Documentation**

For detailed installation instructions for other platforms, visit:

📚 **Official Docker Installation Guide:** https://docs.docker.com/engine/install/

📚 **Docker Compose Installation:** https://docs.docker.com/compose/install/

---

## 📦 **Installing Pulsimo**

### **Method 1: Using Git Clone (Recommended)**

**Step 1: Clone the Repository**

```bash
git clone https://github.com/yourusername/pulsimo.git
cd pulsimo
```

**Step 2: Review the Architecture**

Pulsimo consists of the following services:

- **Frontend** - Next.js web application (Port 3000)
- **API Gateway** - Central API service (Port 8080)
- **Checker Service** - Health check engine
- **Notification Service** - Alert dispatcher
- **PostgreSQL** - Primary database (Port 5432)
- **Redis** - Caching and pub/sub (Port 6379)

**Step 3: Configure Environment Variables**

Copy the example environment file:

```bash
cp .env.example .env
```

Edit the `.env` file with your preferred text editor:

```bash
nano .env
```

---

## ⚙️ **Environment Variables Configuration**

### **Database Configuration (PostgreSQL)**

```bash
# PostgreSQL Database
POSTGRES_USER=monitoring           # Database username
POSTGRES_PASSWORD=your_secure_password_here  # CHANGE THIS!
POSTGRES_DB=monitoring_system      # Database name
DATABASE_URL=postgresql://monitoring:your_secure_password_here@postgres:5432/monitoring_system
```

**Security Best Practices:**
- Use a strong, random password (minimum 16 characters)
- Include uppercase, lowercase, numbers, and special characters
- Never use default passwords in production

---

### **Redis Configuration**

```bash
# Redis Cache
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_PASSWORD=your_redis_password_here  # CHANGE THIS!
REDIS_URL=redis://:your_redis_password_here@redis:6379
```

**Notes:**
- Redis password is optional for development but **mandatory for production**
- If you set a Redis password, update all services' REDIS_URL accordingly

---

### **JWT Authentication Configuration**

```bash
# JWT Secret Keys
JWT_SECRET=your_super_secret_jwt_key_min_32_characters_long  # CHANGE THIS!
JWT_EXPIRATION=24h              # Token expiration time
REFRESH_TOKEN_SECRET=your_refresh_token_secret_key_here      # CHANGE THIS!
REFRESH_TOKEN_EXPIRATION=7d     # Refresh token expiration
```

**Security Requirements:**
- JWT_SECRET must be at least 32 characters long
- Use a cryptographically secure random string
- Never commit secrets to version control

**Generate Secure Secrets (Linux/macOS):**

```bash
# Generate JWT Secret
openssl rand -base64 48

# Generate Refresh Token Secret
openssl rand -base64 48
```

---

### **API Gateway Configuration**

```bash
# API Gateway
API_GATEWAY_PORT=8080
API_GATEWAY_HOST=0.0.0.0
API_BASE_URL=http://localhost:8080/api

# CORS Settings
CORS_ORIGINS=http://localhost:3000,http://your-domain.com
```

**Production Notes:**
- Update `CORS_ORIGINS` to include your production domain
- Use HTTPS URLs in production
- Configure reverse proxy (Nginx/Traefik) for SSL termination

---

### **Frontend Configuration**

```bash
# Frontend
NEXT_PUBLIC_API_URL=http://localhost:8080/api
NEXT_PUBLIC_WS_URL=ws://localhost:8080/ws
NODE_ENV=production
```

**Production URLs:**
- Replace `localhost` with your actual domain or IP address
- Use `https://` and `wss://` for secure connections in production

---

### **Email Configuration (Notifications)**

```bash
# SMTP Email Settings (Optional)
SMTP_HOST=smtp.gmail.com          # Your SMTP server
SMTP_PORT=587                     # SMTP port (587 for TLS, 465 for SSL)
SMTP_USER=your-email@gmail.com    # SMTP username
SMTP_PASSWORD=your-app-password   # SMTP password or app password
SMTP_FROM_EMAIL=noreply@yourcompany.com
SMTP_FROM_NAME=Pulsimo Monitoring
```

**Email Provider Examples:**

**Gmail:**
- Host: smtp.gmail.com
- Port: 587
- Enable "Less secure app access" or use App Password
- Guide: https://support.google.com/accounts/answer/185833

**AWS SES:**
- Host: email-smtp.us-east-1.amazonaws.com
- Port: 587
- Use IAM credentials for SMTP authentication

**SendGrid:**
- Host: smtp.sendgrid.net
- Port: 587
- Use API key as password

**Mailgun:**
- Host: smtp.mailgun.org
- Port: 587
- Use Mailgun SMTP credentials

---

### **Checker Service Configuration**

```bash
# Health Check Settings
CHECK_INTERVAL_SECONDS=10         # Default check interval
MAX_CONCURRENT_CHECKS=150         # Maximum concurrent health checks
REQUEST_TIMEOUT_SECONDS=30        # HTTP request timeout
MAX_RETRIES=3                     # Number of retries on failure
```

**Performance Tuning:**
- For 100-200 endpoints: `MAX_CONCURRENT_CHECKS=50`
- For 200-500 endpoints: `MAX_CONCURRENT_CHECKS=150`
- For 500+ endpoints: `MAX_CONCURRENT_CHECKS=200-300`

---

### **Logging Configuration**

```bash
# Logging
LOG_LEVEL=info                    # Options: debug, info, warn, error
RUST_LOG=info                     # Rust services log level
```

**Log Levels:**
- **debug** - Verbose logging for troubleshooting (not for production)
- **info** - Standard operational information (recommended)
- **warn** - Warning messages only
- **error** - Error messages only

---

### **Complete Example .env File**

Here's a complete example configuration file:

```bash
# ===========================
# DATABASE CONFIGURATION
# ===========================
POSTGRES_USER=monitoring
POSTGRES_PASSWORD=MyStr0ngP@ssw0rd2024!
POSTGRES_DB=monitoring_system
DATABASE_URL=postgresql://monitoring:MyStr0ngP@ssw0rd2024!@postgres:5432/monitoring_system

# ===========================
# REDIS CONFIGURATION
# ===========================
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_PASSWORD=R3d1sSecureP@ss2024
REDIS_URL=redis://:R3d1sSecureP@ss2024@redis:6379

# ===========================
# JWT AUTHENTICATION
# ===========================
JWT_SECRET=aB3dF6hJ9kM2nP5qS8tV1wY4zA7cE0fH3iK6lN9oQ2rT5uX8yB1dG4jM7pS0vY3zA
REFRESH_TOKEN_SECRET=xY9wV6tS3qP0nM7kJ4hG1fE8dC5bA2zA9yX6wV3tS0qP7nM4kJ1hG8fE5dC2bA9zA
JWT_EXPIRATION=24h
REFRESH_TOKEN_EXPIRATION=7d

# ===========================
# API GATEWAY
# ===========================
API_GATEWAY_PORT=8080
API_GATEWAY_HOST=0.0.0.0
API_BASE_URL=http://localhost:8080/api
CORS_ORIGINS=http://localhost:3000

# ===========================
# FRONTEND
# ===========================
NEXT_PUBLIC_API_URL=http://localhost:8080/api
NEXT_PUBLIC_WS_URL=ws://localhost:8080/ws
NODE_ENV=production

# ===========================
# EMAIL NOTIFICATIONS
# ===========================
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=monitoring@yourcompany.com
SMTP_PASSWORD=your-app-password-here
SMTP_FROM_EMAIL=noreply@yourcompany.com
SMTP_FROM_NAME=Pulsimo Monitoring

# ===========================
# HEALTH CHECK SETTINGS
# ===========================
CHECK_INTERVAL_SECONDS=10
MAX_CONCURRENT_CHECKS=150
REQUEST_TIMEOUT_SECONDS=30
MAX_RETRIES=3

# ===========================
# LOGGING
# ===========================
LOG_LEVEL=info
RUST_LOG=info
```

---

## 🚀 **Deployment Steps**

### **Step 1: Build the Services**

Build all Docker images:

```bash
docker compose build
```

This process may take 5-10 minutes depending on your internet connection and system resources.

### **Step 2: Start the Services**

Start all services in detached mode:

```bash
docker compose up -d
```

### **Step 3: Verify Services Are Running**

Check the status of all services:

```bash
docker compose ps
```

Expected output should show all services as "running" or "healthy":

```
NAME                      STATUS
monitoring-api-gateway    Up (healthy)
monitoring-checker        Up
monitoring-frontend       Up
monitoring-notification   Up
monitoring-postgres       Up (healthy)
monitoring-redis          Up (healthy)
```

### **Step 4: View Service Logs**

Monitor logs to ensure successful startup:

```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f frontend
docker compose logs -f api-gateway
docker compose logs -f checker
```

Press `Ctrl+C` to stop following logs.

### **Step 5: Access the Application**

Open your web browser and navigate to:

```
http://localhost:3000
```

Or replace `localhost` with your server's IP address or domain name.

---

## 👤 **Initial Setup**

### **Step 1: Create Admin Account**

On first visit, you'll see the registration page:

1. Click "Register" or "Sign Up"
2. Enter your details:
   - **Name:** Your full name
   - **Email:** Your email address (will be used for login)
   - **Password:** Strong password (minimum 8 characters)
   - **Organization Name:** Your company or team name
3. Click "Create Account"

**Note:** The first registered user automatically becomes an admin with full system access.

### **Step 2: Login**

After registration:

1. You'll be redirected to the login page
2. Enter your email and password
3. Click "Sign In"

### **Step 3: Verify Installation**

Once logged in, you should see:

- ✅ Dashboard with empty service cards
- ✅ Navigation sidebar with all features
- ✅ "Add Endpoint" button functional
- ✅ Settings page accessible

---

## 🔧 **Post-Installation Configuration**

### **1. Configure Notification Channels**

Navigate to **Alerts** → Click **"Add Channel"**:

- Set up at least one notification channel (Email, Slack, Discord, etc.)
- Test the channel to ensure notifications work
- This is required to receive downtime alerts

### **2. Create Your First Project**

Navigate to **Projects** → Click **"New Project"**:

- Create a project to organize your endpoints
- Projects help with team collaboration and access control

### **3. Add Your First Endpoint**

Navigate to **Dashboard** → Click **"Add Endpoint"**:

- Add a service endpoint to start monitoring
- Configure check intervals and timeout settings
- Assign to a project for organization

### **4. Set Up Alert Policies**

For each critical endpoint:

- Configure failure thresholds (how many consecutive failures before alerting)
- Set check intervals (default: 10 seconds)
- Enable first-failure warnings if needed

---

## 🔄 **Updating Pulsimo**

To update to the latest version:

```bash
# Stop services
docker compose down

# Pull latest changes
git pull origin main

# Rebuild images
docker compose build

# Start services with updated images
docker compose up -d
```

Database migrations run automatically on startup.

---

## 🛑 **Stopping Pulsimo**

To stop all services:

```bash
docker compose down
```

To stop and remove all data (including database):

```bash
docker compose down -v
```

**⚠️ Warning:** The `-v` flag deletes all volumes, including your database. Only use this if you want to completely reset the system.

---

## 🔍 **Troubleshooting**

### **Services Won't Start**

Check Docker logs:

```bash
docker compose logs api-gateway
docker compose logs postgres
```

Common issues:
- Port already in use (change ports in docker-compose.yml)
- Insufficient memory (increase Docker memory limit)
- Permission issues (check file permissions)

### **Database Connection Errors**

Verify PostgreSQL is running:

```bash
docker compose ps postgres
docker compose logs postgres
```

Check DATABASE_URL in .env matches POSTGRES credentials.

### **Frontend Can't Connect to API**

Verify NEXT_PUBLIC_API_URL in .env matches your API Gateway URL.

Check CORS_ORIGINS includes your frontend URL.

### **Health Checks Not Running**

Check checker service logs:

```bash
docker compose logs checker
```

Verify checker service can connect to database and Redis.

---

## 📊 **Performance Optimization**

### **For Production Deployments:**

**1. Database Tuning**

Adjust PostgreSQL settings in docker-compose.yml:

```yaml
postgres:
  environment:
    POSTGRES_SHARED_BUFFERS: 256MB
    POSTGRES_EFFECTIVE_CACHE_SIZE: 1GB
    POSTGRES_MAX_CONNECTIONS: 200
```

**2. Redis Configuration**

Enable Redis persistence:

```yaml
redis:
  command: redis-server --appendonly yes --requirepass your_password
```

**3. Resource Limits**

Set appropriate limits in docker-compose.yml:

```yaml
api-gateway:
  deploy:
    resources:
      limits:
        cpus: '2'
        memory: 2G
```

---

## 🔐 **Security Hardening**

### **Production Security Checklist:**

✅ Change all default passwords  
✅ Use strong, random JWT secrets (minimum 32 characters)  
✅ Enable HTTPS with SSL certificates (use Nginx/Traefik reverse proxy)  
✅ Configure firewall rules (allow only necessary ports)  
✅ Set up Redis password authentication  
✅ Use environment-specific .env files (never commit to git)  
✅ Enable Docker secret management for sensitive data  
✅ Regularly update base images and dependencies  
✅ Set up automated backups for PostgreSQL database  
✅ Configure log rotation to prevent disk space issues  

---

## 📦 **Backup and Restore**

### **Database Backup**

```bash
# Create backup
docker compose exec postgres pg_dump -U monitoring monitoring_system > backup.sql

# Restore from backup
docker compose exec -T postgres psql -U monitoring monitoring_system < backup.sql
```

### **Automated Backups**

Set up a cron job for daily backups:

```bash
0 2 * * * cd /path/to/pulsimo && docker compose exec postgres pg_dump -U monitoring monitoring_system > backups/backup_$(date +\%Y\%m\%d).sql
```

---

## 🎉 **Installation Complete!**

Congratulations! Pulsimo is now installed and running.

**Next Steps:**

1. 📖 Read the **[Getting Started Guide](../getting-started.md)** for a walkthrough
2. 🎯 Explore the **[Features Overview](../features/README.md)** to learn all capabilities
3. 🔧 Configure your monitoring endpoints and alert policies
4. 🚀 Start monitoring your infrastructure!

---

## 💬 **Need Help?**

- 📚 Check the **[Troubleshooting Guide](../troubleshooting.md)**
- 🐛 Report issues on **GitHub Issues**
- 💬 Join the community **Discussions**

---

**Happy Monitoring! 🎉**
