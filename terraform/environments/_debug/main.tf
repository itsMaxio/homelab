data "netbox_virtual_machines" "all_vms_with_terraform_tag" {
  filter {
    name  = "tag"
    value = var.vm_tag
  }
}

data "netbox_tags" "all_tags" {}

data "netbox_virtual_disk" "all_virtual_disks" {}

data "netbox_interfaces" "all_interfaces" {}

locals {
  vms_raw = {
    for vm in data.netbox_virtual_machines.all_vms_with_terraform_tag.vms :
    vm.name => merge(
      vm,
      {
        tags = [
          for netbox_tag in data.netbox_tags.all_tags.tags :
          netbox_tag
          if contains(vm.tag_ids, netbox_tag.tag_id)
        ]

        config_context = jsondecode(vm.config_context)

        virtual_disks = [
          for virtual_disk in data.netbox_virtual_disk.all_virtual_disks.virtual_disks :
          virtual_disk
          if virtual_disk.virtual_machine_id == vm.vm_id
        ]

        boot_drive = one([
          for virtual_disk in data.netbox_virtual_disk.all_virtual_disks.virtual_disks :
          virtual_disk
          if virtual_disk.virtual_machine_id == vm.vm_id && tobool(virtual_disk.custom_fields.proxmox_boot_drive)
        ])

        cloud_init_drive = one([
          for virtual_disk in data.netbox_virtual_disk.all_virtual_disks.virtual_disks :
          virtual_disk
          if virtual_disk.virtual_machine_id == vm.vm_id && tobool(virtual_disk.custom_fields.cloud_init_drive)
        ])

        network_devices = [
          for interface in [
            for index in range(0, 8) : one([
              for iface_data in data.netbox_interfaces.all_interfaces.interfaces :
              iface_data
              if iface_data.vm_id == vm.vm_id && try(tonumber(regex("[0-9]+$", iface_data.name)) == index, false)
            ])
          ] : {
            bridge  = vm.custom_fields.proxmox_default_bridge_interface
            vlan_id = length(interface.untagged_vlan) > 0 ? interface.untagged_vlan[0].vid : null
          }
          if interface != null
        ]
      }
    )
  }

  vms = {
    for name, vm in local.vms_raw :
    name => {
      description = vm.description
      tags = [for tag in vm.tags : tag.slug]
      node_name = vm.device_name
      vm_id = tonumber(vm.custom_fields.proxmox_vm_id)
      platform = vm.platform_slug
      cores       = tonumber(vm.custom_fields.proxmox_cores)
      memory = vm.memory_mb
      boot_drive_datastore_id = vm.boot_drive.custom_fields.proxmox_datastore_id
      interface = vm.boot_drive.name
      disk_size = floor(vm.boot_drive.size_mb / 1024)
      discard = tobool(vm.boot_drive.custom_fields.proxmox_discard)
      io_thread = tobool(vm.boot_drive.custom_fields.proxmox_io_thread)
      ssd_emulation = tobool(vm.boot_drive.custom_fields.proxmox_ssd_emulation)
      network_devices = vm.network_devices
      initialization_datastore_id = vm.cloud_init_drive.custom_fields.proxmox_datastore_id
      initialization_interface = vm.cloud_init_drive.name
      auto_upgrade = vm.custom_fields.cloud_init_auto_upgrade
      ipv4_address = vm.primary_ip4
      ipv4_gateway = cidrhost(vm.primary_ip4, 1)
      dns_servers = vm.config_context.dns_servers
      admin_user = vm.config_context.ansible_user
      ssh_public_keys = vm.config_context.ssh_authorized_keys[vm.config_context.ansible_user]
    }
  }
}
