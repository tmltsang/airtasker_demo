#!/bin/bash

python -m virtualenv .venv
source ./venv/bin/activate

python -m pip install requirements.txt
