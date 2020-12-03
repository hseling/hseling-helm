#!/bin/bash

if [ $# -eq 1 ]; then
    PROJECT_NAME="$1"
    FULL_PROJECT_NAME="hseling-${PROJECT_NAME}"
    sudo adduser "${FULL_PROJECT_NAME}"
    echo "umask 027" | sudo tee -a "/home/${FULL_PROJECT_NAME}/.bashrc"
    sudo passwd "${FULL_PROJECT_NAME}"
    sudo mkdir -p "/mnt/data/${FULL_PROJECT_NAME}/app/prod"
    sudo mkdir -p "/mnt/data/${FULL_PROJECT_NAME}/app/backup"
    sudo touch "/mnt/data/${FULL_PROJECT_NAME}/app/prod/rm_file.txt"
    sudo mkdir -p "/mnt/data/${FULL_PROJECT_NAME}/mysql/prod"
    sudo mkdir -p "/mnt/data/${FULL_PROJECT_NAME}/mysql/backup"
    sudo ln -s "/mnt/data/${FULL_PROJECT_NAME}" "/home/${FULL_PROJECT_NAME}/project"
    sudo ln -s "/mnt/data/hseling-helm" "/mnt/data/${FULL_PROJECT_NAME}/helm"
    sudo chown -R "${FULL_PROJECT_NAME}":"hse_linghub_k8s" "/mnt/data/${FULL_PROJECT_NAME}"
    sudo chmod o-r,o-x "/mnt/data/${FULL_PROJECT_NAME}"
fi
