resource "google_service_account" "object_viewer" {
  account_id   = var.service_account_id
  display_name = var.service_account_display_name
  project      = var.project_id
}

resource "google_storage_bucket_iam_member" "vm_access" {
  bucket = google_storage_bucket.scripts.name
  role   = var.role
  member = "serviceAccount:${google_service_account.object_viewer.email}"
}
