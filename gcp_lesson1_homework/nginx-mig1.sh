#!/bin/bash
set -e

sudo apt update -y
sudo apt install -y nginx

INTERNAL_IP=$(hostname -I | awk '{print $1}')


sudo mkdir -p /var/www/html/mig1

sudo cat > /var/www/html/mig1/index.html << EOF
<!DOCTYPE html>
<html>
<head>
<title>MIG1 VM Instance</title>
</head>
<body style="background-color:lightblue;">
<h1 style="font-family:verdana; text-align:center;">MIG1 - VM ${INTERNAL_IP}</h1>
</body>
</html>
EOF

sudo systemctl restart nginx
sudo systemctl enable nginx
