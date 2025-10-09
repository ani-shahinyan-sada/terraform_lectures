output "firewall_rule_name" {
  value       = google_compute_firewall.allow_ingress_ports.name
  description = "the name of the firewall rule"
}

output "firewall_rule_id" {
  value       = google_compute_firewall.allow_ingress_ports.id
  description = "the ID of the firewall rule"
}
