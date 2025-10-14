output "instance_names" {
  description = "List of VM instance names"
  value       = [for instance in google_compute_instance.instances : instance.name]
}

output "internal_ips" {
  description = "Map of VM instance keys to their internal IP addresses"
  value       = { for k, v in google_compute_instance.instances : k => v.network_interface[0].network_ip }
}

output "external_ips" {
  description = "Map of VM instance keys to their external IP addresses"
  value       = { for k, v in google_compute_instance.instances : k => v.network_interface[0].access_config[0].nat_ip }
}