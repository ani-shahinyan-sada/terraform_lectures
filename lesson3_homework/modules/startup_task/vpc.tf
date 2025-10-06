resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_network_name
  project                 = var.project_id
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "sirelis-subnets" {
  for_each      = var.vm_attributes
  name          = each.value.subnet.subnet_name
  ip_cidr_range = each.value.subnet.mask
  region        = each.value.subnet.region
  network       = google_compute_network.vpc_network.self_link
  project       = var.project_id
}


