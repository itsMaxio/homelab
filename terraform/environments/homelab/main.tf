locals {
  virtual_machines_on_main_pve = {
    for virtual_machine_name, virtual_machine in local.vms :
    virtual_machine_name => virtual_machine
    if virtual_machine.node_name == "main"
  }

  virtual_machines_on_backup_pve = {
    for virtual_machine_name, virtual_machine in local.vms :
    virtual_machine_name => virtual_machine
    if virtual_machine.node_name == "backup"
  }
}

# backup
module "cloud_images_on_backup_pve" {
  source   = "../../modules/pve_download_iso"
  for_each = local.cloud_image_catalog

  providers = {
    proxmox = proxmox.backup
  }

  node_name    = "backup"
  datastore_id = "local"
  iso_url      = each.value.url
  file_name    = each.value.file_name
}

module "virtual_machines_on_backup_pve" {
  source   = "../../modules/pve_create_vm"
  for_each = local.virtual_machines_on_backup_pve

  providers = {
    proxmox = proxmox.backup
  }

  name                        = each.key
  description                 = each.value.description
  tags                        = each.value.tags
  node_name                   = each.value.node_name
  vm_id                       = each.value.vm_id
  cpu_cores                   = each.value.cores
  cpu_type                    = each.value.cpu_type
  scsi_controller             = each.value.proxmox_scsi_controller
  memory                      = each.value.memory
  boot_drive_datastore_id     = each.value.boot_drive_datastore_id
  boot_drive_file_id          = module.cloud_images_on_backup_pve[each.value.platform].file_id
  boot_drive_size             = each.value.disk_size
  boot_drive_discard          = each.value.discard ? "on" : "ignore"
  boot_drive_io_thread        = each.value.io_thread
  boot_drive_ssd_emulation    = each.value.ssd_emulation
  initialization_datastore_id = each.value.initialization_datastore_id
  auto_upgrade                = each.value.auto_upgrade
  ipv4_address                = each.value.ipv4_address
  ipv4_gateway                = each.value.ipv4_gateway
  dns_servers                 = each.value.dns_servers
  admin_user                  = each.value.admin_user
  ssh_public_keys             = each.value.ssh_public_keys
  network_devices             = each.value.network_devices
}

# main
module "cloud_images_on_main_pve" {
  source   = "../../modules/pve_download_iso"
  for_each = local.cloud_image_catalog

  providers = {
    proxmox = proxmox.main
  }

  node_name    = "main"
  datastore_id = "local"
  iso_url      = each.value.url
  file_name    = each.value.file_name
}

module "virtual_machines_on_main_pve" {
  source   = "../../modules/pve_create_vm"
  for_each = local.virtual_machines_on_main_pve

  providers = {
    proxmox = proxmox.main
  }

  name                        = each.key
  description                 = each.value.description
  tags                        = each.value.tags
  node_name                   = each.value.node_name
  vm_id                       = each.value.vm_id
  cpu_cores                   = each.value.cores
  cpu_type                    = each.value.cpu_type
  scsi_controller             = each.value.proxmox_scsi_controller
  memory                      = each.value.memory
  boot_drive_datastore_id     = each.value.boot_drive_datastore_id
  boot_drive_file_id          = module.cloud_images_on_main_pve[each.value.platform].file_id
  boot_drive_size             = each.value.disk_size
  boot_drive_discard          = each.value.discard ? "on" : "ignore"
  boot_drive_io_thread        = each.value.io_thread
  boot_drive_ssd_emulation    = each.value.ssd_emulation
  initialization_datastore_id = each.value.initialization_datastore_id
  auto_upgrade                = each.value.auto_upgrade
  ipv4_address                = each.value.ipv4_address
  ipv4_gateway                = each.value.ipv4_gateway
  dns_servers                 = each.value.dns_servers
  admin_user                  = each.value.admin_user
  ssh_public_keys             = each.value.ssh_public_keys
  network_devices             = each.value.network_devices
}