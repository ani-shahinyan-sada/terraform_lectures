resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_network_name
  project                 = var.project_id
  auto_create_subnetworks = false
}
