output "network_name" {
  description = "The name of the VPC network"
  value       = google_compute_network.vpc_network.name
}

output "network_id" {
  description = "The ID of the VPC network"
  value       = google_compute_network.vpc_network.id
}

output "network_self_link" {
  description = "The self_link of the VPC network"
  value       = google_compute_network.vpc_network.self_link
}

output "subnet_names" {
  description = "Map of subnet keys to their names"
  value       = { for k, v in google_compute_subnetwork.subnets : k => v.name }
}

output "subnet_self_links" {
  description = "Map of subnet keys to their self_links"
  value       = { for k, v in google_compute_subnetwork.subnets : k => v.self_link }
}

output "subnet_ids" {
  description = "Map of subnet keys to their IDs"
  value       = { for k, v in google_compute_subnetwork.subnets : k => v.id }
}