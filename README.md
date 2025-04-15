# Airtasker demo

This is a simple webservice that returns the name of `$APP_NAME` deployed into kubernetes.

## Requirements
* Python 3
* [Docker](https://docs.docker.com/engine/)/[Docker on Desktop](https://docs.docker.com/desktop/)
* [Minikube](https://minikube.sigs.k8s.io/docs/start/)
* [Helm](https://helm.sh/docs/helm/helm_install/)

## Installation
Make sure to have python installed and run the setup script
```bash
./scripts/setup.sh
```
This will create a `virtualenv` and install all the necessary requirements for you

## Directory Structure
```
.
├── app     //The web app
│   └── ...
├── k8s     //Kubernetes yaml files
│   └── ...
├── scripts //Helper scripts for building and deployment
│   └── ...
├── test    //Tests written for pytest framework
│   └── ...
├── .github
│   └── workflows //Some sample, proof of concept CI/CD
├── Dockerfile
├── requirements.txt
└── README.md
```
## Usage
Make sure you are in the `virtualenv` before running any commands
```
source ./venv/bin/activate
```
### Running
#### Locally
```
./scripts/run.sh -n airtasker
```
The webserver will be accessible on `localhost:5000`

#### Dockerised
```
./scripts/build.sh && ./scripts/run.sh -d -n airtasker
```
The webserver will be accessible on `localhost:5000`

## Testing
Simply run at directory root
```
pytest
```

## Deploying
### Minikube Setup

```
minikube start
```

### Optional: Custom TLS certificate setup
```
openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out cert.crt -keyout key.key #Generate new keys
kubectl -n kube-system create secret tls mkcert --cert cert.crt --key key.key #Add them to minikube tls secret
minikube addons configure ingress #When prompted use 'kube-system/mkcert'
minikube addons disable ingress
minikube addons enable ingress
cp cert.crt ~/.minikube/certs
minikube start --embed-certs
```

### Optional: Monitoring setup
Kubernetes dashbaord
```
#New Terminal
minikube dashboard
```

Install Prometheus and Grafana using Helm

**Prometheus**
```bash
#New Terminal
kubectl create namespace metrics
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/prometheus --namespace metrics
kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-ext
minikube service prometheus-server-ext #Must Leave open
```

**Grafana**
```bash
#New Terminal
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install grafana grafana/grafana --namespace metrics
kubectl expose service grafana --type=NodePort --target-port=3000 --name=grafana-ext
kubectl get secret --namespace metrics grafana -o jsonpath="{.data.admin-password}" | base64 -d # Get the password
minikube service grafana-ext #Login with 'admin':<password above>
#Add Prometheus as a datasource with the ClusterIP of the 'prometheus-server' service
```

### Running locally
To deploy locally run
```
./scripts/deploy.sh -l -n airtasker
# or, if you want to test https
./scripts/deploy.sh -l -n airtasker -s
```

To access:
#### Docker (Linux)
```
curl --resolve "airtasker.demo:80:$( minikube ip )" -i http://airtasker.demo
```
#### Docker Desktop (MacOs/Windows)
In separate terminals run:
```
minikube tunnel
```
and
```
curl -k -L --resolve "airtasker.demo:443:127.0.0.1" --resolve "airtasker.demo:80:127.0.0.1" -i http://airtasker.demo
```

Once you are done, run:
```
./scripts/cleanup_local_deploy.sh
```