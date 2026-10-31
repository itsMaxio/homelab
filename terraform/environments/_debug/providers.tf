terraform {
  required_providers {
    netbox = {
      source  = "e-breuninger/netbox"
      version = "6.0.0-rc.3"
      # version = "~> 5.8.0"
    }
  }
}

provider "netbox" {
  server_url = var.netbox_endpoint
  api_token  = var.netbox_api_token
}
