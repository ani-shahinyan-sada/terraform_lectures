resource "google_compute_instance" "instances" {
  for_each = var.vm_attributes
  project  = var.project_id

  name         = each.value.name
  machine_type = data.google_compute_machine_types.vm_machine_type.machine_types[0].name
  zone         = each.value.zone

  boot_disk {
    initialize_params {
      image = data.google_compute_image.vm_image.self_link
    }
  }
  tags = var.source_tags
  network_interface {
    network    = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.sirelis-subnets[each.key].self_link

    access_config {
    }
  }

  metadata = {
    startup-script-url = "https://storage.cloud.google.com/${google_storage_bucket.scripts.name}/${each.value.name}"
  }


  service_account {
    email  = google_service_account.object_viewer.email
    scopes = var.scopes
  }

  depends_on = [google_storage_bucket_iam_member.vm_access]
}
