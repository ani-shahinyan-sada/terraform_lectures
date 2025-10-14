resource "google_storage_bucket" "static-site" {
  name          = var.terraform_static_site_bucket_name
  location      = var.bucket_location
  uniform_bucket_level_access = var.uniform_bucket_level_access
  project = var.project_id
}

resource "google_storage_bucket" "static-site" {
  name          = var.terraform_static_site_bucket_name
  location      = var.bucket_location
  uniform_bucket_level_access = var.uniform_bucket_level_access
  project = var.project_id
}