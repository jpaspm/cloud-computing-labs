# Lab 3 — A web server in a VPC you built (Day 2, 35 min)

**Goal:** design your own private network (VPC) across two Availability Zones and run a web server in its public subnet.

**Concepts:** VPC, CIDR blocks, public and private subnets, internet gateway, route tables, security groups, user data.

**Files in this folder**

| File | Use |
| --- | --- |
| `user-data.sh` | Boot script that installs nginx and writes a web page (Step 2) |

## Step 1 — Create the VPC

1. Open **VPC** → **Create VPC**.
2. Choose **VPC and more** (the wizard builds the subnets and routes for you).
3. **Name tag auto-generation:** `lab3`.
4. **IPv4 CIDR block:** `10.0.0.0/16` (65,536 addresses).
5. **Number of Availability Zones:** `2`. **Public subnets:** `2`. **Private subnets:** `2`.
6. **NAT gateways:** `None` (NAT gateways are billed by the hour). **VPC endpoints:** `None`.
7. Choose **Create VPC** and wait for every line to turn green → **View VPC**.
8. Open the **Resource map** tab. Trace how the public subnets route to the internet gateway (`lab3-igw`) and the private subnets do not.

## Step 2 — Launch the web server

1. Open **EC2** → **Launch instance**. **Name:** `lab3-web-yourname`.
2. **AMI:** Amazon Linux 2023. **Instance type:** a Free tier eligible type such as `t3.micro`. **Key pair:** Proceed without a key pair.
3. **Network settings** → **Edit**:
   - **VPC:** `lab3-vpc`.
   - **Subnet:** one whose name contains `public1`.
   - **Auto-assign public IP:** **Enable**.
   - **Firewall (security groups):** Create security group, name `web-sg`.
   - Remove the SSH rule. Choose **Add security group rule**: Type **HTTP**, Source type **Anywhere**.
4. Expand **Advanced details**, scroll to **User data**, and paste the contents of [`user-data.sh`](user-data.sh). It runs once, as root, the first time the instance boots:

```bash
#!/bin/bash
dnf install -y nginx
echo "<h1>Hello from $(hostname)</h1>" > /usr/share/nginx/html/index.html
systemctl enable --now nginx
```

5. Choose **Launch instance**.

## Step 3 — Test

1. Wait 2–3 minutes after the instance shows *Running* (nginx is installing).
2. Copy the instance's **Public IPv4 address** and open `http://` followed by that address. Type `http://` yourself — browsers often try `https://`, which will fail.

**What you should see:** "Hello from ip-10-0-…", showing the instance's private hostname inside your `10.0.0.0/16` network.

## Step 4 — Explore the routing

1. In **VPC** → **Route tables**, open the route table of a public subnet. Find the route `0.0.0.0/0` → `igw-…`.
2. Open the route table of a private subnet. It has only the `local` route.

## Challenge

Launch a second instance with the same settings but in a **private** subnet. Can you open it in your browser? Write one sentence explaining why, using the route tables you just looked at. Terminate it afterwards.

## Clean-up

1. Terminate `lab3-web-yourname` (and any challenge instance).
2. **Keep the VPC** `lab3-vpc` — you will reuse it in Lab 6. A VPC with no NAT gateway costs nothing.

## Deliverable

A screenshot of your page in the browser, and a screenshot of the VPC resource map.
