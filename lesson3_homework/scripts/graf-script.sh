#!/bin/bash
set -e
if systemctl is-active --quiet grafana-server; then
    echo "grafana is already up and active"
    exit 0
fi
sudo apt-get update
sudo apt-get install -y apt-transport-https software-properties-common wget
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
sudo apt-get update
sudo apt-get install -y grafana

sudo mkdir -p /etc/grafana/provisioning/datasources
sudo cat > /etc/grafana/provisioning/datasources/datasources.yml <<EOF
apiVersion: 1

datasources:
  - name: Loki
    type: loki
    access: proxy
    url: http://loki.monitoring.ani.com:3100
    isDefault: true
    editable: true
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prom.monitoring.ani.com:9090


EOF

sudo systemctl daemon-reload
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
sudo systemctl status grafana-server --no-pager