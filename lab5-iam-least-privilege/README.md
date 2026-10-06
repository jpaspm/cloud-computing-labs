# Lab 5 — Least privilege and an audit trail (Day 3, 30 min)

**Goal:** give a person and a program only the permissions they need, prove that everything else is denied, and find the evidence in the audit log.

**Concepts:** IAM users, groups, roles and policies; least privilege; managed vs inline policies; CloudTrail; Block Public Access.

**Before you start:** you need the S3 bucket from [Lab 2](../lab2-s3-static-website/) and the `visit-counter` function from [Lab 4](../lab4-serverless-counter/).

**Files in this folder**

| File | Use |
| --- | --- |
| `visits-update-only-policy.json` | Least-privilege inline policy for the Lambda role (Part B) |

## Part A — A read-only colleague

1. Open **IAM** → **User groups** → **Create group**. **Name:** `s3-readers`. Under **Attach permissions policies**, tick `AmazonS3ReadOnlyAccess` → **Create user group**.
2. **IAM** → **Users** → **Create user**. **User name:** `dev-yourname`.
3. Tick **Provide user access to the AWS Management Console** → **I want to create an IAM user**. Choose **Custom password**, set one, and untick **Users must create a new password at next sign-in** → **Next**.
4. **Add user to group:** tick `s3-readers` → **Next** → **Create user**.
5. Copy the **Console sign-in URL** shown on the final page (it contains your 12-digit account ID).
6. Open a **private/incognito browser window**, go to that URL and sign in as `dev-yourname`.
7. As `dev-yourname`, open **S3** and your Lab 2 bucket. Listing and opening objects works.
8. Now try two things that need write access:
   - Select an object → **Delete**. You get **Access Denied** (or a failed delete).
   - Choose **Create bucket**, any name → **Create**. You get **Access Denied**.

The user can do exactly what the group's policy allows and nothing else. Close the private window.

## Part B — A least-privilege Lambda role

Back in your own (root) session:

1. Open **Lambda** → `visit-counter` → **Configuration** → **Permissions** → click the role name.
2. In the role's **Permissions policies**, tick `AmazonDynamoDBFullAccess` → **Remove** → confirm.
3. Refresh your Function URL. It now fails with an error: the function has lost access.
4. Open **DynamoDB** → **Tables** → `visits` → **Overview** → **General information**, and copy the **Amazon Resource Name (ARN)**.
5. Back on the role: **Add permissions** → **Create inline policy** → **JSON**, and paste the contents of [`visits-update-only-policy.json`](visits-update-only-policy.json), replacing `TABLE-ARN` with the ARN you copied:

```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": "dynamodb:UpdateItem",
    "Resource": "TABLE-ARN"
  }]
}
```

6. **Next** → **Policy name:** `visits-update-only` → **Create policy**.
7. Refresh the Function URL. The count works again.

**Compare:** before, the function could read, change or delete *every* DynamoDB table in your account. Now it can do one action on one table. If its code were ever compromised, the damage is limited to adding to a counter.

## Part C — Find the evidence in CloudTrail

1. Open **CloudTrail** → **Event history** (no setup needed; it keeps 90 days of management events).
2. Set the filter to **User name** = `dev-yourname`. Events can take up to about 5 minutes to appear.
3. Find the **CreateBucket** event and open it. In the event record, find `errorCode: AccessDenied`, the time, and the source IP address.

You will not find the denied object delete here. Object reads and deletes are *data events*, which CloudTrail records only if you create a trail that logs them. Bucket creation is a *management event*, which Event history always shows.

## Part D — Make the Lab 2 bucket private again

1. Open your Lab 2 bucket → **Permissions** → **Block public access** → **Edit** → tick **Block all public access** → **Save** → type `confirm`.
2. Refresh your website URL: **403 Forbidden**.

Block Public Access overrides the public bucket policy. In real projects you keep it on and serve sites through CloudFront with Origin Access Control instead (covered in Unit 5).

## Clean-up

Keep everything until the final clean-up at the end of Day 3 ([CLEANUP.md](../CLEANUP.md)).

## Deliverable

A screenshot of the Access Denied message as `dev-yourname`, and a screenshot of the CreateBucket event showing `AccessDenied` in CloudTrail.
