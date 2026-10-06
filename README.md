# Cloud Computing — Hands-on Labs

Seven hands-on AWS labs for the 3-day Cloud Computing course. Over the three days you will build, secure, scale — and clean up — a real cloud application on your own AWS account.

| Lab | Day | Time | You will build | Folder | Reused later? |
| --- | --- | --- | --- | --- | --- |
| Lab 0 | Before Day 1 | 30 min | A safe AWS account with MFA and a budget alert | [lab0-account-setup](lab0-account-setup/) | Yes, all labs |
| Lab 1 | Day 1 | 30 min | An EC2 virtual machine with a Docker container inside | [lab1-ec2-and-containers](lab1-ec2-and-containers/) | No |
| Lab 2 | Day 2 | 30 min | A static website hosted on Amazon S3 | [lab2-s3-static-website](lab2-s3-static-website/) | Yes, Lab 5 |
| Lab 3 | Day 2 | 35 min | A web server inside a VPC you design | [lab3-vpc-web-server](lab3-vpc-web-server/) | Yes, VPC in Lab 6 |
| Lab 4 | Day 2 | 25 min | A serverless API with Lambda and DynamoDB | [lab4-serverless-counter](lab4-serverless-counter/) | Yes, Lab 5 |
| Lab 5 | Day 3 | 30 min | Least-privilege IAM and an audit trail | [lab5-iam-least-privilege](lab5-iam-least-privilege/) | No |
| Lab 6 | Day 3 | 50 min | A load-balanced, auto-scaling web tier | [lab6-alb-autoscaling](lab6-alb-autoscaling/) | No |

After Lab 6, follow [CLEANUP.md](CLEANUP.md). If something goes wrong, see [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## Getting the files

Download this repository (green **Code** button → **Download ZIP**) or clone it:

```bash
git clone <repository-url>
```

Every lab folder has a `README.md` with step-by-step instructions, plus the code files you will paste into the AWS console. You do **not** need to install anything on your laptop — all labs run in the AWS Management Console in your browser.

## Ground rules

- Work in **one region for the whole course** — the one your instructor names (for example Asia Pacific (Mumbai), `ap-south-1`). Check the region selector at the top-right of the console before every lab.
- Replace `yourname` in every resource name with your own name, for example `lab1-priya`. This keeps resources easy to find and clean up.
- Text in `monospace` is something you type or paste exactly.
- Do the clean-up step at the end of each lab. Forgotten resources are the most common cause of surprise bills.
- Stuck for more than 5 minutes? Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md), then ask a neighbour or the instructor.

## Cost safety

Every lab is designed to fit inside AWS's free allowances and new-account credits. The one paid-by-the-hour item is the load balancer in Lab 6, so finish the clean-up the same day.

## Submitting your work

Each lab lists a **Deliverable** (usually a screenshot). Collect them in one document and submit it as a single PDF at the end of Day 3.

## Repository layout

```
cloud-computing-labs/
├── README.md                  ← you are here
├── CLEANUP.md                 ← final clean-up checklist
├── TROUBLESHOOTING.md         ← common problems and fixes
├── lab0-account-setup/
├── lab1-ec2-and-containers/   ← inspect-vm.sh, run-container.sh
├── lab2-s3-static-website/    ← index.html, error.html, bucket-policy.json
├── lab3-vpc-web-server/       ← user-data.sh
├── lab4-serverless-counter/   ← lambda_function.py
├── lab5-iam-least-privilege/  ← visits-update-only-policy.json
└── lab6-alb-autoscaling/      ← user-data.sh, balance-check.sh, cpu-load.sh
```
