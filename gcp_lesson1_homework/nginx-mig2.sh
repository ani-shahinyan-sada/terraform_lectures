#!/bin/bash
set -e

sudo apt update -y
sudo apt install -y nginx

INTERNAL_IP=$(hostname -I | awk '{print $1}')


sudo mkdir -p /var/www/html/mig2

sudo cat > /var/www/html/mig2/index.html << EOF
<!DOCTYPE html>
<html>
<head>
<title>MIG2 VM Instance</title>
</head>
<body style="background-color:lightcoral;">
<h1 style="font-family:verdana; text-align:center;">MIG2 - VM ${INTERNAL_IP}</h1>
</body>
</html>
EOF

sudo systemctl restart nginx
sudo systemctl enable nginx
