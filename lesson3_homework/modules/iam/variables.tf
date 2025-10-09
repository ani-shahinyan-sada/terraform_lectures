variable "bucket_name" {
  type        = string
  description = "name of the gcs bucket to grant access to, passed from root variable, must match the bucket created by bucket module where startup scripts are stored"
}

variable "role" {
  type        = string
  description = "iam role to grant on the bucket , passed from root variable, determines what service account can do with bucket objects "
}

variable "service_account_email" {
  type        = string
  description = "full email of service account to grant permissions to, constructed in main.tf as 'service_account_id@project_id.iam.gserviceaccount.com', this allows vms using this service account to read startup scripts"
}