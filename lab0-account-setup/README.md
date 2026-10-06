# Lab 0 — Set up a safe AWS account (before Day 1)

**Goal:** an AWS account that is protected by MFA, warns you before you spend money, and is set to the class region. Do this at home before Day 1 — sign-up can take 15–30 minutes.

**Concepts:** root user, multi-factor authentication (MFA), budgets, regions.

## Step 1 — Create the account

1. Go to <https://aws.amazon.com/free> and choose **Create a Free Account**.
2. Enter your email, an account name (for example `cc-course-yourname`) and verify the email code.
3. Set a strong root password and store it safely.
4. Choose the **Free plan** when asked to pick a plan. New accounts get $100 in credits at sign-up and can earn up to $100 more by completing onboarding tasks. The Free plan lasts 6 months or until the credits are used, and does not bill you.
5. Enter contact details, a payment card (used for identity verification), and complete phone verification.
6. Sign in to the **AWS Management Console** as the root user.

## Step 2 — Turn on MFA for the root user

1. Click your account name (top-right) → **Security credentials**.
2. Under **Multi-factor authentication (MFA)**, choose **Assign MFA device**.
3. Name it `root-phone`, pick **Authenticator app**, and scan the QR code with Google Authenticator, Microsoft Authenticator or similar.
4. Enter two consecutive codes and choose **Add MFA**.

## Step 3 — Create a budget alert

1. Search for **Billing and Cost Management** in the top search bar and open it.
2. Choose **Budgets** → **Create budget** → **Use a template** → **Monthly cost budget**.
3. Budget name `course-budget`, amount `5` (USD), and your email as the recipient.
4. Choose **Create budget**. You will now get an email when spending is forecast to cross the amount.
5. Open **Credits** in the same console and note your credit balance.

## Step 4 — Set the class region

1. Click the region name at the top-right of the console.
2. Select the region your instructor names, for example **Asia Pacific (Mumbai) ap-south-1**.

## What you should see

MFA shows as assigned, a budget named `course-budget` exists, and the console shows the class region.

## Deliverable

A screenshot of the Budgets page.

## Why it matters

The root user can do anything, including close the account. MFA stops someone with your password from logging in, and the budget alert is your early warning against forgotten resources.
