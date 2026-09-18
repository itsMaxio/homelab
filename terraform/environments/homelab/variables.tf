variable "main_endpoint" {
  type = string
}

variable "main_api_token" {
  type      = string
  sensitive = true
}

variable "main_ssh_password" {
  type      = string
  sensitive = true
}

variable "backup_endpoint" {
  type = string
}

variable "backup_api_token" {
  type      = string
  sensitive = true
}

variable "backup_ssh_password" {
  type      = string
  sensitive = true
}

variable "netbox_endpoint" {
  type = string
}

variable "netbox_api_token" {
  type = string
  sensitive = true
}

variable "vm_tag" {
  type    = string
  default = "terraform"
}
