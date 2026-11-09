# Ansible Role: borg_backup

Configures automated Borg backups using Borgmatic, registers monitoring checks in Healthchecks, and sets up restricted SSH client connectivity to a remote NAS repository

## Requirements

- Privilege escalation `become: true` is required on the managed host
- Roles:
  - `borgbase.ansible_role_borgbackup`
- Collections:
  - `community.general`

## Role Variables

- All variables and default values are documented in `defaults/main.yaml`
- Argument validation is defined in `meta/argument_specs.yaml`
- Required variables do not have default values and are commented out in `defaults/main.yaml`. You must define them in your inventory or playbook before running the role

Output variables:

- `borg_backup_authorized_key` holds the complete restricted `authorized_keys` line with the public SSH key to paste on the NAS server

## Available Tags

- `borg_backup` runs all tasks in the role
- `packages` installs required SSH and Python packages
- `healthchecks` creates or updates the monitoring check via the Healthchecks API
- `borgmatic` installs Borg/Borgmatic and configures the backup timer
- `ssh_client` configures the local SSH client alias and generates `borg_backup_authorized_key`
- `debug` prints the role variables, makes no changes

## Example Playbook

```yaml
---
- hosts: compute
  gather_facts: true
  become: true
  vars:
    borg_backup_nas_hostname: "10.10.25.1"
    borg_backup_nas_base_directory: "/mnt/storage/borg"
    borg_backup_source_directories:
      - "/docker"
    borg_backup_encryption_passphrase: "{{ vault_borg_backup_encryption_passphrase }}"
    borg_backup_healthchecks_url: "https://hc.example.com"
    borg_backup_healthchecks_api_key: "{{ vault_borg_backup_healthchecks_api_key }}"
  roles:
    - borg_backup
```
