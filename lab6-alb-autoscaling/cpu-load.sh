#!/bin/bash
# Lab 6, Test 3 — push CPU to ~100% so the Auto Scaling group scales out.
# Run inside ONE ShopKart instance (EC2 Instance Connect).

yes > /dev/null &      # fills CPU 1
yes > /dev/null &      # fills CPU 2
echo "Load started. Watch with: top   (press q to quit)"
echo "Stop it with:              pkill yes"
