resource "google_storage_bucket" "bucket" {
  name          = var.bucket_name
  location      = var.location
  project       = var.project_id
  force_destroy = var.force_destroy

  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "objects" {
  for_each = var.bucket_objects

  name   = each.value.name
  source = each.value.source
  bucket = google_storage_bucket.bucket.name
}