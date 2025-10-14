resource "google_service_account" "service_account" {
  account_id   = var.account_id
  display_name = var.display_name
  description  = var.description
  project      = var.project_id
}

resource "google_storage_bucket_iam_member" "bucket_access" {
  for_each = var.bucket_iam_bindings

  bucket = each.value.bucket
  role   = each.value.role
  member = "serviceAccount:${google_service_account.service_account.email}"
}