#!/bin/bash
set -euo pipefail

isLocal=false
isSecure=false
OPTS_STRING='lhn:s'
APP_NAME=${APP_NAME:-airtasker}

print_usage() {
    cat <<EOF
Usage: $0 [options]

-h Outputs help text
-n Sets the APP_NAME for the service
-l Run locally with minikube
-s Secure connection, set if you have added custom tls certs

EOF
exit 1
}


while getopts $OPTS_STRING opt; do
    case $opt in
        l) isLocal=true ;;
        n) APP_NAME=$OPTARG ;;
        s) isSecure=true ;;
        h) print_usage ;;
        *) >&2 echo Unsupported option: $1
               print_usage ;;
    esac
done

if [ $isLocal = true ]; then
    minikube addons enable ingress
    alias kubectl="minikube kubectl --"
    ./scripts/build.sh
    minikube image load airtasker
else
    echo 'Not yet supported'
    exit 1
fi

export APP_NAME=$APP_NAME
kubectl apply -f k8s/k8s-service.yaml
envsubst < k8s/k8s-deployment.yaml | kubectl apply -f -
if [ $isSecure = true ]; then
    kubectl apply -f k8s/k8s-ingress-tls.yaml
else
    kubectl apply -f k8s/k8s-ingress.yaml
fi
