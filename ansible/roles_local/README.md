# Role Name

One or two sentences about what the role does

## Requirements

- Requirement, for example `become: true`
- Python package `proxmoxer` on the controller
- Ansible collection `community.proxmox`

## Role Variables

Defaults are in `defaults/main.yaml`, argument validation in `meta/argument_specs.yaml`

> Variables with the value `<REQUIRED>` have no default and must be set

```yaml
role_name_example: "default" # (STRING) What it is for, allowed values
role_name_port: 8006 # (INT) What it is for
role_name_enabled: true # (BOOL) What it is for
role_name_secret: <REQUIRED> # (STRING) What it is for. Keep it in Ansible Vault

role_name_items: # (LIST of DICT) Default: []. What the list describes
  - name: <REQUIRED> # (STRING) What it is for
    state: present # (STRING) One of: present, absent
```

Output variables:

- `role_name_result` what it holds

## Available Tags

- `items` what the tag does
- `debug` prints the role variables, makes no changes

## Example Playbook

```yaml
- hosts: proxmox
  gather_facts: false
  vars:
    role_name_secret: "{{ vault_role_name_secret }}"
  roles:
    - role_name
```
