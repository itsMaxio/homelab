locals {
  virtual_machines_on_pve_02 = {
    for virtual_machine_name, virtual_machine in local.vms :
    virtual_machine_name => virtual_machine
    if virtual_machine.node_name == "pve-02"
  }
}

module "cloud_images_on_pve_02" {
  source   = "../../modules/pve_download_iso"
  for_each = local.cloud_image_catalog

  providers = {
    proxmox = proxmox.pve_02
  }

  node_name    = "backup"
  datastore_id = "local"
  iso_url      = each.value.url
  file_name    = each.value.file_name
}

module "virtual_machines_on_pve_02" {
  source   = "../../modules/pve_create_vm"
  for_each = local.virtual_machines_on_pve_02

  providers = {
    proxmox = proxmox.pve_02
  }

  name        = each.key
  description = each.value.description
  tags        = each.value.tags
  # node_name               = each.value.node_name
  node_name       = "backup"
  vm_id           = each.value.vm_id
  protection      = each.value.protection
  cpu_cores       = each.value.cpu_cores
  cpu_type        = each.value.cpu_type
  scsi_controller = each.value.scsi_controller
  memory          = each.value.memory

  boot_disk_datastore_id  = each.value.boot_disk_datastore_id
  boot_disk_file_id       = module.cloud_images_on_pve_02[each.value.platform].file_id
  boot_disk_interface     = each.value.boot_disk_interface
  boot_disk_format        = each.value.boot_disk_format
  boot_disk_size          = each.value.boot_disk_size
  boot_disk_discard       = each.value.boot_disk_discard
  boot_disk_io_thread     = each.value.boot_disk_io_thread
  boot_disk_ssd_emulation = each.value.boot_disk_ssd_emulation

  cloud_init_datastore_id = each.value.cloud_init_datastore_id
  cloud_init_interface    = each.value.cloud_init_interface
  cloud_init_auto_upgrade = each.value.cloud_init_auto_upgrade

  network_interfaces = each.value.network_interfaces
  dns_servers        = each.value.dns_servers
  search_domain      = each.value.search_domain

  users = each.value.users
}