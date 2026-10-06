# Troubleshooting quick reference

Most lab problems come from one of three causes: the **wrong region**, a **missing security-group rule**, or a **missing permission**. Check those first.

| Lab | Symptom | Likely cause | Fix |
| --- | --- | --- | --- |
| Any | A resource you created has "disappeared" | Console is in a different region | Switch the region at the top-right back to the class region |
| 1, 3 | EC2 Instance Connect fails | No public IP, or no SSH rule in the security group | Use a public subnet with public IP enabled; allow SSH in the security group |
| 2 | 403 Forbidden on the website | Block Public Access still on, or wrong bucket name in the policy | Untick Block Public Access; check the policy's `Resource` ends in `YOUR-BUCKET/*` |
| 2 | 404 Not Found | Index document name doesn't match the file | Names are case-sensitive: `index.html` in both places |
| 3, 6 | Page won't load in the browser | Browser forced `https://`, or nginx still installing | Type `http://` explicitly; wait 2–3 minutes after launch |
| 3 | Page won't load after waiting | Instance in a private subnet, or no HTTP rule | Relaunch in a `public` subnet; add HTTP to `web-sg` |
| 4 | URL shows "Internal Server Error" | Error inside the function | Open Monitor → CloudWatch logs and read the newest error |
| 4 | Log shows `AccessDeniedException` | Role has no DynamoDB permission | Attach the policy (Lab 4) or the inline policy (Lab 5) |
| 4 | Log shows `ResourceNotFoundException` | Table name or region mismatch | Table must be named `visits`, in the same region as the function |
| 5 | No events for `dev-yourname` in CloudTrail | Events still arriving | Wait about 5 minutes; check the time range and region |
| 6 | Targets stay *unhealthy* | nginx not running, or `app-sg` doesn't allow HTTP from `alb-sg` | Check the user data; check the `app-sg` inbound rule source |
| 6 | Load balancer DNS returns 503 | No healthy targets yet | Wait until both targets are healthy in `tg-web` |
| 6 | Instances have no public IP and never become healthy | Public IP not enabled in the launch template | Edit the template's network interface: auto-assign public IP = Enable |
| 6 | No scale-out after 10 minutes | Load not running, or still within the alarm period | Check `top` shows ~100% CPU; check CloudWatch → Alarms |
| Clean-up | VPC won't delete | Something is still inside it | Delete the load balancer and instances first, then retry |
