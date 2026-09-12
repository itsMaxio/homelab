#!/usr/bin/env bash
set -eu

mkdir -p /root/.ssh
chmod 700 /root/.ssh

if [ -d /root/.sshtemplate ]; then
    cp -a /root/.sshtemplate/. /root/.ssh/
fi

find /root/.ssh -type f -exec chmod 600 {} \;
find /root/.ssh -type d -exec chmod 700 {} \;

# terraform
terraform -install-autocomplete;