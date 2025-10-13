#!/bin/bash
set -e

sudo apt update -y
sudo apt install -y nginx

INTERNAL_IP=$(hostname -I | awk '{print $1}')
sudo cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html>
<head>
<title>VM Instance</title>
</head>
<body style="background-color:powderblue;">
<h1 style="font-family:verdana; text-align:center;">Hey! This is VM ${INTERNAL_IP}</h1>
</body>
</html>
EOF

sudo systemctl restart nginx
sudo systemctl enable nginx
