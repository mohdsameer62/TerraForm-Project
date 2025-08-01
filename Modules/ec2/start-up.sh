#!/bin/bash
# Install Apache
sudo apt-get update -y
sudo apt-get install apache2 -y

# Create static index.html
cat <<EOF | sudo tee /var/www/html/index.html
    <h1>Hello from your EC2 instance!</h1>
EOF

# Start Apache
sudo systemctl enable apache2
sudo systemctl start apache2
