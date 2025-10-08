resource "google_storage_bucket_object" "script" {
  name   = var.object_name
  source = var.script_source_path
  bucket = var.bucket_name
}

