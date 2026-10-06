# Lab 2 — Host a static website on Amazon S3 (Day 2, 30 min)

**Goal:** publish a website with no server at all, using S3 object storage.

**Concepts:** object storage, buckets and objects, globally unique names, resource-based policies, Block Public Access.

**Files in this folder**

| File | Use |
| --- | --- |
| `index.html` | Your home page (replace it with your own if you like) |
| `error.html` | Page shown for missing paths |
| `bucket-policy.json` | Policy that allows public reads (Step 5) |

## Step 1 — Prepare the files

Download `index.html` and `error.html` from this folder. Edit `index.html` to put your name in it (or use your own page from the Day 1 homework).

## Step 2 — Create the bucket

1. Open **S3** → **Create bucket**.
2. **Bucket name:** `cc-lab2-yourname-1234` (replace `1234` with any digits). Names must be unique across all AWS accounts worldwide, lowercase, with no spaces.
3. Confirm the region is the class region. Keep all other defaults, including **Block all public access** ticked for now.
4. Choose **Create bucket**.

## Step 3 — Upload the files

Open your bucket → **Upload** → **Add files** → select `index.html` and `error.html` → **Upload**.

## Step 4 — Turn on static website hosting

1. Open the **Properties** tab and scroll to the bottom: **Static website hosting** → **Edit**.
2. Choose **Enable**, hosting type **Host a static website**.
3. **Index document:** `index.html`. **Error document:** `error.html`. Choose **Save changes**.
4. Scroll down again and copy the **Bucket website endpoint** URL.

Open that URL now. You get **403 Forbidden** — the bucket is still private. That is S3 protecting you by default.

## Step 5 — Allow public reads

1. Open the **Permissions** tab → **Block public access (bucket settings)** → **Edit**.
2. Untick **Block all public access** → **Save changes** → type `confirm`.
3. Still on **Permissions**, scroll to **Bucket policy** → **Edit**, and paste the contents of [`bucket-policy.json`](bucket-policy.json), replacing `YOUR-BUCKET` with your bucket name:

```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "PublicRead",
    "Effect": "Allow",
    "Principal": "*",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::YOUR-BUCKET/*"
  }]
}
```

4. Choose **Save changes**. The bucket now shows a red **Publicly accessible** label.

**Read the policy:** *Effect* Allow, *Principal* everyone (`*`), *Action* read an object (`s3:GetObject`), *Resource* every object in your bucket (`/*`). It allows reading only — nobody else can upload or delete.

## Step 6 — Test

1. Refresh the website endpoint: your page appears.
2. Add `/nope` to the end of the URL: your `error.html` appears.

## Bonus — versioning

1. **Properties** → **Bucket Versioning** → **Edit** → **Enable**.
2. Change `index.html` on your laptop and upload it again.
3. Open the bucket, turn on **Show versions**, and see both versions. Delete the newest version to roll back.

## Clean-up

**Keep this bucket** — you will lock it down in Lab 5.

## Deliverable

Your website URL, plus a screenshot of the page in the browser.
