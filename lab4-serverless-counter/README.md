# Lab 4 — A serverless visitor counter (Day 2, 25 min)

**Goal:** build a public web API that counts visits, with no server to manage, using Lambda and DynamoDB.

**Concepts:** serverless, functions as a service, event-driven code, NoSQL key-value tables, execution roles, CloudWatch Logs.

**Files in this folder**

| File | Use |
| --- | --- |
| `lambda_function.py` | The function code (Step 3) |

## Step 1 — Create the table

1. Open **DynamoDB** → **Tables** → **Create table**.
2. **Table name:** `visits`. **Partition key:** `page`, type **String**.
3. Keep **Default settings** → **Create table**. Wait until the status is *Active*.

A partition key is the unique ID for each item — here one item per page, such as `home`.

## Step 2 — Create the function

1. Open **Lambda** → **Create function** → **Author from scratch**.
2. **Function name:** `visit-counter`. **Runtime:** **Python 3.13**. Keep the default architecture.
3. Under **Permissions**, keep **Create a new role with basic Lambda permissions**. This role lets the function write logs, and nothing else yet.
4. Choose **Create function**.

## Step 3 — Add the code

On the **Code** tab, replace everything in `lambda_function.py` with the contents of [`lambda_function.py`](lambda_function.py) from this folder, then choose **Deploy**.

What the code does: every time the function runs, DynamoDB's `ADD` operation adds 1 to the `hits` attribute of the `home` item (creating the item the first time), and the function returns the new total as JSON.

## Step 4 — Give the function access to the table

1. Open the **Configuration** tab → **Permissions**, and click the **Role name** link (it opens IAM).
2. **Add permissions** → **Attach policies** → search `AmazonDynamoDBFullAccess` → tick it → **Add permissions**.

This policy is far broader than the function needs. That is deliberate: in Lab 5 you will replace it with a least-privilege policy.

## Step 5 — Give the function a URL

1. Back in Lambda: **Configuration** → **Function URL** → **Create function URL**.
2. **Auth type:** `NONE` → **Save**.
3. Open the **Function URL**. Refresh a few times.

**What you should see:** `{"visits": 1}`, then 2, 3, and so on. Share your URL with a neighbour and watch your count rise. In DynamoDB → **Explore items** → `visits`, the `home` item shows the same number.

## Step 6 — Read the logs

1. In Lambda, open **Monitor** → **View CloudWatch logs**.
2. Open the newest log stream. Each visit shows a `START`, `END` and `REPORT` line with the duration and memory used — this is what you pay for, per millisecond.

## Clean-up

**Keep the function and table** for Lab 5. Lambda and DynamoDB have always-free monthly allowances, so this lab should cost nothing.

## Deliverable

A screenshot of your Function URL showing a count above 5, and one of the CloudWatch log stream.
