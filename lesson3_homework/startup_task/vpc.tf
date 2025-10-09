resource "google_compute_network" "vpc_network" {
  name    = var.vpc_network_name
  project = var.project_id
}

resource "google_compute_subnetwork" "sirelis-subnets" {
  for_each      = var.vm_attributes
  name          = each.value.subnet.subnet_name
  ip_cidr_range = each.value.subnet.mask
  region        = var.region
  network       = google_compute_network.vpc_network.self_link
  project       = var.project_id
}


