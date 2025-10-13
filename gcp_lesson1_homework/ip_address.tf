resource "google_compute_address" "ip_address_for_lb" {
  name = "external-ip-first"
  project = var.project_id
}