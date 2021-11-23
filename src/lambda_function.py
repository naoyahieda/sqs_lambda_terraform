import json
import os

def lambda_handler(event, context):
    records = event["Records"]
    
    for record in records:
        message = record["body"]
        print(str(message)) # ここで処理
    
    # 環境変数を出力してみる
    print(os.environ.get("SLACK_API_KEY"))
    
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
