#!/bin/bash
set -e

if systemctl is-active --quiet node-exporter; then
    echo "node exporter is already up and active"
    exit 0
fi

if ! id "node_exporter" &>/dev/null; then
    sudo useradd --system --no-create-home --shell /bin/false node_exporter
fi

cd /tmp
wget -q https://github.com/prometheus/node_exporter/releases/download/v1.9.1/node_exporter-1.9.1.linux-amd64.tar.gz
tar -xzf node_exporter-1.9.1.linux-amd64.tar.gz

sudo cp node_exporter-1.9.1.linux-amd64/node_exporter /usr/local/bin/
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

rm -rf node_exporter-1.9.1.linux-amd64*

sudo cat <<EOF | sudo tee /etc/systemd/system/node-exporter.service >/dev/null
[Unit]
Description=Prometheus Node Exporter Service
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable node-exporter
sudo systemctl start node-exporter
sudo systemctl status node-exporter --no-pager