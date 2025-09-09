#!/bin/bash

# Update system packages
apt-get update -y

# Install Apache web server
apt-get install -y apache2

# Ensure Apache is properly configured for Ubuntu 24.04
a2enmod rewrite
a2dissite 000-default
a2ensite 000-default

# Enable and start Apache service
systemctl enable apache2
systemctl start apache2

# Get the VM's hostname
HOSTNAME=$(hostname)

# Get the VM's private IP address
PRIVATE_IP=$(hostname -I | awk '{print $1}')

# Get the VM's public IP address (if available)
PUBLIC_IP=$(curl -s http://checkip.amazonaws.com/ 2>/dev/null || echo "Not available")

# Create a custom HTML page
cat > /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Azure VM Info</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #0078d4;
            text-align: center;
        }
        .info-item {
            margin: 20px 0;
            padding: 15px;
            background-color: #f8f9fa;
            border-left: 4px solid #0078d4;
        }
        .label {
            font-weight: bold;
            color: #333;
        }
        .value {
            font-family: monospace;
            color: #555;
            font-size: 1.1em;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Azure VM Information</h1>
        
        <div class="info-item">
            <div class="label">Hostname:</div>
            <div class="value" id="hostname">Loading...</div>
        </div>
        
        <div class="info-item">
            <div class="label">Private IP Address:</div>
            <div class="value" id="private-ip">Loading...</div>
        </div>
        
        <div class="info-item">
            <div class="label">Public IP Address:</div>
            <div class="value" id="public-ip">Loading...</div>
        </div>
        
        <div class="info-item">
            <div class="label">Server Time:</div>
            <div class="value" id="server-time">Loading...</div>
        </div>
        
        <div style="text-align: center; margin-top: 30px; color: #666;">
            <p>This page was generated automatically by Azure VM custom data</p>
        </div>
    </div>

    <script>
        // Update time every second
        setInterval(function() {
            document.getElementById('server-time').textContent = new Date().toLocaleString();
        }, 1000);
    </script>
</body>
</html>
EOF

# Update the HTML with actual values
sed -i "s/Loading.../$(hostname)/g" /var/www/html/index.html
PRIVATE_IP=$(hostname -I | awk '{print $1}')
sed -i "s/id=\"private-ip\">Loading.../id=\"private-ip\">$PRIVATE_IP/g" /var/www/html/index.html
PUBLIC_IP=$(curl -s http://checkip.amazonaws.com/ 2>/dev/null || echo "Not available")
sed -i "s/id=\"public-ip\">Loading.../id=\"public-ip\">$PUBLIC_IP/g" /var/www/html/index.html

# Set proper permissions
chown www-data:www-data /var/www/html/index.html
chmod 644 /var/www/html/index.html

# Configure firewall to allow HTTP traffic (if ufw is enabled)
ufw allow 'Apache'

# Log completion
echo "Web server setup completed at $(date)" >> /var/log/custom-data.log