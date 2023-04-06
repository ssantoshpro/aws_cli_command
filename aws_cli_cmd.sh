#Removing Existing Output File
echo "Code Running"
if [ ! -f 'AWS_Count_Log.txt' ]
then
  echo "No existing out file. 
  Proceeding Next Step ->"
else
  rm 'AWS_Count_Log.txt'
fi

# to download it in E2C
aws s3 cp "s3://pocbucket06032023/cmd_list.txt" .

# to run each line 
cat cmd_list.txt | while read bucket_path; do
	fname=$(echo $bucket_path | sed -e 's/\r//g')
	COUNT=$(aws s3 cp s3://"$fname" - | wc -l)
	echo "$fname has $COUNT lines"
	echo "$fname has $COUNT lines" >> AWS_Count_Log.txt
done

# Upload the output file to S3
aws s3 cp "AWS_Count_Log.txt" "s3://pocbucket06032023/output.txt"