#!/bin/bash

if [ $# -le 0 ]; then
    echo "Not enough args"
    exit 1
fi
if [ $# -ge 3 ]; then
    echo "Too much args"
    exit 1
fi

PROJECT_NAME="$1"
FULL_PROJECT_NAME="hseling-${PROJECT_NAME}"
PROJECT_NAMESPACE="${FULL_PROJECT_NAME}"

PROJECT_EXISTS="$(helm list -n ${PROJECT_NAMESPACE} | grep ${FULL_PROJECT_NAME} | cut -f 1)"

DOMAIN="${DOMAIN:-hseling}"

IMAGE_API="hseling/hseling-api-${PROJECT_NAME}"
IMAGE_WEB="hseling/hseling-web-${PROJECT_NAME}"

VALUES="nameOverride=${FULL_PROJECT_NAME}"
VALUES="${VALUES},images.API.repository=${IMAGE_API}"
VALUES="${VALUES},images.Web.repository=${IMAGE_WEB}"
VALUES="${VALUES},ingress.enabled=true,ingress.hosts.0.host=${PROJECT_NAME}.${DOMAIN},ingress.hosts.0.paths=/"

if [ "x${HSELING_K8S}" == "x" ]; then
    VALUES="${VALUES},hostPath=true"
else
    VALUES="${VALUES},storageClass=${BLOCK_STORAGE:-csi-cephfs-sc}"
fi
VALUES="${VALUES},localPath=${2:-/data/${FULL_PROJECT_NAME}}"

BASE_DIR=$(dirname $(readlink -e $0))

sudo chown -R "${FULL_PROJECT_NAME}":"hse_linghub_k8s" "/data/${FULL_PROJECT_NAME}"

if [ -z ${PROJECT_EXISTS} ]; then
  helm install ${FULL_PROJECT_NAME} ${BASE_DIR} --create-namespace --namespace ${PROJECT_NAMESPACE} --set ${VALUES}
else
  helm upgrade ${FULL_PROJECT_NAME} ${BASE_DIR} --namespace ${PROJECT_NAMESPACE} --set ${VALUES}
fi
