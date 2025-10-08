output "script_url" {
  value       = "https://storage.cloud.google.com/${var.bucket_name}/${var.object_name}"
  description = "the full URL to the script in GCS"
}