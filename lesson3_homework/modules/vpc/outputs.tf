output "vpc_network_self_link" {
  value       = google_compute_network.vpc_network.self_link
  description = "the self link of the VPC network"
}

output "vpc_network_id" {
  value       = google_compute_network.vpc_network.id
  description = "the ID of the VPC network"
}
