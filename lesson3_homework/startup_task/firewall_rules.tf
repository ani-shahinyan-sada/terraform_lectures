resource "google_compute_firewall" "monitoring_ports" {
  for_each = var.firewall_rules
  
  name    = each.value.name
  network = google_compute_network.vpc_network.self_link
  project = var.project_id

  allow {
    protocol = each.value.protocol
    ports    = each.value.ports
  }
  source_ranges = var.allowed_source_ranges 
  target_tags   = each.value.target_tags
}