resource "google_storage_bucket_iam_member" "vm_access" {
  bucket = google_storage_bucket.scripts.name
  role   = var.role
  member = "serviceAccount:${google_service_account.object_viewer.email}"
}

resource "google_service_account" "object_viewer" {
  account_id   = split("@", var.service_acc_id)[0]
  display_name = var.display_name
  project      = var.project_id
}

# # Add this - make objects readable by the service account
# resource "google_storage_bucket_iam_member" "public_read" {
#   bucket = google_storage_bucket.scripts.name
#   role   = "roles/storage.objectViewer"
#   member = "allUsers"  # Or use serviceAccount:${data.google_service_account.object_viewer.email}
# }
