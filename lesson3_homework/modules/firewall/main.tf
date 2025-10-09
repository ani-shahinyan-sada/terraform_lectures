resource "google_compute_firewall" "allow_ingress_ports" {

  #filters incoming (ingress) traffic towards the compute engine instances
  #set to ingress by default in the resource

  name    = var.firewall_name
  network = var.vpc_network_self_link #the vpc network where the firewall should work
  project = var.project_id

  allow {
    protocol = var.protocol
    ports    = var.firewall_ports
  }

  source_ranges = var.allowed_source_ranges #which ip range is allowed to go through
  target_tags   = var.target_tags
}
