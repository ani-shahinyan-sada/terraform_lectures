#!/bin/bash
set -e

apt-get update
apt-get upgrade -y
apt-get install -y wget unzip curl

PROMTAIL_VERSION="2.9.3"
ARCH="amd64"
LOKI_URL="http://loki.monitoring.ani.com:3100"

useradd --system --no-create-home --shell /bin/false promtail || true
usermod -aG adm promtail
usermod -aG systemd-journal promtail
mkdir -p /etc/promtail
mkdir -p /var/lib/promtail
mkdir -p /var/log/promtail
chown -R promtail:promtail /var/lib/promtail /var/log/promtail

cd /tmp
wget "https://github.com/grafana/loki/releases/download/v${PROMTAIL_VERSION}/promtail-linux-${ARCH}.zip"
unzip promtail-linux-${ARCH}.zip
chmod +x promtail-linux-${ARCH}
mv promtail-linux-${ARCH} /usr/local/bin/promtail
rm promtail-linux-${ARCH}.zip

HOSTNAME=$(hostname)

cat > /etc/promtail/config.yml <<EOF
server:
  http_listen_port: 9080
  grpc_listen_port: 0
  log_level: info

positions:
  filename: /var/lib/promtail/positions.yaml

clients:
  - url: ${LOKI_URL}/loki/api/v1/push

scrape_configs:
  - job_name: system
    static_configs:
      - targets:
          - localhost
        labels:
          job: varlogs
          host: ${HOSTNAME}
          __path__: /var/log/*log

  - job_name: syslog
    static_configs:
      - targets:
          - localhost
        labels:
          job: syslog
          host: ${HOSTNAME}
          __path__: /var/log/syslog

  - job_name: auth
    static_configs:
      - targets:
          - localhost
        labels:
          job: auth
          host: ${HOSTNAME}
          __path__: /var/log/auth.log

  - job_name: systemd
    journal:
      max_age: 12h
      labels:
        job: systemd-journal
        host: ${HOSTNAME}
    relabel_configs:
      - source_labels: ['__journal__systemd_unit']
        target_label: 'unit'
EOF

chown promtail:promtail /etc/promtail/config.yml

cat > /etc/systemd/system/promtail.service <<'EOF'
[Unit]
Description=Promtail Log Collector
Documentation=https://grafana.com/docs/loki/latest/clients/promtail/
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=promtail
Group=promtail
ExecStart=/usr/local/bin/promtail -config.file=/etc/promtail/config.yml
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal
SyslogIdentifier=promtail

NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/var/lib/promtail /var/log/promtail
ReadOnlyPaths=/var/log

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable promtail
systemctl start promtail

sleep 5

systemctl status promtail --no-pager || true

echo ""
echo "Promtail installation complete"
echo "Configuration: /etc/promtail/config.yml"
echo "Data directory: /var/lib/promtail"
echo "Service status: systemctl status promtail"
echo "Service logs: journalctl -u promtail -f"
echo "Promtail HTTP endpoint: http://localhost:9080"
echo "Sending logs to: ${LOKI_URL}"