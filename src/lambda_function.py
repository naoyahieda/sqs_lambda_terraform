import json
import os
import time

def lambda_handler(event, context):
    records = event["Records"]
    
    for record in records:
        message = record["body"]
        print(message) # ここで処理
        print('wow')
        time.sleep(10)
    
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
