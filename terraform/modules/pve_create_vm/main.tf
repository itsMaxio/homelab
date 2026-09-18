resource "proxmox_virtual_environment_vm" "vm" {
  name        = var.name
  description = var.description
  tags = var.tags

  node_name   = var.node_name
  vm_id       = var.vm_id

  operating_system {
    type = var.operating_system
  }

  scsi_hardware = var.scsi_controller

  cpu {
    cores = var.cpu_cores
    type  = var.cpu_type
  }

  memory {
    dedicated = var.memory
  }

  disk {
    datastore_id = var.boot_drive_datastore_id
    file_id      = var.boot_drive_file_id
    interface    = var.boot_drive_interface
    file_format = var.boot_drive_format
    size         = var.boot_drive_size

    discard  = var.boot_drive_discard
    iothread = var.boot_drive_io_thread
    ssd      = var.boot_drive_ssd_emulation
  }

  dynamic "network_device" {
    for_each = var.network_devices

    content {
      bridge  = network_device.value.bridge
      vlan_id = network_device.value.vlan_id
    }
  }

  dynamic "initialization" {
    for_each = var.initialization_datastore_id != "" ? [1] : []

    content {
      datastore_id = var.initialization_datastore_id
      interface = var.initialization_interface

      upgrade = var.auto_upgrade

      ip_config {
        ipv4 {
          address = var.ipv4_address
          gateway = var.ipv4_gateway
        }
      }

      dns {
        servers = var.dns_servers
      }

      user_account {
        username = var.admin_user
        keys     = var.ssh_public_keys
        password = "ansible"
      }
    }
  }
}
