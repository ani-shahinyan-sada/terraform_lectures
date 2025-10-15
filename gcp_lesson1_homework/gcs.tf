resource "google_storage_bucket" "cloud_build_logs" {
  name          = "${var.project_id}-cloud-build-logs"
  location      = var.location
  project       = var.project_id
  force_destroy = var.force_destroy

  uniform_bucket_level_access = true

  lifecycle_rule {
    condition {
      age = var.lifecycle_rule_age
    }
    action {
      type = var.lifecycle_rule_action_type
    }
  }
}
