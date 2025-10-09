output "vpc_network_self_link" {
  value       = google_compute_network.vpc_network.self_link
  description = "full resource path of vpc network  passed to subnet, firewall, and gce modules to attach resources to this vpc"
}

output "vpc_network_id" {
  value       = google_compute_network.vpc_network.id
  description = "terraform resource identifier for vpc network, passed to dns module to configure private dns zone visibility for this vpc, allows vms in this vpc to resolve private dns names"
}
