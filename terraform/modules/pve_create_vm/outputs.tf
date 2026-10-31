output "vm_id" {
  value       = proxmox_virtual_environment_vm.vm.vm_id
  description = "The Proxmox VM ID"
}

output "ipv4_addresses" {
  value       = proxmox_virtual_environment_vm.vm.ipv4_addresses
  description = "The IPv4 addresses reported by the guest agent"
}