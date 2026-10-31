variable "name" {
  type        = string
  description = "Name of the virtual machine"
}

variable "description" {
  type        = string
  default     = ""
  description = "Description of the virtual machine"
}

variable "tags" {
  type        = list(string)
  default     = []
  description = "Tags of the virtual machine"
}

variable "node_name" {
  type        = string
  description = "Name of the Proxmox node where the VM will be created"
}

variable "vm_id" {
  type        = number
  description = "ID of the virtual machine in Proxmox"
}

variable "operating_system" {
  type        = string
  default     = "l26"
  description = "Operating system type in Proxmox"
}

variable "scsi_controller" {
  type        = string
  default     = "virtio-scsi-single"
  description = "SCSI controller model"
}

variable "cpu_cores" {
  type        = number
  description = "Number of CPU cores allocated to the VM"
}

variable "cpu_type" {
  type        = string
  default     = "host"
  description = "CPU emulation model in Proxmox"
}

variable "memory" {
  type        = number
  description = "Amount of RAM memory in megabytes"
}

variable "boot_disk_datastore_id" {
  type        = string
  description = "ID of the Proxmox datastore for the main disk"
}

variable "boot_disk_file_id" {
  type        = string
  description = "ID of the cloud image file used to create the VM"
}

variable "boot_disk_interface" {
  type        = string
  default     = "scsi0"
  description = "Bus interface of the boot disk (e.g. scsi0)"
}

variable "boot_disk_format" {
  type        = string
  default     = "raw"
  description = "Boot disk image format (raw, qcow2, vmdk)"
}

variable "boot_disk_size" {
  type        = number
  description = "Size of the boot disk in gigabytes"
}

variable "boot_disk_discard" {
  type        = bool
  default     = false
  description = "Enable discard or TRIM for the boot disk"
}

variable "boot_disk_io_thread" {
  type        = bool
  default     = false
  description = "Enable dedicated IO thread for the boot disk"
}

variable "boot_disk_ssd_emulation" {
  type        = bool
  default     = false
  description = "Enable SSD emulation for the boot disk"
}

variable "cloud_init_datastore_id" {
  type        = string
  default     = ""
  description = "ID of the Proxmox datastore for the cloud-init disk"
}

variable "cloud_init_interface" {
  type        = string
  default     = "ide2"
  description = "Hardware interface for the cloud-init drive"
}

variable "cloud_init_auto_upgrade" {
  type        = bool
  default     = false
  description = "Enable package upgrade on first boot via Cloud-Init"
}

variable "snippets_datastore_id" {
  type        = string
  default     = "local"
  description = "ID of the Proxmox datastore for snippets files"
}

variable "network_interfaces" {
  type = list(object({
    name        = string
    bridge      = string
    vlan_id     = optional(number)
    mtu         = optional(number)
    queues      = optional(number)
    mac_address = optional(string)
    ip          = string
    cidr        = number
    gateway     = optional(string)
  }))
  default     = []
  description = "List of network interfaces to attach to the VM"
}

variable "dns_servers" {
  type        = list(string)
  default     = []
  description = "List of DNS nameservers for the VM"
}

variable "search_domain" {
  type        = string
  default     = null
  description = "Search search_domain for DNS resolution"
}

variable "admin_user" {
  type        = string
  default     = "debian"
  description = "Username for the default admin account created by cloud-init"
}

variable "admin_password" {
  type        = string
  default     = "ansible"
  sensitive   = true
  description = "Password for the admin user account"
}

variable "ssh_public_keys" {
  type        = list(string)
  default     = []
  description = "List of SSH public keys added to the admin user"
}