# output "all_tags" {
#   value = data.netbox_tags.all_tags
# }

# output "all_vms_raw" {
#   value = local.vms_raw
# }

output "all_vms" {
  value = local.vms
}

# output "all_disks" {
#   value = data.netbox_virtual_disk.all_virtual_disks.virtual_disks
# }

# output "all_vms" {
#   value = data.netbox_virtual_machines.all_vms_with_terraform_tag
# }

# output "config_context" {
#   value = data.netbox_config_context.text
# }

# output "all_interfaces" {
#   value = data.netbox_virtual_machine_interfaces.all_interfaces
# }
