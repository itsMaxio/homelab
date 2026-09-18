variable "netbox_url" {
  type        = string
  description = "np. https://netbox.local"
}

variable "netbox_token" {
  type      = string
  sensitive = true
}

variable "vm_tag" {
  type        = string
  default     = "terraform-managed"
  description = "Tag po którym filtrujemy VM w NetBox"
}

variable "vm_name" {
  type        = string
  default     = "eve-ng"
  description = "Nazwa konkretnej VM do sprawdzenia interfejsów/adresów"
}
