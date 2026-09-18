terraform {
  required_version = ">= 1.16.2"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.111.0"
    }

    netbox = {
      source  = "e-breuninger/netbox"
      version = "~> 5.7.0"
    }
  }
}

provider "proxmox" {
  alias     = "main"
  endpoint  = var.main_endpoint
  api_token = var.main_api_token
  insecure  = true

  ssh {
    agent    = false
    username = "root"
    password = var.main_ssh_password
  }
}

provider "proxmox" {
  alias     = "backup"
  endpoint  = var.backup_endpoint
  api_token = var.backup_api_token
  insecure  = true

  ssh {
    agent    = false
    username = "root"
    password = var.backup_ssh_password
  }
}

provider "netbox" {
  server_url = var.netbox_endpoint
  api_token  = var.netbox_api_token
}
