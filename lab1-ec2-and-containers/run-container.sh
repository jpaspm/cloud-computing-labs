#!/bin/bash
# Lab 1, Step 4 — run a Docker container inside your EC2 virtual machine.
# Run inside the instance (EC2 Instance Connect).

sudo dnf install -y docker                   # install the Docker engine
sudo systemctl start docker                  # start it
time sudo docker run --rm alpine echo hi     # start a container, print 'hi', remove it

# Run the last line again: the image is now cached, so it finishes in about a second.
