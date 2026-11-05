data "netbox_virtual_machines" "all_vms_with_terraform_tag" {
  filters = [
    {
      name  = "tag"
      value = var.vm_tag
    },
  ]
}

data "netbox_devices" "all_devices" {}

data "netbox_platforms" "all_platforms" {}

data "netbox_virtual_disks" "all_virtual_disks" {}

data "netbox_virtual_machine_interfaces" "all_virtual_machine_interfaces" {}

data "netbox_ip_addresses" "all_ip_addresses" {}

data "netbox_vlans" "all_vlans" {}

locals {
  devices_by_id = {
    for device in data.netbox_devices.all_devices.devices :
    device.id => device
  }

  platforms_by_id = {
    for platform in data.netbox_platforms.all_platforms.platforms :
    platform.id => platform
  }

  vlans_by_id = {
    for vlan in data.netbox_vlans.all_vlans.vlans :
    vlan.id => vlan.vid
  }

  interfaces_by_vm_and_index = {
    for interface in data.netbox_virtual_machine_interfaces.all_virtual_machine_interfaces.virtual_machine_interfaces :
    "${interface.virtual_machine_id}_${tonumber(regex("[0-9]+$", interface.name))}" => interface
    if interface.virtual_machine_id != null && can(regex("[0-9]+$", interface.name))
  }

  ipv4_by_interface_id = {
    for ip in data.netbox_ip_addresses.all_ip_addresses.ip_addresses :
    ip.virtual_machine_interface_id => ip...
    if ip.virtual_machine_interface_id != null && ip.family == 4
  }

  vms_raw = {
    for vm in data.netbox_virtual_machines.all_vms_with_terraform_tag.virtual_machines :
    vm.name => merge(
      vm,
      {
        config_context = jsondecode(coalesce(vm.config_context, "{}"))

        boot_disk = one([
          for virtual_disk in data.netbox_virtual_disks.all_virtual_disks.virtual_disks :
          virtual_disk
          if virtual_disk.virtual_machine_id == vm.id && tobool(virtual_disk.custom_fields.proxmox_boot_drive)
        ])

        cloud_init_disk = one([
          for virtual_disk in data.netbox_virtual_disks.all_virtual_disks.virtual_disks :
          virtual_disk
          if virtual_disk.virtual_machine_id == vm.id && tobool(virtual_disk.custom_fields.proxmox_cloud_init_drive)
        ])

        network_interfaces = [
          for interface in [
            for index in range(0, 8) : lookup(local.interfaces_by_vm_and_index, "${vm.id}_${index}", null)
            ] : {
            name        = interface.name
            bridge      = interface.custom_fields.proxmox_interface_bridge
            vlan_id     = interface.untagged_vlan_id != null ? local.vlans_by_id[interface.untagged_vlan_id] : null
            mtu         = interface.mtu
            queues      = tonumber(interface.custom_fields.proxmox_interface_queues)
            mac_address = null

            ip   = split("/", local.ipv4_by_interface_id[interface.id][0].ip_address)[0]
            cidr = tonumber(split("/", local.ipv4_by_interface_id[interface.id][0].ip_address)[1])

            gateway = try(interface.custom_fields["proxmox_interface_gateway"] != "" ? interface.custom_fields["proxmox_interface_gateway"] : null, null)
          }
          if interface != null
        ]
      }
    )
  }

  vms = {
    for name, vm in local.vms_raw :
    name => {
      name            = name
      vm_id           = tonumber(vm.custom_fields.proxmox_vm_id)
      description     = vm.description
      tags            = vm.tags
      node_name       = local.devices_by_id[vm.device_id].name
      platform        = local.platforms_by_id[vm.platform_id].slug
      protection      = contains(try(vm.tags, []), var.protected_vm_tag)
      cpu_cores       = tonumber(vm.custom_fields.proxmox_cores)
      cpu_type        = jsondecode(vm.custom_fields.proxmox_cpu_type).value
      scsi_controller = jsondecode(vm.custom_fields.proxmox_scsi_controller).value
      memory          = vm.memory_mb

      boot_disk_datastore_id  = vm.boot_disk.custom_fields.proxmox_datastore_id
      boot_disk_interface     = vm.boot_disk.name
      boot_disk_size          = floor(vm.boot_disk.size_mb / 1024)
      boot_disk_format        = jsondecode(vm.boot_disk.custom_fields.proxmox_drive_format).value
      boot_disk_discard       = tobool(vm.boot_disk.custom_fields.proxmox_discard)
      boot_disk_io_thread     = tobool(vm.boot_disk.custom_fields.proxmox_io_thread)
      boot_disk_ssd_emulation = tobool(vm.boot_disk.custom_fields.proxmox_ssd_emulation)

      cloud_init_datastore_id = vm.cloud_init_disk.custom_fields.proxmox_datastore_id
      cloud_init_interface    = vm.cloud_init_disk.name
      cloud_init_auto_upgrade = tobool(vm.custom_fields.proxmox_cloud_init_auto_upgrade)

      network_interfaces = vm.network_interfaces
      dns_servers        = vm.config_context.dns.nameservers
      search_domain      = vm.config_context.dns.search_domain

      users = vm.config_context.ssh_authorized_keys
    }
  }
}