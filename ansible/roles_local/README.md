# Role Name

One or two sentences about what the role does

## Requirements

- Requirement, for example `become: true`
- Python package `proxmoxer` on the controller
- Ansible collection `community.proxmox`

## Role Variables

- All variables and default values are documented in `defaults/main.yaml`
- Argument validation is defined in `meta/argument_specs.yaml`
- Required variables do not have default values and are commented out in `defaults/main.yaml`. You must define them in your inventory or playbook before running the role

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
