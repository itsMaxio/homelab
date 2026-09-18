terraform {
  required_providers {
    netbox = {
      source  = "e-breuninger/netbox"
      version = "~> 5.7.0"
    }
  }
}

provider "netbox" {
  server_url = var.netbox_url
  api_token  = var.netbox_token
}
