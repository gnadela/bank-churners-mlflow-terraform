#!/bin/bash
yum update -y
yum install -y docker
service docker start
usermod -a -G docker ec2-user
curl -LO https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)
mv docker-compose-$(uname -s)-$(uname -m) /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
mkdir /mlflow
cd /mlflow
cat <<EOL > docker-compose.yml
version: '3.7'
services:
  mlflow:
    image: mlflow:latest
    environment:
      - BACKEND_STORE_URI=postgresql://${username}@${endpoint}/${db_name}
      - ARTIFACT_ROOT=s3://${bucket}
    ports:
      - "5000:5000"
EOL
docker-compose up -d
