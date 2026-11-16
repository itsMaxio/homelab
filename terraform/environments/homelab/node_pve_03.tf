locals {
  virtual_machines_on_pve_03 = {
    for virtual_machine_name, virtual_machine in local.vms :
    virtual_machine_name => virtual_machine
    if virtual_machine.node_name == "pve-03"
  }

  required_platforms_on_pve_03 = toset([
    for vm in local.virtual_machines_on_pve_03 : vm.platform
  ])
}

module "cloud_images_on_pve_03" {
  source = "../../modules/pve_download_iso"
  for_each = {
    for platform, image in local.cloud_image_catalog :
    platform => image
    if contains(local.required_platforms_on_pve_03, platform)
  }

  providers = {
    proxmox = proxmox.pve_03
  }

  node_name    = "pve-03"
  datastore_id = "local"
  iso_url      = each.value.url
  file_name    = each.value.file_name
}

module "virtual_machines_on_pve_03" {
  source   = "../../modules/pve_create_vm"
  for_each = local.virtual_machines_on_pve_03

  providers = {
    proxmox = proxmox.pve_03
  }

  name               = each.key
  description        = each.value.description
  tags               = each.value.tags
  node_name          = each.value.node_name
  vm_id              = each.value.vm_id
  started            = each.value.started
  on_boot            = each.value.on_boot
  protection         = each.value.protection
  qemu_agent_enabled = each.value.qemu_agent_enabled
  operating_system   = each.value.operating_system

  cpu_cores       = each.value.cpu_cores
  cpu_sockets     = each.value.cpu_sockets
  cpu_type        = each.value.cpu_type
  scsi_controller = each.value.scsi_controller

  memory            = each.value.memory
  memory_ballooning = each.value.memory_ballooning

  boot_disk_datastore_id  = each.value.boot_disk_datastore_id
  boot_disk_file_id       = module.cloud_images_on_pve_03[each.value.platform].file_id
  boot_disk_interface     = each.value.boot_disk_interface
  boot_disk_format        = each.value.boot_disk_format
  boot_disk_size          = each.value.boot_disk_size
  boot_disk_discard       = each.value.boot_disk_discard
  boot_disk_io_thread     = each.value.boot_disk_io_thread
  boot_disk_ssd_emulation = each.value.boot_disk_ssd_emulation
  boot_disk_backup        = each.value.boot_disk_backup

  cloud_init_datastore_id = each.value.cloud_init_datastore_id
  cloud_init_interface    = each.value.cloud_init_interface
  cloud_init_auto_upgrade = each.value.cloud_init_auto_upgrade
  snippets_datastore_id   = each.value.snippets_datastore_id

  network_interfaces = each.value.network_interfaces
  dns_servers        = each.value.dns_servers
  domain_name        = each.value.domain_name
  search_domains     = each.value.search_domains

  users = each.value.users
}