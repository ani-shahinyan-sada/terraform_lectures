resource "google_compute_instance" "instances" {
  for_each = var.vm_instances

  project      = var.project_id
  name         = each.value.name
  machine_type = var.machine_type
  zone         = each.value.zone

  boot_disk {
    initialize_params {
      image = var.boot_disk_image
    }
  }

  tags = var.network_tags

  network_interface {
    network    = var.network
    subnetwork = var.subnets[each.value.subnet_key]

    access_config {
      
    }
  }

  metadata = {
    startup-script-url = "${var.startup_script_bucket_url}/${each.value.startup_script}"
  }

  service_account {
    email  = var.service_account_email
    scopes = var.service_account_scopes
  }
}