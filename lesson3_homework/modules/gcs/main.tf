resource "google_storage_bucket" "scripts" {
  name          = var.bucket_name
  location      = var.bucket_location
  force_destroy = false
  project       = var.project_id

  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "script" {
  name   = var.object_name
  source = var.script_source_path
  bucket = google_storage_bucket.scripts.name
}
