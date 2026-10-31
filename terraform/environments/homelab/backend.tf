terraform {
  cloud {
    organization = "maxio-homelab"

    workspaces {
      name = "proxmox-infra"
    }
  }
}
