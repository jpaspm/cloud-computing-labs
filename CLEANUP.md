# Final clean-up (end of Day 3, 15 min)

Delete in this order — some resources block others from being deleted, and the Auto Scaling group relaunches any instance you delete before it. Tick each box as you go.

- [ ] **CloudFront distribution** (if you made one): select it → **Disable** → wait until it shows *Deployed* again → **Delete**.
- [ ] **Auto Scaling group** `asg-shopkart`: **Actions** → **Delete**. This also terminates its instances.
- [ ] **Load balancer** `alb-shopkart`: **Actions** → **Delete load balancer**.
- [ ] **Target group** `tg-web`: **Actions** → **Delete**.
- [ ] **Launch template** `lt-shopkart`: **Actions** → **Delete template**.
- [ ] **EC2 → Instances**: confirm none are *Running* or *Stopped*. **EC2 → Volumes**: delete any left *Available*.
- [ ] **VPC** `lab3-vpc`: **Actions** → **Delete VPC** (this removes its subnets, route tables, internet gateway and security groups). If it refuses, a load balancer or instance is still inside.
- [ ] **Lambda** `visit-counter`: **Actions** → **Delete**. Then in **IAM** → **Roles**, delete the role whose name starts with `visit-counter-role`.
- [ ] **DynamoDB** table `visits`: **Actions** → **Delete table**.
- [ ] **S3** bucket from Lab 2: **Empty** (type `permanently delete`) → then **Delete** (type the bucket name).
- [ ] **IAM**: delete user `dev-yourname`, then group `s3-readers`.
- [ ] **CloudWatch** → **Log groups**: delete `/aws/lambda/visit-counter`. **Alarms**: delete any left over.
- [ ] **Search everywhere:** **Resource Groups & Tag Editor** → **Tag Editor** → Regions *All regions*, Resource types *All supported resource types* → **Search resources**. Investigate anything you don't recognise.
- [ ] **Billing and Cost Management** → **Bills** and **Credits**: check again tomorrow that charges have stopped.

Keep your MFA and budget alert switched on for as long as you keep the account.
