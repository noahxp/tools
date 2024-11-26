#!/bin/bash

### CLI command to list task definitions and Docker images
### 適合用來刪除 Batch 

export prefix=$1
[ -z "$prefix" ] && echo -e "CLI command to list task definitions and Docker images\n\nUsage: $0 <task definition name> [number of latest task definitions to exclude]" && exit 1

export reserve_items=$2

[ -n "$reserve_items" ] && TASK_DEFINITIONS=$(aws ecs list-task-definitions --family-prefix $prefix --query 'taskDefinitionArns[:-'$reserve_items']' --output text) || \
                           TASK_DEFINITIONS=$(aws ecs list-task-definitions --family-prefix $prefix --query 'taskDefinitionArns' --output text)
# TASK_DEFINITIONS=$(aws ecs list-task-definitions --family-prefix $prefix --query 'taskDefinitionArns[-2:]' --output text) #　取最後二筆，用來 debug

LATEST_IMAGE=$(aws ecs list-task-definitions --family-prefix $prefix --query 'taskDefinitionArns[-1]' --output text \
                    | xargs -I {} aws ecs describe-task-definition --task-definition {} --query 'taskDefinition.containerDefinitions[].image' --output text )
REPO_NAME=$(echo $LATEST_IMAGE | cut -d'/' -f2 | cut -d':' -f1)
LATEST_DIGEST=$(aws ecr batch-get-image --repository-name $REPO_NAME --image-ids imageTag=latest --query 'images[].imageId.imageDigest' --output text)

for TD_ARN in $TASK_DEFINITIONS; do

    # 取得 Task Definition 詳細資訊
    CONTAINER_IMAGES=$(aws ecs describe-task-definition --task-definition $TD_ARN --query 'taskDefinition.containerDefinitions[].image' --output text)

    for IMAGE in $CONTAINER_IMAGES; do
        REPO_NAME=$(echo $IMAGE | cut -d'/' -f2 | cut -d':' -f1)
        TAG=$(echo $IMAGE | cut -d':' -f2)

        # TAG 本身就是 latest ，就不刪除
        [ "$TAG" == "latest" ] && IS_LATEST="true" && continue

        # 檢查該映像是否為 latest 標籤，如果是就跳開，此 task definition 及 image 不刪除
        IS_LATEST=""
        DIGEST=$(aws ecr batch-get-image --repository-name $REPO_NAME --image-ids imageTag=$TAG --query 'images[].imageId.imageDigest' --output text)
        [ "$DIGEST" == "$LATEST_DIGEST" ] && IS_LATEST="true" && echo "Skipping image with tag 'latest' in repository $REPO_NAME: $IMAGE" && continue

        # 刪除映像
        echo "aws ecr batch-delete-image --repository-name $REPO_NAME --image-ids imageTag=$TAG --output text"
    done

    [ -n "$IS_LATEST" ] && continue

    # Deregister the task definition
    echo "aws ecs deregister-task-definition --task-definition $TD_ARN --query 'taskDefinition.taskDefinitionArn' --output text"
    echo "aws ecs delete-task-definitions --task-definitions $TD_ARN --query 'taskDefinitions[].taskDefinitionArn' --output text"
    echo ""

done
