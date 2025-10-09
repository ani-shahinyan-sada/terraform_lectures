output "iam_member_id" {
  value       = google_storage_bucket_iam_member.vm_access.id
  description = "the ID of the IAM member binding"
}

output "iam_member_role" {
  value       = google_storage_bucket_iam_member.vm_access.role
  description = "the role granted to the service account"
}

output "id" {
  value = google_storage_bucket_iam_member.vm_access.id
  description = "the id of the bucket iam member"
}