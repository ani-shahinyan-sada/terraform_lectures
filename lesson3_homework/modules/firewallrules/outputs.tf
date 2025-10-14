output "firewall_rule_names" {
  description = "List of firewall rule names"
  value       = [for rule in google_compute_firewall.rules : rule.name]
}

output "firewall_rule_ids" {
  description = "Map of firewall rule keys to their resource IDs"
  value       = { for k, v in google_compute_firewall.rules : k => v.id }
}

output "firewall_rule_self_links" {
  description = "Map of firewall rule keys to their self_links"
  value       = { for k, v in google_compute_firewall.rules : k => v.self_link }
}