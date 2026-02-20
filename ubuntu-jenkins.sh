#!/bin/bash

sudo apt update -y
sudo apt install -y openjdk-17-jdk wget

java -version

# Download latest Jenkins WAR file
wget https://get.jenkins.io/war-stable/latest/jenkins.war -O jenkins.war

# Create Jenkins user
sudo useradd -m -d /var/lib/jenkins -s /bin/bash jenkins || true

# Move WAR file
sudo mv jenkins.war /usr/local/bin/jenkins.war

# Create systemd service file
sudo tee /etc/systemd/system/jenkins.service > /dev/null <<EOF
[Unit]
Description=Jenkins Service
After=network.target

[Service]
User=root
ExecStart=/usr/bin/java -jar /usr/local/bin/jenkins.war --httpPort=8080
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins
