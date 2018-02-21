#!/bin/bash
mkdir -p /home/ec2-user/data
dbname = YOUR-DB-NAME
bucket = YOUR-BUCKET-NAME
# List all the logs files in your RDS instance
aws rds describe-db-log-files --db-instance-identifier $dbname --output text | awk '{print $3}' > /home/ec2-user/log-list.txt
for i in `cat /home/ec2-user/log-list.txt` ; do
# Download log files to your local 
aws rds download-db-log-file-portion --db-instance-identifier $dbname --log-file-name $i >> /home/ec2-user/data/$i
# Uplload log files to S3 bucket
aws s3 cp /home/ec2-user/data/$i s3://$bucket
done
