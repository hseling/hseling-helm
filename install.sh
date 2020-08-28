#!/bin/bash

PROJECT_NAME=$1


# Variables and defaults
FULL_PROJECT_NAME=hseling-$PROJECT_NAME
PROJECT_NAMESPACE=$FULL_PROJECT_NAME

PROJECT_EXISTS=$(helm list -n $PROJECT_NAMESPACE | grep $FULL_PROJECT_NAME | cut -f 1)

MINIO_ACCESS_KEY=${MINIO_ACCESS_KEY:-$(echo -n "minio" | base64 -w 0)}
MINIO_SECRET_KEY=${MINIO_SECRET_KEY:-$(echo -n "minio-$FULL_PROJECT_NAME" | base64 -w 0)}

DOMAIN=${DOMAIN:-hseling}

BLOCK_STORAGE=${BLOCK_STORAGE:-csi-cephfs-sc} # For DigitalOcean: do-block-storage

IMAGE_API="hseling/hseling-api-$PROJECT_NAME"
IMAGE_WEB="hseling/hseling-web-$PROJECT_NAME"


# Overriding default values
VALUES_NAME_OVERRIDE="nameOverride=$FULL_PROJECT_NAME"
VALUES_MINIO_ACCESS_KEY="secrets.minioAccessKey=$MINIO_ACCESS_KEY"
VALUES_MINIO_SECRET_KEY="secrets.minioSecretKey=$MINIO_SECRET_KEY"
VALUES_IMAGE_API="images.API.repository=$IMAGE_API"
VALUES_IMAGE_WEB="images.Web.repository=$IMAGE_WEB"
VALUES_HOST="ingress.enabled=true,ingress.hosts.0.host=${PROJECT_NAME}.${DOMAIN},ingress.hosts.0.paths=/"
VALUES_BLOCK_STORAGE="storageClass=${BLOCK_STORAGE}"

VALUES_PART_ONE="$VALUES_NAME_OVERRIDE,$VALUES_MINIO_ACCESS_KEY,$VALUES_MINIO_SECRET_KEY"
VALUES_PART_TWO="$VALUES_IMAGE_API,$VALUES_IMAGE_WEB,$VALUES_BLOCK_STORAGE,$VALUES_HOST"
VALUES="$VALUES_PART_ONE,$VALUES_PART_TWO"

# echo $VALUES

# Get script dir: https://stackoverflow.com/a/246128
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"


# Upsert project
if [ -z $PROJECT_EXISTS ]; then
  helm install $FULL_PROJECT_NAME $DIR --namespace $PROJECT_NAMESPACE --set $VALUES
else
  helm upgrade $FULL_PROJECT_NAME $DIR --namespace $PROJECT_NAMESPACE --set $VALUES
fi
