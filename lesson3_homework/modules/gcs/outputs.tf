output "bucket_name" {
  description = "The name of the created bucket"
  value       = google_storage_bucket.bucket.name
}

output "bucket_url" {
  description = "The base URL of the bucket"
  value       = google_storage_bucket.bucket.url
}

output "bucket_self_link" {
  description = "The URI of the created bucket"
  value       = google_storage_bucket.bucket.self_link
}

output "bucket_id" {
  description = "The ID of the bucket"
  value       = google_storage_bucket.bucket.id
}

output "object_names" {
  description = "List of object names in the bucket"
  value       = [for obj in google_storage_bucket_object.objects : obj.name]
}

output "startup_script_base_url" {
  description = "Base URL for accessing startup scripts in the bucket"
  value       = "https://storage.cloud.google.com/${google_storage_bucket.bucket.name}"
}