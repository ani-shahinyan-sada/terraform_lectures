#!/bin/bash
set -e

if systemctl is-active --quiet prometheus; then
    echo "prometheus is already up and active"
    exit 0
fi

if ! id "prometheus" &>/dev/null; then
    sudo useradd --system --no-create-home --shell /bin/false prometheus
fi

cd /tmp
wget -q "https://github.com/prometheus/prometheus/releases/download/v3.0.0/prometheus-3.0.0.linux-amd64.tar.gz"
tar -xzf "prometheus-3.0.0.linux-amd64.tar.gz"

sudo rm -f /usr/local/bin/prometheus /usr/local/bin/promtool
sudo rm -rf /etc/prometheus /var/lib/prometheus

sudo mkdir -p /etc/prometheus
sudo mkdir -p /var/lib/prometheus

sudo cp prometheus-3.0.0.linux-amd64/prometheus /usr/local/bin/
sudo cp prometheus-3.0.0.linux-amd64/promtool /usr/local/bin/

if [ -d "prometheus-3.0.0.linux-amd64/consoles" ]; then
    sudo cp -r prometheus-3.0.0.linux-amd64/consoles /etc/prometheus/
fi
if [ -d "prometheus-3.0.0.linux-amd64/console_libraries" ]; then
    sudo cp -r prometheus-3.0.0.linux-amd64/console_libraries /etc/prometheus/
fi

sudo cat <<'EOF' | sudo tee /etc/prometheus/prometheus.yml >/dev/null
global:
  scrape_interval: 15s
  external_labels:
    monitor: 'prometheus'

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
EOF

sudo cat <<'EOF' | sudo tee /etc/systemd/system/prometheus.service >/dev/null
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus/

[Install]
WantedBy=multi-user.target
EOF

sudo chown -R prometheus:prometheus /etc/prometheus
sudo chown -R prometheus:prometheus /var/lib/prometheus
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool

rm -rf prometheus-3.0.0.linux-amd64*

sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus
sudo systemctl status prometheus --no-pager