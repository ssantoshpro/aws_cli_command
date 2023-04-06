import boto3
import pandas as pd
import subprocess as sp
from datetime import datetime
with open('cmd_list.txt','w') as f:
    f.write('')
f.close()
response= s3.list_buckets()
bucket_list=[]
final_list=[]
file_issue=[]
i=0
start= str(datetime.now())
for obj in response['Buckets']: 
    bucket_list.append(obj['Name']) 
for bucket_name in bucket_list: 
    responses = s3.list_objects_v2(Bucket=bucket_name) 
    for obj in responses['Contents']: 
        key=obj['Key'] 
        if '.' in key: 
            cmd ='{}/{}'.format(bucket_name,key)
            with open('cmd_list.txt', 'a') as f:
                f.write(cmd + '\n')
            f.close()