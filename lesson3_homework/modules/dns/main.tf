resource "google_dns_managed_zone" "private_zone" {
  name       = var.zone_name
  dns_name   = var.dns_name
  visibility = var.visibility
  project    = var.project_id

  private_visibility_config {
    networks {
      network_url = var.network
    }
  }
}

resource "google_dns_record_set" "records" {
  for_each = var.vm_instances

  name         = "${each.key}.${google_dns_managed_zone.private_zone.dns_name}"
  managed_zone = google_dns_managed_zone.private_zone.name
  type         = var.record_type
  project      = var.project_id
  rrdatas      = [var.external_ips[each.key]]
}