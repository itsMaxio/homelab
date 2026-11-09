# Ansible Role: acme_certificate

Installs `acme.sh` from Git and issues or renews TLS certificates via DNS-01 API with optional PKCS#12 (`.pfx`) conversion and reload hooks

## Requirements

- Privilege escalation `become: true` is required on the managed host
- Target host running Debian/Ubuntu (`apt` package manager)

## Role Variables

- All variables and default values are documented in `defaults/main.yaml`
- Argument validation is defined in `meta/argument_specs.yaml`
- Required variables do not have default values and are commented out in `defaults/main.yaml`. You must define them in your inventory or playbook before running the role

## Available Tags

- `acme_certificate` runs all tasks within the role
- `install` installs required packages, clones `acme.sh`, and configures auto-upgrade
- `issue` issues the TLS certificate, converts it to PKCS#12 if enabled, and registers the reload command
- `debug` prints the role variables, makes no changes

## Example Playbook

```yaml
---
- name: ACME
  hosts: all
  gather_facts: true
  become: true
  serial: 1

  roles:
    - role: acme_certificate
      vars:
        acme_certificate_account_email: "admin@example.com"
        acme_certificate_main_domain: "{{ inventory_hostname }}.example.com"
        acme_certificate_additional_domains:
          - "dns.example.com"
        acme_certificate_dns_provider: "dns_cf"
        acme_certificate_dns_environment:
          CF_Token: "your_cloudflare_api_token"
          CF_Account_ID: "your_cloudflare_account_id"
        acme_certificate_pkcs12_enable: true
        acme_certificate_pkcs12_password: "your_pkcs12_password"
      tags: [acme_certificate]
```
