resource "google_compute_instance" "instance" {
  project = var.project_id

  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.vm_zone

  boot_disk {
    initialize_params {
      image = var.image_self_link
    }
  }
  tags = var.source_tags
  network_interface {
    network    = var.vpc_network_self_link
    subnetwork = var.subnet_self_link
    #allow the vm to have a public IP
    access_config {
    }
  }

  metadata = {
    startup-script-url = var.startup_script_url
  }

  service_account {
    email  = var.service_account_email
    scopes = var.scopes
  }
}
