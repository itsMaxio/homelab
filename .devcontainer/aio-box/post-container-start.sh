#!/bin/bash
set -eu

mkdir -p /root/.ssh
chmod 700 /root/.ssh

if [ -d /root/.sshtemplate ]; then
    cp -a /root/.sshtemplate/. /root/.ssh/
fi

find /root/.ssh -type f -exec chmod 600 {} \;
find /root/.ssh -type d -exec chmod 700 {} \;

# ansible
bash /workspace/ansible/install_requirements.sh

# terraform
terraform -install-autocomplete 2>/dev/null || true