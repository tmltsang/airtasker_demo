#!/bin/bash
set -euo pipefail

isDocker=false
OPTS_STRING='dhn:'
APP_NAME=${APP_NAME:-airtasker}

print_usage() {
    cat <<EOF
Usage: $0 [options]

-h Outputs help text
-n Sets the APP_NAME for the service. (Will override APP_NAME env variable)
-d Run in docker

EOF
exit 1
}


while getopts $OPTS_STRING opt; do
    case $opt in
        d) isDocker=true ;;
        n) APP_NAME=$OPTARG ;;
        h) print_usage ;;
        *) >&2 echo Unsupported option: $1
               print_usage ;;
    esac
done

if [ $isDocker = true ]; then
    docker run --rm  -it -p 5000:5000 -e APP_NAME=$APP_NAME --name airtasker airtasker
else
    export APP_NAME=$APP_NAME
    flask --app app run --debug
fi
