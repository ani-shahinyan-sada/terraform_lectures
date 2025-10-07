resource "google_dns_record_set" "a" {
  name         = "${var.dns_record_name}.${var.dns_zone_dns_name}"
  managed_zone = var.dns_zone_name
  type         = var.record_type
  project      = var.project_id
  rrdatas      = [var.vm_network_ip]
}
