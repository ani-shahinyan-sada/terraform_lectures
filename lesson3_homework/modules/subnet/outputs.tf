output "subnet_self_link" {
  value       = google_compute_subnetwork.subnet.self_link
  description = "the self link of the subnet"
}
