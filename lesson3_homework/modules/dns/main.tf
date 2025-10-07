resource "google_dns_managed_zone" "private-zone" {
  name       = var.private-zone-name
  dns_name   = var.dns-name
  visibility = var.visibility-type

  private_visibility_config {
    networks {
      network_url = var.vpc_network_id
    }
  }
  project = var.project_id
}
