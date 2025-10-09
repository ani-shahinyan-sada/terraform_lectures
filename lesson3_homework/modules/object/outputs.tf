output "script_url" {
  value       = "https://storage.cloud.google.com/${var.bucket_name}/${var.object_name}"
  description = "publicly accessible url to the uploaded script in gcs, passed to gce module as startup_script_url via for_each, vm fetches and executes this script on boot"
}
