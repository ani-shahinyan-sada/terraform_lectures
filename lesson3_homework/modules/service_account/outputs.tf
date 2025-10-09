output "service_account_id" {
  value       = google_service_account.object_viewer.account_id
  description = "account id portion of the service account, useful for verification"
}

output "service_account_name" {
  value       = google_service_account.object_viewer.name
  description = "full resource name of service account, useful for additional iam bindings"
}