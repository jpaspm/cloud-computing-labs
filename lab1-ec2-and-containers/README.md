# Lab 1 — Your first virtual machine, and a container inside it (Day 1, 30 min)

**Goal:** launch an EC2 instance, inspect the virtual hardware the hypervisor gives it, and run a Docker container inside it.

**Concepts:** virtual machine, hypervisor, AMI, instance type, security group, OS-level virtualization (containers).

**Files in this folder**

| File | Use |
| --- | --- |
| `inspect-vm.sh` | Commands to inspect the virtual hardware (Step 3) |
| `run-container.sh` | Commands to install Docker and run a container (Step 4) |

## Step 1 — Launch the instance

1. In the console search bar type `EC2` and open it. Confirm the class region at the top-right.
2. Choose **Launch instance**.
3. **Name:** `lab1-yourname`.
4. **Application and OS Images (AMI):** keep **Amazon Linux 2023**. An AMI is the template disk image the VM boots from.
5. **Instance type:** pick one marked **Free tier eligible**, for example `t3.micro` (2 vCPUs, 1 GiB memory).
6. **Key pair:** choose **Proceed without a key pair**. You will connect through the browser instead.
7. **Network settings:** keep the default VPC and subnet. Leave **Allow SSH traffic from Anywhere** ticked. (On Day 3 you will learn why this is risky in real systems.)
8. Keep the default storage and choose **Launch instance**, then **View all instances**.

## Step 2 — Connect

1. Wait until **Instance state** is *Running* and **Status check** shows *2/2 checks passed* (about 1–2 minutes; use the refresh button).
2. Select the instance → **Connect** → **EC2 Instance Connect** tab → **Connect**. A Linux terminal opens in a new browser tab.

## Step 3 — Inspect the virtual hardware

Run the commands from [`inspect-vm.sh`](inspect-vm.sh) one at a time and note the answers:

```bash
systemd-detect-virt                       # which hypervisor runs this VM?
nproc                                     # how many virtual CPUs?
lscpu | grep -E 'Model name|Hypervisor'   # physical CPU model and hypervisor vendor
free -h                                   # how much memory?
df -h /                                   # how big is the virtual disk?
```

**What you should see:** `systemd-detect-virt` prints `amazon` — the AWS Nitro hypervisor, which is based on KVM. On `t3.micro`, `nproc` prints `2` and `free -h` shows about 1 GiB of memory. None of this hardware is a physical machine dedicated to you; it is a slice of a shared server.

## Step 4 — Run a container inside the VM

Run the commands from [`run-container.sh`](run-container.sh):

```bash
sudo dnf install -y docker                   # install the Docker engine
sudo systemctl start docker                  # start it
time sudo docker run --rm alpine echo hi     # start a container, print 'hi', remove it
```

**What you should see:** Docker downloads the small `alpine` image, prints `hi`, and `time` reports the duration. Run the last command a second time: it now finishes in about a second, because the image is cached. Compare that with the minute or so your VM needed to boot.

**Think about it:** you now have two layers of virtualization — a hardware-level VM (EC2) and an OS-level container (Docker) that shares the VM's Linux kernel.

## Step 5 — Clean up

1. Close the terminal tab.
2. In EC2 → **Instances**, select `lab1-yourname` → **Instance state** → **Terminate (delete) instance** → confirm.

## Deliverable

One screenshot showing the outputs of `systemd-detect-virt` and `nproc`, and one showing the `docker run` output with its time.
