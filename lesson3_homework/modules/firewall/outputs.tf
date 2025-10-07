output "firewall_rule_name" {
  value       = google_compute_firewall.monitoring_port.name
  description = "the name of the firewall rule"
}

output "firewall_rule_id" {
  value       = google_compute_firewall.monitoring_port.id
  description = "the ID of the firewall rule"
}
