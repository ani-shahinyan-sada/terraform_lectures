resource "google_dns_managed_zone" "private-zone" {
  name       = var.private-zone-name
  dns_name   = var.dns-name
  visibility = var.visibility-type

  private_visibility_config {
    networks {
      network_url = google_compute_network.vpc_network.id
    }
  }
  project = var.project_id
}

resource "google_dns_record_set" "a" {
  for_each     = var.vm_attributes
  name         = "${each.value.dns_name}.${google_dns_managed_zone.private-zone.dns_name}"
  managed_zone = google_dns_managed_zone.private-zone.name
  type         = var.record_type
  project      = var.project_id
  rrdatas      = [google_compute_instance.instances[each.key].network_interface[0].access_config[0].nat_ip]
}
