resource "google_storage_bucket" "scripts" {
  name          = var.bucket_name
  location      = var.bucket_location #"US"
  force_destroy = false
  project       = var.project_id

  uniform_bucket_level_access = true

}

resource "google_storage_bucket_object" "script" {
  for_each = var.vm_attributes
  name     = each.value.name
  source   = each.value.startup_script
  bucket   = google_storage_bucket.scripts.name
}
