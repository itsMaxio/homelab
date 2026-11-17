# Documentation

This file is a short summary of the documentation for my Homelab.

## Directory Structure

The main directory tree looks like this:

```text
docs
├── hardware
├── standards
├── guides
└── cheatsheets
```

### Hardware

This folder contains notes about what parts I use and how my machines are built. Most of my machines are not enterprise servers. They are used enterprise equipment, off-lease office computers, or thin clients.

### Standards

This folder contains notes and rules about standards in my Homelab. It covers device naming, network elements, storage, and service conventions. These files act as guidelines and templates while actual values live in a Single Source of Truth such as NetBox.

### Guides

This folder contains step by step instructions on how to configure and use various things. It covers software services, virtual machines, physical servers, network switches, etc.

### Cheatsheets

This folder contains short cheatsheets for different systems and tools. I store useful commands here that I do not remember every day but need for quick reference.

## File and Folder Rules

Core rules for naming files and folders:

- use lowercase letters for all file and folder names
- use a hyphen `-` as a separator between words
- do not use underscores `_` in file and folder names (with the exception of Ansible)

Examples:

- `thin-client-router.md`
- `opnsense-iot-igmp-proxy.md`
- `device-and-services`

## How to Organize Files

Rules for placing files and creating subfolders:

- place each file in one of the four main folders based on its purpose
- group files into subfolders by functional domain such as `network`, `backup`, `storage`, or `virtualization`
- create a dedicated subfolder for a specific tool or system when needed
