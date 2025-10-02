resource "google_compute_network" "vpc_network" {
  name    = var.vpc_network_name
  project = var.project_id
}

resource "google_compute_subnetwork" "sirelis1" {
  name          = var.subnetwork_1_name
  ip_cidr_range = var.subnetwork_1_mask
  region        = var.region
  network       = google_compute_network.vpc_network.self_link
  project       = var.project_id
}

resource "google_compute_subnetwork" "sirelis2" {
  name          = var.subnetwork_2_name
  ip_cidr_range = var.subnetwork_2_mask
  region        = var.region
  network       = google_compute_network.vpc_network.self_link
  project       = var.project_id
}

resource "google_compute_subnetwork" "sirelis3" {
  name          = var.subnetwork_3_name
  ip_cidr_range = var.subnetwork_3_mask
  region        = var.region
  network       = google_compute_network.vpc_network.self_link
  project       = var.project_id
}



