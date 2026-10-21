#!/bin/bash
# ==============================================================================
# PULSIMO MONITORING SYSTEM - PRODUCTION DEPLOYMENT SCRIPT
# ==============================================================================
# This script deploys Pulsimo using pre-built Docker images
# No source code compilation required - just pull and run!
#
# System Requirements: 4 vCPU, 8GB RAM minimum
# ==============================================================================

set -e

# Version to deploy
VERSION=${1:-v1beta1}

echo "=============================================================="
echo "  🚀 PULSIMO MONITORING - PRODUCTION SETUP"
echo "=============================================================="
echo ""
echo "  This script will deploy Pulsimo ${VERSION}"
echo "  using pre-built Docker images."
echo ""
echo "  System Requirements:"
echo "    - 4 vCPU minimum"
echo "    - 8GB RAM minimum"
echo "    - 20GB disk space"
echo "    - Docker & Docker Compose installed"
echo ""
echo "=============================================================="
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    echo "   Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker Compose is available
if ! command -v docker compose &> /dev/null && ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed."
    echo "   Visit: https://docs.docker.com/compose/install/"
    exit 1
fi

# Use docker compose if available, otherwise docker-compose
if command -v docker compose &> /dev/null; then
    DOCKER_COMPOSE="docker compose"
else
    DOCKER_COMPOSE="docker-compose"
fi

echo "✅ Docker is installed: $(docker --version)"
echo "✅ Docker Compose is available"
echo ""

# Check system resources
echo "🔍 Checking system resources..."
echo ""

# Check CPU count (Linux)
if [ -f /proc/cpuinfo ]; then
    CPU_COUNT=$(grep -c ^processor /proc/cpuinfo)
    echo "   CPUs detected: $CPU_COUNT"
    if [ "$CPU_COUNT" -lt 4 ]; then
        echo "   ⚠️  Warning: Less than 4 CPUs detected. Performance may be impacted."
    fi
fi

# Check available memory (Linux)
if [ -f /proc/meminfo ]; then
    TOTAL_MEM=$(grep MemTotal /proc/meminfo | awk '{print int($2/1024)}')
    echo "   Memory: ${TOTAL_MEM}MB"
    if [ "$TOTAL_MEM" -lt 7000 ]; then
        echo "   ⚠️  Warning: Less than 8GB RAM detected. Performance may be impacted."
    fi
fi

# Check disk space
AVAILABLE_DISK=$(df -BG . | tail -1 | awk '{print $4}' | sed 's/G//')
echo "   Available disk: ${AVAILABLE_DISK}GB"
if [ "$AVAILABLE_DISK" -lt 20 ]; then
    echo "   ⚠️  Warning: Less than 20GB disk space available."
fi

echo ""

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "=============================================================="
    echo "  📝 CONFIGURATION SETUP"
    echo "=============================================================="
    echo ""
    echo "Creating .env file from template..."
    
    if [ ! -f .env.example ]; then
        echo "❌ .env.example not found!"
        echo "   Please ensure you have .env.example in the current directory."
        exit 1
    fi
    
    cp .env.example .env
    
    # Detect server IP
    echo ""
    echo "🌐 Detecting network configuration..."
    echo ""
    
    # Try to get the primary IP address
    if command -v ip &> /dev/null; then
        # Linux with ip command
        DETECTED_IP=$(ip route get 1.1.1.1 | grep -oP 'src \K\S+' 2>/dev/null || echo "")
    elif command -v ifconfig &> /dev/null; then
        # macOS or Linux with ifconfig
        DETECTED_IP=$(ifconfig | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | head -n 1 | sed 's/addr://')
    else
        DETECTED_IP=""
    fi
    
    if [ -n "$DETECTED_IP" ]; then
        echo "   Detected IP address: $DETECTED_IP"
    else
        echo "   Could not auto-detect IP address"
    fi
    
    echo ""
    echo "Enter your server IP address or domain name:"
    echo "   Examples:"
    echo "   - 192.168.1.100 (local network)"
    echo "   - monitoring.yourcompany.com (domain)"
    echo "   - localhost (local development only)"
    echo ""
    
    if [ -n "$DETECTED_IP" ]; then
        read -p "   IP/Domain [$DETECTED_IP]: " HOST_IP_INPUT
        HOST_IP=${HOST_IP_INPUT:-$DETECTED_IP}
    else
        read -p "   IP/Domain [localhost]: " HOST_IP_INPUT
        HOST_IP=${HOST_IP_INPUT:-localhost}
    fi
    
    echo ""
    echo "   ✅ Using: $HOST_IP"
    
    # Generate secure credentials
    echo ""
    echo "🔐 Generating secure credentials..."
    JWT_SECRET=$(openssl rand -base64 32 2>/dev/null || cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    DB_PASSWORD=$(openssl rand -base64 24 2>/dev/null || cat /dev/urandom | tr -dc 'a-zA-Z0-9!@#$%^&*' | fold -w 24 | head -n 1)
    
    # Update .env file
    if [ "$(uname)" == "Darwin" ]; then
        # macOS
        sed -i '' "s/HOST_IP=localhost/HOST_IP=$HOST_IP/" .env
        sed -i '' "s/CHANGE_THIS_TO_RANDOM_SECRET_IN_PRODUCTION_USE_OPENSSL_RAND/$JWT_SECRET/" .env
        sed -i '' "s/ChangeThisPassword123!/$DB_PASSWORD/" .env
    else
        # Linux
        sed -i "s/HOST_IP=localhost/HOST_IP=$HOST_IP/" .env
        sed -i "s/CHANGE_THIS_TO_RANDOM_SECRET_IN_PRODUCTION_USE_OPENSSL_RAND/$JWT_SECRET/" .env
        sed -i "s/ChangeThisPassword123!/$DB_PASSWORD/" .env
    fi
    
    echo "   ✅ Generated secure credentials"
    echo ""
    echo "=============================================================="
    echo "  ✅ CONFIGURATION COMPLETE"
    echo "=============================================================="
    echo ""
    echo "Configuration file created: .env"
    echo ""
    echo "   Server IP:       $HOST_IP"
    echo "   JWT Secret:      [Generated]"
    echo "   DB Password:     [Generated]"
    echo ""
    echo "⚠️  IMPORTANT:"
    echo ""
    echo "   Review .env and configure SMTP settings for email alerts:"
    echo "   - SMTP_HOST, SMTP_USERNAME, SMTP_PASSWORD"
    echo "   - FROM_EMAIL, FROM_NAME"
    echo ""
    read -p "Press Enter to continue with deployment..."
    echo ""
else
    echo "✅ .env file already exists"
    echo ""
    # Get HOST_IP from .env
    HOST_IP=$(grep "^HOST_IP=" .env | cut -d '=' -f2)
    echo "   Configured for: $HOST_IP"
    echo ""
fi

# Pull images
echo "=============================================================="
echo "  📥 PULLING DOCKER IMAGES (${VERSION})"
echo "=============================================================="
echo ""
echo "This will download pre-built images from Docker Hub..."
echo "Download size: ~2-3 GB total"
echo ""

$DOCKER_COMPOSE docker-compose.yml pull

echo ""
echo "✅ All images downloaded"
echo ""

# Start services
echo "=============================================================="
echo "  🚀 STARTING SERVICES"
echo "=============================================================="
echo ""

$DOCKER_COMPOSE docker-compose.yml up -d

echo ""
echo "⏳ Waiting for services to initialize..."
echo ""

# Wait for services to start
sleep 5

# Progressive health checks
for i in {1..6}; do
    echo "   Health check attempt $i/6..."
    sleep 5
    
    # Check if all containers are running
    RUNNING=$($DOCKER_COMPOSE docker-compose.yml ps --services --filter "status=running" | wc -l)
    TOTAL=$($DOCKER_COMPOSE docker-compose.yml ps --services | wc -l)
    
    if [ "$RUNNING" -eq "$TOTAL" ]; then
        break
    fi
done

# Check service health
echo ""
echo "=============================================================="
echo "  🔍 SERVICE HEALTH STATUS"
echo "=============================================================="
echo ""

# Check PostgreSQL
if $DOCKER_COMPOSE -f docker-compose.yml exec -T postgres pg_isready -U monitoring &> /dev/null; then
    echo "✅ PostgreSQL     - Ready"
else
    echo "⚠️  PostgreSQL     - Not ready (may still be initializing)"
fi

# Check Redis
if $DOCKER_COMPOSE -f docker-compose.yml exec -T redis redis-cli ping &> /dev/null 2>&1; then
    echo "✅ Redis          - Ready"
else
    echo "⚠️  Redis          - Not ready"
fi

# Check API Gateway
sleep 2
API_PORT=$(grep "^EXPOSE_API_PORT=" .env | cut -d '=' -f2)
API_PORT=${API_PORT:-8080}

if curl -s http://localhost:${API_PORT}/health > /dev/null 2>&1; then
    echo "✅ API Gateway    - Ready"
else
    echo "⚠️  API Gateway    - Starting (may take 30-60 seconds)"
fi

# Check Frontend
FRONTEND_PORT=$(grep "^EXPOSE_FRONTEND_PORT=" .env | cut -d '=' -f2)
FRONTEND_PORT=${FRONTEND_PORT:-3000}

if curl -s http://localhost:${FRONTEND_PORT} > /dev/null 2>&1; then
    echo "✅ Frontend       - Ready"
else
    echo "⚠️  Frontend       - Starting (may take 30-60 seconds)"
fi

# Display resource usage
echo ""
echo "=============================================================="
echo "  📊 RESOURCE ALLOCATION"
echo "=============================================================="
echo ""
echo "  Service limits configured for 4 vCPU, 8GB RAM system:"
echo ""
echo "  PostgreSQL:       1.0 CPU, 2GB RAM"
echo "  Redis:            0.25 CPU, 512MB RAM"
echo "  API Gateway:      0.75 CPU, 1.5GB RAM"
echo "  Checker:          0.5 CPU, 1GB RAM"
echo "  Notification:     0.25 CPU, 512MB RAM"
echo "  Dependency:       0.25 CPU, 512MB RAM"
echo "  Maintenance:      0.25 CPU, 256MB RAM"
echo "  Frontend:         0.75 CPU, 1.5GB RAM"
echo ""
echo "  Total:            4.0 vCPU, 7.75GB RAM"
echo ""

echo ""
echo "=============================================================="
echo "  ✅ DEPLOYMENT COMPLETE!"
echo "=============================================================="
echo ""
echo "🌐 Access URLs:"
echo ""
echo "   Frontend:   http://${HOST_IP}:${FRONTEND_PORT}"
echo "   API:        http://${HOST_IP}:${API_PORT}"
echo "   Health:     http://${HOST_IP}:${API_PORT}/health"
echo ""

if [ "$HOST_IP" == "localhost" ]; then
    echo "⚠️  Note: Using localhost - only accessible from this machine"
    echo ""
fi

echo "=============================================================="
echo "  📚 GETTING STARTED"
echo "=============================================================="
echo ""
echo "1. Open your browser: http://${HOST_IP}:${FRONTEND_PORT}"
echo ""
echo "2. Click 'Register' to create your organization"
echo ""
echo "3. Add your first service endpoint"
echo ""
echo "=============================================================="
echo "  🔧 USEFUL COMMANDS"
echo "=============================================================="
echo ""
echo "   View logs:       $DOCKER_COMPOSE docker-compose.yml logs -f"
echo "   Stop services:   $DOCKER_COMPOSE docker-compose.yml down"
echo "   Restart:         $DOCKER_COMPOSE docker-compose.yml restart"
echo "   Check status:    $DOCKER_COMPOSE docker-compose.yml ps"
echo "   Stats:           docker stats"
echo ""
echo "=============================================================="
echo ""
echo "Happy Monitoring! 🎉"
echo ""
