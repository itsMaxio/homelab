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
  type = list(string)
  default = [ "" ]
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
  type = string
  default = "l26"
  description = "Operating system of the virtual machine"
}

variable "scsi_controller" {
  type = string
  description = "SCSI controller"
}

variable "cpu_cores" {
  type        = number
  description = "Number of CPU cores allocated to the VM"
}

variable "cpu_type" {
  type        = string
  description = "VM type of CPU"
}

variable "memory" {
  type        = number
  description = "Amount of RAM memory in megabytes"
}

variable "boot_drive_datastore_id" {
  type        = string
  description = "ID of the Proxmox datastore for the main disk"
}

variable "boot_drive_interface" {
  type = string
  default = "scsi0"
  description = "Interface type of the virtual machine disk"
}

variable "boot_drive_format" {
  type = string
  default = "qcow2"
  description = "Boot drive file format"
}

variable "auto_upgrade" {
  type = bool
  default = false
  description = "Enable auto upgrade after start"
}

variable "boot_drive_file_id" {
  type        = string
  description = "ID of the cloud image file used to create the VM"
}

variable "boot_drive_size" {
  type        = number
  description = "Size of the main disk in gigabytes"
}

variable "boot_drive_discard" {
  type        = string
  default     = "on"
  description = "Enable discard or TRIM for the disk"
}

variable "boot_drive_io_thread" {
  type        = bool
  default     = true
  description = "Enable IO thread for the disk"
}

variable "boot_drive_ssd_emulation" {
  type        = bool
  default     = true
  description = "Enable SSD emulation for the disk"
}

variable "network_devices" {
  type = list(object({
    bridge  = string
    vlan_id = optional(number)
  }))
  default     = []
  description = "List of network devices to attach to the VM"
}

variable "initialization_datastore_id" {
  type        = string
  default = ""
  description = "ID of the Proxmox datastore for the cloud-init disk"
}

variable "initialization_interface" {
  type        = string
  default = "ide2"
  description = "The hardware interface to connect the cloud-init image to"
}

variable "ipv4_address" {
  type        = string
  default = ""
  description = "Static IPv4 address with CIDR notation for the management interface"
}

variable "ipv4_gateway" {
  type        = string
  default = ""
  description = "IPv4 gateway address for the management network"
}

variable "dns_servers" {
  type = list(string)
  default = []
  description = "List of DNS servers"
}

variable "admin_user" {
  type        = string
  default = ""
  description = "Username for the default admin account created by cloud-init"
}

variable "ssh_public_keys" {
  type        = list(string)
  default = []
  description = "List of SSH public keys added to the admin user"
}
