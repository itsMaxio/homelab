terraform {
  cloud {
    hostname     = "app.terraform.io"
    organization = "maxio-homelab"

    workspaces {
      name = "proxmox-infra"
    }
  }
}
