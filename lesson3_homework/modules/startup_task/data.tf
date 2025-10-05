data "google_compute_machine_types" "vm_machine_type" {
  filter  = var.machine_filter
  zone    = var.zone
  project = var.project_id
}

data "google_compute_image" "vm_image" {
  family  = var.image_family
  project = var.image_repository
}

# data "google_service_account" "object_viewer" {
#   account_id = split("@", var.service_acc_id)[0]  
#   project    = var.project_id
# }