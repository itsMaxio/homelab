# Device and Services Naming Conventions

This document provides naming guidelines and templates for devices and services in the homelab. Names can change over time and actual values are stored in a Single Source of Truth such as Netbox

Core rules:

- all names use lowercase letters
- all words use a hyphen `-` as a separator
- do not use spaces
- do not use underscores

## Devices

The device format is `device-role-number` or `device-number` if a role is not required. The `device` value represents the platform type. The `role` value defines its primary function. The `number` value represents a two digit sequential index like `01` or `02`

### Switches

Switch names start with `sw`

Switch roles:

- `core` for the main switch that connects routers and hypervisor
- `acc` for access switches that connect end devices

Examples:

- `sw-core-01`
- `sw-acc-01`
- `sw-acc-02`

### Firewalls

Firewall names start with `fw`. Firewalls do not use a role in their name

Examples:

- `fw-01`

### Hypervisors

Proxmox hosts start with `pve`

Examples:

- `pve-01`
- `pve-02`

### Access Points

Access points start with `ap`

Examples:

- `ap-01`
- `ap-02`

### Virtual Machines and Containers

Virtual machines start with `vm`. LXC containers start with `lxc`

Generic roles:

- `docker` for virtual machines running Docker engine

Special roles:

- `zabbix` for Zabbix monitoring instances
- `dns` for DNS server instances

Examples:

- `vm-docker-01`
- `vm-zabbix-01`
- `lxc-dns-01`
