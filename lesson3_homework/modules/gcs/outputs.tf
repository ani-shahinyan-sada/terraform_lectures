output "bucket_name" {
  value       = google_storage_bucket.scripts.name
  description = "the name of the GCS bucket"
}

output "script_url" {
  value       = "https://storage.cloud.google.com/${google_storage_bucket.scripts.name}/${var.object_name}"
  description = "the full URL to the script in GCS"
}
