resource "random_id" "mac_suffix" {
  for_each    = { for interface in var.network_interfaces : interface.name => interface }
  byte_length = 3
}

locals {
  interfaces_with_mac = [
    for interface in var.network_interfaces : merge(interface, {
      mac_address = interface.mac_address != null && interface.mac_address != "" ? interface.mac_address : format("bc:24:11:%s:%s:%s",
        substr(random_id.mac_suffix[interface.name].hex, 0, 2),
        substr(random_id.mac_suffix[interface.name].hex, 2, 2),
        substr(random_id.mac_suffix[interface.name].hex, 4, 2)
      )
    })
  ]

  gateway_interfaces = [
    for interface in var.network_interfaces :
    interface.name
    if interface.gateway != null && interface.gateway != ""
  ]

  dns_interface_name = try(
    local.gateway_interfaces[0],
    var.network_interfaces[0].name,
    ""
  )
}

resource "proxmox_virtual_environment_file" "network_config" {
  count = var.cloud_init_datastore_id != "" ? 1 : 0

  content_type = "snippets"
  datastore_id = var.snippets_datastore_id
  node_name    = var.node_name

  source_raw {
    file_name = "net-config-${var.name}.yaml"
    data = templatefile("${path.module}/templates/network_config.yaml.tftpl", {
      interfaces         = local.interfaces_with_mac
      dns_servers        = var.dns_servers
      search_domains     = var.search_domains
      dns_interface_name = local.dns_interface_name
    })
  }
}

resource "proxmox_virtual_environment_file" "cloud_config" {
  count = var.cloud_init_datastore_id != "" ? 1 : 0

  content_type = "snippets"
  datastore_id = var.snippets_datastore_id
  node_name    = var.node_name

  source_raw {
    file_name = "cloud-config-${var.name}.yaml"
    data = templatefile("${path.module}/templates/cloud_config.yaml.tftpl", {
      hostname    = var.name
      domain_name = var.domain_name
      users       = var.users
    })
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  name        = var.name
  description = var.description
  tags        = var.tags
  node_name   = var.node_name
  vm_id       = var.vm_id
  protection  = var.protection
  started     = var.started
  on_boot     = var.on_boot

  lifecycle {
    ignore_changes = [
      disk[0].file_id,
      initialization[0].network_data_file_id,
      initialization[0].user_data_file_id,
    ]
  }

  agent {
    enabled = var.qemu_agent_enabled
  }

  serial_device {}

  operating_system {
    type = var.operating_system
  }

  scsi_hardware = var.scsi_controller

  cpu {
    cores   = var.cpu_cores
    sockets = var.cpu_sockets
    type    = var.cpu_type
  }

  memory {
    dedicated = var.memory
    floating  = var.memory_ballooning ? var.memory : 0
  }

  disk {
    datastore_id = var.boot_disk_datastore_id
    file_id      = var.boot_disk_file_id
    interface    = var.boot_disk_interface
    file_format  = var.boot_disk_format
    size         = var.boot_disk_size
    discard      = var.boot_disk_discard ? "on" : "ignore"
    iothread     = var.boot_disk_io_thread
    ssd          = var.boot_disk_ssd_emulation
    backup       = var.boot_disk_backup
  }

  dynamic "network_device" {
    for_each = local.interfaces_with_mac
    content {
      bridge      = network_device.value.bridge
      model       = network_device.value.model
      firewall    = network_device.value.firewall
      vlan_id     = network_device.value.vlan_id
      mac_address = upper(network_device.value.mac_address)
      mtu         = network_device.value.mtu
      queues      = network_device.value.queues
    }
  }

  dynamic "initialization" {
    for_each = var.cloud_init_datastore_id != "" ? [1] : []

    content {
      datastore_id         = var.cloud_init_datastore_id
      interface            = var.cloud_init_interface
      upgrade              = var.cloud_init_auto_upgrade
      network_data_file_id = proxmox_virtual_environment_file.network_config[0].id
      user_data_file_id    = proxmox_virtual_environment_file.cloud_config[0].id
    }
  }
}
