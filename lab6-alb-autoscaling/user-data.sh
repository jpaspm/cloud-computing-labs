#!/bin/bash
# Lab 6 — launch template user data (lt-shopkart).
# Installs nginx and writes a page showing this instance's hostname and Availability Zone,
# so you can see the load balancer spreading traffic across AZs.

dnf install -y nginx
M=http://169.254.169.254/latest
H=X-aws-ec2-metadata-token
# IMDSv2: get a session token, then ask which AZ this instance is in
T=$(curl -sX PUT $M/api/token -H "$H-ttl-seconds: 300")
AZ=$(curl -s -H "$H: $T" $M/meta-data/placement/availability-zone)
echo "<h1>ShopKart · $(hostname) · $AZ</h1>" > /usr/share/nginx/html/index.html
systemctl enable --now nginx
