# hseling-helm

The `hseling-helm` is a means of deploying projects under HSELing umbrella to K8s clusters.

## Installation

Prerequisites include installed `helm`: https://github.com/helm/helm/releases/latest

Install `tiller` into your K8s cluster:

    helm init

## Usage

To install package into local minikube do the following:
    
    # Start minikube and enable "ingress" addon
    minikube start
    minikube addons enable ingress
    
    # Add minikube IP into /etc/hosts
    echo "$(minikube ip) template.hseling" | sudo tee -a /etc/hosts
    
    # Install "template" package into minikube
    ./install.sh template
    
    # Open "template" in your default browser
    xdg-open http://template.hseling/


To install package into DigitalOcean do the following:

    # Do some magic to be able to init Helm as pointed in https://github.com/helm/helm/issues/2687
    kubectl create clusterrolebinding add-on-cluster-admin \
        --clusterrole=cluster-admin --serviceaccount=kube-system:default
        
    # Install "template" package into DigitalOcean
    DOMAIN=partycat.ru BLOCK_STORAGE=do-block-storage ./install.sh template


To uninstall "template" package:

    # Use uninstall.sh script
    ./uninstall.sh template


Feel free to open any issues: https://github.com/hseling/hseling-helm/issues

## License

Copyright © 2019 Sergey Sobko

Distributed under the MIT License. See LICENSE.

All the libraries and systems are licensed and remain the property of their respective owners.
