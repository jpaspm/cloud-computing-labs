# Lab 6 — Capstone: a load-balanced, auto-scaling web tier (Day 3, 50 min)

**Goal:** build the centre of the ShopKart case-study architecture — an Application Load Balancer in front of an Auto Scaling group spread over two Availability Zones — then prove that it balances traffic, heals itself and scales.

**Concepts:** launch templates, target groups, Application Load Balancer, Auto Scaling groups, target-tracking policies, health checks, security-group referencing, instance metadata (IMDSv2).

**Before you start:** you need `lab3-vpc` from [Lab 3](../lab3-vpc-web-server/).

**Files in this folder**

| File | Use |
| --- | --- |
| `user-data.sh` | Boot script for the launch template (Step 2) |
| `balance-check.sh` | CloudShell loop that calls the load balancer 10 times (Test 1) |
| `cpu-load.sh` | Commands that push an instance's CPU to ~100% (Test 3) |

```
Users ──HTTP──▶ Application Load Balancer (alb-sg, 2 public subnets)
                       │  forwards to target group tg-web
            ┌──────────┴──────────┐
     EC2 in AZ a            EC2 in AZ b      ◀── Auto Scaling group asg-shopkart
       (app-sg)               (app-sg)            min 2 · desired 2 · max 4
                                                  target tracking: CPU 50%
```

**Build order matters:** security groups → launch template → target group → load balancer → Auto Scaling group. Everything goes in `lab3-vpc`.

## Part A — Build (30 min)

### Step 1 — Two security groups

1. **EC2** → **Security Groups** → **Create security group**. **Name:** `alb-sg`. **VPC:** `lab3-vpc`. Inbound rule: **HTTP**, source **Anywhere-IPv4**. **Create**.
2. Create another: **Name:** `app-sg`, **VPC:** `lab3-vpc`. Inbound rule: **HTTP**, source **Custom**, then pick `alb-sg` from the list. **Create**.

The instances will accept web traffic *only* from the load balancer, never directly from the internet.

### Step 2 — Launch template

1. **EC2** → **Launch Templates** → **Create launch template**. **Name:** `lt-shopkart`.
2. **AMI:** Amazon Linux 2023. **Instance type:** a Free tier eligible type such as `t3.micro`. **Key pair:** Don't include in launch template.
3. **Network settings:** leave **Subnet** as *Don't include*. Expand **Advanced network configuration** → **Add network interface**: **Auto-assign public IP** = **Enable**, **Security groups** = `app-sg`.
4. **Advanced details** → **User data**: paste the contents of [`user-data.sh`](user-data.sh).
5. **Create launch template**.

### Step 3 — Target group

1. **EC2** → **Target Groups** → **Create target group**. **Target type:** Instances. **Name:** `tg-web`. **Protocol/Port:** HTTP 80. **VPC:** `lab3-vpc`. Health check path: `/`.
2. **Next** → register nothing → **Create target group**. The Auto Scaling group will register instances for you.

### Step 4 — Application Load Balancer

1. **EC2** → **Load Balancers** → **Create load balancer** → **Application Load Balancer** → **Create**.
2. **Name:** `alb-shopkart`. **Scheme:** Internet-facing. **IP address type:** IPv4.
3. **VPC:** `lab3-vpc`. **Mappings:** tick both Availability Zones and choose the **public** subnet in each.
4. **Security groups:** remove `default`, select `alb-sg`.
5. **Listeners:** HTTP 80 → forward to `tg-web`.
6. **Create load balancer**. Provisioning takes a few minutes; carry on.

### Step 5 — Auto Scaling group

1. **EC2** → **Auto Scaling Groups** → **Create Auto Scaling group**. **Name:** `asg-shopkart`. **Launch template:** `lt-shopkart` → **Next**.
2. **VPC:** `lab3-vpc`. **Availability Zones and subnets:** both **public** subnets → **Next**.
3. **Load balancing:** **Attach to an existing load balancer** → choose `tg-web` from the target groups. Tick **Turn on Elastic Load Balancing health checks** → **Next**.
4. **Group size:** Desired `2`, Min `2`, Max `4`.
5. **Automatic scaling:** **Target tracking scaling policy**, metric **Average CPU utilization**, target value `50` → **Next** → skip notifications and tags → **Create Auto Scaling group**.
6. Open **EC2** → **Target Groups** → `tg-web` → **Targets**. Wait until both instances show **healthy** (3–5 minutes).

## Part B — Prove it works (20 min)

### Test 1 — Load balancing

Copy the load balancer's **DNS name** (EC2 → Load Balancers) and open it with `http://`. Refresh several times: the hostname and Availability Zone change.

Or open **CloudShell** (the terminal icon in the console's top bar), upload or paste [`balance-check.sh`](balance-check.sh), and run:

```bash
bash balance-check.sh ALB-DNS-NAME
```

### Test 2 — Self-healing

In **EC2** → **Instances**, terminate one of the two ShopKart instances. Open **Auto Scaling Groups** → `asg-shopkart` → **Activity**: within a few minutes the group launches a replacement to get back to 2. The website stays up the whole time, served by the surviving instance.

### Test 3 — Auto scaling

1. Temporarily allow a browser SSH connection: edit `app-sg` → add inbound rule **SSH**, source **Anywhere-IPv4**.
2. Connect to one instance with **EC2 Instance Connect** and run the commands from [`cpu-load.sh`](cpu-load.sh):

```bash
yes > /dev/null &      # fills CPU 1
yes > /dev/null &      # fills CPU 2
top                    # CPU near 100%; press q to quit
```

3. Open **CloudWatch** → **Alarms**. Within about 5–10 minutes the `TargetTracking-…-AlarmHigh` alarm goes into *In alarm*, and the Auto Scaling group's **Activity** tab shows new instances launching.
4. Stop the load with `pkill yes`, then **remove the SSH rule** from `app-sg`. After a while the AlarmLow alarm fires and the group scales back in to 2.

Opening SSH to the internet is a temporary shortcut for this test. In real systems you would use Systems Manager Session Manager, which needs no open inbound port.

### Extension (optional) — CloudFront

**CloudFront** → **Create distribution**. **Origin:** your load balancer, protocol **HTTP only**. Keep other defaults, and decline optional paid extras such as WAF protections. After it deploys (a few minutes), open the `…cloudfront.net` domain: your site, now served over HTTPS from an edge location.

## Deliverable

A screenshot of two responses showing different Availability Zones, and a screenshot of the Auto Scaling group's Activity history showing the replacement and scale-out launches.

## Clean-up

Do the final clean-up in [CLEANUP.md](../CLEANUP.md) **today** — the load balancer is billed by the hour.
