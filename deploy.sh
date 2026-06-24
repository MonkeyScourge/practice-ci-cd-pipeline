#! /bin/bash

# Description:
#  1. get-login-token
#  2. pull image from ecr
#  3. stop running container
#  4. start new container new image
#  5. prune images

# Can be Implemented later:
#  rollback logic; not priority for my demo
#  ECR lifecycle policy
#  error handling 

  # basic error handling: exit if any command fails
set -e
image_tag=$1
#amazon_id=$2
  # get acc_id from parameter store
amazon_id=(aws ssm get-parameter --name amazon_acc_id --with-decryption | jq -r '.Parameter.Value')

  # get aws-login-token for ecr
aws ecr get-login-password --region us-west-1 | \
  docker login --username AWS \
  --password-stdin "$amazon_id".dkr.ecr.us-west-1.amazonaws.com

  # pull image from ecr
docker pull "$amazon_id".dkr.ecr.us-west-1.amazonaws.com/my-app:"$image_tag"

  # stop running container: git.sha tag specifically
docker stop $(docker ps -q --filter "label=app.version=${CURRENT_SHA}") 2>/dev/null || true

  # run new container
docker run -dp \
  --label "app=myapp" \
  --label "app.version=${NEW_SHA}"
  --name "myapp-${NEW_SHA}" \
  

  # prune unused images
docker prune -a
