#!/bin/bash
# Lab 3 — EC2 user data. Paste into Advanced details → User data when launching.
# Runs once, as root, the first time the instance boots.

dnf install -y nginx
echo "<h1>Hello from $(hostname)</h1>" > /usr/share/nginx/html/index.html
systemctl enable --now nginx
