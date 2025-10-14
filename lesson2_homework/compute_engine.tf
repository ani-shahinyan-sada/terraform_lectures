resource "google_service_account" "for_vms" {
  account_id   = var.account_id
  display_name = var.display_name
  project      = var.project_id

}

resource "google_compute_instance" "node" {
  project = var.project_id

  name         = var.node_vm_name
  machine_type = data.google_compute_machine_types.vm_machine_type.machine_types[0].name
  zone         = var.zone

  tags = var.tags

  boot_disk {
    initialize_params {
      image  = data.google_compute_image.vm_image.self_link
      labels = var.labels_1
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.sirelis1.self_link

  }

  metadata = var.metadata

  metadata_startup_script = var.metadata_startup_script

  service_account {
    email  = google_service_account.for_vms.email
    scopes = var.scopes
  }
}

resource "google_compute_instance" "prom" {
  project = var.project_id

  name         = var.prom_vm_name
  machine_type = data.google_compute_machine_types.vm_machine_type.machine_types[0].name
  zone         = var.zone

  tags = var.tags

  boot_disk {
    initialize_params {
      image  = data.google_compute_image.vm_image.self_link
      labels = var.labels_2
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.sirelis1.self_link
  }

  metadata = var.metadata

  metadata_startup_script = var.metadata_startup_script

  service_account {
    email  = google_service_account.for_vms.email
    scopes = var.scopes
  }
}
