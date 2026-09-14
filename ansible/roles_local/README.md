# Ansible Role Template

Template for writing main.yaml, generic feature tasks, debug tasks, and validation checks

## main.yaml

```yaml
- name: "DEBUG : Host connection info"
  ansible.builtin.debug:
    msg:
      - "inventory_hostname: {{ inventory_hostname }}"
      - "ansible_host: {{ ansible_host | default(inventory_hostname) }}"
      - "ansible_user: {{ ansible_user | default(None) }}"
      - "ansible_port: {{ ansible_port | default(22) }}"
  tags: [never, debug]

- name: Feature one task list include
  ansible.builtin.include_tasks: feature_one.yaml
  tags: [role_name, feature_one, checks, debug]

- name: Feature two task list include
  ansible.builtin.include_tasks: feature_two.yaml
  tags: [role_name, feature_two, checks, debug]
```

## Feature Task

Template for task files such as tasks/feature_name.yaml

```yaml
- name: "DEBUG : Feature variables"
  ansible.builtin.debug:
    msg:
      - "feature_enabled: {{ feature_enabled }}"
      - "feature_name: {{ feature_name }}"
      - "feature_port: {{ feature_port }}"
      - "feature_items: {{ feature_items }}"
  tags: [never, debug]

- name: "CHECKS: Assert feature variable types"
  ansible.builtin.assert:
    that:
      - feature_enabled is boolean
      - feature_name is string
      - feature_port is number
      - feature_items is sequence and feature_items is not string
    fail_msg: "One or more variables have incorrect data types!"
    quiet: true
  tags: [role_name, feature_name, checks]

- name: "CHECKS: Assert feature values"
  ansible.builtin.assert:
    that:
      - feature_name | length > 0
      - feature_port | int > 0
    fail_msg: "Invalid feature values provided!"
    quiet: true
  when: feature_enabled | bool
  tags: [role_name, feature_name, checks]

- name: Configure feature settings
  ansible.builtin.template:
    src: feature.conf.j2
    dest: /etc/feature/feature.conf
    mode: "0644"
  when: feature_enabled | bool
  tags: [role_name, feature_name]
```
