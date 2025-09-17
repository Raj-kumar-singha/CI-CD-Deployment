#!/bin/bash
set -e

# Basic tools
apt-get update -y
apt-get install -y git curl python3 python3-pip

# Node 18 + PM2
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs
npm install -g pm2

# Gunicorn
apt-get install -y gunicorn

# Jenkins
apt-get install -y fontconfig openjdk-17-jre apt-transport-https gnupg ca-certificates
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee /usr/share/keyrings/jenkins-keyring.asc >/dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list
apt-get update -y
apt-get install -y jenkins
systemctl enable --now jenkins

# Optional: get repo locally (Jenkins will also checkout)
mkdir -p /var/www && cd /var/www
git clone ${repo_url} app || true
