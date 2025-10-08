output "bucket_name" {
  value       = google_storage_bucket.scripts.name
  description = "the name of the GCS bucket"
}


