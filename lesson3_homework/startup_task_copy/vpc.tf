resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_network_name
  project                 = var.project_id
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_mask
  region        = var.subnet_region
  network       = google_compute_network.vpc_network.self_link
  project       = var.project_id
}
