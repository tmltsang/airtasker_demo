# Airtasker demo

This is a simple webservice that returns the name of `$APP_NAME` deployed into kubernetes.

## Requirements
* Python 3
* [Docker](https://docs.docker.com/engine/)/[Docker on Desktop](https://docs.docker.com/desktop/)
* [Minikube](https://minikube.sigs.k8s.io/docs/start/)

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
├── Dockerfile
├── requirements.txt
└── README.md
```
## Usage
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
To deploy locally run
```
./scripts/deploy.sh -l -n airtasker
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
curl --resolve "airtasker.demo:80:127.0.0.1" -i http://airtasker.demo
```

Once you are done, run:
```
./scripts/cleanup_local_deploy.sh
```