# Network Naming Conventions

This document provides naming guidelines and templates for VLANs in the homelab. Names can change over time and actual values are stored in a Single Source of Truth such as Netbox

Core rules:

- all names use uppercase letters
- do not place a space between the word `VLAN` and the number
- use an underscore `_` to separate the VLAN number and purpose
- do not use spaces
- do not use hyphens

## VLANs

The VLAN format is `VLANx_PURPOSE`. The `x` represents the 802.1Q VLAN ID. The `PURPOSE` represents the function or target zone of the network

Examples:

- `VLAN10_LAN`
- `VLAN20_SERVERS`
- `VLAN30_MANAGEMENT`
- `VLAN40_GUEST`
