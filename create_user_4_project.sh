#!/bin/bash

if [ $# -eq 1 ]; then
    sudo adduser "$1"
    echo "umask 027" >> "/home/$1/.bashrc"
    sudo passwd "$1"
    sudo mkdir -p "/data/$1"
    sudo ln -s "/data/$1" "/home/$1/project"
    sudo ln -s "/data/hseling-helm" "/data/$1/helm"
    sudo chown -R "$1":"hse_linghub_k8s" "/data/$1"
fi
