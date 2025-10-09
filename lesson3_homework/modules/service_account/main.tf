resource "google_service_account" "object_viewer" {
  account_id   = var.service_account_id
  display_name = var.service_account_display_name
  project      = var.project_id
}
