# resource "google_storage_bucket" "bucket_for_migs" {
#   name          = var.bucket_name
#   location      = var.location
#   project       = var.project_id
#   force_destroy = var.force_destroy

#   uniform_bucket_level_access = true
# }

# resource "google_storage_bucket_object" "objects_for_migs" {
#   for_each = var.mig_bucket_objects

#   name   = each.value.name
#   source = each.value.source
#   bucket = google_storage_bucket.bucket_for_migs.name
# }



resource "google_storage_bucket" "cloud_build_logs" {
  name          = "${var.project_id}-cloud-build-logs"
  location      = var.location
  project       = var.project_id
  force_destroy = var.force_destroy

  uniform_bucket_level_access = true

  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }
}