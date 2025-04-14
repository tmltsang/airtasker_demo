#!/bin/bash

#Setup the python environment properly
python -m virtualenv .venv
source ./venv/bin/activate

python -m pip install requirements.txt
