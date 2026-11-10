# NetBox Config Context Standard

This document provides rules and templates for structuring, naming, and weighting Config Contexts in NetBox. Actual values can change over time and are stored in NetBox as the Single Source of Truth

Core rules:

- place only one top level JSON object inside a single Config Context
- do not copy Ansible role variable names directly into NetBox Config Contexts
- never store secrets, passwords, or private API tokens in NetBox
- map NetBox `config_context[0]` variables to Ansible role variables inside `inventories/group_vars/` or inside type playbooks

## Naming Convention

The Config Context name format is `scope_namespace`. The `scope` defines the target group of devices or virtual machines. The `namespace` matches the top level JSON key inside the context. Sharing the same `scope` prefix groups related contexts together in the NetBox list

Examples:

- `global_ansible`
- `global_system`
- `linux_ansible`
- `linux_system`
- `virtual_machines_dns`
- `virtual_machines_ssh`
- `borg_backup_borg`
- `borg_backup_healthchecks`
- `dns_server_acme`

## Grouping and Merging Rules

Multiple Config Contexts at different weight tiers can contribute keys to the same top level JSON dictionary. NetBox performs a deep merge on dictionaries from lowest weight to highest weight

- separate Config Contexts based on their scope of assignment and top level JSON key
- use lower weight tiers for shared baseline settings and higher weight tiers for role or host overrides

## Standard Namespaces

- `ansible_*` flat keys for Ansible connection, user, and privilege escalation settings
- `system` holds general host settings such as `domain_name` and `timezone`
- `dns` holds client resolver settings such as `nameservers` and `search_domains`
- `ssh_authorized_keys` holds lists of public SSH keys grouped by username
- `acme` holds TLS certificate issuance parameters
- `borg` holds backup repository, compression, schedule, and hook settings
- `healthchecks` holds monitoring server URL, timezone, and grace time settings

## Weight Hierarchy

NetBox merges Config Contexts from lowest weight to highest weight. Contexts with higher weights override values from contexts with lower weights

Always assign weights according to the following tiers:

### Global level `1000`

- assigned to general management or virtualization tags such as `Ansible Managed` or `Terraform Managed`
- used for global defaults such as default Ansible user, main domain name, DNS resolvers, and SSH public keys

### Platform level `2000`

- assigned to Operating System platforms such as `Linux` or `Cisco IOS`
- used for OS specific settings such as privilege escalation flags and system timezone

### Service level `3000`

- assigned to service tags such as `Borg Backup` or `Docker`
- used for shared service baselines across different machine types such as backup repository address or monitoring settings

### Role level `4000`

- assigned to device or VM roles such as `DNS Server`, `Switch`, `Hypervisor`, or `Compute`
- used for role specific parameters such as ACME settings or role specific overrides for services

## Merging Example

Global context `global_system` with weight `1000` sets the base domain:

```json
{
    "system": {
        "domain_name": "example.com"
    }
}
```

Platform context `linux_system` with weight `2000` adds the timezone for Linux hosts:

```json
{
    "system": {
        "timezone": "Europe/Warsaw"
    }
}
```

Virtual machine context `virtual_machines_dns` with weight `1000` sets client DNS resolvers:

```json
{
    "dns": {
        "search_domains": [
            "example.com"
        ],
        "nameservers": [
            "10.10.10.53",
            "10.10.10.54"
        ]
    }
}
```

Rendered output on a Linux virtual machine combines all matching contexts:

```json
{
    "dns": {
        "search_domains": [
            "example.com"
        ],
        "nameservers": [
            "10.10.10.53",
            "10.10.10.54"
        ]
    },
    "system": {
        "domain_name": "example.com",
        "timezone": "Europe/Warsaw"
    }
}
```
