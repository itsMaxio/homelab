variable "pve_01_endpoint" {
  type        = string
  description = "Proxmox API endpoint for pve-01 (https://192.168.10.11:8006/)"
}

variable "pve_01_api_token" {
  type        = string
  sensitive   = true
  description = "API Token for pve-01 (e.g. USER@REALM!TOKENID=UUID)"
}

variable "pve_01_ssh_password" {
  type        = string
  sensitive   = true
  description = "Root SSH password for pve-01 (used by provider for file transfer)"
}


variable "pve_02_endpoint" {
  type        = string
  description = "Proxmox API endpoint for pve-02"
}

variable "pve_02_api_token" {
  type        = string
  sensitive   = true
  description = "API Token for pve-02"
}

variable "pve_02_ssh_password" {
  type        = string
  sensitive   = true
  description = "Root SSH password for pve-02"
}


variable "pve_03_endpoint" {
  type        = string
  description = "Proxmox API endpoint for pve-03"
}

variable "pve_03_api_token" {
  type        = string
  sensitive   = true
  description = "API Token for pve-03"
}

variable "pve_03_ssh_password" {
  type        = string
  sensitive   = true
  description = "Root SSH password for pve-03"
}


variable "netbox_endpoint" {
  type        = string
  description = "NetBox API endpoint"
}

variable "netbox_api_token" {
  type        = string
  sensitive   = true
  description = "NetBox API token"
}

variable "vm_tag" {
  type        = string
  default     = "terraform-managed"
  description = "Tag used to filter virtual machines in NetBox"
}


variable "admin_user" {
  type        = string
  default     = "ansible"
  description = "Default administrative username created by Cloud-Init"
}

variable "admin_password" {
  type        = string
  sensitive   = true
  description = "Password for administrative username created by Cloud-Init"
}

variable "ssh_public_keys" {
  type        = list(string)
  default     = []
  description = "Public SSH keys injected into the admin account"
}