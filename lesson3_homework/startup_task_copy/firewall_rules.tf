resource "google_compute_firewall" "monitoring_port" {
  name    = var.firewall_name
  network = google_compute_network.vpc_network.self_link
  project = var.project_id

  allow {
    protocol = var.protocol
    ports    = var.firewall_ports
  }
  source_ranges = var.allowed_source_ranges
  target_tags   = var.target_tags
}
