terraform {
  backend "gcs" {
    bucket = "state-for-mig-task-ani"
    prefix = "terraform/state"
  }
}

# resource "google_service_account" "object_viewer" {
#   account_id   = split("@", var.service_acc_id)[0]
#   display_name = var.display_name
#   project      = var.project_id
# }

# resource "google_storage_bucket_iam_member" "public_read" {
#   bucket = "state-for-mig-task"
#   role   = "roles/storage.objectViewer"
#   member = "serviceAccount:${data.google_service_account.object_viewer.email}"
# }