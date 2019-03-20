#!/bin/bash

PROJECT_NAME=$1


# Variables and defaults
FULL_PROJECT_NAME=hseling-$PROJECT_NAME
PROJECT_EXISTS=$(helm list | grep $FULL_PROJECT_NAME | cut -f 1 | head -n 1)

if [ ! -z $PROJECT_EXISTS ]; then
  helm delete $PROJECT_EXISTS --purge
fi
