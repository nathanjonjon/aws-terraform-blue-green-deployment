#!/bin/bash -xe

## slack us when the stanging instance is created
ENV="${ENV}"
TAG="${TAG}"
curl -X POST -H "Content-Type: application/json" -d "{\"channel\": \"#eng-alerts-testing\", \"username\": \"webhookbot\", \"text\": \"${ENV} instance created\", \"icon_emoji\": \":rocket:\"}" $SLACK_URL

export AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION

## config the instance and download awscli, docker and so on
sudo su
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
aws --version
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user

## pull the image from ECR
ECR_REPO="${ECR_REPO}"

aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $ECR_REPO
docker pull $ECR_REPO:$TAG

## mound EFS and and bind it to our docker volume (feel free to customize the below commands)
sudo yum -y install amazon-efs-utils
sudo mkdir /mnt/efs
sudo mkdir /mnt/efs/source
sudo mount -t efs -o iam,tls,accesspoint=$ACCESS_POINT $MOUNT_POINT /mnt/efs/source
docker volume create --driver local --opt type=nfs --opt o=addr=$MOUNT_POINT.efs.$AWS_DEFAULT_REGION.amazonaws.com,nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport --opt device=:/source efs_source

## slack us when the config is done
curl -X POST -H "Content-Type: application/json" -d "{\"channel\": \"#eng-alerts-testing\", \"username\": \"webhookbot\", \"text\": \"${ENV} instance ready to run\", \"icon_emoji\": \":rocket:\"}" $SLACK_URL

sudo yum install jq -y

## get the access keys from meta data of this instance
IAM_ROLE="${IAM_ROLE}"
aws_access_key=`curl http://instance-data/latest/meta-data/iam/security-credentials/${IAM_ROLE} | jq -r '.AccessKeyId'`
aws_secret_key=`curl http://instance-data/latest/meta-data/iam/security-credentials/${IAM_ROLE} | jq -r '.SecretAccessKey'`

docker run -d -p 8000:8000 --mount source=efs_source,target=/efs --env SECRET_KEY=$django_key --env aws_access_key=$aws_access_key --env aws_secret_key=$aws_secret_key --env AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION --env ENV=$ENV --name $APP_NAME $ECR_REPO:$TAG

