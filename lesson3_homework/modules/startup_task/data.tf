data "google_compute_machine_types" "vm_machine_type" {
  filter  = var.machine_filter
  zone    = var.zone
  project = var.project_id
}

data "google_compute_image" "vm_image" {
  family  = var.image_family
  project = var.image_repository
}

