terraform {
  required_version = "1.17.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.119.0"
    }

    netbox = {
      source  = "e-breuninger/netbox"
      version = "6.0.0-rc.3"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.9.1"
    }
  }
}

provider "netbox" {
  server_url = var.netbox_endpoint
  api_token  = var.netbox_api_token
}

provider "proxmox" {
  alias     = "pve_01"
  endpoint  = var.pve_01_endpoint
  api_token = var.pve_01_api_token
  insecure  = true

  ssh {
    agent    = false
    username = "root"
    password = var.pve_01_ssh_password
  }
}

provider "proxmox" {
  alias     = "pve_02"
  endpoint  = var.pve_02_endpoint
  api_token = var.pve_02_api_token
  insecure  = true

  ssh {
    agent    = false
    password = var.pve_02_ssh_password
  }
}

provider "proxmox" {
  alias     = "pve_03"
  endpoint  = var.pve_03_endpoint
  api_token = var.pve_03_api_token
  insecure  = true

  ssh {
    agent    = false
    password = var.pve_03_ssh_password
  }
}