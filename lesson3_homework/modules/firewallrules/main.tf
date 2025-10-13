resource "google_compute_firewall" "rules" {
  for_each = var.firewall_rules

  name    = each.value.name
  network = var.network
  project = var.project_id

  allow {
    protocol = var.protocol
    ports    = each.value.ports
  }

  source_ranges = var.source_ranges
  target_tags   = var.target_tags
}