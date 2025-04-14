#!/bin/bash
set -uo pipefail
alias kubectl="minikube kubectl --"

kubectl delete service airtasker
kubectl delete deployment airtasker-deployment
kubectl delete ingress airtasker-ingress