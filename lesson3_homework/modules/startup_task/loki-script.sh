#!/bin/bash
set -e


echo "=== Starting Loki Installation ==="

echo "Updating system packages..."
apt-get update
apt-get upgrade -y

echo "Installing dependencies..."
apt-get install -y wget unzip curl

LOKI_VERSION="2.9.3"
ARCH="amd64"

echo "Creating Loki user and directories..."
useradd --system --no-create-home --shell /bin/false loki || true
mkdir -p /etc/loki
mkdir -p /var/lib/loki
mkdir -p /var/log/loki
chown -R loki:loki /var/lib/loki /var/log/loki

echo "Downloading Loki ${LOKI_VERSION}..."
cd /tmp
wget "https://github.com/grafana/loki/releases/download/v${LOKI_VERSION}/loki-linux-${ARCH}.zip"
unzip loki-linux-${ARCH}.zip
chmod +x loki-linux-${ARCH}
mv loki-linux-${ARCH} /usr/local/bin/loki
rm loki-linux-${ARCH}.zip

echo "Creating Loki configuration..."
cat > /etc/loki/config.yml <<'EOF'
auth_enabled: false

server:
  http_listen_port: 3100
  grpc_listen_port: 9096
  log_level: info

common:
  path_prefix: /var/lib/loki
  storage:
    filesystem:
      chunks_directory: /var/lib/loki/chunks
      rules_directory: /var/lib/loki/rules
  replication_factor: 1
  ring:
    instance_addr: 127.0.0.1
    kvstore:
      store: inmemory

schema_config:
  configs:
    - from: 2020-10-24
      store: boltdb-shipper
      object_store: filesystem
      schema: v11
      index:
        prefix: index_
        period: 24h

storage_config:
  boltdb_shipper:
    active_index_directory: /var/lib/loki/boltdb-shipper-active
    cache_location: /var/lib/loki/boltdb-shipper-cache
    cache_ttl: 24h
    shared_store: filesystem
  filesystem:
    directory: /var/lib/loki/chunks

compactor:
  working_directory: /var/lib/loki/boltdb-shipper-compactor
  shared_store: filesystem

limits_config:
  reject_old_samples: true
  reject_old_samples_max_age: 168h
  ingestion_rate_mb: 16
  ingestion_burst_size_mb: 32
  max_query_series: 100000
  max_query_parallelism: 32

chunk_store_config:
  max_look_back_period: 0s

table_manager:
  retention_deletes_enabled: true
  retention_period: 168h

ruler:
  alertmanager_url: http://localhost:9093
EOF

chown loki:loki /etc/loki/config.yml

echo "Creating systemd service..."
cat > /etc/systemd/system/loki.service <<'EOF'
[Unit]
Description=Loki Log Aggregation System
Documentation=https://grafana.com/docs/loki/latest/
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=loki
Group=loki
ExecStart=/usr/local/bin/loki -config.file=/etc/loki/config.yml
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal
SyslogIdentifier=loki

# Security settings
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/var/lib/loki /var/log/loki

[Install]
WantedBy=multi-user.target
EOF

# Configure firewall (if ufw is installed)
if command -v ufw &> /dev/null; then
    echo "Configuring firewall..."
    ufw allow 3100/tcp comment 'Loki HTTP'
    ufw allow 9096/tcp comment 'Loki gRPC'
fi

echo "Enabling and starting Loki service..."
systemctl daemon-reload
systemctl enable loki
systemctl start loki

sleep 5

echo "=== Loki Service Status ==="
systemctl status loki --no-pager || true

echo ""
echo "=== Verifying Loki Installation ==="
if curl -s http://localhost:3100/ready | grep -q "ready"; then
    echo "✓ Loki is ready and responding on port 3100"
else
    echo "✗ Warning: Loki may not be responding correctly"
fi

echo ""
echo "=== Loki Installation Complete ==="
echo "Loki is now running and ready to receive logs from Promtail"
echo ""
echo "Configuration file: /etc/loki/config.yml"
echo "Data directory: /var/lib/loki"
echo "Service status: systemctl status loki"
echo "Service logs: journalctl -u loki -f"
echo ""
echo "Loki HTTP endpoint: http://localhost:3100"
echo "Loki gRPC endpoint: localhost:9096"
echo ""
echo "To connect Promtail, configure it to push logs to:"
echo "  http://<this-vm-ip>:3100/loki/api/v1/push"
echo ""
echo "To connect Grafana, add Loki as a data source:"
echo "  URL: http://<this-vm-ip>:3100"