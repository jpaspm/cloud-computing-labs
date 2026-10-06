#!/bin/bash
# Lab 6, Test 1 — call the load balancer 10 times and show which instance/AZ answered.
# Run in AWS CloudShell. Usage: bash balance-check.sh <ALB-DNS-NAME>
#   e.g. bash balance-check.sh alb-shopkart-123456789.ap-south-1.elb.amazonaws.com

ALB="${1:?Usage: bash balance-check.sh <ALB-DNS-NAME>}"
for i in $(seq 10); do
  curl -s "http://$ALB"
  echo
done
