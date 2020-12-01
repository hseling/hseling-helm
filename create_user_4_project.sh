#!/bin/bash

if [ $# -eq 1 ]; then
    PROJECT_NAME="$1"
    FULL_PROJECT_NAME="hseling-${PROJECT_NAME}"
    sudo adduser "${FULL_PROJECT_NAME}"
    echo "umask 027" | sudo tee -a "/home/${FULL_PROJECT_NAME}/.bashrc"
    sudo passwd "${FULL_PROJECT_NAME}"
    sudo mkdir -p "/data/${FULL_PROJECT_NAME}/app/prod"
    sudo mkdir -p "/data/${FULL_PROJECT_NAME}/app/backup"
    sudo touch "/data/${FULL_PROJECT_NAME}/app/prod/rm_file.txt"
    sudo mkdir -p "/data/${FULL_PROJECT_NAME}/mysql/prod"
    sudo mkdir -p "/data/${FULL_PROJECT_NAME}/mysql/backup"
    sudo touch "/data/${FULL_PROJECT_NAME}/mysql/prod/rm_file.txt"
    sudo ln -s "/data/${FULL_PROJECT_NAME}" "/home/${FULL_PROJECT_NAME}/project"
    sudo ln -s "/data/hseling-helm" "/data/${FULL_PROJECT_NAME}/helm"
    sudo chown -R "${FULL_PROJECT_NAME}":"hse_linghub_k8s" "/data/${FULL_PROJECT_NAME}"
fi
