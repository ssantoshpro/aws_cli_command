#Removing Existing Output File
echo "Code Running"
if [ ! -f 'AWS_Count_Log.txt' ]
then
  echo "No existing out file. 
  Proceeding Next Step ->"
else
  rm 'AWS_Count_Log.txt'
fi

if [ ! -f 'Trailer_Deatil.txt' ]
then
  echo "No existing Trailer_Deatil.txt file. 
  Proceeding Next Step ->"
else
  rm 'Trailer_Deatil.txt'
fi

# to download it in E2C
aws s3 cp "s3://pocbucket06032023/cmd_list.txt" .

# to run each line 
cat cmd_list.txt | while read bucket_path; do
	fname=$(echo $bucket_path | sed -e 's/\r//g')
	temp_file=$(basename $fname | sed -e 's/\r//g')
	aws s3 cp s3://"$fname" .
	if grep -q "TRAILER" $temp_file; then
		COUNT=$(grep -n 'TRAILER' $temp_file | cut -d':' -f1 )
		echo "$fname has $((COUNT-2)) lines"
		echo "$fname has $((COUNT-2)) lines" >> AWS_Count_Log.txt
		echo "TRAILER-"$(grep -m 1 'TRAILER' $temp_file | sed 's/.*TRAILER//') >> Trailer_Deatil.txt
	else
		COUNT=$(grep -cve '^\s*$' $temp_file)
		echo "$fname has $COUNT lines"
		echo "$fname has $COUNT lines" >> AWS_Count_Log.txt
	fi
	rm $temp_file
done

# Upload the AWS_Count_Log file to S3
aws s3 cp "AWS_Count_Log.txt" "s3://pocbucket06032023/"
# Upload the Trailer_Deatil file to S3
aws s3 cp "Trailer_Deatil.txt" "s3://pocbucket06032023/"
