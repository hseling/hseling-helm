#!/bin/bash

PROJECT_NAME=$1

FULL_PROJECT_NAME=hseling-$PROJECT_NAME
PROJECT_NAMESPACE=$FULL_PROJECT_NAME
PROJECT_EXISTS=$(helm list -n $PROJECT_NAMESPACE | grep $FULL_PROJECT_NAME | cut -f 1 | head -n 1)

if [ ! -z $PROJECT_EXISTS ]; then
    helm delete $PROJECT_EXISTS -n $PROJECT_NAMESPACE
    kubectl delete namespaces $PROJECT_NAMESPACE
fi
