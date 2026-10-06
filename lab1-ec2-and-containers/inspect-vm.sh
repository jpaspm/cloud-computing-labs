#!/bin/bash
# Lab 1, Step 3 — inspect the virtual hardware of your EC2 instance.
# Run inside the instance (EC2 Instance Connect). You can paste the lines one at a time.

systemd-detect-virt                       # which hypervisor runs this VM? (expect: amazon)
nproc                                     # how many virtual CPUs? (t3.micro: 2)
lscpu | grep -E 'Model name|Hypervisor'   # physical CPU model and hypervisor vendor
free -h                                   # how much memory? (t3.micro: about 1 GiB)
df -h /                                   # how big is the virtual disk?
