# Proxmox Base

Validates the connection settings for the Proxmox VE API, tests the API and detects whether the node is the primary node of its cluster. It is a dependency of the other proxmox roles and is not meant to be used on its own

## Requirements

- Proxmox VE API reachable from the Ansible controller (all tasks run with `delegate_to: localhost`)
- Python packages `proxmoxer` and `requests` on the controller
- Ansible collection `community.proxmox`
- API credentials are needed. Password, or an API token (token ID and secret)
- `become` is not needed, fact gathering can be disabled (`gather_facts: false`)

## Role Variables

Defaults are in `defaults/main.yaml`, argument validation in `meta/argument_specs.yaml`

> Variables with the value `<REQUIRED>` have no default and must be set

```yaml
proxmox_api_host: "{{ inventory_hostname }}" # (STRING) Hostname or IP address of the Proxmox VE API
proxmox_api_port: 8006 # (INT) API port
proxmox_api_user: "root@pam" # (STRING) User in user@realm form used to authenticate
proxmox_api_validate_certs: false # (BOOL) Validate the TLS certificate of the API

# Authentication
proxmox_api_password: <REQUIRED> # (STRING) Password of proxmox_api_user. Not needed with an API token
proxmox_api_token_id: <REQUIRED> # (STRING) Name of the API token, without user@realm!. Not needed with a password
proxmox_api_token_secret: <REQUIRED> # (STRING) Secret of the API token. Keep it in Ansible Vault
```

Output variables:

- `_proxmox_is_cluster` defines if node is in cluster
- `_proxmox_is_primary_node` defines if node is primary node

## Available Tags

- `always` tests the API and detects the node role, runs on every play whatever tags are selected (skipped with `--tags debug`)
- `debug` prints the connection settings (secrets are masked) and the node role, does not connect to the API

## Example Playbook

```yaml
- hosts: proxmox
  gather_facts: false
  vars:
    proxmox_api_user: "ansible@pam"
    proxmox_api_token_id: "ansible-token"
    proxmox_api_token_secret: "{{ vault_proxmox_api_token_secret }}"
  roles:
    - proxmox_base
```