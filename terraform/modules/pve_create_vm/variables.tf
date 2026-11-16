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

variable "protection" {
  type        = bool
  default     = false
  description = "Enable Proxmox VM protection flag to prevent accidental removal"
}

variable "on_boot" {
  type        = bool
  default     = false
  description = "Specifies whether a VM will be started during system boot"
}

variable "started" {
  type        = bool
  default     = true
  description = "Whether to start the virtual machine"
}

variable "qemu_agent_enabled" {
  type        = bool
  default     = true
  description = "Enable QEMU Guest Agent communication in Proxmox"
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
  description = "Number of CPU cores per socket allocated to the VM"
}

variable "cpu_sockets" {
  type        = number
  default     = 1
  description = "Number of CPU sockets allocated to the VM"
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

variable "memory_ballooning" {
  type        = bool
  default     = false
  description = "Enable memory ballooning device in Proxmox"
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

variable "boot_disk_backup" {
  type        = bool
  default     = true
  description = "Include boot disk in Proxmox backup jobs"
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
    model       = optional(string)
    firewall    = optional(bool)
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

variable "domain_name" {
  type        = string
  default     = null
  description = "Primary domain name of the VM used to construct its FQDN"
}

variable "search_domains" {
  type        = list(string)
  default     = []
  description = "List of DNS search domains configured on the primary network interface"
}

variable "users" {
  type        = map(list(string))
  description = "Map of usernames to their list of SSH public keys"
}