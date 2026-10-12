#!/bin/bash

cd /workspace/ansible

ansible-galaxy install -r requirements.yaml
pip install -r requirements.txt