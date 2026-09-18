resource "proxmox_download_file" "iso" {
  content_type = "iso"
  datastore_id = var.datastore_id
  node_name    = var.node_name
  url          = var.iso_url
  file_name    = var.file_name
}
