output "bucket_name" {
  value       = google_storage_bucket.scripts.name
  description = "name of the created bucket, passed to object module and iam module to specify where scripts are stored and where to grant permissions"

}


