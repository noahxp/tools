#!/bin/bash

### 通用型刪除


# TASK_DEFINITION_PREFIX=${BACKEND_TASK_DEFINITION_NAME}
# ECR_REPOSITORY_NAME=${BACKEND_ECR_REPOSITORY_NAME}
TASK_DEFINITION_PREFIX=$1
ECR_REPOSITORY_NAME=$2

reserve_items=$3

[ -z "$TASK_DEFINITION_PREFIX" -o -z "$ECR_REPOSITORY_NAME" ] && echo -e "CLI command to list task definitions and Docker images\n\nUsage: $0 <task definition name> <ecr repository name> [reserve items]" && exit 1


[ -z "$reserve_items" ] && reserve_items=30

TASK_DEFINITIONS=$(aws ecs list-task-definitions --family-prefix ${TASK_DEFINITION_PREFIX} --query 'taskDefinitionArns[:-'${reserve_items}']' --output text)
for TD_ARN in $TASK_DEFINITIONS; do
  CONTAINER_IMAGES=$(aws ecs describe-task-definition --task-definition $TD_ARN --query 'taskDefinition.containerDefinitions[].image' --output text)
  for IMAGE in $CONTAINER_IMAGES; do
    TAG=$(echo $IMAGE | cut -d':' -f2)
    if [ "$TAG" != "latest" ]; then
      echo "aws ecr batch-delete-image --repository-name ${ECR_REPOSITORY_NAME} --image-ids imageTag=$TAG --output text"
    fi
  done
  if ! echo $CONTAINER_IMAGES | grep -q ':latest'; then
    echo "aws ecs deregister-task-definition --task-definition ${TD_ARN} --query 'taskDefinition.taskDefinitionArn' --output text"
    echo "aws ecs delete-task-definitions --task-definitions ${TD_ARN} --query 'taskDefinitions[].taskDefinitionArn' --output text"
    echo ''
  fi
done