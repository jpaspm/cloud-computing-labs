"""Lab 4 — serverless visitor counter.

Paste this into the Lambda console (Code tab, lambda_function.py) and choose Deploy.
Runtime: Python 3.13. Needs a DynamoDB table named 'visits' with partition key 'page' (String).
"""
import json

import boto3

# Connect to the 'visits' table once, when the function starts
table = boto3.resource("dynamodb").Table("visits")


def lambda_handler(event, context):
    # Add 1 to 'hits' for the 'home' item (creates it the first time)
    r = table.update_item(
        Key={"page": "home"},
        UpdateExpression="ADD hits :one",
        ExpressionAttributeValues={":one": 1},
        ReturnValues="UPDATED_NEW",
    )
    hits = int(r["Attributes"]["hits"])
    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps({"visits": hits}),
    }
