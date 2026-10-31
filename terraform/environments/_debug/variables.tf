variable "netbox_endpoint" {
  type        = string
  description = "np. https://netbox.local"
}

variable "netbox_api_token" {
  type      = string
  sensitive = true
}

variable "vm_tag" {
  type    = string
  default = "terraform-managed"
}