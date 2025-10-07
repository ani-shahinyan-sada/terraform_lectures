resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_mask
  region        = var.subnet_region
  network       = var.vpc_network_self_link
  project       = var.project_id
}
